<?php
// backend/api/student/available_courses.php

header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: GET");

require_once '../../config/db.php';

try {
    // A safe query explicitly selecting just what we need
    $query = "
        SELECT 
            co.offering_id, 
            c.course_code, 
            c.course_title, 
            c.credits,
            co.section_name, 
            co.capacity, 
            co.enrolled_count,
            u.name AS teacher_name
        FROM course_offerings co
        INNER JOIN courses c ON co.course_id = c.course_id
        INNER JOIN teachers t ON co.teacher_id = t.teacher_id
        INNER JOIN users u ON t.user_id = u.user_id
    ";
    
    $stmt = $pdo->prepare($query);
    $stmt->execute();
    $courses = $stmt->fetchAll(PDO::FETCH_ASSOC); // Fetch strictly as an Array

    // Safely encode to JSON
    $jsonOutput = json_encode(["status" => "success", "data" => $courses]);

    // IF JSON encoding failed silently, this catches it and shows us why!
    if ($jsonOutput === false) {
        echo json_encode(["status" => "error", "message" => "JSON Encoding Error: " . json_last_error_msg()]);
    } else {
        echo $jsonOutput;
    }

} catch (PDOException $e) {
    echo json_encode(["status" => "error", "message" => "Database Query Failed: " . $e->getMessage()]);
}
?>