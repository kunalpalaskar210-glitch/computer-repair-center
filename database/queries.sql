-- =============================================================================
-- File: database/queries.sql
-- Project: Computer Repair Center Management System
-- Database: computer_repair_center
-- Description: Demonstrates core relational operations, CRUD flows, multi-table
--              JOINs, aggregation, analytical subqueries, and operational reports
--              on the 11-table schema without mutating core sample data.
-- =============================================================================

USE computer_repair_center;

-- =============================================================================
-- SECTION 1: BASIC SELECT QUERIES
-- =============================================================================

-- Q01: Display all registered customers
-- Demonstrates: Column projection and sorting on a primary entity
SELECT 
    customer_id, 
    customer_name, 
    phone, 
    email, 
    address
FROM customers
ORDER BY customer_id ASC;

-- Q02: Display all service technicians
-- Demonstrates: Projection of staff records and technical attributes
SELECT 
    technician_id, 
    technician_name, 
    phone, 
    specialization, 
    experience_years
FROM technicians
ORDER BY experience_years DESC;

-- Q03: Display all customer devices
-- Demonstrates: Filtering and ordering hardware registry records
SELECT 
    device_id, 
    customer_id, 
    device_type, 
    brand, 
    model, 
    serial_number, 
    operating_system, 
    warranty_status
FROM devices
ORDER BY device_id ASC;

-- Q04: Display all intake repair jobs
-- Demonstrates: Status auditing and intake timeline sorting
SELECT 
    repair_id, 
    device_id, 
    technician_id, 
    problem_description, 
    date_received, 
    expected_completion_date, 
    priority, 
    status
FROM repair_jobs
ORDER BY date_received DESC;

-- Q05: Display all spare parts with inventory stock levels and catalog prices
-- Demonstrates: Real-time inventory evaluation
SELECT 
    part_id, 
    part_name, 
    category, 
    quantity_in_stock, 
    purchase_price, 
    selling_price
FROM spare_parts
ORDER BY category ASC, part_name ASC;


-- =============================================================================
-- SECTION 2: CRUD DEMONSTRATIONS (SAFE DEMONSTRATION WORKFLOW)
-- Note: DML statements use customer_id = 999 to prevent altering demo data.
-- =============================================================================

-- Q06: CRUD - CREATE (Demonstration Insert)
-- Demonstrates: Explicit column insertion into a base table
-- (Uncomment to test execution; safe test key customer_id = 999)
-- INSERT INTO customers (customer_id, customer_name, phone, email, address)
-- VALUES (999, 'Rahul Dravid', '+91-98299-99999', 'rahul.d@example.com', '12 Brigade Road, Bengaluru, KA');

-- Q07: CRUD - READ (Demonstration Select)
-- Demonstrates: Targeted key-based entity retrieval
SELECT 
    customer_id, 
    customer_name, 
    phone, 
    email, 
    address
FROM customers
WHERE customer_id = 1;

-- Q08: CRUD - UPDATE (Demonstration Modification)
-- Demonstrates: Safe scalar mutation with an exact primary key constraint
-- (Uncomment to execute modification on demonstration record 999)
-- UPDATE customers
-- SET phone = '+91-98299-88888',
--     email = 'rahul.updated@example.com'
-- WHERE customer_id = 999;

-- Q09: CRUD - DELETE (Demonstration Removal)
-- Demonstrates: Safe tuple deletion restricted to demonstration record
-- (Uncomment to delete demo record 999)
-- DELETE FROM customers
-- WHERE customer_id = 999;


-- =============================================================================
-- SECTION 3: JOIN QUERIES
-- =============================================================================

-- Q10: JOIN 1 - Customer + Device
-- Demonstrates: 1:N INNER JOIN between device registry and owners
SELECT 
    c.customer_name, 
    c.phone, 
    d.device_type, 
    d.brand, 
    d.model, 
    d.serial_number,
    d.warranty_status
FROM customers c
INNER JOIN devices d 
    ON c.customer_id = d.customer_id
ORDER BY c.customer_name ASC;

-- Q11: JOIN 2 - Repair Job + Customer + Device + Technician
-- Demonstrates: Multi-table INNER JOIN across four core business entities
SELECT 
    r.repair_id, 
    c.customer_name, 
    CONCAT(d.brand, ' ', d.model) AS device_model, 
    t.technician_name, 
    r.problem_description, 
    r.priority, 
    r.status, 
    r.date_received
