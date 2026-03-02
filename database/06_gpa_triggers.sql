-- database/06_gpa_triggers.sql
-- First, DELETE the old triggers if they exist, so we can start fresh
DROP TRIGGER IF EXISTS calculate_grade_insert;
DROP TRIGGER IF EXISTS calculate_grade_update;

DELIMITER //

-- TRIGGER 1: Calculate Grade on INSERT
CREATE TRIGGER calculate_grade_insert
BEFORE INSERT ON results
FOR EACH ROW
BEGIN
    DECLARE total DECIMAL(5,2);
    SET total = COALESCE(NEW.mid_marks, 0) + COALESCE(NEW.final_marks, 0);

    -- Apply Grading Scale
    IF total >= 80 THEN SET NEW.letter_grade = 'A+', NEW.grade_point = 4.00;
    ELSEIF total >= 75 THEN SET NEW.letter_grade = 'A', NEW.grade_point = 3.75;
    ELSEIF total >= 70 THEN SET NEW.letter_grade = 'A-', NEW.grade_point = 3.50;
    ELSEIF total >= 65 THEN SET NEW.letter_grade = 'B+', NEW.grade_point = 3.25;
    ELSEIF total >= 60 THEN SET NEW.letter_grade = 'B', NEW.grade_point = 3.00;
    ELSEIF total >= 55 THEN SET NEW.letter_grade = 'B-', NEW.grade_point = 2.75;
    ELSEIF total >= 50 THEN SET NEW.letter_grade = 'C+', NEW.grade_point = 2.50;
    ELSEIF total >= 45 THEN SET NEW.letter_grade = 'C', NEW.grade_point = 2.25;
    ELSEIF total >= 40 THEN SET NEW.letter_grade = 'D', NEW.grade_point = 2.00;
    ELSE SET NEW.letter_grade = 'F', NEW.grade_point = 0.00;
    END IF;
END //

-- TRIGGER 2: Calculate Grade on UPDATE
CREATE TRIGGER calculate_grade_update
BEFORE UPDATE ON results
FOR EACH ROW
BEGIN
    DECLARE total DECIMAL(5,2);
    SET total = COALESCE(NEW.mid_marks, 0) + COALESCE(NEW.final_marks, 0);

    IF total >= 80 THEN SET NEW.letter_grade = 'A+', NEW.grade_point = 4.00;
    ELSEIF total >= 75 THEN SET NEW.letter_grade = 'A', NEW.grade_point = 3.75;
    ELSEIF total >= 70 THEN SET NEW.letter_grade = 'A-', NEW.grade_point = 3.50;
    ELSEIF total >= 65 THEN SET NEW.letter_grade = 'B+', NEW.grade_point = 3.25;
    ELSEIF total >= 60 THEN SET NEW.letter_grade = 'B', NEW.grade_point = 3.00;
    ELSEIF total >= 40 THEN SET NEW.letter_grade = 'D', NEW.grade_point = 2.00;
    ELSE SET NEW.letter_grade = 'F', NEW.grade_point = 0.00;
    END IF;
END //

DELIMITER ;