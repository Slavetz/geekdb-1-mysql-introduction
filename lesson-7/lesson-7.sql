-- 1. Составить список пользователей, которые осуществили хотя бы один заказ

-- заполним базу
INSERT INTO orders (user_id) SELECT id FROM users ORDER BY RAND() LIMIT 1;
INSERT INTO orders_products (order_id, product_id, total)
SELECT LAST_INSERT_ID(), id, 1 FROM products ORDER BY RAND() LIMIT 1;

INSERT INTO orders (user_id) SELECT id FROM users ORDER BY RAND() LIMIT 1;
INSERT INTO orders_products (order_id, product_id, total)
SELECT LAST_INSERT_ID(), id, 2 FROM products ORDER BY RAND() LIMIT 1;

SELECT u.id AS user_id, u.name AS user_name, COUNT(*) AS orders_count FROM users AS u
   JOIN orders AS o ON u.id = o.user_id
    GROUP BY u.id;


-- 2. Вывести список товаров с соответсвующими им разделами

SELECT p.id, p.name, p.price, c.name AS catalog FROM products AS p
    LEFT JOIN catalogs AS c ON p.catalog_id = c.id;
