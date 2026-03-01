-- database/00_master_schema.sql
-- COMPLETE UAMS DATABASE SCHEMA (Includes Users & cleanup)

-- DISABLE FOREIGN KEY CHECKS to prevent error while dropping tables
SET FOREIGN_KEY_CHECKS = 0;

-- -----------------------------------------------------
-- 0. CLEANUP (Drop tables in reverse order)
-- -----------------------------------------------------
DROP TABLE IF EXISTS results;
DROP TABLE IF EXISTS enrollments;
DROP TABLE IF EXISTS course_offerings;
DROP TABLE IF EXISTS courses;
DROP TABLE IF EXISTS students;
DROP TABLE IF EXISTS teachers;
DROP TABLE IF EXISTS semesters;
DROP TABLE IF EXISTS departments;
DROP TABLE IF EXISTS users;

-- ENABLE FOREIGN KEY CHECKS
SET FOREIGN_KEY_CHECKS = 1;

-- -----------------------------------------------------
-- 1. AUTHENTICATION & USERS (Parent Table)
-- -----------------------------------------------------
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    role ENUM('admin', 'teacher', 'student') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- -----------------------------------------------------
-- 2. CORE ACADEMIC ENTITIES
-- -----------------------------------------------------
CREATE TABLE departments (
    dept_id INT AUTO_INCREMENT PRIMARY KEY,
    dept_code VARCHAR(10) UNIQUE NOT NULL, 
    dept_name VARCHAR(100) NOT NULL
);

CREATE TABLE semesters (
    semester_id INT AUTO_INCREMENT PRIMARY KEY,
    semester_name VARCHAR(20) NOT NULL, 
    year YEAR NOT NULL,
    start_date DATE,
    end_date DATE,
    UNIQUE(semester_name, year) 
);

-- -----------------------------------------------------
-- 3. PROFILES (Link Users to Depts)
-- -----------------------------------------------------
CREATE TABLE teachers (
    teacher_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT UNIQUE NOT NULL,
    dept_id INT NOT NULL,
    designation VARCHAR(50), 
    joining_date DATE,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (dept_id) REFERENCES departments(dept_id) ON DELETE CASCADE
);

CREATE TABLE students (
    student_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT UNIQUE NOT NULL,
    dept_id INT NOT NULL,
    student_code VARCHAR(20) UNIQUE NOT NULL, 
    batch VARCHAR(10),
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (dept_id) REFERENCES departments(dept_id) ON DELETE CASCADE
);

-- -----------------------------------------------------
-- 4. ACADEMIC CATALOG
-- -----------------------------------------------------
CREATE TABLE courses (
    course_id INT AUTO_INCREMENT PRIMARY KEY,
    dept_id INT NOT NULL,
    course_code VARCHAR(20) UNIQUE NOT NULL, 
    course_title VARCHAR(100) NOT NULL,
    credits DECIMAL(3, 2) NOT NULL,
    FOREIGN KEY (dept_id) REFERENCES departments(dept_id) ON DELETE CASCADE
);

-- -----------------------------------------------------
-- 5. COURSE OFFERING (Scheduling)
-- -----------------------------------------------------
CREATE TABLE course_offerings (
    offering_id INT AUTO_INCREMENT PRIMARY KEY,
    course_id INT NOT NULL,
    semester_id INT NOT NULL,
    teacher_id INT NOT NULL,
    section_name VARCHAR(5) NOT NULL, 
    capacity INT DEFAULT 40,
    enrolled_count INT DEFAULT 0,
    schedule_info VARCHAR(255), 
    FOREIGN KEY (course_id) REFERENCES courses(course_id) ON DELETE CASCADE,
    FOREIGN KEY (semester_id) REFERENCES semesters(semester_id) ON DELETE CASCADE,
    FOREIGN KEY (teacher_id) REFERENCES teachers(teacher_id) ON DELETE CASCADE,
    UNIQUE(course_id, semester_id, section_name) 
);

-- -----------------------------------------------------
-- 6. REGISTRATION & RESULTS
-- -----------------------------------------------------
CREATE TABLE enrollments (
    enrollment_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id INT NOT NULL,
    offering_id INT NOT NULL,
    enrollment_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    status ENUM('active', 'dropped', 'completed') DEFAULT 'active',
    FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE,
    FOREIGN KEY (offering_id) REFERENCES course_offerings(offering_id) ON DELETE CASCADE,
    UNIQUE(student_id, offering_id) 
);

CREATE TABLE results (
    result_id INT AUTO_INCREMENT PRIMARY KEY,
    enrollment_id INT UNIQUE NOT NULL,
    mid_marks DECIMAL(5,2),
    final_marks DECIMAL(5,2),
    -- Calculating Total automatically (MariaDB 10.2+)
    total_marks DECIMAL(5,2) AS (COALESCE(mid_marks, 0) + COALESCE(final_marks, 0)) PERSISTENT, 
    grade_point DECIMAL(3,2), 
    letter_grade VARCHAR(2), 
    FOREIGN KEY (enrollment_id) REFERENCES enrollments(enrollment_id) ON DELETE CASCADE
);