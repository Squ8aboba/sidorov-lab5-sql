CREATE DATABASE IF NOT EXISTS sidorov_lab5;

CREATE TABLE clients (
  phone_customer VARCHAR(20) PRIMARY KEY,
  name_customer VARCHAR(255) NOT NULL
);

CREATE TABLE employees (
  id_employee INT AUTO_INCREMENT PRIMARY KEY,
  name_employee VARCHAR(255) NOT NULL,
  position VARCHAR(100) NOT NULL
);

CREATE TABLE categories (
  id_category INT AUTO_INCREMENT PRIMARY KEY,
  name_category VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE components (
  id_component INT AUTO_INCREMENT PRIMARY KEY,
  name_component VARCHAR(255) NOT NULL,
  brand VARCHAR(100) NOT NULL,
  price_purchase DECIMAL(10,2) NOT NULL CHECK (price_purchase >= 0),
  price_retail DECIMAL(10,2) NOT NULL CHECK (price_retail >= 0),
  stock INT NOT NULL DEFAULT 0 CHECK (stock >= 0),
  id_category INT NOT NULL,
  FOREIGN KEY (id_category) REFERENCES categories(id_category)
);

CREATE TABLE orders (
  id_order INT AUTO_INCREMENT PRIMARY KEY,
  date_order DATE NOT NULL DEFAULT (CURRENT_DATE),
  price_work DECIMAL(10,2) NOT NULL DEFAULT 1500.00,
  status_order VARCHAR(50) NOT NULL DEFAULT 'Принят'
    CHECK (status_order IN ('Принят','Сборка','Тестирование','Готов','Выдан')),
  phone_customer VARCHAR(20) NOT NULL,
  id_employee INT NOT NULL,
  FOREIGN KEY (phone_customer) REFERENCES clients(phone_customer) ON UPDATE CASCADE,
  FOREIGN KEY (id_employee) REFERENCES employees(id_employee)
);

CREATE TABLE order_details (
  serial_number VARCHAR(100) PRIMARY KEY,
  id_order INT NOT NULL,
  id_component INT NOT NULL,
  FOREIGN KEY (id_order) REFERENCES orders(id_order),
  FOREIGN KEY (id_component) REFERENCES components(id_component)
);

ALTER TABLE orders ADD COLUMN note VARCHAR(255);
ALTER TABLE orders MODIFY COLUMN note VARCHAR(500);
ALTER TABLE orders DROP COLUMN note;

INSERT INTO categories (name_category) VALUES
('Процессоры'), ('Материнские платы'), ('Оперативная память'), ('Видеокарты'),
('Накопители'), ('Блоки питания'), ('Корпуса'), ('Системы охлаждения');

INSERT INTO employees (name_employee, position) VALUES
('Смирнов Алексей Петрович', 'Руководитель'),
('Кузнецова Марина Игоревна', 'Менеджер по продажам'),
('Петров Павел Сергеевич', 'Мастер-сборщик'),
('Волков Дмитрий Андреевич', 'Мастер-сборщик'),
('Орлова Елена Викторовна', 'Кладовщик');

INSERT INTO clients VALUES
('+7 (900) 111-22-33', 'Иванов Иван Иванович'),
('+7 (911) 222-33-44', 'Сидорова Анна Павловна'),
('+7 (922) 333-44-55', 'Козлов Артём Олегович'),
('+7 (933) 444-55-66', 'Новикова Ольга Сергеевна');

INSERT INTO components (name_component, brand, price_purchase, price_retail, stock, id_category) VALUES
('Intel Core i5-13400F', 'Intel', 14500, 17500, 4, 1),
('AMD Ryzen 5 7600', 'AMD', 16000, 19000, 3, 1),
('ASUS PRIME B760M-K', 'ASUS', 8500, 10500, 3, 2),
('MSI B650M GAMING', 'MSI', 11000, 13500, 2, 2),
('Kingston FURY Beast 16GB DDR5', 'Kingston', 3800, 4800, 5, 3),
('Gigabyte GeForce RTX 4060', 'Gigabyte', 29000, 33500, 0, 4),
('Samsung 980 500GB', 'Samsung', 4200, 5300, 5, 5),
('Corsair CV650', 'Corsair', 4500, 5600, 2, 6),
('DeepCool MATREXX 40', 'DeepCool', 2600, 3500, 2, 7),
('DeepCool AK400', 'DeepCool', 2100, 2900, 5, 8),
('Kingston NV2 1TB', 'Kingston', 5200, 6500, 1, 5);

INSERT INTO orders (date_order, price_work, status_order, phone_customer, id_employee) VALUES
('2026-10-05', 1500, 'Выдан', '+7 (900) 111-22-33', 3),
('2026-10-12', 1500, 'Выдан', '+7 (911) 222-33-44', 4),
('2026-10-20', 2000, 'Сборка', '+7 (922) 333-44-55', 3),
('2026-10-27', 1500, 'Принят', '+7 (933) 444-55-66', 4);

INSERT INTO order_details VALUES
('CPU-I5-0001', 1, 1), ('MB-B760-0001', 1, 3), ('RAM-KF-0001', 1, 5), ('RAM-KF-0002', 1, 5),
('SSD-980-0001', 1, 7), ('PSU-CV-0001', 1, 8), ('CASE-MX-0001', 1, 9), ('COOL-AK-0001', 1, 10),
('CPU-R5-0001', 2, 2), ('MB-B650-0001', 2, 4), ('RAM-KF-0003', 2, 5), ('RAM-KF-0004', 2, 5),
('GPU-4060-0001', 2, 6), ('SSD-980-0002', 2, 7), ('PSU-CV-0002', 2, 8), ('CASE-MX-0002', 2, 9),
('CPU-I5-0002', 3, 1), ('MB-B760-0002', 3, 3), ('RAM-KF-0005', 3, 5), ('GPU-4060-0002', 3, 6),
('SSD-980-0003', 3, 7), ('PSU-CV-0003', 3, 8), ('COOL-AK-0002', 3, 10);

UPDATE orders SET status_order = 'Готов' WHERE id_order = 3;
UPDATE components SET price_retail = ROUND(price_retail * 1.05, 2) WHERE id_category = 4;
UPDATE components SET stock = stock + 5 WHERE id_component = 6;
UPDATE clients SET phone_customer = '+7 (900) 111-22-34' WHERE phone_customer = '+7 (900) 111-22-33';

INSERT INTO clients VALUES ('+7 (999) 000-00-00', 'Тестовый Клиент');
DELETE FROM clients WHERE phone_customer = '+7 (999) 000-00-00';
INSERT INTO order_details VALUES ('CASE-MX-9999', 3, 9);
DELETE FROM order_details WHERE serial_number = 'CASE-MX-9999';

CREATE USER IF NOT EXISTS 'u_manager'@'localhost' IDENTIFIED BY 'Manager#2026';
CREATE USER IF NOT EXISTS 'u_master'@'localhost' IDENTIFIED BY 'Master#2026';
CREATE USER IF NOT EXISTS 'u_storekeeper'@'localhost' IDENTIFIED BY 'Store#2026';
CREATE USER IF NOT EXISTS 'u_director'@'localhost' IDENTIFIED BY 'Director#2026';

GRANT SELECT, INSERT, UPDATE ON sidorov_lab5.clients TO 'u_manager'@'localhost';
GRANT SELECT, INSERT, UPDATE ON sidorov_lab5.orders TO 'u_manager'@'localhost';
GRANT SELECT ON sidorov_lab5.employees TO 'u_manager'@'localhost';
GRANT SELECT ON sidorov_lab5.components TO 'u_manager'@'localhost';
GRANT SELECT ON sidorov_lab5.categories TO 'u_manager'@'localhost';
GRANT SELECT ON sidorov_lab5.order_details TO 'u_manager'@'localhost';

GRANT SELECT ON sidorov_lab5.orders TO 'u_master'@'localhost';
GRANT UPDATE (status_order) ON sidorov_lab5.orders TO 'u_master'@'localhost';
GRANT SELECT, INSERT ON sidorov_lab5.order_details TO 'u_master'@'localhost';
GRANT SELECT ON sidorov_lab5.components TO 'u_master'@'localhost';
GRANT SELECT ON sidorov_lab5.categories TO 'u_master'@'localhost';

GRANT SELECT, INSERT, UPDATE ON sidorov_lab5.components TO 'u_storekeeper'@'localhost';
GRANT SELECT, INSERT ON sidorov_lab5.categories TO 'u_storekeeper'@'localhost';
GRANT SELECT ON sidorov_lab5.order_details TO 'u_storekeeper'@'localhost';

GRANT SELECT ON sidorov_lab5.* TO 'u_director'@'localhost';
GRANT INSERT, UPDATE ON sidorov_lab5.employees TO 'u_director'@'localhost';

SHOW GRANTS FOR 'u_manager'@'localhost';
SHOW GRANTS FOR 'u_master'@'localhost';
SHOW GRANTS FOR 'u_storekeeper'@'localhost';
SHOW GRANTS FOR 'u_director'@'localhost';

DESCRIBE clients;
DESCRIBE employees;
DESCRIBE categories;
DESCRIBE components;
DESCRIBE orders;
DESCRIBE order_details;

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
