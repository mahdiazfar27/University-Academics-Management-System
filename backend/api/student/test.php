<?php
// backend/api/student/test.php

echo "<h3>Step 1: PHP is working.</h3>";

// Let's try to load the database file...
echo "<p>Attempting to load db.php...</p>";

require_once '../../config/db.php';

// If db.php is broken, the code will STOP before reaching Step 2.
echo "<h3 style='color:green;'>Step 2: db.php loaded successfully! The problem is not here.</h3>";
?>