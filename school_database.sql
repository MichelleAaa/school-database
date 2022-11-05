-- Instructions:
-- •	Test your code as you go by running the following command from your VS Code integrated terminal:
-- cat school_database.sql | docker exec -i pg_container psql
-- After running this command, refresh or open pgAdmin in your browser at http://localhost:5433 , then navigate to the 'school_database' database 


-- kill other connections
SELECT pg_terminate_backend(pg_stat_activity.pid)
FROM pg_stat_activity
WHERE pg_stat_activity.datname = 'school_database' AND pid <> pg_backend_pid();
-- (re)create the database
DROP DATABASE IF EXISTS school_database;
CREATE DATABASE school_database;
-- connect via psql
\c school_database

-- database configuration
SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET default_tablespace = '';
SET default_with_oids = false;


---
--- CREATE tables
---

CREATE TABLE students (
    student_id SERIAL,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    start_date DATE NOT NULL,
    end_date DATE, 
    mailing_address TEXT NOT NULL, 
    physical_address TEXT NOT NULL, 
    date_of_birth DATE NOT NULL, 
    PRIMARY KEY (student_id)
);

CREATE TABLE student_phone (
    phone_id SERIAL,
    phone_type TEXT NOT NULL,
    phone_number VARCHAR(50) NOT NULL,
    student_id INT,
    PRIMARY KEY (phone_id)
);

CREATE TABLE classes (
    class_id SERIAL,
    class_name TEXT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    class_time TEXT NOT NULL,
    credits TEXT NOT NULL,
    description TEXT NOT NULL,
    location_id INT,
    teacher_id INT,
    department_id INT,
    PRIMARY KEY (class_id)
);

CREATE TABLE locations (
    location_id SERIAL,
    building_name TEXT NOT NULL,
    building_address TEXT NOT NULL,
    room_number TEXT NOT NULL,
    room_phone VARCHAR(50) NOT NULL,
    max_capacity INT NOT NULL,
    PRIMARY KEY (location_id)
);

CREATE TABLE teachers (
    teacher_id SERIAL,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    start_date DATE NOT NULL,
    end_date DATE,
    status TEXT NOT NULL,
    physical_address TEXT NOT NULL,
    mailing_address TEXT NOT NULL,
    subjects_taught TEXT NOT NULL,
    level TEXT NOT NULL,
    department_id INT,
    PRIMARY KEY (teacher_id)
);

CREATE TABLE teacher_phone (
    phone_id SERIAL,
    phone_type TEXT NOT NULL,
    phone_number VARCHAR(50) NOT NULL,
    student_id INT,
    PRIMARY KEY (phone_id)
);

CREATE TABLE departments (
    department_id SERIAL,
    department_name TEXT NOT NULL,
    PRIMARY KEY (department_id)
);

-- Many to Many Relationship table:
CREATE TABLE students_classes (
    student_id INT,
    class_id INT,
    PRIMARY KEY (student_id, class_id)
);

---
--- Add foreign key constraints
---


-- For the One to Many Relationships:

ALTER TABLE teacher_phone
ADD CONSTRAINT fk_teacher_phone_teacher 
FOREIGN KEY (teacher_id) 
REFERENCES teachers (teacher_id);

ALTER TABLE student_phone
ADD CONSTRAINT fk_student_phone_students
FOREIGN KEY (student_id) 
REFERENCES students (student_id);

ALTER TABLE classes
ADD CONSTRAINT fk_classes_locations
FOREIGN KEY (location_id) 
REFERENCES locations (location_id);

ALTER TABLE classes 
ADD CONSTRAINT fk_classes_teachers
FOREIGN KEY (teacher_id) 
REFERENCES teachers (teacher_id);

ALTER TABLE classes 
ADD CONSTRAINT fk_classes_departments
FOREIGN KEY (department_id) 
REFERENCES departments (department_id);

ALTER TABLE teachers 
ADD CONSTRAINT fk_teachers_departments
FOREIGN KEY (department_id) 
REFERENCES departments (department_id);

--  For the Many to Many Relationship:
ALTER TABLE students_classes
ADD CONSTRAINT fk_students_classes_students
FOREIGN KEY (student_id) 
REFERENCES students (student_id);

ALTER TABLE students_classes
ADD CONSTRAINT fk_students_classes_classes
FOREIGN KEY (class_id) 
REFERENCES classes (class_id);