FROM repair_jobs r
INNER JOIN devices d 
    ON r.device_id = d.device_id
INNER JOIN customers c 
    ON d.customer_id = c.customer_id
INNER JOIN technicians t 
    ON r.technician_id = t.technician_id
ORDER BY r.repair_id ASC;

-- Q12: JOIN 3 - Repair Job + Diagnosis
-- Demonstrates: 1:1 LEFT JOIN retaining intake repairs pending diagnostic review
SELECT 
    r.repair_id, 
    CONCAT(d.brand, ' ', d.model) AS device_model, 
    r.status AS repair_status, 
    diag.problem_found, 
    diag.diagnosis_details, 
    diag.diagnosis_date
FROM repair_jobs r
INNER JOIN devices d 
    ON r.device_id = d.device_id
LEFT JOIN diagnoses diag 
    ON r.repair_id = diag.repair_id
ORDER BY r.repair_id ASC;

-- Q13: JOIN 4 - Repair Job + Services Rendered
-- Demonstrates: M:N Junction table navigation with calculated service line totals
SELECT 
    rs.repair_id, 
    s.service_name, 
    rs.quantity, 
    rs.unit_price, 
    (rs.quantity * rs.unit_price) AS line_total
FROM repair_services rs
INNER JOIN services s 
    ON rs.service_id = s.service_id
ORDER BY rs.repair_id ASC, line_total DESC;

-- Q14: JOIN 5 - Repair Job + Spare Parts Utilized
-- Demonstrates: M:N Junction table navigation with calculated inventory line totals
SELECT 
    rp.repair_id, 
    sp.part_name, 
    sp.category, 
    rp.quantity, 
    rp.unit_price, 
    (rp.quantity * rp.unit_price) AS line_total
FROM repair_parts rp
INNER JOIN spare_parts sp 
    ON rp.part_id = sp.part_id
ORDER BY rp.repair_id ASC, line_total DESC;

-- Q15: JOIN 6 - Invoice + Customer + Repair
-- Demonstrates: Relational billing trace linking financial receipts to job history
SELECT 
    inv.invoice_id, 
    inv.repair_id, 
    c.customer_name, 
    inv.invoice_date, 
    inv.discount, 
    inv.total_amount, 
    inv.invoice_status
FROM invoices inv
INNER JOIN repair_jobs r 
    ON inv.repair_id = r.repair_id
INNER JOIN devices d 
    ON r.device_id = d.device_id
INNER JOIN customers c 
    ON d.customer_id = c.customer_id
ORDER BY inv.invoice_id ASC;

-- Q16: JOIN 7 - Invoice + Payments
-- Demonstrates: 1:N financial audit trail for invoice settlements
SELECT 
    inv.invoice_id, 
    inv.total_amount AS invoice_total, 
    p.payment_id, 
    p.amount AS payment_amount, 
    p.payment_method, 
    p.payment_date, 
    p.payment_status
FROM invoices inv
LEFT JOIN payments p 
    ON inv.invoice_id = p.invoice_id
ORDER BY inv.invoice_id ASC, p.payment_date ASC;


-- =============================================================================
-- SECTION 4: AGGREGATE QUERIES (COUNT, SUM, AVG, MIN, MAX)
-- =============================================================================

-- Q17: Overall entity counts
-- Demonstrates: COUNT aggregate function on primary collections
SELECT 
    COUNT(*) AS total_customers_registered
FROM customers;

-- Q18: Count repairs partitioned by status
-- Demonstrates: COUNT with GROUP BY across domain states
SELECT 
    status, 
    COUNT(*) AS total_repairs
FROM repair_jobs
GROUP BY status
ORDER BY total_repairs DESC;

-- Q19: Count repair volume assigned per technician
-- Demonstrates: COUNT aggregate with relational foreign key grouping
SELECT 
    t.technician_name, 
    COUNT(r.repair_id) AS assigned_repairs
FROM technicians t
LEFT JOIN repair_jobs r 
    ON t.technician_id = r.technician_id
GROUP BY t.technician_id, t.technician_name
ORDER BY assigned_repairs DESC;

-- Q20: Total billable labor revenue from repair services
-- Demonstrates: Arithmetic SUM aggregate over junction records
SELECT 
    SUM(quantity * unit_price) AS total_service_revenue
FROM repair_services;

-- Q21: Total spare-parts revenue billed across all repairs
-- Demonstrates: Arithmetic SUM aggregate over inventory usage lines
SELECT 
    SUM(quantity * unit_price) AS total_spare_parts_revenue
