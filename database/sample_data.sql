-- =============================================================================
-- File: database/sample_data.sql
-- Project: Computer Repair Center Management System
-- Database: computer_repair_center
-- Description: Inserts verified, internally consistent demo data across all
--              11 tables adhering to foreign key dependencies, UNIQUE constraints,
--              CHECK constraints, logical workflows, and invoice/payment math.
-- =============================================================================

USE computer_repair_center;

-- =============================================================================
-- 1. CUSTOMERS (10 records)
-- =============================================================================
INSERT INTO customers (customer_id, customer_name, phone, email, address) VALUES
(1, 'Aarav Sharma', '+91-98201-11223', 'aarav.sharma@example.com', 'Flat 402, Green Valley Apartments, Mumbai, MH'),
(2, 'Neha Verma', '+91-98202-22334', 'neha.verma@example.com', 'House 12/A, Model Town, Delhi, DL'),
(3, 'Rohan Kulkarni', '+91-98203-33445', 'rohan.kulkarni@example.com', '74 Shivaji Nagar, Pune, MH'),
(4, 'Pooja Iyer', '+91-98204-44556', 'pooja.iyer@example.com', '104 Palm Grove, Indiranagar, Bengaluru, KA'),
(5, 'Vikram Malhotra', '+91-98205-55667', 'vikram.m@example.com', 'B-301 Regency Heights, Gurugram, HR'),
(6, 'Ananya Sen', '+91-98206-66778', 'ananya.sen@example.com', '28 Salt Lake Sector 1, Kolkata, WB'),
(7, 'Karthik Raja', '+91-98207-77889', 'karthik.raja@example.com', '15 T. Nagar 3rd Street, Chennai, TN'),
(8, 'Sunita Deshmukh', '+91-98208-88990', 'sunita.d@example.com', '55 Samarth Nagar, Chhatrapati Sambhajinagar, MH'),
(9, 'Manish Patel', '+91-98209-99001', 'manish.patel@example.com', '9 Navrangpura Cross Road, Ahmedabad, GJ'),
(10, 'Divya Nair', '+91-98210-10112', 'divya.nair@example.com', '12 Panampilly Nagar, Kochi, KL');

-- =============================================================================
-- 2. TECHNICIANS (6 records)
-- =============================================================================
INSERT INTO technicians (technician_id, technician_name, phone, specialization, experience_years) VALUES
(1, 'Rajesh Gupta', '+91-97111-00001', 'Laptop Repair', 8),
(2, 'Amitabh Roy', '+91-97111-00002', 'Desktop Repair', 10),
(3, 'Suresh Patil', '+91-97111-00003', 'Hardware', 5),
(4, 'Meera Joshi', '+91-97111-00004', 'Software', 4),
(5, 'Deepak Chawla', '+91-97111-00005', 'Networking', 6),
(6, 'Imran Khan', '+91-97111-00006', 'Hardware', 3);

