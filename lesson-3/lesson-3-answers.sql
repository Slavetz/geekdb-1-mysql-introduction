-- ----------------------------------------------------
-- 1) Проанализировать структуру БД
-- ----------------------------------------------------

-- не совсем понял про status в profiles, если текст там не произвольный то стоит создать словарик profile_statuses
-- города и страны лучше вынести в отдельные справочники cities countries
-- из таблицы profiles лучше убрать поле country и перенести его в таблицу cities
-- для сообщений messages можно доабвить поле reply_to в которм указывать id сообщения на которе мы ответили,
-- поможет при навигации в чате


-- ----------------------------------------------------
-- 2) Добавить возможность лайков
-- ----------------------------------------------------

-- создадим таблицу для определения того, с какам объектом БД связан Лайк (медиафайлом, постом, пользователем)
-- возможно она пригодится для связывания не только лайков поэтому имя выбираем без указания принадлежности к лайкам
-- like_to лучше заменим на relation_to
CREATE TABLE relation_to (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT 'Идентификатор строки',
    name VARCHAR(150) NOT NULL UNIQUE COMMENT 'Название связи (таблицы БД)',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Время создания строки',
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Время обновления строки'
) COMMENT 'Словарь связей';

-- создадим таблицу в которой лайк буде связан с relation_to и самим объектом БД
CREATE TABLE likes (
    relation_to_id INT UNSIGNED NOT NULL COMMENT 'Ссылка на объект БД',
    FOREIGN KEY (relation_to_id) REFERENCES relation_to(id),
    object_id INT UNSIGNED NOT NULL COMMENT 'Ссылка на объект БД',
    user_id INT UNSIGNED NOT NULL COMMENT 'Ссылка на пользователя поставившего лайк',
    PRIMARY KEY (relation_to_id, object_id) COMMENT 'Составной первичный ключ',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT 'Время создания строки',
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Время обновления строки'
) COMMENT 'Словарь отношени';

-- если лайки например будут только положительные (thumbs up), то этого достаточно
-- если нужны еще и отрицательные (thumbs down) то можно решить это через доп поле, например like_value
-- и сделаем так чтобы like_value принимали значения 1 или -1, так будет проще считать средню оценку
-- like_value INT(1) NOT NULL

-- если лайки должны иметь больше значений (как в FB), то нужно добавить таблицу likes_types


-- ----------------------------------------------------
-- 3) Сгенерировать тестовые данные для всех таблиц
-- ----------------------------------------------------

-- vk-dump.sql
