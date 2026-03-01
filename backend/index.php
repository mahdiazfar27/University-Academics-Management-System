<?php
// backend/index.php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json");

// Include the database connection
require_once 'config/db.php';

// If code reaches here without error, connection is success
if ($pdo) {
    echo json_encode(["status" => "success", "message" => "Database Connected Successfully"]);
}
?>