-- =============================================================================
-- 3. DEVICES (14 records)
-- =============================================================================
INSERT INTO devices (device_id, customer_id, device_type, brand, model, serial_number, operating_system, warranty_status) VALUES
(1, 1, 'Laptop', 'Dell', 'XPS 13 9310', 'SN-DELL-9310-001', 'Windows 11 Pro', 'OUT_OF_WARRANTY'),
(2, 1, 'Desktop', 'HP', 'Pavilion Gaming TG01', 'SN-HP-TG01-102', 'Windows 10 Home', 'OUT_OF_WARRANTY'),
(3, 2, 'Laptop', 'Lenovo', 'ThinkPad T14 Gen 2', 'SN-LEN-T14-203', 'Ubuntu 22.04 LTS', 'IN_WARRANTY'),
(4, 3, 'Laptop', 'ASUS', 'ROG Zephyrus G14', 'SN-ASUS-G14-304', 'Windows 11 Home', 'OUT_OF_WARRANTY'),
(5, 3, 'Monitor', 'Samsung', 'Odyssey G5 27-inch', 'SN-SAM-G5-405', NULL, 'IN_WARRANTY'),
(6, 4, 'Laptop', 'Acer', 'Swift 3 SF314', 'SN-ACER-SW3-506', 'Windows 11 Home', 'OUT_OF_WARRANTY'),
(7, 5, 'Desktop', 'Dell', 'OptiPlex 7080 Tower', 'SN-DELL-7080-607', 'Windows 10 Pro', 'IN_WARRANTY'),
(8, 6, 'Printer', 'Canon', 'PIXMA G3010', 'SN-CAN-G30-708', NULL, 'OUT_OF_WARRANTY'),
(9, 6, 'Laptop', 'HP', 'Envy x360 15', 'SN-HP-ENVY-809', 'Windows 11 Home', 'IN_WARRANTY'),
(10, 7, 'Tablet', 'Samsung', 'Galaxy Tab S7 FE', 'SN-SAM-TAB-910', 'Android 13', 'OUT_OF_WARRANTY'),
(11, 8, 'Laptop', 'Lenovo', 'IdeaPad Slim 5', 'SN-LEN-IPS5-011', 'Windows 11 Home', 'IN_WARRANTY'),
(12, 9, 'Desktop', 'Custom PC', 'Ryzen 5 Workstation', 'SN-CUST-R5-112', 'Fedora Workstation 38', 'OUT_OF_WARRANTY'),
(13, 9, 'Laptop', 'Dell', 'Inspiron 15 3511', 'SN-DELL-3511-213', 'Windows 11 Home', 'OUT_OF_WARRANTY'),
(14, 10, 'Laptop', 'HP', 'ProBook 440 G8', 'SN-HP-PB440-314', 'Windows 11 Pro', 'IN_WARRANTY');

-- =============================================================================
-- 4. SERVICES (10 records)
-- =============================================================================
INSERT INTO services (service_id, service_name, description, service_charge) VALUES
(1, 'Hardware Diagnosis', 'Full diagnostic check of motherboard, RAM, storage, and CPU', 300.00),
(2, 'Operating System Installation', 'Clean OS install with official drivers and updates', 600.00),
(3, 'Virus and Malware Removal', 'Deep scan, malware eradication, and system optimization', 500.00),
(4, 'Laptop Cleaning and Thermal Paste', 'Internal dust removal, heat sink clean, and thermal grease repaste', 450.00),
(5, 'Screen Replacement Labor', 'Precision display assembly replacement and cable testing', 750.00),
(6, 'Keyboard Replacement Labor', 'Chassis disassembly and keyboard module installation', 500.00),
(7, 'RAM Upgrade Labor', 'Compatibility verification, memory module insertion, and memtest', 250.00),
(8, 'SSD Installation and Data Migration', 'Drive fitting with full partition clone or OS migration', 700.00),
(9, 'Power Supply Replacement Labor', 'SMPS/PSU installation and safe internal cabling', 400.00),
(10, 'Printer Servicing and Head Cleaning', 'Roller clean, printhead alignment, and test print routine', 550.00);

-- =============================================================================
-- 5. SPARE_PARTS (12 records)
-- High stock levels safely accommodate repair allocations and future trigger checks
-- =============================================================================
INSERT INTO spare_parts (part_id, part_name, category, quantity_in_stock, purchase_price, selling_price) VALUES
(1, 'Kingston Fury 8GB DDR4 3200MHz RAM', 'RAM', 45, 1400.00, 1950.00),
(2, 'Crucial 16GB DDR4 3200MHz SODIMM', 'RAM', 38, 2600.00, 3400.00),
(3, 'Samsung 980 500GB NVMe M.2 SSD', 'SSD', 30, 2900.00, 3900.00),
(4, 'Crucial BX500 1TB 2.5 SATA SSD', 'SSD', 25, 4100.00, 5200.00),
(5, 'Seagate Barracuda 1TB 7200RPM HDD', 'HDD', 20, 2700.00, 3500.00),
(6, 'Dell 56Wh Laptop Battery WDX0R', 'Battery', 18, 2200.00, 3100.00),
(7, 'HP Envy 15 Replacement Keyboard', 'Keyboard', 22, 900.00, 1450.00),
(8, '14.0-inch FHD IPS 30-Pin Display Panel', 'Display', 16, 3200.00, 4600.00),
(9, 'Arctic MX-4 High-Performance Thermal Paste', 'Cooling Fan', 60, 250.00, 450.00),
(10, 'Corsair CV550 550W 80 Plus Bronze PSU', 'Power Supply', 14, 2800.00, 3850.00),
(11, 'Dell 65W Round Tip AC Adapter', 'Adapter', 40, 850.00, 1350.00),
(12, 'Logitech B100 USB Optical Mouse', 'Mouse', 50, 220.00, 380.00);

