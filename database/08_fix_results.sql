-- database/08_fix_results.sql

-- 1. Ensure Student John exists and get his ID
SET @stud_id = (SELECT student_id FROM students s JOIN users u ON s.user_id = u.user_id WHERE u.email = 'student@uams.edu' LIMIT 1);

-- 2. Ensure Offering exists and get ID
SET @off_id = (SELECT offering_id FROM course_offerings LIMIT 1);

-- 3. Create a FRESH enrollment (This gives us a valid ID)
INSERT INTO enrollments (student_id, offering_id, status) 
VALUES (@stud_id, @off_id, 'completed');

-- 4. Get the ID of the enrollment we JUST created
SET @last_id = LAST_INSERT_ID();

-- 5. Give that enrollment some Marks (This fires your Grading Trigger!)
INSERT INTO results (enrollment_id, mid_marks, final_marks) 
VALUES (@last_id, 35.00, 45.00);