FROM repair_parts;

-- Q22: Average, minimum, and maximum catalog service charges
-- Demonstrates: AVG, MIN, and MAX scalar aggregates on financial catalog
SELECT 
    AVG(service_charge) AS average_service_charge, 
    MIN(service_charge) AS lowest_service_charge, 
    MAX(service_charge) AS highest_service_charge
FROM services;

-- Q23: Total net cash inflows from completed customer payments
-- Demonstrates: SUM aggregate with conditional filter logic
SELECT 
    SUM(amount) AS total_completed_payments_collected
FROM payments
WHERE payment_status = 'COMPLETED';


-- =============================================================================
-- SECTION 5: GROUP BY AND HAVING
-- =============================================================================

-- Q24: Total quantity consumed per spare-part SKU
-- Demonstrates: GROUP BY on junction table references
SELECT 
    sp.part_id, 
    sp.part_name, 
    SUM(rp.quantity) AS total_units_consumed
FROM spare_parts sp
INNER JOIN repair_parts rp 
    ON sp.part_id = rp.part_id
GROUP BY sp.part_id, sp.part_name
ORDER BY total_units_consumed DESC;

-- Q25: Active senior technicians handling heavy workloads (repairs > 2)
-- Demonstrates: GROUP BY with HAVING filter condition on aggregate volume
SELECT 
    t.technician_id, 
    t.technician_name, 
    COUNT(r.repair_id) AS total_repairs_handled
FROM technicians t
INNER JOIN repair_jobs r 
    ON t.technician_id = r.technician_id
GROUP BY t.technician_id, t.technician_name
HAVING COUNT(r.repair_id) > 2
ORDER BY total_repairs_handled DESC;

-- Q26: High-turnover spare parts with cumulative usage >= 2 units
-- Demonstrates: GROUP BY and HAVING applied to inventory consumption thresholds
SELECT 
    sp.part_id, 
    sp.part_name, 
    sp.category, 
    SUM(rp.quantity) AS total_quantity_used
FROM spare_parts sp
INNER JOIN repair_parts rp 
    ON sp.part_id = rp.part_id
GROUP BY sp.part_id, sp.part_name, sp.category
HAVING SUM(rp.quantity) >= 2
ORDER BY total_quantity_used DESC;


-- =============================================================================
-- SECTION 6: SUBQUERIES
-- =============================================================================

-- Q27: Catalog services with charges above the portfolio average
-- Demonstrates: Non-correlated scalar subquery in WHERE clause
SELECT 
    service_id, 
    service_name, 
    service_charge
FROM services
WHERE service_charge > (
    SELECT AVG(service_charge) 
    FROM services
)
ORDER BY service_charge DESC;

-- Q28: Technicians handling more repair jobs than the workforce average across all technicians
-- Demonstrates: Scalar subquery calculating the true fleet-wide average (including zero-job technicians)
SELECT 
    t.technician_id, 
    t.technician_name, 
    COUNT(r.repair_id) AS assigned_repairs
FROM technicians t
LEFT JOIN repair_jobs r 
    ON t.technician_id = r.technician_id
GROUP BY t.technician_id, t.technician_name
HAVING COUNT(r.repair_id) > (
    SELECT COUNT(r2.repair_id) / COUNT(DISTINCT t2.technician_id)
    FROM technicians t2
    LEFT JOIN repair_jobs r2 
        ON t2.technician_id = r2.technician_id
)
ORDER BY assigned_repairs DESC;

-- Q29: Spare parts priced higher than the average selling price across all stock
-- Demonstrates: Uncorrelated scalar subquery for inventory price tiering
SELECT 
    part_id, 
    part_name, 
    category, 
    selling_price
FROM spare_parts
WHERE selling_price > (
    SELECT AVG(selling_price) 
    FROM spare_parts
)
ORDER BY selling_price DESC;

-- Q30: Customers with at least one active or historical repair intake
-- Demonstrates: Correlated subquery using EXISTS
SELECT 
    c.customer_id, 
    c.customer_name, 
    c.phone, 
    c.email
FROM customers c
WHERE EXISTS (
    SELECT 1 
    FROM devices d
    INNER JOIN repair_jobs r 
        ON d.device_id = r.device_id
    WHERE d.customer_id = c.customer_id
)
ORDER BY c.customer_id ASC;


-- =============================================================================
-- SECTION 7: SEARCH AND FILTER QUERIES
-- =============================================================================

