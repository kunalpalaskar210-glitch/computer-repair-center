package com.computerrepair.dao;

import com.computerrepair.database.DBConnection;
import com.computerrepair.model.Device;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class DeviceDAO {

    public boolean addDevice(Device device) throws SQLException {
        String sql = "INSERT INTO devices (customer_id, brand, model, serial_number, device_type, issue_description) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setInt(1, device.getCustomerId());
            stmt.setString(2, device.getBrand());
            stmt.setString(3, device.getModel());
            stmt.setString(4, device.getSerialNumber());
            stmt.setString(5, device.getDeviceType());
            stmt.setString(6, device.getIssueDescription());

            int affectedRows = stmt.executeUpdate();
            if (affectedRows > 0) {
                try (ResultSet rs = stmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        device.setDeviceId(rs.getInt(1));
                    }
                }
                return true;
            }
            return false;
        }
    }

    public Device getDeviceById(int deviceId) throws SQLException {
        String sql = "SELECT d.device_id, d.customer_id, d.brand, d.model, d.serial_number, d.device_type, d.issue_description, d.created_at, " +
                     "CONCAT(c.first_name, ' ', c.last_name) AS customer_name " +
                     "FROM devices d " +
                     "LEFT JOIN customers c ON d.customer_id = c.customer_id " +
                     "WHERE d.device_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, deviceId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToDevice(rs);
                }
            }
        }
        return null;
    }

    public List<Device> getAllDevices() throws SQLException {
        List<Device> devices = new ArrayList<>();
        String sql = "SELECT d.device_id, d.customer_id, d.brand, d.model, d.serial_number, d.device_type, d.issue_description, d.created_at, " +
                     "CONCAT(c.first_name, ' ', c.last_name) AS customer_name " +
                     "FROM devices d " +
                     "LEFT JOIN customers c ON d.customer_id = c.customer_id " +
                     "ORDER BY d.device_id DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                devices.add(mapResultSetToDevice(rs));
            }
        }
        return devices;
    }

    public List<Device> getDevicesByCustomerId(int customerId) throws SQLException {
        List<Device> list = new ArrayList<>();
        String sql = "SELECT d.device_id, d.customer_id, d.brand, d.model, d.serial_number, d.device_type, d.issue_description, d.created_at, " +
                     "CONCAT(c.first_name, ' ', c.last_name) AS customer_name " +
                     "FROM devices d " +
                     "LEFT JOIN customers c ON d.customer_id = c.customer_id " +
                     "WHERE d.customer_id = ? ORDER BY d.device_id DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, customerId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToDevice(rs));
                }
            }
        }
        return list;
    }

    public boolean updateDevice(Device device) throws SQLException {
        String sql = "UPDATE devices SET customer_id = ?, brand = ?, model = ?, serial_number = ?, device_type = ?, issue_description = ? WHERE device_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, device.getCustomerId());
            stmt.setString(2, device.getBrand());
            stmt.setString(3, device.getModel());
            stmt.setString(4, device.getSerialNumber());
            stmt.setString(5, device.getDeviceType());
            stmt.setString(6, device.getIssueDescription());
            stmt.setInt(7, device.getDeviceId());
            return stmt.executeUpdate() > 0;
        }
    }

    public boolean deleteDevice(int deviceId) throws SQLException {
        String sql = "DELETE FROM devices WHERE device_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, deviceId);
            return stmt.executeUpdate() > 0;
        }
    }

    public List<Device> searchDevices(String keyword) throws SQLException {
        List<Device> list = new ArrayList<>();
        String sql = "SELECT d.device_id, d.customer_id, d.brand, d.model, d.serial_number, d.device_type, d.issue_description, d.created_at, " +
                     "CONCAT(c.first_name, ' ', c.last_name) AS customer_name " +
                     "FROM devices d " +
                     "LEFT JOIN customers c ON d.customer_id = c.customer_id " +
                     "WHERE d.brand LIKE ? OR d.model LIKE ? OR d.serial_number LIKE ? OR d.device_type LIKE ? OR c.first_name LIKE ? OR c.last_name LIKE ? " +
                     "ORDER BY d.device_id DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            String wildcard = "%" + keyword + "%";
            for (int i = 1; i <= 6; i++) {
                stmt.setString(i, wildcard);
            }
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToDevice(rs));
                }
            }
        }
        return list;
    }

    public boolean isSerialNumberTaken(String serialNumber, int excludeDeviceId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM devices WHERE serial_number = ? AND device_id <> ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, serialNumber);
            stmt.setInt(2, excludeDeviceId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        }
        return false;
    }

    private Device mapResultSetToDevice(ResultSet rs) throws SQLException {
        Device device = new Device(
                rs.getInt("device_id"),
                rs.getInt("customer_id"),
                rs.getString("brand"),
                rs.getString("model"),
                rs.getString("serial_number"),
                rs.getString("device_type"),
                rs.getString("issue_description"),
                rs.getTimestamp("created_at")
        );
        device.setCustomerName(rs.getString("customer_name"));
        return device;
    }
}