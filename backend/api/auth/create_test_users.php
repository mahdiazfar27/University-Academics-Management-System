<?php
// backend/api/auth/create_test_users.php
header("Content-Type: application/json");
require_once '../../config/db.php';

// 1. Define Test Users
$users = [
    [
        'name' => 'System Admin',
        'email' => 'admin@uams.edu',
        'password' => 'admin123', // This will be hashed
        'role' => 'admin'
    ],
    [
        'name' => 'John Student',
        'email' => 'student@uams.edu',
        'password' => 'student123',
        'role' => 'student'
    ],
    [
        'name' => 'Prof. Sarah',
        'email' => 'teacher@uams.edu',
        'password' => 'teacher123',
        'role' => 'teacher'
    ]
];

$results = [];

foreach ($users as $user) {
    // Check if user exists
    $check = $pdo->prepare("SELECT email FROM users WHERE email = ?");
    $check->execute([$user['email']]);
    
    if ($check->rowCount() == 0) {
        // Hash the password
        $hash = password_hash($user['password'], PASSWORD_DEFAULT);
        
        // Insert
        $sql = "INSERT INTO users (name, email, password_hash, role) VALUES (?, ?, ?, ?)";
        $stmt = $pdo->prepare($sql);
        if ($stmt->execute([$user['name'], $user['email'], $hash, $user['role']])) {
            $results[] = "Created user: " . $user['email'];
        } else {
            $results[] = "Failed to create: " . $user['email'];
        }
    } else {
        $results[] = "User already exists: " . $user['email'];
    }
}

echo json_encode(["status" => "success", "log" => $results]);
?>