-- Q31: Search customers by wildcard name match
-- Demonstrates: Text search pattern matching using LIKE
SELECT 
    customer_id, 
    customer_name, 
    phone, 
    email
FROM customers
WHERE customer_name LIKE '%Sharma%';

-- Q32: Search customers by contact phone prefix
-- Demonstrates: Wildcard phone number search
SELECT 
    customer_id, 
    customer_name, 
    phone
FROM customers
WHERE phone LIKE '+91-98201%';

-- Q33: Filter hardware assets by brand specification
-- Demonstrates: Case-insensitive equality matching
SELECT 
    device_id, 
    customer_id, 
    device_type, 
    brand, 
    model, 
    serial_number
FROM devices
WHERE brand = 'Dell';

-- Q34: Filter repair tickets by prioritized operational urgency
-- Demonstrates: Enumerated domain filtering with specific priority states
SELECT 
    repair_id, 
    device_id, 
    problem_description, 
    priority, 
    status
FROM repair_jobs
WHERE priority IN ('HIGH', 'URGENT')
ORDER BY priority DESC;

-- Q35: Filter repair tickets by execution status
-- Demonstrates: Operational queue filtering for active diagnostics
SELECT 
    repair_id, 
    technician_id, 
    problem_description, 
    date_received
FROM repair_jobs
WHERE status = 'DIAGNOSING';

-- Q36: Filter repair tickets assigned to a specific technician
-- Demonstrates: Staff assignment tracking by technician ID
SELECT 
    repair_id, 
    device_id, 
    problem_description, 
    status, 
    priority
FROM repair_jobs
WHERE technician_id = 1;

-- Q37: Search catalog inventory by partial part name
-- Demonstrates: Substring containment lookup on catalog components
SELECT 
    part_id, 
    part_name, 
    category, 
    quantity_in_stock, 
    selling_price
FROM spare_parts
WHERE part_name LIKE '%SSD%';

-- Q38: Search repairs received within a calibrated historical window
-- Demonstrates: Interval filtering using BETWEEN on DATETIME columns
SELECT 
    repair_id, 
    device_id, 
    technician_id, 
    date_received, 
    status
FROM repair_jobs
WHERE date_received BETWEEN '2026-08-01 00:00:00' AND '2026-08-15 23:59:59'
ORDER BY date_received ASC;


-- =============================================================================
-- SECTION 8: MANAGEMENT REPORTS
-- =============================================================================

-- Q39: Report 1 - Operational Active Repairs Dashboard
-- Demonstrates: Multi-table join isolating in-progress repair jobs
SELECT 
    r.repair_id, 
    c.customer_name, 
    c.phone AS customer_phone, 
    CONCAT(d.brand, ' ', d.model) AS device, 
    t.technician_name, 
    r.priority, 
    r.status, 
    r.date_received
FROM repair_jobs r
INNER JOIN devices d 
    ON r.device_id = d.device_id
INNER JOIN customers c 
    ON d.customer_id = c.customer_id
INNER JOIN technicians t 
    ON r.technician_id = t.technician_id
WHERE r.status NOT IN ('COMPLETED', 'DELIVERED', 'CANCELLED')
ORDER BY r.date_received ASC;

-- Q40: Report 2 - Technician Performance & Workload Breakdown
-- Demonstrates: Conditional aggregation using SUM with CASE expressions
SELECT 
    t.technician_id, 
    t.technician_name, 
    t.specialization, 
    COUNT(r.repair_id) AS total_assigned_repairs, 
    SUM(CASE WHEN r.status IN ('COMPLETED', 'DELIVERED') THEN 1 ELSE 0 END) AS completed_repairs, 
    SUM(CASE WHEN r.status NOT IN ('COMPLETED', 'DELIVERED', 'CANCELLED') THEN 1 ELSE 0 END) AS active_repairs
FROM technicians t
LEFT JOIN repair_jobs r 
    ON t.technician_id = r.technician_id
GROUP BY t.technician_id, t.technician_name, t.specialization
ORDER BY total_assigned_repairs DESC;

-- Q41: Report 3 - Spare-Part Inventory Reorder Threshold Analysis
-- Demonstrates: Multi-branch CASE classification for stock health evaluation
-- (Threshold: OUT OF STOCK = 0, LOW STOCK < 20, HEALTHY/AVAILABLE >= 20)
SELECT 
    part_id, 
    part_name, 
    category, 
    quantity_in_stock, 
    selling_price, 
    CASE 
        WHEN quantity_in_stock = 0 THEN 'OUT OF STOCK'
        WHEN quantity_in_stock < 20 THEN 'LOW STOCK'
        ELSE 'AVAILABLE'
    END AS stock_status
