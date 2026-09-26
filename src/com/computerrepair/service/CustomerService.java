package com.computerrepair.service;

import com.computerrepair.dao.CustomerDAO;
import com.computerrepair.model.Customer;
import java.sql.SQLException;
import java.util.List;

public class CustomerService {
    private final CustomerDAO customerDAO;

    public CustomerService() {
        this.customerDAO = new CustomerDAO();
    }

    public CustomerService(CustomerDAO customerDAO) {
        this.customerDAO = customerDAO;
    }

    public void registerCustomer(Customer customer) throws IllegalArgumentException, SQLException {
        validateCustomer(customer);
        if (customerDAO.isEmailTaken(customer.getEmail(), 0)) {
            throw new IllegalArgumentException("A customer with this email address already exists.");
        }
        customerDAO.addCustomer(customer);
    }

    public void updateCustomer(Customer customer) throws IllegalArgumentException, SQLException {
        if (customer.getCustomerId() <= 0) {
            throw new IllegalArgumentException("Invalid customer ID for update.");
        }
        validateCustomer(customer);
        if (customerDAO.isEmailTaken(customer.getEmail(), customer.getCustomerId())) {
            throw new IllegalArgumentException("Another customer is already registered with this email address.");
        }
        boolean updated = customerDAO.updateCustomer(customer);
        if (!updated) {
            throw new SQLException("Failed to update customer. Customer not found.");
        }
    }

    public void deleteCustomer(int customerId) throws IllegalArgumentException, SQLException {
        if (customerId <= 0) {
            throw new IllegalArgumentException("Invalid customer ID.");
        }
        boolean deleted = customerDAO.deleteCustomer(customerId);
        if (!deleted) {
            throw new SQLException("Customer could not be deleted or does not exist.");
        }
    }

    public Customer getCustomerById(int customerId) throws SQLException {
        if (customerId <= 0) {
            return null;
        }
        return customerDAO.getCustomerById(customerId);
    }

    public List<Customer> getAllCustomers() throws SQLException {
        return customerDAO.getAllCustomers();
    }

    public List<Customer> searchCustomers(String keyword) throws SQLException {
        if (keyword == null || keyword.trim().isEmpty()) {
            return customerDAO.getAllCustomers();
        }
        return customerDAO.searchCustomers(keyword.trim());
    }

    private void validateCustomer(Customer customer) {
        if (customer == null) {
            throw new IllegalArgumentException("Customer details cannot be empty.");
        }
        if (customer.getFirstName() == null || customer.getFirstName().trim().isEmpty()) {
            throw new IllegalArgumentException("First name is required.");
        }
        if (customer.getLastName() == null || customer.getLastName().trim().isEmpty()) {
            throw new IllegalArgumentException("Last name is required.");
        }
        if (customer.getEmail() == null || !customer.getEmail().matches("^[A-Za-z0-9+_.-]+@(.+)$")) {
            throw new IllegalArgumentException("A valid email address is required.");
        }
        if (customer.getPhone() == null) {
            throw new IllegalArgumentException("A valid phone number is required (at least 7 digits).");
        }
        String phone = customer.getPhone().trim();
        if (phone.isEmpty() || !phone.matches("^[+()\\-\\s\\d]{7,}$") || phone.replaceAll("\\D", "").length() < 7) {
            throw new IllegalArgumentException("A valid phone number is required (at least 7 digits).");
        }
    }
}