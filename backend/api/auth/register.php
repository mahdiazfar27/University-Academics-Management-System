<?php
// backend/api/auth/register.php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: POST");

require_once '../../config/db.php';

// Get JSON Input
$data = json_decode(file_get_contents("php://input"));

if (!empty($data->name) && !empty($data->email) && !empty($data->password) && !empty($data->role)) {
    
    // Validate Role (Security check)
    $valid_roles = ['admin', 'teacher', 'student'];
    if (!in_array($data->role, $valid_roles)) {
        http_response_code(400);
        echo json_encode(["message" => "Invalid role selected."]);
        exit();
    }

    // Hash the password
    $password_hash = password_hash($data->password, PASSWORD_BCRYPT);

    try {
        // Insert User
        $query = "INSERT INTO users (name, email, password_hash, role) VALUES (:name, :email, :pass, :role)";
        $stmt = $pdo->prepare($query);

        $stmt->bindParam(":name", $data->name);
        $stmt->bindParam(":email", $data->email);
        $stmt->bindParam(":pass", $password_hash); // Store hash, not text
        $stmt->bindParam(":role", $data->role);

        if ($stmt->execute()) {
            http_response_code(201); // 201 Created
            echo json_encode(["message" => "User registered successfully."]);
        }
    } catch (PDOException $e) {
        if ($e->getCode() == 23000) { // Error 23000 = Duplicate Email
            http_response_code(409); // 409 Conflict
            echo json_encode(["message" => "Email already exists."]);
        } else {
            http_response_code(503);
            echo json_encode(["message" => "Database error: " . $e->getMessage()]);
        }
    }
} else {
    http_response_code(400); // 400 Bad Request
    echo json_encode(["message" => "Incomplete data. Name, email, password, and role required."]);
}
?>