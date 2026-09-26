package com.computerrepair.service;

import com.computerrepair.dao.CustomerDAO;
import com.computerrepair.dao.DeviceDAO;
import com.computerrepair.model.Device;
import java.sql.SQLException;
import java.util.List;

public class DeviceService {
    private final DeviceDAO deviceDAO;
    private final CustomerDAO customerDAO;

    public DeviceService() {
        this.deviceDAO = new DeviceDAO();
        this.customerDAO = new CustomerDAO();
    }

    public DeviceService(DeviceDAO deviceDAO, CustomerDAO customerDAO) {
        this.deviceDAO = deviceDAO;
        this.customerDAO = customerDAO;
    }

    public void registerDevice(Device device) throws IllegalArgumentException, SQLException {
        validateDevice(device);
        if (customerDAO.getCustomerById(device.getCustomerId()) == null) {
            throw new IllegalArgumentException("Selected customer does not exist.");
        }
        if (deviceDAO.isSerialNumberTaken(device.getSerialNumber(), 0)) {
            throw new IllegalArgumentException("A device with this serial number already exists.");
        }
        deviceDAO.addDevice(device);
    }

    public void updateDevice(Device device) throws IllegalArgumentException, SQLException {
        if (device.getDeviceId() <= 0) {
            throw new IllegalArgumentException("Invalid device ID for update.");
        }
        validateDevice(device);
        if (customerDAO.getCustomerById(device.getCustomerId()) == null) {
            throw new IllegalArgumentException("Selected customer does not exist.");
        }
        if (deviceDAO.isSerialNumberTaken(device.getSerialNumber(), device.getDeviceId())) {
            throw new IllegalArgumentException("Another device has this serial number.");
        }
        boolean updated = deviceDAO.updateDevice(device);
        if (!updated) {
            throw new SQLException("Failed to update device. Device record not found.");
        }
    }

    public void deleteDevice(int deviceId) throws IllegalArgumentException, SQLException {
        if (deviceId <= 0) {
            throw new IllegalArgumentException("Invalid device ID.");
        }
        boolean deleted = deviceDAO.deleteDevice(deviceId);
        if (!deleted) {
            throw new SQLException("Device could not be deleted or does not exist.");
        }
    }

    public Device getDeviceById(int deviceId) throws SQLException {
        if (deviceId <= 0) {
            return null;
        }
        return deviceDAO.getDeviceById(deviceId);
    }

    public List<Device> getAllDevices() throws SQLException {
        return deviceDAO.getAllDevices();
    }

    public List<Device> searchDevices(String keyword) throws SQLException {
        if (keyword == null || keyword.trim().isEmpty()) {
            return deviceDAO.getAllDevices();
        }
        return deviceDAO.searchDevices(keyword.trim());
    }

    private void validateDevice(Device device) {
        if (device == null) {
            throw new IllegalArgumentException("Device details cannot be empty.");
        }
        if (device.getCustomerId() <= 0) {
            throw new IllegalArgumentException("A valid customer must be associated with the device.");
        }
        if (device.getBrand() == null || device.getBrand().trim().isEmpty()) {
            throw new IllegalArgumentException("Device brand is required.");
        }
        if (device.getModel() == null || device.getModel().trim().isEmpty()) {
            throw new IllegalArgumentException("Device model is required.");
        }
        if (device.getSerialNumber() == null || device.getSerialNumber().trim().isEmpty()) {
            throw new IllegalArgumentException("Serial number is required.");
        }
        if (device.getDeviceType() == null || device.getDeviceType().trim().isEmpty()) {
            throw new IllegalArgumentException("Device type is required.");
        }
    }
}