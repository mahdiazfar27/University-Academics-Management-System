-- database/03_dummy_data.sql
-- Run this in phpMyAdmin to populate the Academic Catalog

-- 1. Departments
INSERT IGNORE INTO departments (dept_code, dept_name) VALUES 
('CSE', 'Computer Science & Engineering'),
('EEE', 'Electrical & Electronic Engineering'),
('BBA', 'Business Administration');

-- 2. Semesters
INSERT IGNORE INTO semesters (semester_name, year, start_date, end_date) VALUES 
('Spring', 2024, '2024-01-01', '2024-06-30'),
('Fall', 2024, '2024-07-01', '2024-12-31');

-- 3. Link the Test Users (created by Redowan earlier) to Student/Teacher Profiles
INSERT INTO students (user_id, dept_id, student_code, batch) 
SELECT user_id, (SELECT dept_id FROM departments WHERE dept_code = 'CSE'), '2024-001', 'Spring24'
FROM users WHERE email = 'student@uams.edu'
ON DUPLICATE KEY UPDATE student_code = '2024-001';

INSERT INTO teachers (user_id, dept_id, designation, joining_date) 
SELECT user_id, (SELECT dept_id FROM departments WHERE dept_code = 'CSE'), 'Professor', '2020-01-15'
FROM users WHERE email = 'teacher@uams.edu'
ON DUPLICATE KEY UPDATE designation = 'Professor';

-- 4. Courses
INSERT IGNORE INTO courses (dept_id, course_code, course_title, credits) VALUES 
(1, 'CSE101', 'Introduction to Programming', 3.00),
(1, 'CSE102', 'Data Structures', 3.00),
(1, 'CSE201', 'Database Management Systems', 3.00);

-- 5. Course Offerings (Connecting it all)
INSERT IGNORE INTO course_offerings (course_id, semester_id, teacher_id, section_name, capacity, enrolled_count, schedule_info) 
VALUES 
((SELECT course_id FROM courses WHERE course_code = 'CSE101'), 1, 1, 'A', 40, 0, 'Mon/Wed 10:00 AM'),
((SELECT course_id FROM courses WHERE course_code = 'CSE201'), 1, 1, 'A', 2, 0, 'Tue/Thu 11:00 AM'); -- Notice capacity is 2 for testing triggers!