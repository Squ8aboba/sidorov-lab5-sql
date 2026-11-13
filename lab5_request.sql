SELECT o.id_order, o.date_order, o.status_order, c.name_customer, e.name_employee
FROM orders o, clients c, employees e
WHERE o.phone_customer = c.phone_customer AND o.id_employee = e.id_employee AND o.status_order <> 'Выдан'
ORDER BY o.date_order;

SELECT k.name_component, cat.name_category, d.serial_number, k.price_retail
FROM order_details d
JOIN components k ON k.id_component = d.id_component
JOIN categories cat ON cat.id_category = k.id_category
WHERE d.id_order = 1;

SELECT o.id_order, c.name_customer
FROM orders o
JOIN clients c ON c.phone_customer = o.phone_customer
LEFT JOIN order_details d ON d.id_order = o.id_order
WHERE d.serial_number IS NULL;

SELECT o.id_order, k.name_component, d.serial_number
FROM orders o
JOIN order_details d ON d.id_order = o.id_order
JOIN components k ON k.id_component = d.id_component
WHERE o.id_employee = 3
ORDER BY o.id_order;

SELECT o.id_order, COUNT(*) AS units
FROM orders o
JOIN order_details d ON d.id_order = o.id_order
WHERE o.id_employee = 3
GROUP BY o.id_order
HAVING COUNT(*) >= 7;

SELECT k.name_component, cat.name_category, k.stock
FROM components k, categories cat
WHERE k.id_category = cat.id_category AND k.stock < 3
ORDER BY k.stock;

SELECT COUNT(*) AS models, SUM(stock) AS total_units, AVG(price_retail) AS avg_price,
       MAX(price_retail) AS max_price, MIN(price_retail) AS min_price
FROM components;

SELECT cat.name_category, SUM(k.stock) AS total_stock
FROM categories cat
JOIN components k ON k.id_category = cat.id_category
GROUP BY cat.name_category
HAVING SUM(k.stock) < 10;

SELECT o.id_order, o.price_work + SUM(k.price_retail) AS total
FROM orders o
JOIN order_details d ON d.id_order = o.id_order
JOIN components k ON k.id_component = d.id_component
GROUP BY o.id_order, o.price_work;

SELECT e.name_employee, COUNT(DISTINCT o.id_order) AS orders_count, SUM(k.price_retail) AS revenue
FROM orders o
JOIN employees e ON e.id_employee = o.id_employee
JOIN order_details d ON d.id_order = o.id_order
JOIN components k ON k.id_component = d.id_component
WHERE o.status_order = 'Выдан'
GROUP BY e.name_employee
HAVING SUM(k.price_retail) > 50000;

SELECT cat.name_category, COUNT(*) AS installed
FROM order_details d
JOIN components k ON k.id_component = d.id_component
JOIN categories cat ON cat.id_category = k.id_category
GROUP BY cat.name_category
ORDER BY installed DESC;

SELECT o.id_order, o.date_order, c.name_customer
FROM orders o, clients c
WHERE o.phone_customer = c.phone_customer AND o.date_order BETWEEN '2026-10-01' AND '2026-10-31'
ORDER BY o.date_order DESC;

SELECT name_component, price_retail
FROM components
WHERE price_retail > (SELECT AVG(price_retail) FROM components);

SELECT name_customer
FROM clients
WHERE phone_customer IN (SELECT phone_customer FROM orders WHERE status_order = 'Выдан');

SELECT name_component, stock
FROM components
WHERE id_component NOT IN (SELECT id_component FROM order_details);

SELECT name_component, price_retail
FROM components
WHERE price_retail > ALL (SELECT price_retail FROM components WHERE id_category = 5);

SELECT name_component, stock,
       IF(stock < 3, 'заказать', 'достаточно') AS need
FROM components;

SELECT id_order, status_order,
  CASE status_order
    WHEN 'Принят' THEN 'ожидает сборки'
    WHEN 'Сборка' THEN 'в работе'
    WHEN 'Тестирование' THEN 'в работе'
    WHEN 'Готов' THEN 'можно выдавать'
    ELSE 'завершён'
  END AS state
FROM orders;

SELECT name_component, stock,
  CASE
    WHEN stock = 0 THEN 'нет в наличии'
    WHEN stock < 3 THEN 'мало'
    ELSE 'норма'
  END AS level
FROM components
ORDER BY stock;

CREATE VIEW v_order_total AS
SELECT o.id_order, c.name_customer, o.status_order,
       o.price_work + COALESCE(SUM(k.price_retail), 0) AS total
FROM orders o
JOIN clients c ON c.phone_customer = o.phone_customer
LEFT JOIN order_details d ON d.id_order = o.id_order
LEFT JOIN components k ON k.id_component = d.id_component
GROUP BY o.id_order, c.name_customer, o.status_order, o.price_work;

SELECT * FROM v_order_total ORDER BY total DESC;

GRANT SELECT ON sidorov_lab5.v_order_total TO 'u_manager'@'localhost';

WITH master_revenue AS (
  SELECT o.id_employee, SUM(k.price_retail) AS revenue
  FROM orders o
  JOIN order_details d ON d.id_order = o.id_order
  JOIN components k ON k.id_component = d.id_component
  WHERE o.status_order = 'Выдан'
  GROUP BY o.id_employee
)
SELECT e.name_employee, m.revenue
FROM master_revenue m
JOIN employees e ON e.id_employee = m.id_employee
ORDER BY m.revenue DESC;

EXPLAIN SELECT * FROM components WHERE brand = 'Kingston';

CREATE INDEX idx_components_brand ON components(brand);

EXPLAIN SELECT * FROM components WHERE brand = 'Kingston';

START TRANSACTION;
INSERT INTO order_details VALUES ('RAM-KF-0006', 4, 5);
UPDATE components SET stock = stock - 1 WHERE id_component = 5;
UPDATE orders SET status_order = 'Сборка' WHERE id_order = 4;
COMMIT;

SELECT id_order, status_order FROM orders WHERE id_order = 4;
SELECT stock FROM components WHERE id_component = 5;

START TRANSACTION;
UPDATE components SET stock = stock - 3 WHERE id_component = 5;
SELECT stock FROM components WHERE id_component = 5;
ROLLBACK;
SELECT stock FROM components WHERE id_component = 5;

SET @status = 'Выдан';
PREPARE stmt FROM 'SELECT id_order, date_order FROM orders WHERE status_order = ?';
EXECUTE stmt USING @status;
DEALLOCATE PREPARE stmt;