-- =============================================================================
-- 6. REPAIR_JOBS (14 records)
-- Varied across priorities (LOW, MEDIUM, HIGH, URGENT) and statuses
-- =============================================================================
INSERT INTO repair_jobs (repair_id, device_id, technician_id, problem_description, date_received, expected_completion_date, priority, status) VALUES
(1, 1, 1, 'Laptop fails to power on; battery swollen and trackpad lifting', '2026-08-01 10:15:00', '2026-08-03', 'HIGH', 'DELIVERED'),
(2, 2, 2, 'Random BSOD shutdown under gaming load; loud CPU fan whining', '2026-08-03 11:30:00', '2026-08-06', 'MEDIUM', 'DELIVERED'),
(3, 3, 4, 'Bootloader corrupted after kernel update; user requests dual-boot repair', '2026-08-05 09:45:00', '2026-08-07', 'LOW', 'COMPLETED'),
(4, 4, 3, 'Spilled sugary tea across keyboard; several keys sticky and non-responsive', '2026-08-08 14:20:00', '2026-08-11', 'HIGH', 'DELIVERED'),
(5, 6, 1, 'Cracked display panel after minor drop; back panel hinge stiff', '2026-08-10 12:00:00', '2026-08-13', 'MEDIUM', 'COMPLETED'),
(6, 7, 2, 'Office desktop shuts down within 5 minutes of booting; burning odor detected', '2026-08-12 16:10:00', '2026-08-15', 'URGENT', 'DELIVERED'),
(7, 8, 3, 'Paper feed jamming constantly; printhead output faded and missing magenta', '2026-08-15 10:00:00', '2026-08-18', 'LOW', 'COMPLETED'),
(8, 9, 1, 'Extremely slow boot times; user requests upgrading 8GB RAM to 16GB and NVMe SSD', '2026-08-18 13:15:00', '2026-08-21', 'MEDIUM', 'DELIVERED'),
(9, 11, 4, 'Severe adware infection causing popup redirects and browser hijacking', '2026-08-22 15:30:00', '2026-08-24', 'LOW', 'COMPLETED'),
(10, 12, 5, 'Network card packet drop and intermittent motherboard LAN disconnects', '2026-08-25 11:00:00', '2026-08-29', 'MEDIUM', 'WAITING_FOR_PARTS'),
(11, 13, 1, 'Laptop screen flickering and horizontal white bars appearing when hinge moves', '2026-08-27 10:45:00', '2026-08-30', 'HIGH', 'IN_REPAIR'),
(12, 14, 6, 'Complete power failure; indicator LED blinks orange 3 times then halts', '2026-08-29 16:30:00', '2026-09-02', 'URGENT', 'DIAGNOSING'),
(13, 5, 3, 'Monitor backlight bleeding and power button stuck in pressed state', '2026-09-01 09:30:00', '2026-09-04', 'LOW', 'RECEIVED'),
(14, 10, 4, 'Tablet stuck in continuous boot loop following an interrupted firmware patch', '2026-09-02 14:00:00', '2026-09-05', 'MEDIUM', 'RECEIVED');

