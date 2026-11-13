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
