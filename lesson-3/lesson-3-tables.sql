-- Создаём БД
DROP DATABASE IF EXISTS vk;
CREATE DATABASE vk;

-- Делаем её текущей
USE vk;

-- Создаём таблицу пользователей
CREATE TABLE users (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT 'Идентификатор строки',
    first_name VARCHAR(100) NOT NULL COMMENT 'Имя пользователя',
    last_name VARCHAR(100) NOT NULL COMMENT 'Фамилия пользователя',
    email VARCHAR(100) NOT NULL UNIQUE COMMENT 'Почта',
    phone VARCHAR(100) NOT NULL UNIQUE COMMENT 'Телефон',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Время создания строки',
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Время обновления строки'
) COMMENT 'Пользователи';

-- Таблица типов медиафайлов
CREATE TABLE media_types (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT 'Идентификатор строки',
    name VARCHAR(255) NOT NULL UNIQUE COMMENT 'Название типа',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Время создания строки',
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Время обновления строки'
) COMMENT 'Типы медиафайлов';

-- Таблица медиафайлов
CREATE TABLE media (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT 'Идентификатор строки',
    user_id INT UNSIGNED NOT NULL COMMENT 'Ссылка на пользователя, который загрузил файл',
    FOREIGN KEY (user_id) REFERENCES users(id),
    filename VARCHAR(255) NOT NULL COMMENT 'Путь к файлу',
    size INT NOT NULL COMMENT 'Размер файла',
    metadata JSON COMMENT 'Метаданные файла',
    media_type_id INT UNSIGNED NOT NULL COMMENT 'Ссылка на тип контента',
    FOREIGN KEY (media_type_id) REFERENCES media_types(id),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Время создания строки',
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Время обновления строки'
) COMMENT 'Медиафайлы';

-- Таблица стран
CREATE TABLE countries (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT 'Идентификатор строки',
    name VARCHAR(255) NOT NULL UNIQUE COMMENT 'Название страны',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Время создания строки',
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Время обновления строки'
) COMMENT 'Словарь стран';

-- Таблица городов
CREATE TABLE cities (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT 'Идентификатор строки',
    country INT UNSIGNED NOT NULL COMMENT 'ссылка на страну',
    FOREIGN KEY (country) REFERENCES countries(id),
    name VARCHAR(255) NOT NULL UNIQUE COMMENT 'Название города',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Время создания строки',
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Время обновления строки'
) COMMENT 'Словарь городов';

-- Таблица профилей
CREATE TABLE profiles (
    user_id INT UNSIGNED NOT NULL PRIMARY KEY COMMENT 'Ссылка на пользователя',
    FOREIGN KEY (user_id) REFERENCES users(id),
    gender CHAR(1) NOT NULL COMMENT 'Пол',
    birthday DATE COMMENT 'Дата рождения',
    photo_id INT UNSIGNED COMMENT 'Ссылка на основную фотографию пользователя',
    FOREIGN KEY (photo_id) REFERENCES media(id),
    status VARCHAR(30) COMMENT 'Текущий статус',
    city INT UNSIGNED NOT NULL COMMENT 'Город проживания',
    FOREIGN KEY (city) REFERENCES cities(id),
    country INT UNSIGNED NOT NULL COMMENT 'Страна проживания',
    FOREIGN KEY (country) REFERENCES countries(id),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Время создания строки',
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Время обновления строки'
) COMMENT 'Профили';

-- Таблица сообщений
CREATE TABLE messages (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT 'Идентификатор строки',
    from_user_id INT UNSIGNED NOT NULL COMMENT 'Ссылка на отправителя сообщения',
    FOREIGN KEY (from_user_id) REFERENCES users(id),
    to_user_id INT UNSIGNED NOT NULL COMMENT 'Ссылка на получателя сообщения',
    FOREIGN KEY (to_user_id) REFERENCES users(id),
    body TEXT NOT NULL COMMENT 'Текст сообщения',
    is_important BOOLEAN COMMENT 'Признак важности',
    is_delivered BOOLEAN COMMENT 'Признак доставки',
    created_at DATETIME DEFAULT NOW() COMMENT 'Время создания строки',
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Время обновления строки'
) COMMENT 'Сообщения';

-- Таблица дружбы
CREATE TABLE friendship (
    user_id INT UNSIGNED NOT NULL COMMENT 'Ссылка на инициатора дружеских отношений',
    FOREIGN KEY (user_id) REFERENCES users(id),
    friend_id INT UNSIGNED NOT NULL COMMENT 'Ссылка на получателя приглашения дружить',
    FOREIGN KEY (friend_id) REFERENCES users(id),
    status_id INT UNSIGNED NOT NULL COMMENT 'Ссылка на статус (текущее состояние) отношений',
    requested_at DATETIME DEFAULT NOW() COMMENT 'Время отправления приглашения дружить',
    confirmed_at DATETIME COMMENT 'Время подтверждения приглашения',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Время создания строки',
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Время обновления строки',
    PRIMARY KEY (user_id, friend_id) COMMENT 'Составной первичный ключ'
) COMMENT 'Таблица дружбы';

-- Таблица статусов дружеских отношений
CREATE TABLE friendship_statuses (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT 'Идентификатор строки',
    name VARCHAR(150) NOT NULL UNIQUE COMMENT 'Название статуса',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Время создания строки',
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Время обновления строки'
) COMMENT 'Статусы дружбы';

-- Таблица групп
CREATE TABLE communities (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT 'Идентификатор сроки',
    name VARCHAR(150) NOT NULL UNIQUE COMMENT 'Название группы',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Время создания строки',
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Время обновления строки'
) COMMENT 'Группы';

-- Таблица связи пользователей и групп
CREATE TABLE communities_users (
    community_id INT UNSIGNED NOT NULL COMMENT 'Ссылка на группу',
    FOREIGN KEY (community_id) REFERENCES communities(id),
    user_id INT UNSIGNED NOT NULL COMMENT 'Ссылка на пользователя',
    FOREIGN KEY (user_id) REFERENCES users(id),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Время создания строки',
    PRIMARY KEY (community_id, user_id) COMMENT 'Составной первичный ключ'
) COMMENT 'Участники групп, связь между пользователями и группами';

-- Таблица связей
CREATE TABLE relation_to (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT 'Идентификатор строки',
    name VARCHAR(150) NOT NULL UNIQUE COMMENT 'Название связи (таблицы БД)',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Время создания строки',
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Время обновления строки'
) COMMENT 'Словарь связей';

-- Таблица лайков
CREATE TABLE likes (
    relation_to_id INT UNSIGNED NOT NULL COMMENT 'Ссылка на объект БД',
    FOREIGN KEY (relation_to_id) REFERENCES relation_to(id),
    object_id INT UNSIGNED NOT NULL COMMENT 'Ссылка на объект БД',
    user_id INT UNSIGNED NOT NULL COMMENT 'Ссылка на пользователя поставившего лайк',
    PRIMARY KEY (relation_to_id, object_id) COMMENT 'Составной первичный ключ',
    like_value INT(1) NOT NULL COMMENT 'Значение лайка',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Время создания строки',
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Время обновления строки'
) COMMENT 'Таблица лайков';

-- Рекомендуемый стиль написания кода SQL
-- https://www.sqlstyle.guide/ru/

-- Заполняем таблицы с учётом отношений
-- на http://filldb.info

-- Документация
-- https://dev.mysql.com/doc/refman/8.0/en/
-- http://www.rldp.ru/mysql/mysql80/index.htm
