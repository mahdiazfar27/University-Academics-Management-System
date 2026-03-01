<?php
// backend/api/auth/login.php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: POST");

// 1. HEADERS MUST BE FIRST
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

// Handle "Preflight" OPTIONS request (Browsers sometimes send this first)
if ($_SERVER['REQUEST_METHOD'] == 'OPTIONS') {
    http_response_code(200);
    exit();
}


require_once '../../config/db.php';

$data = json_decode(file_get_contents("php://input"));

if (!empty($data->email) && !empty($data->password)) {

    try {
        // Find User by Email
        $query = "SELECT user_id, name, password_hash, role FROM users WHERE email = :email LIMIT 1";
        $stmt = $pdo->prepare($query);
        $stmt->bindParam(":email", $data->email);
        $stmt->execute();
        $user = $stmt->fetch(PDO::FETCH_ASSOC);

        // Verify Password
        if ($user && password_verify($data->password, $user['password_hash'])) {
            http_response_code(200);
            echo json_encode([
                "status" => "success",
                "message" => "Login successful.",
                "user" => [
                    "id" => $user['user_id'],
                    "name" => $user['name'],
                    "role" => $user['role']
                ]
            ]);
        } else {
            http_response_code(401); // 401 Unauthorized
            echo json_encode(["status" => "error", "message" => "Invalid email or password."]);
        }

    } catch (PDOException $e) {
        http_response_code(503);
        echo json_encode(["message" => "System error."]);
    }
} else {
    http_response_code(400);
    echo json_encode(["message" => "Email and password are required."]);
}
?>