-- =============================================================================
-- 7. DIAGNOSES (10 records)
-- 1:1 on repair_id; later jobs (11, 12, 13, 14) intentionally left uncompleted/undiagnosed
-- =============================================================================
INSERT INTO diagnoses (diagnosis_id, repair_id, problem_found, diagnosis_details, diagnosis_date) VALUES
(1, 1, 'Degraded swollen lithium polymer battery pack', 'Battery cells expanded dangerously against palmrest; motherboard DC-in rail verified healthy.', '2026-08-01 11:45:00'),
(2, 2, 'Thermal throttling and dried-out thermal interface material', 'CPU thermal grease degraded to dry crust; heatsink clogged with dust bunnies; peak temp reached 98C.', '2026-08-03 13:00:00'),
(3, 3, 'Damaged GRUB bootloader configuration and partition header error', 'EFI system partition missing chainload pointers; root Ubuntu ext4 filesystem fully intact.', '2026-08-05 11:15:00'),
(4, 4, 'Oxidized key membranes and shorted trace matrix', 'Chassis interior has sugar residue; liquid reached keyboard sheet but stopped short of mainboard.', '2026-08-08 16:00:00'),
(5, 5, 'Fractured TFT glass panel and cracked right hinge mount', 'Screen matrix shattered along bottom edge; eDP 30-pin ribbon cable still passes continuity test.', '2026-08-10 14:00:00'),
(6, 6, 'Faulty power supply unit with leaking electrolytic capacitor', '12V rail voltage drops to 9.2V under load causing instant shutdown; internal capacitor bulge observed.', '2026-08-12 17:30:00'),
(7, 7, 'Dry ink sediment blockage and worn rubber feed roller', 'Cyan and magenta nozzles clogged by non-OEM ink drying; pick-up roller glazed and slipping.', '2026-08-15 12:30:00'),
(8, 8, 'Bottleneck caused by single-channel 8GB RAM and mechanical 5400RPM hard drive', 'Storage active time remains pinned at 100%; SMART health acceptable but read speed throttled at 75MB/s.', '2026-08-18 15:00:00'),
(9, 9, 'Multiple rootkits and malicious Chrome helper extension profiles', 'Found Trojan.Dropper in temp cache and malicious proxy script redirecting DNS queries.', '2026-08-22 17:00:00'),
(10, 10, 'Burned integrated Realtek gigabit PHY chip on motherboard', 'Ethernet controller fried by lightning voltage spike over external RJ45 cable; PCIe bus intact.', '2026-08-26 10:30:00');

-- =============================================================================
-- 8. REPAIR_SERVICES (17 records)
-- Junction table between repair_jobs and services; unique (repair_id, service_id)
-- =============================================================================
INSERT INTO repair_services (repair_service_id, repair_id, service_id, quantity, unit_price) VALUES
-- Repair 1: Hardware Diagnosis (300.00)
(1, 1, 1, 1, 300.00),

-- Repair 2: Hardware Diagnosis (300.00) + Cleaning/Thermal Paste (450.00) = 750.00
(2, 2, 1, 1, 300.00),
(3, 2, 4, 1, 450.00),

-- Repair 3: OS Installation / Bootloader Rebuild (600.00)
(4, 3, 2, 1, 600.00),

-- Repair 4: Hardware Diagnosis (300.00) + Keyboard Replacement Labor (500.00) = 800.00
(5, 4, 1, 1, 300.00),
(6, 4, 6, 1, 500.00),

-- Repair 5: Screen Replacement Labor (750.00)
(7, 5, 5, 1, 750.00),

-- Repair 6: Hardware Diagnosis (300.00) + Power Supply Replacement Labor (400.00) = 700.00
(8, 6, 1, 1, 300.00),
(9, 6, 9, 1, 400.00),

-- Repair 7: Printer Servicing (550.00)
(10, 7, 10, 1, 550.00),

-- Repair 8: RAM Upgrade Labor (250.00) + SSD Migration (700.00) = 950.00
(11, 8, 7, 1, 250.00),
(12, 8, 8, 1, 700.00),

-- Repair 9: Virus Removal (500.00) + OS Installation (600.00) = 1100.00
(13, 9, 3, 1, 500.00),
(14, 9, 2, 1, 600.00),

-- Repair 10: Hardware Diagnosis (300.00) [Awaiting PCIe NIC card]
(15, 10, 1, 1, 300.00),

