-- database/05_dummy_results.sql

-- Give Student #1 some results for the courses they enrolled in
-- Assuming Student #2 (student@uams.edu) enrolled in Offering 1 (CSE101)
-- Check your enrollments table first! We will use the enrollment_id.

INSERT INTO results (enrollment_id, mid_marks, final_marks)
VALUES 
(
    (SELECT enrollment_id FROM enrollments e 
     JOIN students s ON e.student_id = s.student_id 
     JOIN users u ON s.user_id = u.user_id 
     JOIN course_offerings co ON e.offering_id = co.offering_id
     JOIN courses c ON co.course_id = c.course_id
     WHERE u.email = 'student@uams.edu' AND c.course_code = 'CSE101' LIMIT 1), 
    35.00, -- Mid Marks (out of 40)
    45.00  -- Final Marks (out of 60)
);

-- NOTE: If the query fails, just go to your 'enrollments' table, 
-- look at the ID number for a student's active enrollment, and type:
-- INSERT INTO results (enrollment_id, mid_marks, final_marks) VALUES (1, 35, 45);