FROM spare_parts
ORDER BY quantity_in_stock ASC;

-- Q42: Report 4 - Financial Account Statement & Receivables Aging
-- Demonstrates: Safe join aggregation using derived tables to calculate net balance
SELECT 
    inv.invoice_id, 
    inv.repair_id, 
    c.customer_name, 
    inv.total_amount AS invoice_total, 
    COALESCE(pmt.total_paid, 0.00) AS completed_payments, 
    (inv.total_amount - COALESCE(pmt.total_paid, 0.00)) AS remaining_balance, 
    inv.invoice_status
FROM invoices inv
INNER JOIN repair_jobs r 
    ON inv.repair_id = r.repair_id
INNER JOIN devices d 
    ON r.device_id = d.device_id
INNER JOIN customers c 
    ON d.customer_id = c.customer_id
LEFT JOIN (
    SELECT 
        invoice_id, 
        SUM(amount) AS total_paid
    FROM payments
    WHERE payment_status = 'COMPLETED'
    GROUP BY invoice_id
) pmt 
    ON inv.invoice_id = pmt.invoice_id
ORDER BY remaining_balance DESC, inv.invoice_id ASC;

-- Q43: Report 5 - Comprehensive Corporate Revenue Summary
-- Demonstrates: Cross-table financial ledger aggregation via subqueries
SELECT 
    (SELECT COALESCE(SUM(total_amount), 0.00) FROM invoices) AS total_invoiced_amount, 
    (SELECT COALESCE(SUM(amount), 0.00) FROM payments WHERE payment_status = 'COMPLETED') AS total_completed_payments, 
    ((SELECT COALESCE(SUM(total_amount), 0.00) FROM invoices) - 
     (SELECT COALESCE(SUM(amount), 0.00) FROM payments WHERE payment_status = 'COMPLETED')) AS total_outstanding_receivables;


-- =============================================================================
-- SECTION 9: DATE / TIME QUERIES
-- =============================================================================

-- Q44: Repairs received during August 2026 (matching demo intake cohort)
-- Demonstrates: MySQL MONTH() and YEAR() date extraction functions
SELECT 
    repair_id, 
    device_id, 
    problem_description, 
    date_received, 
    status
FROM repair_jobs
WHERE MONTH(date_received) = 8 
  AND YEAR(date_received) = 2026
ORDER BY date_received ASC;

-- Q45: Overdue repair jobs exceeding SLA target completion date
-- Demonstrates: Comparative date evaluation against active ticket statuses
-- Note: Evaluated against fixed reference snapshot '2026-09-20'
SELECT 
    repair_id, 
    device_id, 
    technician_id, 
    date_received, 
    expected_completion_date, 
    status
FROM repair_jobs
WHERE expected_completion_date < '2026-09-20'
  AND status NOT IN ('COMPLETED', 'DELIVERED', 'CANCELLED')
ORDER BY expected_completion_date ASC;


-- =============================================================================
-- SECTION 10: NULL / OPTIONAL DATA QUERIES
-- =============================================================================

-- Q46: Repairs awaiting diagnostic review
-- Demonstrates: Outer join with IS NULL check to identify incomplete workflow stages
SELECT 
    r.repair_id, 
    CONCAT(d.brand, ' ', d.model) AS device, 
    r.problem_description, 
    r.date_received, 
    r.status
FROM repair_jobs r
INNER JOIN devices d 
    ON r.device_id = d.device_id
LEFT JOIN diagnoses diag 
    ON r.repair_id = diag.repair_id
WHERE diag.diagnosis_id IS NULL
ORDER BY r.repair_id ASC;

-- Q47: Active or finished repairs pending billing invoice generation
-- Demonstrates: Outer join with IS NULL check to spot missing accounting documents
SELECT 
    r.repair_id, 
    c.customer_name, 
    CONCAT(d.brand, ' ', d.model) AS device, 
    r.status, 
    r.date_received
FROM repair_jobs r
INNER JOIN devices d 
    ON r.device_id = d.device_id
INNER JOIN customers c 
    ON d.customer_id = c.customer_id
LEFT JOIN invoices inv 
    ON r.repair_id = inv.repair_id
WHERE inv.invoice_id IS NULL
ORDER BY r.repair_id ASC;