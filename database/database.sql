-- =============================================================================
-- Database: computer_repair_center
-- Engine: InnoDB
-- Character Set: utf8mb4
-- Description: Core schema definition script for Computer Repair Center Management System
-- =============================================================================

CREATE DATABASE IF NOT EXISTS computer_repair_center
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE computer_repair_center;

-- -----------------------------------------------------------------------------
-- 1. Table: customers
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS customers (
    customer_id INT AUTO_INCREMENT,
    customer_name VARCHAR(100) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    email VARCHAR(100) NULL,
    address VARCHAR(255) NULL,
    CONSTRAINT pk_customers PRIMARY KEY (customer_id),
    INDEX idx_customers_phone (phone)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- 2. Table: devices
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS devices (
    device_id INT AUTO_INCREMENT,
    customer_id INT NOT NULL,
    device_type VARCHAR(50) NOT NULL,
    brand VARCHAR(50) NOT NULL,
    model VARCHAR(100) NOT NULL,
    serial_number VARCHAR(100) NULL,
    operating_system VARCHAR(100) NULL,
    warranty_status VARCHAR(30) NOT NULL,
    CONSTRAINT pk_devices PRIMARY KEY (device_id),
    CONSTRAINT uq_devices_serial_number UNIQUE (serial_number),
    CONSTRAINT fk_devices_customers FOREIGN KEY (customer_id)
        REFERENCES customers (customer_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    INDEX idx_devices_customer_id (customer_id)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- 3. Table: technicians
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS technicians (
    technician_id INT AUTO_INCREMENT,
    technician_name VARCHAR(100) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    specialization VARCHAR(100) NULL,
    experience_years INT NOT NULL,
    CONSTRAINT pk_technicians PRIMARY KEY (technician_id),
    CONSTRAINT chk_technicians_experience CHECK (experience_years >= 0)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- 4. Table: repair_jobs
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS repair_jobs (
    repair_id INT AUTO_INCREMENT,
    device_id INT NOT NULL,
    technician_id INT NOT NULL,
    problem_description TEXT NOT NULL,
    date_received DATETIME NOT NULL,
    expected_completion_date DATE NULL,
    priority VARCHAR(20) NOT NULL,
    status VARCHAR(30) NOT NULL,
    CONSTRAINT pk_repair_jobs PRIMARY KEY (repair_id),
    CONSTRAINT fk_repair_jobs_devices FOREIGN KEY (device_id)
        REFERENCES devices (device_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT fk_repair_jobs_technicians FOREIGN KEY (technician_id)
        REFERENCES technicians (technician_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT chk_repair_jobs_priority CHECK (
        priority IN ('LOW', 'MEDIUM', 'HIGH', 'URGENT')
    ),
    CONSTRAINT chk_repair_jobs_status CHECK (
        status IN ('RECEIVED', 'DIAGNOSING', 'IN_REPAIR', 'WAITING_FOR_PARTS', 'COMPLETED', 'DELIVERED', 'CANCELLED')
    ),
    INDEX idx_repair_jobs_device_id (device_id),
    INDEX idx_repair_jobs_technician_id (technician_id)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- 5. Table: diagnoses
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS diagnoses (
    diagnosis_id INT AUTO_INCREMENT,
    repair_id INT NOT NULL,
    problem_found VARCHAR(255) NOT NULL,
    diagnosis_details TEXT NULL,
    diagnosis_date DATETIME NOT NULL,
    CONSTRAINT pk_diagnoses PRIMARY KEY (diagnosis_id),
    CONSTRAINT uq_diagnoses_repair_id UNIQUE (repair_id),
    CONSTRAINT fk_diagnoses_repair_jobs FOREIGN KEY (repair_id)
        REFERENCES repair_jobs (repair_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- 6. Table: services
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS services (
    service_id INT AUTO_INCREMENT,
    service_name VARCHAR(100) NOT NULL,
    description VARCHAR(255) NULL,
    service_charge DECIMAL(10, 2) NOT NULL,
    CONSTRAINT pk_services PRIMARY KEY (service_id),
    CONSTRAINT uq_services_service_name UNIQUE (service_name),
    CONSTRAINT chk_services_service_charge CHECK (service_charge >= 0.00)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- 7. Table: repair_services
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS repair_services (
    repair_service_id INT AUTO_INCREMENT,
    repair_id INT NOT NULL,
    service_id INT NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(10, 2) NOT NULL,
    CONSTRAINT pk_repair_services PRIMARY KEY (repair_service_id),
    CONSTRAINT uq_repair_services_job_service UNIQUE (repair_id, service_id),
    CONSTRAINT fk_repair_services_repair_jobs FOREIGN KEY (repair_id)
        REFERENCES repair_jobs (repair_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT fk_repair_services_services FOREIGN KEY (service_id)
        REFERENCES services (service_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT chk_repair_services_quantity CHECK (quantity > 0),
    CONSTRAINT chk_repair_services_unit_price CHECK (unit_price >= 0.00),
    INDEX idx_repair_services_repair_id (repair_id),
    INDEX idx_repair_services_service_id (service_id)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- 8. Table: spare_parts
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS spare_parts (
    part_id INT AUTO_INCREMENT,
    part_name VARCHAR(100) NOT NULL,
    category VARCHAR(100) NULL,
    quantity_in_stock INT NOT NULL,
    purchase_price DECIMAL(10, 2) NOT NULL,
    selling_price DECIMAL(10, 2) NOT NULL,
    CONSTRAINT pk_spare_parts PRIMARY KEY (part_id),
    CONSTRAINT chk_spare_parts_stock CHECK (quantity_in_stock >= 0),
    CONSTRAINT chk_spare_parts_purchase_price CHECK (purchase_price >= 0.00),
    CONSTRAINT chk_spare_parts_selling_price CHECK (selling_price >= 0.00)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- 9. Table: repair_parts
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS repair_parts (
    repair_part_id INT AUTO_INCREMENT,
    repair_id INT NOT NULL,
    part_id INT NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(10, 2) NOT NULL,
    CONSTRAINT pk_repair_parts PRIMARY KEY (repair_part_id),
    CONSTRAINT uq_repair_parts_job_part UNIQUE (repair_id, part_id),
    CONSTRAINT fk_repair_parts_repair_jobs FOREIGN KEY (repair_id)
        REFERENCES repair_jobs (repair_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT fk_repair_parts_spare_parts FOREIGN KEY (part_id)
        REFERENCES spare_parts (part_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT chk_repair_parts_quantity CHECK (quantity > 0),
    CONSTRAINT chk_repair_parts_unit_price CHECK (unit_price >= 0.00),
    INDEX idx_repair_parts_repair_id (repair_id),
    INDEX idx_repair_parts_part_id (part_id)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- 10. Table: invoices
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS invoices (
    invoice_id INT AUTO_INCREMENT,
    repair_id INT NOT NULL,
    invoice_date DATETIME NOT NULL,
    discount DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    total_amount DECIMAL(10, 2) NOT NULL,
    invoice_status VARCHAR(30) NOT NULL,
    CONSTRAINT pk_invoices PRIMARY KEY (invoice_id),
    CONSTRAINT uq_invoices_repair_id UNIQUE (repair_id),
    CONSTRAINT fk_invoices_repair_jobs FOREIGN KEY (repair_id)
        REFERENCES repair_jobs (repair_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT chk_invoices_discount CHECK (discount >= 0.00),
    CONSTRAINT chk_invoices_total_amount CHECK (total_amount >= 0.00),
    CONSTRAINT chk_invoices_status CHECK (
        invoice_status IN ('UNPAID', 'PARTIALLY_PAID', 'PAID', 'CANCELLED')
    )
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- 11. Table: payments
-- -----------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS payments (
    payment_id INT AUTO_INCREMENT,
    invoice_id INT NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    payment_method VARCHAR(30) NOT NULL,
    payment_date DATETIME NOT NULL,
    payment_status VARCHAR(30) NOT NULL,
    CONSTRAINT pk_payments PRIMARY KEY (payment_id),
    CONSTRAINT fk_payments_invoices FOREIGN KEY (invoice_id)
        REFERENCES invoices (invoice_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT chk_payments_amount CHECK (amount > 0.00),
    CONSTRAINT chk_payments_method CHECK (
        payment_method IN ('CASH', 'CARD', 'UPI', 'BANK_TRANSFER')
    ),
    CONSTRAINT chk_payments_status CHECK (
        payment_status IN ('PENDING', 'COMPLETED', 'FAILED', 'REFUNDED')
    ),
    INDEX idx_payments_invoice_id (invoice_id)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_unicode_ci;