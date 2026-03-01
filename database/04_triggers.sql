-- database/04_triggers.sql
-- SEAT LIMIT AND ENROLLMENT TRIGGERS

-- We change DELIMITER so MySQL doesn't get confused by the semicolons inside the trigger
DELIMITER //

-- TRIGGER 1: Prevent Over-enrollment
CREATE TRIGGER prevent_over_enrollment
BEFORE INSERT ON enrollments
FOR EACH ROW
BEGIN
    DECLARE current_enrolled INT;
    DECLARE max_capacity INT;

    -- Fetch the capacity details for the requested class
    SELECT capacity, enrolled_count INTO max_capacity, current_enrolled
    FROM course_offerings
    WHERE offering_id = NEW.offering_id;

    -- If full, throw a database error
    IF current_enrolled >= max_capacity THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Enrollment failed: This course section is full.';
    END IF;
END //

-- TRIGGER 2: Auto-increase enrolled count when a student Add's a course
CREATE TRIGGER update_enrolled_count_add
AFTER INSERT ON enrollments
FOR EACH ROW
BEGIN
    IF NEW.status = 'active' THEN
        UPDATE course_offerings 
        SET enrolled_count = enrolled_count + 1 
        WHERE offering_id = NEW.offering_id;
    END IF;
END //

-- TRIGGER 3: Auto-decrease enrolled count when a student Drops a course
CREATE TRIGGER update_enrolled_count_drop
AFTER UPDATE ON enrollments
FOR EACH ROW
BEGIN
    -- If status changes from active to dropped
    IF OLD.status = 'active' AND NEW.status = 'dropped' THEN
        UPDATE course_offerings 
        SET enrolled_count = enrolled_count - 1 
        WHERE offering_id = NEW.offering_id;
    END IF;
END //

DELIMITER ;