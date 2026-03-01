<?php
// backend/config/db.php

$host = '127.0.0.1';
$db   = 'University-Academics-Management-System';
$user = 'root';     // Default XAMPP user
$pass = '';         // Default XAMPP password (empty)
$charset = 'utf8mb4';

$dsn = "mysql:host=$host;dbname=$db;charset=$charset";
$options = [
    PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION, // Throw errors
    PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,       // Return arrays
    PDO::ATTR_EMULATE_PREPARES   => false,                  // Prevent SQL injection simulation
];

try {
    $pdo = new PDO($dsn, $user, $pass, $options);
} catch (\PDOException $e) {
    // Return JSON error if connection fails (API friendly)
    header('Content-Type: application/json');
    echo json_encode(['status' => 'error', 'message' => 'Database connection failed: ' . $e->getMessage()]);
    exit;
}
?>