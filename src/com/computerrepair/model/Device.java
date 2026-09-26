package com.computerrepair.model;

import java.sql.Timestamp;

public class Device {
    private int deviceId;
    private int customerId;
    private String brand;
    private String model;
    private String serialNumber;
    private String deviceType;
    private String issueDescription;
    private Timestamp createdAt;

    // Joined helper field for display convenience in tables and lists
    private String customerName;

    public Device() {}

    public Device(int customerId, String brand, String model, String serialNumber, String deviceType, String issueDescription) {
        this.customerId = customerId;
        this.brand = brand;
        this.model = model;
        this.serialNumber = serialNumber;
        this.deviceType = deviceType;
        this.issueDescription = issueDescription;
    }

    public Device(int deviceId, int customerId, String brand, String model, String serialNumber, String deviceType, String issueDescription, Timestamp createdAt) {
        this.deviceId = deviceId;
        this.customerId = customerId;
        this.brand = brand;
        this.model = model;
        this.serialNumber = serialNumber;
        this.deviceType = deviceType;
        this.issueDescription = issueDescription;
        this.createdAt = createdAt;
    }

    public int getDeviceId() {
        return deviceId;
    }

    public void setDeviceId(int deviceId) {
        this.deviceId = deviceId;
    }

    public int getCustomerId() {
        return customerId;
    }

    public void setCustomerId(int customerId) {
        this.customerId = customerId;
    }

    public String getBrand() {
        return brand;
    }

    public void setBrand(String brand) {
        this.brand = brand;
    }

    public String getModel() {
        return model;
    }

    public void setModel(String model) {
        this.model = model;
    }

    public String getSerialNumber() {
        return serialNumber;
    }

    public void setSerialNumber(String serialNumber) {
        this.serialNumber = serialNumber;
    }

    public String getDeviceType() {
        return deviceType;
    }

    public void setDeviceType(String deviceType) {
        this.deviceType = deviceType;
    }

    public String getIssueDescription() {
        return issueDescription;
    }

    public void setIssueDescription(String issueDescription) {
        this.issueDescription = issueDescription;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public String getCustomerName() {
        return customerName;
    }

    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }

    @Override
    public String toString() {
        return String.format("[%d] %s %s (S/N: %s)", deviceId, brand, model, serialNumber);
    }
}