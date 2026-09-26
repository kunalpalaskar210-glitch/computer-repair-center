package com.computerrepair.ui;

import com.computerrepair.model.Customer;
import com.computerrepair.service.CustomerService;
import java.awt.*;
import java.sql.SQLException;
import java.util.List;
import javax.swing.*;
import javax.swing.table.DefaultTableModel;

public class CustomerPanel extends JPanel {
    private final CustomerService customerService;

    private JTextField txtId;
    private JTextField txtFirstName;
    private JTextField txtLastName;
    private JTextField txtEmail;
    private JTextField txtPhone;
    private JTextField txtAddress;
    private JTextField txtSearch;

    private JButton btnAdd;
    private JButton btnUpdate;
    private JButton btnDelete;
    private JButton btnClear;
    private JButton btnSearch;
    private JButton btnRefresh;

    private JTable customerTable;
    private DefaultTableModel tableModel;

    public CustomerPanel() {
        this.customerService = new CustomerService();
        initComponents();
        loadCustomerData();
    }

    private void initComponents() {
        setLayout(new BorderLayout(10, 10));
        setBorder(BorderFactory.createEmptyBorder(10, 10, 10, 10));

        // Form Panel
        JPanel formPanel = new JPanel(new GridBagLayout());
        formPanel.setBorder(BorderFactory.createTitledBorder("Customer Details"));
        GridBagConstraints gbc = new GridBagConstraints();
        gbc.insets = new Insets(4, 4, 4, 4);
        gbc.fill = GridBagConstraints.HORIZONTAL;

        txtId = new JTextField(15);
        txtId.setEditable(false);
        txtFirstName = new JTextField(15);
        txtLastName = new JTextField(15);
        txtEmail = new JTextField(15);
        txtPhone = new JTextField(15);
        txtAddress = new JTextField(15);

        addFormField(formPanel, gbc, "Customer ID:", txtId, 0);
        addFormField(formPanel, gbc, "First Name *:", txtFirstName, 1);
        addFormField(formPanel, gbc, "Last Name *:", txtLastName, 2);
        addFormField(formPanel, gbc, "Email *:", txtEmail, 3);
        addFormField(formPanel, gbc, "Phone *:", txtPhone, 4);
        addFormField(formPanel, gbc, "Address:", txtAddress, 5);

        // Buttons
        JPanel buttonPanel = new JPanel(new FlowLayout(FlowLayout.CENTER, 8, 8));
        btnAdd = new JButton("Add Customer");
        btnUpdate = new JButton("Update");
        btnDelete = new JButton("Delete");
        btnClear = new JButton("Clear Form");

        buttonPanel.add(btnAdd);
        buttonPanel.add(btnUpdate);
        buttonPanel.add(btnDelete);
        buttonPanel.add(btnClear);

        gbc.gridx = 0;
        gbc.gridy = 6;
        gbc.gridwidth = 2;
        formPanel.add(buttonPanel, gbc);

        // Top Search Panel
        JPanel searchPanel = new JPanel(new FlowLayout(FlowLayout.LEFT, 8, 4));
        txtSearch = new JTextField(20);
        btnSearch = new JButton("Search");
        btnRefresh = new JButton("Refresh All");
        searchPanel.add(new JLabel("Search (Name/Email/Phone):"));
        searchPanel.add(txtSearch);
        searchPanel.add(btnSearch);
        searchPanel.add(btnRefresh);

        // Table
        String[] columnNames = {"ID", "First Name", "Last Name", "Email", "Phone", "Address", "Date Registered"};
        tableModel = new DefaultTableModel(columnNames, 0) {
            @Override
            public boolean isCellEditable(int row, int column) {
                return false;
            }
        };
        customerTable = new JTable(tableModel);
        customerTable.setSelectionMode(ListSelectionModel.SINGLE_SELECTION);
        JScrollPane scrollPane = new JScrollPane(customerTable);

        JPanel tableContainer = new JPanel(new BorderLayout(5, 5));
        tableContainer.add(searchPanel, BorderLayout.NORTH);
        tableContainer.add(scrollPane, BorderLayout.CENTER);

        add(formPanel, BorderLayout.WEST);
        add(tableContainer, BorderLayout.CENTER);

        // Listeners
        btnAdd.addActionListener(e -> onAddCustomer());
        btnUpdate.addActionListener(e -> onUpdateCustomer());
        btnDelete.addActionListener(e -> onDeleteCustomer());
        btnClear.addActionListener(e -> clearForm());
        btnSearch.addActionListener(e -> onSearchCustomer());
        btnRefresh.addActionListener(e -> loadCustomerData());

        customerTable.getSelectionModel().addListSelectionListener(e -> {
            if (!e.getValueIsAdjusting() && customerTable.getSelectedRow() != -1) {
                populateFormFromSelectedRow();
            }
        });
    }

    private void addFormField(JPanel panel, GridBagConstraints gbc, String label, JComponent field, int row) {
        gbc.gridwidth = 1;
        gbc.gridx = 0;
        gbc.gridy = row;
        panel.add(new JLabel(label), gbc);
        gbc.gridx = 1;
        panel.add(field, gbc);
    }

