-- =============================================================================
-- File: database/triggers.sql
-- Project: Computer Repair Center Management System
-- Database: computer_repair_center
-- Description: Creates the inventory control trigger trg_reduce_spare_part_stock
--              on the repair_parts table to automatically deduct stock from
--              spare_parts and prevent negative stock via custom error signals.
-- =============================================================================

USE computer_repair_center;

DROP TRIGGER IF EXISTS trg_reduce_spare_part_stock;

DELIMITER $$

CREATE TRIGGER trg_reduce_spare_part_stock
AFTER INSERT ON repair_parts
FOR EACH ROW
BEGIN
    DECLARE v_current_stock INT;

    -- Retrieve current available stock for the designated spare part
    SELECT quantity_in_stock
    INTO v_current_stock
    FROM spare_parts
    WHERE part_id = NEW.part_id;

    -- Validate stock sufficiency before deduction
    IF v_current_stock < NEW.quantity THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Insufficient spare-part stock.';
    END IF;

    -- Deduct utilized quantity from spare_parts inventory
    UPDATE spare_parts
    SET quantity_in_stock = quantity_in_stock - NEW.quantity
    WHERE part_id = NEW.part_id;
END$$

DELIMITER ;

-- =============================================================================
-- MANUAL VERIFICATION & TESTING INSTRUCTIONS (COMMENTS ONLY)
-- =============================================================================
-- The following steps can be run manually in MySQL Workbench / VS Code to verify
-- the trigger without altering initial demo data during automated build setups:
--
-- Step 1: Check initial stock level for a target part (e.g., part_id = 6)
--         SELECT part_id, part_name, quantity_in_stock 
--         FROM spare_parts 
--         WHERE part_id = 6;
--
-- Step 2: Insert a valid repair_parts record using an active repair (e.g., repair_id = 12)
--         INSERT INTO repair_parts (repair_id, part_id, quantity, unit_price)
--         VALUES (12, 6, 2, 3100.00);
--
-- Step 3: Check stock again to confirm it was reduced by exactly 2 units
--         SELECT part_id, part_name, quantity_in_stock 
--         FROM spare_parts 
--         WHERE part_id = 6;
--
-- Step 4: Attempt to insert a quantity exceeding available stock (e.g., quantity = 9999)
--         INSERT INTO repair_parts (repair_id, part_id, quantity, unit_price)
--         VALUES (13, 6, 9999, 3100.00);
--
-- Step 5: Verify MySQL aborts the transaction with:
--         Error Code: 1644 (45000): Insufficient spare-part stock.
--
-- Step 6: Rollback or delete test record if testing was performed:
--         DELETE FROM repair_parts WHERE repair_id = 12 AND part_id = 6;
--         UPDATE spare_parts SET quantity_in_stock = quantity_in_stock + 2 WHERE part_id = 6;
-- =============================================================================