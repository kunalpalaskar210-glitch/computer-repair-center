-- =============================================================================
-- File: database/views.sql
-- Project: Computer Repair Center Management System
-- Database: computer_repair_center
-- Description: Defines the vw_active_repairs view to present an operational
--              overview of ongoing repair jobs by linking customers, devices,
--              repair jobs, and assigned technicians.
-- =============================================================================

USE computer_repair_center;

-- -----------------------------------------------------------------------------
-- View: vw_active_repairs
-- Description: Consolidates active repair jobs (RECEIVED, DIAGNOSING, IN_REPAIR,
--              WAITING_FOR_PARTS), excluding finished and terminated workflows.
-- -----------------------------------------------------------------------------
CREATE OR REPLACE VIEW vw_active_repairs AS
SELECT 
    r.repair_id,
    c.customer_id,
    c.customer_name,
    c.phone,
    d.device_id,
    d.device_type,
    d.brand,
    d.model,
    d.serial_number,
    t.technician_id,
    t.technician_name,
    t.specialization,
    r.problem_description,
    r.date_received,
    r.expected_completion_date,
    r.priority,
    r.status
FROM repair_jobs r
INNER JOIN devices d 
    ON r.device_id = d.device_id
INNER JOIN customers c 
    ON d.customer_id = c.customer_id
INNER JOIN technicians t 
    ON r.technician_id = t.technician_id
WHERE r.status NOT IN ('COMPLETED', 'DELIVERED', 'CANCELLED');

-- -----------------------------------------------------------------------------
-- Test Query: Verify view creation and active repair record retrieval
-- -----------------------------------------------------------------------------
SELECT * 
FROM vw_active_repairs;