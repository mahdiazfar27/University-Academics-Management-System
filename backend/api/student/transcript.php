<?php
// backend/api/student/transcript.php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

require_once '../../config/db.php';

// Get the user_id from the URL (e.g., transcript.php?user_id=2)
// In a real app, we'd use Sessions, but for this lab, we use query params.
$user_id = isset($_GET['user_id']) ? $_GET['user_id'] : die();

try {
    // 1. Get overall CGPA and standing from Rupom's View
    $summaryQuery = "SELECT * FROM student_cgpa_view WHERE student_id = 
                    (SELECT student_id FROM students WHERE user_id = :uid)";
    $stmt1 = $pdo->prepare($summaryQuery);
    $stmt1->execute(['uid' => $user_id]);
    $summary = $stmt1->fetch();

    // 2. Get detailed semester-wise grades
    $detailsQuery = "
        SELECT 
            c.course_code, 
            c.course_title, 
            c.credits, 
            r.grade_point, 
            r.letter_grade,
            s.semester_name,
            s.year
        FROM results r
        JOIN enrollments e ON r.enrollment_id = e.enrollment_id
        JOIN course_offerings co ON e.offering_id = co.offering_id
        JOIN courses c ON co.course_id = c.course_id
        JOIN semesters s ON co.semester_id = s.semester_id
        WHERE e.student_id = (SELECT student_id FROM students WHERE user_id = :uid)
    ";
    $stmt2 = $pdo->prepare($detailsQuery);
    $stmt2->execute(['uid' => $user_id]);
    $results = $stmt2->fetchAll();

    echo json_encode([
        "status" => "success",
        "summary" => $summary,
        "details" => $results
    ]);

} catch (PDOException $e) {
    echo json_encode(["status" => "error", "message" => $e->getMessage()]);
}
?>