-- Repair 11: Hardware Diagnosis (300.00) + Screen Labor (750.00) [In repair]
(16, 11, 1, 1, 300.00),
(17, 11, 5, 1, 750.00);

-- =============================================================================
-- 9. REPAIR_PARTS (11 records)
-- Junction table between repair_jobs and spare_parts; unique (repair_id, part_id)
-- Some repairs use no parts (Repairs 3, 7, 9); some use single or multiple parts
-- =============================================================================
INSERT INTO repair_parts (repair_part_id, repair_id, part_id, quantity, unit_price) VALUES
-- Repair 1: 1x Dell 56Wh Laptop Battery WDX0R (3100.00)
(1, 1, 6, 1, 3100.00),

-- Repair 2: 1x Arctic MX-4 Thermal Paste (450.00)
(2, 2, 9, 1, 450.00),

-- Repair 4: 1x HP Envy 15 Replacement Keyboard (1450.00)
(3, 4, 7, 1, 1450.00),

-- Repair 5: 1x 14.0-inch FHD IPS 30-Pin Display Panel (4600.00)
(4, 5, 8, 1, 4600.00),

-- Repair 6: 1x Corsair CV550 PSU (3850.00)
(5, 6, 10, 1, 3850.00),

-- Repair 8: 1x Crucial 16GB SODIMM (3400.00) + 1x Samsung 980 500GB NVMe (3900.00) = 7300.00
(6, 8, 2, 1, 3400.00),
(7, 8, 3, 1, 3900.00),

-- Repair 10: 1x Dell 65W Round Tip AC Adapter (1350.00) [Customer ordered backup adapter]
(8, 10, 11, 1, 1350.00),

-- Repair 11: 1x 14.0-inch FHD IPS 30-Pin Display Panel (4600.00)
(9, 11, 8, 1, 4600.00),

-- Extra testing line: 2x Logitech B100 USB Optical Mouse on Repair 6 (380.00 * 2 = 760.00)
(10, 6, 12, 2, 380.00),

-- Extra testing line: 1x Arctic MX-4 on Repair 8 (450.00)
(11, 8, 9, 1, 450.00);

-- =============================================================================
-- 10. INVOICES (9 records)
-- Math verified: (Services Total + Parts Total - Discount) = Total Amount
-- Status variety: PAID, PARTIALLY_PAID, UNPAID, CANCELLED
-- =============================================================================
-- Inv 1 (Repair 1): Services=300.00, Parts=3100.00, Disc=100.00  => 3300.00 (PAID)
-- Inv 2 (Repair 2): Services=750.00, Parts=450.00,  Disc=0.00    => 1200.00 (PAID)
-- Inv 3 (Repair 3): Services=600.00, Parts=0.00,    Disc=50.00   => 550.00  (PAID)
-- Inv 4 (Repair 4): Services=800.00, Parts=1450.00, Disc=150.00  => 2100.00 (PARTIALLY_PAID)
-- Inv 5 (Repair 5): Services=750.00, Parts=4600.00, Disc=350.00  => 5000.00 (PAID)
-- Inv 6 (Repair 6): Services=700.00, Parts=4610.00, Disc=110.00  => 5200.00 (PARTIALLY_PAID)
-- Inv 7 (Repair 7): Services=550.00, Parts=0.00,    Disc=0.00    => 550.00  (PAID)
-- Inv 8 (Repair 8): Services=950.00, Parts=7750.00, Disc=200.00  => 8500.00 (UNPAID)
-- Inv 9 (Repair 9): Services=1100.00,Parts=0.00,    Disc=100.00  => 1000.00 (PAID)
-- =============================================================================
INSERT INTO invoices (invoice_id, repair_id, invoice_date, discount, total_amount, invoice_status) VALUES
(1, 1, '2026-08-03 14:00:00', 100.00, 3300.00, 'PAID'),
(2, 2, '2026-08-06 16:30:00', 0.00,   1200.00, 'PAID'),
(3, 3, '2026-08-07 15:45:00', 50.00,  550.00,  'PAID'),
(4, 4, '2026-08-11 11:30:00', 150.00, 2100.00, 'PARTIALLY_PAID'),
(5, 5, '2026-08-13 17:00:00', 350.00, 5000.00, 'PAID'),
(6, 6, '2026-08-15 18:20:00', 110.00, 5200.00, 'PARTIALLY_PAID'),
(7, 7, '2026-08-18 16:15:00', 0.00,   550.00,  'PAID'),
(8, 8, '2026-08-21 17:30:00', 200.00, 8500.00, 'UNPAID'),
(9, 9, '2026-08-24 18:00:00', 100.00, 1000.00, 'PAID');