    private void loadCustomerData() {
        try {
            List<Customer> list = customerService.getAllCustomers();
            updateTable(list);
        } catch (SQLException ex) {
            JOptionPane.showMessageDialog(this, "Failed to load customers from database.", "Database Error", JOptionPane.ERROR_MESSAGE);
        }
    }

    private void updateTable(List<Customer> list) {
        tableModel.setRowCount(0);
        for (Customer c : list) {
            tableModel.addRow(new Object[]{
                    c.getCustomerId(),
                    c.getFirstName(),
                    c.getLastName(),
                    c.getEmail(),
                    c.getPhone(),
                    c.getAddress(),
                    c.getCreatedAt()
            });
        }
    }

    private void onAddCustomer() {
        try {
            Customer customer = new Customer(
                    txtFirstName.getText().trim(),
                    txtLastName.getText().trim(),
                    txtEmail.getText().trim(),
                    txtPhone.getText().trim(),
                    txtAddress.getText().trim()
            );
            customerService.registerCustomer(customer);
            JOptionPane.showMessageDialog(this, "Customer registered successfully!", "Success", JOptionPane.INFORMATION_MESSAGE);
            clearForm();
            loadCustomerData();
        } catch (IllegalArgumentException ex) {
            JOptionPane.showMessageDialog(this, ex.getMessage(), "Validation Error", JOptionPane.WARNING_MESSAGE);
        } catch (SQLException ex) {
            JOptionPane.showMessageDialog(this, "Database operation failed: " + ex.getMessage(), "Error", JOptionPane.ERROR_MESSAGE);
        }
    }

    private void onUpdateCustomer() {
        if (txtId.getText().isEmpty()) {
            JOptionPane.showMessageDialog(this, "Select a customer from the table first.", "Notice", JOptionPane.WARNING_MESSAGE);
            return;
        }
        try {
            Customer customer = new Customer();
            customer.setCustomerId(Integer.parseInt(txtId.getText()));
            customer.setFirstName(txtFirstName.getText().trim());
            customer.setLastName(txtLastName.getText().trim());
            customer.setEmail(txtEmail.getText().trim());
            customer.setPhone(txtPhone.getText().trim());
            customer.setAddress(txtAddress.getText().trim());

            customerService.updateCustomer(customer);
            JOptionPane.showMessageDialog(this, "Customer updated successfully!", "Success", JOptionPane.INFORMATION_MESSAGE);
            clearForm();
            loadCustomerData();
        } catch (IllegalArgumentException ex) {
            JOptionPane.showMessageDialog(this, ex.getMessage(), "Validation Error", JOptionPane.WARNING_MESSAGE);
        } catch (SQLException ex) {
            JOptionPane.showMessageDialog(this, "Database update failed: " + ex.getMessage(), "Error", JOptionPane.ERROR_MESSAGE);
        }
    }

    private void onDeleteCustomer() {
        if (txtId.getText().isEmpty()) {
            JOptionPane.showMessageDialog(this, "Select a customer to delete.", "Notice", JOptionPane.WARNING_MESSAGE);
            return;
        }
        int confirm = JOptionPane.showConfirmDialog(
                this,
                "Are you sure you want to delete this customer? This may affect linked devices!",
                "Confirm Deletion",
                JOptionPane.YES_NO_OPTION,
                JOptionPane.WARNING_MESSAGE
        );

        if (confirm == JOptionPane.YES_OPTION) {
            try {
                int id = Integer.parseInt(txtId.getText());
                customerService.deleteCustomer(id);
                JOptionPane.showMessageDialog(this, "Customer removed successfully.", "Success", JOptionPane.INFORMATION_MESSAGE);
                clearForm();
                loadCustomerData();
            } catch (SQLException ex) {
                JOptionPane.showMessageDialog(this, "Cannot delete this customer because related devices or other records are linked to the customer.", "Delete Failed", JOptionPane.ERROR_MESSAGE);
            }
        }
    }

    private void onSearchCustomer() {
        String query = txtSearch.getText().trim();
        try {
            List<Customer> list = customerService.searchCustomers(query);
            updateTable(list);
        } catch (SQLException ex) {
            JOptionPane.showMessageDialog(this, "Search error: " + ex.getMessage(), "Error", JOptionPane.ERROR_MESSAGE);
        }
    }

    private void populateFormFromSelectedRow() {
        int row = customerTable.getSelectedRow();
        if (row != -1) {
            txtId.setText(tableModel.getValueAt(row, 0).toString());
            txtFirstName.setText(tableModel.getValueAt(row, 1).toString());
            txtLastName.setText(tableModel.getValueAt(row, 2).toString());
            txtEmail.setText(tableModel.getValueAt(row, 3).toString());
            txtPhone.setText(tableModel.getValueAt(row, 4).toString());
            Object addr = tableModel.getValueAt(row, 5);
            txtAddress.setText(addr != null ? addr.toString() : "");
        }
    }

    private void clearForm() {
        txtId.setText("");
        txtFirstName.setText("");
        txtLastName.setText("");
        txtEmail.setText("");
        txtPhone.setText("");
        txtAddress.setText("");
        customerTable.clearSelection();
    }
}