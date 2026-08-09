/* Cтили
PascalCase: MyAwesomeVariable 
camelCase: мyAwesomeVariable 
венгерская нотация: tblHugarianNotation, tbPassword 
kebab-case: my-awesome-variable

для SQL лучше использовать
_snake_case, snake_case : my_awesome_variable 
UPPER_CASE_SNAKE_CASE
*/ 

 
-- DDL

DROP DATABASE IF EXISTS netology_lesson1; -- удаление базы данных 
CREATE DATABASE netology_lesson1; -- создание базы данных
USE netology_lesson1;


-- создание таблицы user
DROP TABLE IF EXISTS user;
CREATE TABLE user (
    id SERIAL PRIMARY KEY, -- SERIAL = BIGINT UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE
    firstname VARCHAR(100),
    lastname VARCHAR(100) COMMENT 'Фамилия', -- COMMENT на случай, если имя неочевидное
    email VARCHAR(120) UNIQUE,
    is_deleted BIT DEFAULT b'0'
);

-- создание таблицы profiles
DROP TABLE IF EXISTS `profiles`;
CREATE TABLE `profiles` (
    user_id SERIAL PRIMARY KEY,
    gender CHAR(1),
    birthday DATE,
    created_at DATETIME DEFAULT NOW()
);

-- переименование таблицы user в users   
RENAME TABLE user TO users; 

-- добавление новых столбцов updated_at и hometown в таблицу `profiles`
ALTER TABLE profiles
ADD COLUMN updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
ADD hometown VARCHAR(100) AFTER birthday; 

-- удаление столбца is_deleted из таблицы users
ALTER TABLE users
DROP COLUMN is_deleted;

-- добавление внешнего ключа от поля user_id таблицы cinema к полю id таблицы users
ALTER TABLE profiles
ADD FOREIGN KEY(user_id) REFERENCES users(id) ON UPDATE CASCADE ON DELETE CASCADE;

-- удаление таблицы profiles
DROP TABLE `profiles`;


-- DML

-- вставка данных
INSERT INTO users (id, firstname, lastname, email)
VALUES (1, 'Иван', 'Иванов', 'ivanov@netology.ru');

INSERT users (firstname, lastname, email)
VALUES 
('Петр', 'Петров', 'petrov@netology.ru'),
('Леонид', NULL, 'leonidov@netology.ru');

INSERT users
SET 
	firstname='Новиков',
	lastname='Юрий',
	email='novikov@netology.ru';

INSERT users (firstname, lastname, email)
SELECT first_name, last_name, email FROM sakila.staff;


-- чтение данных 
SELECT * FROM users;
SELECT id, firstname, lastname, email FROM users;  

SELECT firstname, email 
FROM users
WHERE id=1;   

-- изменение данных 
UPDATE users
SET lastname = 'Леонидов'
WHERE id=3;

-- удаление данных 
DELETE FROM users 
WHERE id=3;

-- DCL
-- создание пользователя
CREATE USER 'student'@'localhost' IDENTIFIED BY '123456';

-- добавление прав
GRANT SELECT ON netology_lesson1.users TO 'student'@'localhost';



