-- Загружаем дамп восстанавливаем базу из дампа и поехали
DROP DATABASE vk;
CREATE DATABASE vk;
USE vk;


-- --------------------------------
-- Работа с таблицей users
-- --------------------------------

-- приводим в порядок даты
UPDATE users SET updated_at = created_at WHERE updated_at < created_at;


-- --------------------------------
-- Работа с таблицей user_statuses
-- --------------------------------

-- создаем таблицу
CREATE TABLE user_statuses (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT 'Идентификатор строки',
    name VARCHAR(100) NOT NULL COMMENT 'Название статуса (уникально)',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Время создания строки',
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Время обновления строки'
) COMMENT 'Справочник статусов пользователей';

-- заполняем таблицу
INSERT INTO user_statuses (name) VALUES ('single'), ('married');


-- --------------------------------
-- Работа с таблицей profiles
-- --------------------------------

-- приводим в порядок даты
UPDATE profiles SET updated_at = created_at WHERE updated_at < created_at;

-- приводим в порядок photo_id
UPDATE profiles SET photo_id = 1 + FLOOR(RAND() * 100);
-- есть медиа в photo_id которым соответсвует тип != Image
-- есрь есть повторяющиеся photo_id

-- UPDATE profiles SET gender = 'f' WHERE gender != 'm'; // это не нужно у меня норм дамп

-- меняем колонку status на user_status_id
ALTER TABLE profiles ADD user_status_id INT UNSIGNED NOT NULL COMMENT 'Ссылка на статус пользователя';
ALTER TABLE profiles DROP COLUMN status;

-- заполняем колонку user_status_id
UPDATE profiles SET user_status_id = 1 + FLOOR(RAND() * 2);


-- --------------------------------
-- Работа с таблицей messages
-- --------------------------------

-- приводим в порядок даты
UPDATE messages SET updated_at = created_at WHERE updated_at < created_at;

-- заполням значениями from_user_id to_user_id из доступного диапазона
UPDATE messages SET
    from_user_id = 1 + FLOOR(RAND() * 100),
    to_user_id = 1 + FLOOR(RAND() * 100);

-- корректируем значение from_user_id
UPDATE messages SET from_user_id = from_user_id + 1 WHERE from_user_id = to_user_id;


-- --------------------------------
-- Работа с таблицей media_types
-- --------------------------------

-- DELETE FROM media_types;
-- TRUNCATE media_types; // не работает данный через FOREIGN KEY, видимо рано на него перехал
-- INSERT INTO media_types(name) VALUES ('Audio'),('Video'),('Image');


-- --------------------------------
-- Работа с таблицей media
-- --------------------------------

-- задаем значения из доступных диапазонов
UPDATE media SET media_type_id = 1 + FLOOR(RAND() * 3);
UPDATE media SET user_id = 1 + FLOOR(RAND() * 100);
UPDATE media SET updated_at = created_at WHERE updated_at < created_at;

-- CREATE TEMPORARY TABLE extensions (name VARCHAR(10));
-- INSERT INTO extensions VALUES ('jpeg'), ('avi'), ('mpeg'), ('png');
-- SELECT * FROM extensions;

-- назначаем имена файлов в зависимости от типов // нужно было файлов поболе нарандомить
UPDATE media SET filename = CONCAT(
        'https://dropbox.net/vk/',
        filename,
        '.png'
    ) WHERE media_type_id = 1;

UPDATE media SET filename = CONCAT(
        'https://dropbox.net/vk/',
        filename,
        '.mp4'
    ) WHERE media_type_id = 2;

UPDATE media SET filename = CONCAT(
        'https://dropbox.net/vk/',
        filename,
        '.mp3'
    ) WHERE media_type_id = 3;

-- корректируем размер файла
UPDATE media SET size = FLOOR(100000 + (RAND() * 1000000)) WHERE size < 100000;

-- заполняем метадату
UPDATE media SET metadata = CONCAT(
        '{"owner":"',
        (SELECT CONCAT(first_name, ' ', last_name) FROM users WHERE id = user_id),
        '"}'
    );
ALTER TABLE media MODIFY COLUMN metadata JSON;


-- --------------------------------
-- Работа с таблицей friendship_statuses
-- --------------------------------

TRUNCATE friendship_statuses;
-- UPDATE friendship_statuses SET updated_at = created_at WHERE updated_at < created_at;
INSERT INTO friendship_statuses(name) VALUES ('requested'),('confirmed'),('rejected');


-- --------------------------------
-- Работа с таблицей friendship
-- --------------------------------

-- корректируем дату // вообще нужно было везде ON UPDATE прилепить
UPDATE friendship SET updated_at = created_at WHERE updated_at < created_at;

-- задаем значения из доступных диапазонов
UPDATE friendship SET status_id = 1 + FLOOR(RAND() * 3);
UPDATE friendship SET
    user_id = 1 + FLOOR(RAND() * 100),
    friend_id = 1 + FLOOR(RAND() * 100);

-- корректируем погрешность заполнения
UPDATE friendship SET friend_id = friend_id + 1 WHERE user_id = friend_id;


-- --------------------------------
-- Работа с таблицей communities
-- --------------------------------

DELETE FROM communities WHERE id > 10;
UPDATE communities SET updated_at = created_at WHERE updated_at < created_at;


-- --------------------------------
-- Работа с таблицей communities_users
-- --------------------------------

UPDATE communities_users SET
    community_id = 1 + FLOOR(RAND() * 10),
    user_id = 1 + FLOOR(RAND() * 100);
