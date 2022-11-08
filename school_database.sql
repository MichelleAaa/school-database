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
    semester TEXT NOT NULL,
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
    teacher_id INT,
    PRIMARY KEY (phone_id)
);

CREATE TABLE departments (
    department_id SERIAL,
    department_name TEXT NOT NULL,
    department_description TEXT NOT NULL,
    PRIMARY KEY (department_id)
);

-- Many to Many Relationship table with Grade:
CREATE TABLE students_classes (
    student_id INT,
    class_id INT,
    grade TEXT,
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

---
--- Insert Entries into the Database
---

INSERT INTO students (first_name, last_name, email, start_date, end_date, mailing_address, physical_address, date_of_birth) VALUES 
('Jane', 'Doe', 'jane@email.com', '2022-01-01', null, '123 Address Lane, City, AZ 00000', '123 Address Lane, City, AZ 00000', '1990-01-02'), ('John', 'Smith', 'john@email.com', '2018-01-01', '2022-01-01', '123 Street Ave, City, AZ 00000', '123 Street Ave, City, AZ 00000', '1991-01-12'), ('Alice', 'Sharp', 'alice@email.com', '2016-01-01', '2019-12-01', '123 Metro Ave, City, AZ 00000', '123 Metro Ave, City, AZ 00000', '1986-05-01');

INSERT INTO student_phone (phone_type, phone_number, student_id) VALUES 
('home', '123-456-7890', 1), ('cell', '098-765-4321', 1), ('home', '112-334-5500', 2), ('home', '009-887-6654', 3), ('cell', '121-343-4545', 3);

INSERT INTO locations (building_name, building_address, room_number, room_phone, max_capacity) VALUES 
('H.C. Academy Building 1', '123 Fake Lane, City, AZ 00001', '203', '123-456-9990', 24), ('H.C. Academy Building 1', '123 Fake Lane, City, AZ 00001', '211', '112-345-8800', 34), ('H.C. Academy Building 2', '124 Fake Lane, City, AZ 00001', '101', '110-332-9090', 70), ('H.C. Academy Building 2', '124 Fake Lane, City, AZ 00001', '102', '181-440-8790', 24);

INSERT INTO departments (department_name, department_description) VALUES 
('Math', 'Algebra, Geometry, and Calculus'), ('Science', 'Biology, Chemistry, and Physics'), ('Englishh', 'English Language and Literature');

INSERT INTO teachers (first_name, last_name, email, start_date, end_date, status, physical_address, mailing_address, subjects_taught, level, department_id) VALUES 
('Mark', 'Yates', 'mark@email.com', '2020-01-01', null, 'active', '345 School Street, City, AZ 00001', '345 School Street, City, AZ 00001', 'English Literature', 'Introductory', 3), ('Susan', 'Doe', 'susan@email.com', '2018-01-01', null, 'active', '789 Florence Road, City, AZ 00001', '789 Florence Road, City, AZ 00001', 'Physics', 'Introductory', 2), ('Terrance', 'Hu', 'terrance@email.com', '2018-01-01', null, 'active', '90 Domingo Road, City, AZ 00001', '90 Domingo Road, City, AZ 00001', 'Algebra', 'Introductory', 1);

INSERT INTO teacher_phone (phone_type, phone_number, teacher_id) VALUES 
('home', '121-990-1212', 1), ('cell', '990-880-7890', 1), ('home', '746-909-5678', 2), ('home', '148-976-1234', 3), ('cell', '232-149-3456', 3);

INSERT INTO classes (class_name, semester, start_date, end_date, class_time, credits, description, location_id, teacher_id, department_id) VALUES 
('Algebra I', 'FALL 2021', '2021-09-01', '2021-12-15', '12:30pm', 3, 'An introduction to Algebra', 1, 3, 1), ('Algebra III', 'FALL 2021', '2021-09-01', '2021-12-15', '10:30am', 3, 'An exploration of advanced topics in Algebra', 1, 3, 1), ('Physics I', 'FALL 2021', '2021-09-01', '2021-12-15', '1:00pm', 3, 'An introduction to Physics', 2, 2, 2), ('English I', 'FALL 2021', '2021-09-01', '2021-12-15', '9:00am', 3, 'An introduction to English', 3, 1, 3), ('English I - Duplicate for Deletion', 'FALL 2021',  '2021-09-01', '2021-12-15', '9:00am', 3, 'An introduction to English', 3, 1, 3);

INSERT INTO students_classes (student_id, class_id, grade) VALUES 
(1, 1, 'A'), (1, 3, 'A-'), (2, 1, 'B+'), (2, 3, 'C'), (3, 2, 'A'), (3, 3, 'B');

---
--- Update a Record
---

UPDATE departments set department_name = 'English' 
WHERE department_name = 'Englishh';

---
--- Delete a Record
---

DELETE FROM classes WHERE class_name = 'English I - Duplicate for Deletion';

---
--- Query Data Examples
---

-- Select all entries from the departments table, in ascending order, based on the department_id:
SELECT * FROM departments
ORDER BY department_id ASC;


-- Select all classes in the English department:
-- Display the department_id and department_name from the departments table.
-- Display the class_id, class_name, credits, and description from the classes table.
SELECT b.department_id, b.department_name, a.class_id, a.class_name, a.credits, a.description FROM classes a
INNER JOIN departments b
ON a.department_id = b.department_id
WHERE b.department_name = 'Math';


-- Select the schedule of classes that were in building_name 'H.C. Academy Building 1', room_number '203' during the semester 'FALL 2021':
-- Display the location_id from the locations table.
-- Display the class_id, class_name, and class_time from the classes table.
SELECT a.location_id, b.class_id, b.class_name, b.class_time
FROM locations a 
INNER JOIN classes b 
ON a.location_id = b.location_id
WHERE b.semester = 'FALL 2021' AND a.building_name = 'H.C. Academy Building 1' AND a.room_number = '203';


-- Display a student's transcript:
-- Select all classes student_id 1 is enrolled in. 
-- Display the student_id, class_id, and grade from the students_classes table. 
-- Display the class name, description, start_date, end_date, and credits from the classes table.
-- Display the student first and last name from the students table, referring to them as student_first_name and student_last_name, respectively.
-- Order by the start date of the class, in descending order.
SELECT a.student_id, c.first_name AS student_first_name, c.last_name AS student_last_name, a.class_id, b.class_name, b.description, b.start_date, b.end_date, b.credits, a.grade FROM students_classes a
INNER JOIN classes b
ON a.class_id = b.class_id
INNER JOIN students c
ON a.student_id = c.student_id
WHERE a.student_id=1
ORDER BY b.start_date DESC;