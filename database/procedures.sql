-- =============================================================================
-- File: database/procedures.sql
-- Project: Computer Repair Center Management System
-- Database: computer_repair_center
-- Description: Creates the stored procedure sp_get_repair_details to retrieve
--              a consolidated, single-row detailed report for a specific repair.
--              Includes customer, device, technician, diagnosis, invoice, and
--              payment aggregates with robust validation.
-- =============================================================================

USE computer_repair_center;

DROP PROCEDURE IF EXISTS sp_get_repair_details;

DELIMITER $$

CREATE PROCEDURE sp_get_repair_details(
    IN p_repair_id INT
)
BEGIN
    DECLARE v_repair_exists INT DEFAULT 0;

    -- Verify whether the specified repair_id exists
    SELECT COUNT(*)
    INTO v_repair_exists
    FROM repair_jobs
    WHERE repair_id = p_repair_id;

    -- Raise an exception if the repair record does not exist
    IF v_repair_exists = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Repair ID not found.';
    END IF;

    -- Return consolidated repair details
    -- Uses a derived table for payments to prevent duplicate row multiplication
    SELECT 
        -- Repair Job Details
        r.repair_id,
        r.problem_description,
        r.date_received,
        r.expected_completion_date,
        r.priority,
        r.status,

        -- Customer Details
        c.customer_id,
        c.customer_name,
        c.phone,
        c.email,

        -- Device Details
        d.device_id,
        d.device_type,
        d.brand,
        d.model,
        d.serial_number,

        -- Technician Details
        t.technician_id,
        t.technician_name,
        t.specialization,

        -- Diagnosis Details (Optional, LEFT JOIN)
        diag.problem_found,
        diag.diagnosis_details,
        diag.diagnosis_date,

        -- Invoice Details (Optional, LEFT JOIN)
        inv.invoice_id,
        inv.invoice_date,
        inv.discount,
        inv.total_amount,
        inv.invoice_status,

        -- Payment Summary (Aggregated COMPLETED payments, returns 0 if none)
        COALESCE(pmt.total_paid, 0.00) AS total_paid

    FROM repair_jobs r
    INNER JOIN devices d 
        ON r.device_id = d.device_id
    INNER JOIN customers c 
        ON d.customer_id = c.customer_id
    INNER JOIN technicians t 
        ON r.technician_id = t.technician_id
    LEFT JOIN diagnoses diag 
        ON r.repair_id = diag.repair_id
    LEFT JOIN invoices inv 
        ON r.repair_id = inv.repair_id
    LEFT JOIN (
        SELECT 
            invoice_id,
            SUM(amount) AS total_paid
        FROM payments
        WHERE payment_status = 'COMPLETED'
        GROUP BY invoice_id
    ) pmt 
        ON inv.invoice_id = pmt.invoice_id
    WHERE r.repair_id = p_repair_id;

END$$

DELIMITER ;

-- =============================================================================
-- MANUAL VERIFICATION & TESTING INSTRUCTIONS (COMMENTS ONLY)
-- =============================================================================
-- Test 1: Fetch details for a completed repair with an invoice and payment:
--         CALL sp_get_repair_details(1);
--         Expected: Returns full customer, device, technician, diagnosis, 
--                   invoice details, and total_paid = 3300.00.
--
-- Test 2: Fetch details for a partially paid invoice (split/deposit payments):
--         CALL sp_get_repair_details(4);
--         Expected: Returns invoice details (2100.00) and total_paid = 1000.00.
--
-- Test 3: Fetch details for a new intake repair with no diagnosis or invoice:
--         CALL sp_get_repair_details(13);
--         Expected: Returns customer, device, technician, and repair details.
--                   Diagnosis, invoice fields are NULL, and total_paid = 0.00.
--
-- Test 4: Attempt to fetch details for a non-existent repair ID:
--         CALL sp_get_repair_details(9999);
--         Expected: Error Code 1644 (45000): Repair ID not found.
-- =============================================================================