CREATE DATABASE IF NOT EXISTS example;
DROP TABLE IF EXISTS users;
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255)
) COMMENT = 'Пользователи';
