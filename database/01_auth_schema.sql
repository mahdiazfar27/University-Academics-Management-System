-- database/01_auth_schema.sql

-- Users Table (Handles Login for Admin, Teacher, Student)
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    role ENUM('admin', 'teacher', 'student') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert Dummy Admin (Password: 'admin123' - Hashing logic applied later)
-- Note: In real app, never store plain text passwords. We will fix this in PHP code.
INSERT INTO users (name, email, password_hash, role) 
VALUES ('System Admin', 'admin@uams.edu', 'admin123', 'admin');