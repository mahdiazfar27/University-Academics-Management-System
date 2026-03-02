-- database/07_gpa_view.sql

CREATE OR REPLACE VIEW student_cgpa_view AS
SELECT 
    s.student_id,
    s.student_code,
    u.name AS student_name,
    d.dept_name,
    -- Total Credits Attempted
    SUM(c.credits) AS total_credits_attempted,
    
    -- Formula: Sum of (Course Credits * Earned Grade Point) / Total Credits
    ROUND( SUM(c.credits * r.grade_point) / SUM(c.credits), 2 ) AS cgpa

FROM students s
JOIN users u ON s.user_id = u.user_id
JOIN departments d ON s.dept_id = d.dept_id
JOIN enrollments e ON s.student_id = e.student_id
JOIN course_offerings co ON e.offering_id = co.offering_id
JOIN courses c ON co.course_id = c.course_id
JOIN results r ON e.enrollment_id = r.enrollment_id

WHERE e.status = 'completed' OR r.grade_point IS NOT NULL -- Only count courses with grades

GROUP BY s.student_id;