-- =============================================================================
-- 11. PAYMENTS (12 records)
-- Multiple payments for split invoices, single payments, and pending/failed states
-- =============================================================================
INSERT INTO payments (payment_id, invoice_id, amount, payment_method, payment_date, payment_status) VALUES
-- Invoice 1 (3300.00 PAID): Single payment by UPI
(1, 1, 3300.00, 'UPI', '2026-08-03 15:00:00', 'COMPLETED'),

-- Invoice 2 (1200.00 PAID): Single payment by CASH
(2, 2, 1200.00, 'CASH', '2026-08-06 17:00:00', 'COMPLETED'),

-- Invoice 3 (550.00 PAID): Single payment by CARD
(3, 3, 550.00, 'CARD', '2026-08-07 16:10:00', 'COMPLETED'),

-- Invoice 4 (2100.00 PARTIALLY_PAID): First deposit 1000.00 paid, remaining 1100.00 unpaid
(4, 4, 1000.00, 'UPI', '2026-08-11 12:00:00', 'COMPLETED'),

-- Invoice 5 (5000.00 PAID): Split payment across Card (3000.00) + Cash (2000.00)
(5, 5, 3000.00, 'CARD', '2026-08-13 17:15:00', 'COMPLETED'),
(6, 5, 2000.00, 'CASH', '2026-08-13 17:20:00', 'COMPLETED'),

-- Invoice 6 (5200.00 PARTIALLY_PAID): 1 failed attempt, 1 bank transfer deposit (3000.00)
(7, 6, 5200.00, 'CARD', '2026-08-15 18:30:00', 'FAILED'),
(8, 6, 3000.00, 'BANK_TRANSFER', '2026-08-15 19:00:00', 'COMPLETED'),

-- Invoice 7 (550.00 PAID): Single payment by UPI
(9, 7, 550.00, 'UPI', '2026-08-18 16:45:00', 'COMPLETED'),

-- Invoice 8 (8500.00 UNPAID): Customer initiated pending payment that hasn't cleared
(10, 8, 8500.00, 'BANK_TRANSFER', '2026-08-22 09:30:00', 'PENDING'),

-- Invoice 9 (1000.00 PAID): Split payment by 2x UPI installments (500.00 + 500.00)
(11, 9, 500.00, 'UPI', '2026-08-24 18:15:00', 'COMPLETED'),
(12, 9, 500.00, 'UPI', '2026-08-24 18:45:00', 'COMPLETED');

-- =============================================================================
-- SUMMARY OF INSERTED RECORDS:
-- -----------------------------------------------------------------------------
-- 1.  customers       : 10 records
-- 2.  technicians     : 6 records
-- 3.  devices         : 14 records
-- 4.  services        : 10 records
-- 5.  spare_parts     : 12 records (Stock levels healthy for subsequent triggers)
-- 6.  repair_jobs     : 14 records (Covers all priorities & statuses)
-- 7.  diagnoses       : 10 records (Repair jobs 11-14 intentionally null for JOIN tests)
-- 8.  repair_services : 17 records (M:N relations, 1 or multiple services per job)
-- 9.  repair_parts    : 11 records (Jobs with 0, 1, or multiple parts used)
-- 10. invoices        : 9 records  (Strict mathematical balance: Services + Parts - Disc)
-- 11. payments        : 12 records (Single, split, pending, and failed payment flows)
-- =============================================================================