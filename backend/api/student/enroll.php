<?php
// backend/api/student/enroll.php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: POST");

require_once '../../config/db.php';

$data = json_decode(file_get_contents("php://input"));

if (!empty($data->user_id) && !empty($data->offering_id)) {
    try {
        // CALL the Stored Procedure you just created in phpMyAdmin
        $query = "CALL EnrollStudent(:user_id, :offering_id)";
        $stmt = $pdo->prepare($query);
        $stmt->bindParam(":user_id", $data->user_id);
        $stmt->bindParam(":offering_id", $data->offering_id);
        
        $stmt->execute();

        echo json_encode(["status" => "success", "message" => "Successfully enrolled in the course!"]);

    } catch (PDOException $e) {
        // Catch Database Errors (Triggers & Unique Constraints)
        $errorMessage = $e->getMessage();
        
        if ($e->getCode() == 23000) {
            // Error 23000 is MySQL's code for "Duplicate Entry" (Unique Constraint)
            http_response_code(409);
            echo json_encode(["status" => "error", "message" => "You are already enrolled in this course."]);
        } 
        elseif (strpos($errorMessage, '45000') !== false) {
            // Error 45000 is our custom error from the Seat Limit Trigger!
            http_response_code(400);
            // Extract just our clean text message from the ugly SQL error string
            $cleanMsg = preg_replace('/SQLSTATE\[45000\]:.*1644 /', '', $errorMessage);
            echo json_encode(["status" => "error", "message" => $cleanMsg]);
        } 
        else {
            http_response_code(500);
            echo json_encode(["status" => "error", "message" => "Database error: " . $errorMessage]);
        }
    }
} else {
    http_response_code(400);
    echo json_encode(["status" => "error", "message" => "User ID and Offering ID are required."]);
}
?>