package com.computerrepair.ui;

import com.computerrepair.model.Customer;
import com.computerrepair.model.Device;
import com.computerrepair.service.CustomerService;
import com.computerrepair.service.DeviceService;
import java.awt.*;
import java.sql.SQLException;
import java.util.List;
import javax.swing.*;
import javax.swing.table.DefaultTableModel;

public class DevicePanel extends JPanel {
    private final DeviceService deviceService;
    private final CustomerService customerService;

    private JTextField txtDeviceId;
    private JComboBox<CustomerItem> cmbCustomer;
    private JTextField txtBrand;
    private JTextField txtModel;
    private JTextField txtSerialNumber;
    private JComboBox<String> cmbDeviceType;
    private JTextArea txtIssueDescription;
    private JTextField txtSearch;

    private JButton btnAdd;
    private JButton btnUpdate;
    private JButton btnDelete;
    private JButton btnClear;
    private JButton btnSearch;
    private JButton btnRefresh;

    private JTable deviceTable;
    private DefaultTableModel tableModel;

    // Helper item class to bind Customer ID while displaying readable Name
    private static class CustomerItem {
        private final int id;
        private final String displayName;

        public CustomerItem(int id, String displayName) {
            this.id = id;
            this.displayName = displayName;
        }

        public int getId() {
            return id;
        }

        @Override
        public String toString() {
            return displayName;
        }
    }

    public DevicePanel() {
        this.deviceService = new DeviceService();
        this.customerService = new CustomerService();
        initComponents();
        loadCustomersIntoComboBox();
        loadDeviceData();
    }

    private void initComponents() {
        setLayout(new BorderLayout(10, 10));
        setBorder(BorderFactory.createEmptyBorder(10, 10, 10, 10));

        // Form Panel
        JPanel formPanel = new JPanel(new GridBagLayout());
        formPanel.setBorder(BorderFactory.createTitledBorder("Device Details"));
        GridBagConstraints gbc = new GridBagConstraints();
        gbc.insets = new Insets(4, 4, 4, 4);
        gbc.fill = GridBagConstraints.HORIZONTAL;

        txtDeviceId = new JTextField(15);
        txtDeviceId.setEditable(false);
        cmbCustomer = new JComboBox<>();
        txtBrand = new JTextField(15);
        txtModel = new JTextField(15);
        txtSerialNumber = new JTextField(15);
        cmbDeviceType = new JComboBox<>(new String[]{"Laptop", "Desktop", "Smartphone", "Tablet", "Server", "Other"});
        txtIssueDescription = new JTextArea(3, 15);
        txtIssueDescription.setLineWrap(true);
        txtIssueDescription.setWrapStyleWord(true);
        JScrollPane descScroll = new JScrollPane(txtIssueDescription);

        addFormField(formPanel, gbc, "Device ID:", txtDeviceId, 0);
        addFormField(formPanel, gbc, "Owner (Customer) *:", cmbCustomer, 1);
        addFormField(formPanel, gbc, "Brand *:", txtBrand, 2);
        addFormField(formPanel, gbc, "Model *:", txtModel, 3);
        addFormField(formPanel, gbc, "Serial Number *:", txtSerialNumber, 4);
        addFormField(formPanel, gbc, "Device Type *:", cmbDeviceType, 5);
        addFormField(formPanel, gbc, "Issue Description:", descScroll, 6);

        // Action Buttons
        JPanel buttonPanel = new JPanel(new FlowLayout(FlowLayout.CENTER, 8, 8));
        btnAdd = new JButton("Add Device");
        btnUpdate = new JButton("Update");
        btnDelete = new JButton("Delete");
        btnClear = new JButton("Clear Form");

        buttonPanel.add(btnAdd);
        buttonPanel.add(btnUpdate);
        buttonPanel.add(btnDelete);
        buttonPanel.add(btnClear);

        gbc.gridx = 0;
        gbc.gridy = 7;
        gbc.gridwidth = 2;
        formPanel.add(buttonPanel, gbc);

        // Search Bar
        JPanel searchPanel = new JPanel(new FlowLayout(FlowLayout.LEFT, 8, 4));
        txtSearch = new JTextField(20);
        btnSearch = new JButton("Search");
        btnRefresh = new JButton("Refresh All");
        searchPanel.add(new JLabel("Search (Brand/Model/Serial/Owner):"));
        searchPanel.add(txtSearch);
        searchPanel.add(btnSearch);
        searchPanel.add(btnRefresh);

        // Table
        String[] columns = {"ID", "Customer ID", "Owner", "Brand", "Model", "Serial No", "Type", "Issue"};
        tableModel = new DefaultTableModel(columns, 0) {
            @Override
            public boolean isCellEditable(int row, int col) {
                return false;
            }
        };
        deviceTable = new JTable(tableModel);
        deviceTable.setSelectionMode(ListSelectionModel.SINGLE_SELECTION);
        JScrollPane scrollPane = new JScrollPane(deviceTable);

        JPanel tableContainer = new JPanel(new BorderLayout(5, 5));
        tableContainer.add(searchPanel, BorderLayout.NORTH);
        tableContainer.add(scrollPane, BorderLayout.CENTER);

        add(formPanel, BorderLayout.WEST);
        add(tableContainer, BorderLayout.CENTER);

        // Listeners
        btnAdd.addActionListener(e -> onAddDevice());
        btnUpdate.addActionListener(e -> onUpdateDevice());
        btnDelete.addActionListener(e -> onDeleteDevice());
        btnClear.addActionListener(e -> clearForm());
        btnSearch.addActionListener(e -> onSearchDevice());
        btnRefresh.addActionListener(e -> {
            loadCustomersIntoComboBox();
            loadDeviceData();
        });

        deviceTable.getSelectionModel().addListSelectionListener(e -> {
            if (!e.getValueIsAdjusting() && deviceTable.getSelectedRow() != -1) {
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

    public void loadCustomersIntoComboBox() {
        try {
            cmbCustomer.removeAllItems();
            List<Customer> customers = customerService.getAllCustomers();
            for (Customer c : customers) {
                cmbCustomer.addItem(new CustomerItem(c.getCustomerId(), String.format("[%d] %s", c.getCustomerId(), c.getFullName().trim())));
            }
        } catch (SQLException ex) {
            JOptionPane.showMessageDialog(this, "Failed to load customers for selection.", "Database Error", JOptionPane.ERROR_MESSAGE);
        }
    }

    private void loadDeviceData() {
        try {
            List<Device> list = deviceService.getAllDevices();
            updateTable(list);
        } catch (SQLException ex) {
            JOptionPane.showMessageDialog(this, "Failed to load devices: " + ex.getMessage(), "Database Error", JOptionPane.ERROR_MESSAGE);
        }
    }

    private void updateTable(List<Device> list) {
        tableModel.setRowCount(0);
        for (Device d : list) {
            tableModel.addRow(new Object[]{
                    d.getDeviceId(),
                    d.getCustomerId(),
                    d.getCustomerName() != null ? d.getCustomerName() : "N/A",
                    d.getBrand(),
                    d.getModel(),
                    d.getSerialNumber(),
                    d.getDeviceType(),
                    d.getIssueDescription()
            });
        }
    }

    private void onAddDevice() {
        CustomerItem selectedCustomer = (CustomerItem) cmbCustomer.getSelectedItem();
        if (selectedCustomer == null) {
            JOptionPane.showMessageDialog(this, "Please select an existing customer first.", "Notice", JOptionPane.WARNING_MESSAGE);
            return;
        }

        try {
            Device device = new Device(
                    selectedCustomer.getId(),
                    txtBrand.getText().trim(),
                    txtModel.getText().trim(),
                    txtSerialNumber.getText().trim(),
                    (String) cmbDeviceType.getSelectedItem(),
                    txtIssueDescription.getText().trim()
            );

            deviceService.registerDevice(device);
            JOptionPane.showMessageDialog(this, "Device added successfully!", "Success", JOptionPane.INFORMATION_MESSAGE);
            clearForm();
            loadDeviceData();
        } catch (IllegalArgumentException ex) {
            JOptionPane.showMessageDialog(this, ex.getMessage(), "Validation Error", JOptionPane.WARNING_MESSAGE);
        } catch (SQLException ex) {
            JOptionPane.showMessageDialog(this, "Database insertion failed: " + ex.getMessage(), "Database Error", JOptionPane.ERROR_MESSAGE);
        }
    }

    private void onUpdateDevice() {
        if (txtDeviceId.getText().isEmpty()) {
            JOptionPane.showMessageDialog(this, "Select a device from the table first.", "Notice", JOptionPane.WARNING_MESSAGE);
            return;
        }

        CustomerItem selectedCustomer = (CustomerItem) cmbCustomer.getSelectedItem();
        if (selectedCustomer == null) {
            JOptionPane.showMessageDialog(this, "Please select a valid customer.", "Notice", JOptionPane.WARNING_MESSAGE);
            return;
        }

        try {
            Device device = new Device();
            device.setDeviceId(Integer.parseInt(txtDeviceId.getText()));
            device.setCustomerId(selectedCustomer.getId());
            device.setBrand(txtBrand.getText().trim());
            device.setModel(txtModel.getText().trim());
            device.setSerialNumber(txtSerialNumber.getText().trim());
            device.setDeviceType((String) cmbDeviceType.getSelectedItem());
            device.setIssueDescription(txtIssueDescription.getText().trim());

            deviceService.updateDevice(device);
            JOptionPane.showMessageDialog(this, "Device record updated successfully!", "Success", JOptionPane.INFORMATION_MESSAGE);
            clearForm();
            loadDeviceData();
        } catch (IllegalArgumentException ex) {
            JOptionPane.showMessageDialog(this, ex.getMessage(), "Validation Error", JOptionPane.WARNING_MESSAGE);
        } catch (SQLException ex) {
            JOptionPane.showMessageDialog(this, "Database update failed: " + ex.getMessage(), "Database Error", JOptionPane.ERROR_MESSAGE);
        }
    }

    private void onDeleteDevice() {
        if (txtDeviceId.getText().isEmpty()) {
            JOptionPane.showMessageDialog(this, "Select a device to delete.", "Notice", JOptionPane.WARNING_MESSAGE);
            return;
        }

        int confirm = JOptionPane.showConfirmDialog(
                this,
                "Are you sure you want to delete this device record?",
                "Confirm Deletion",
                JOptionPane.YES_NO_OPTION,
                JOptionPane.WARNING_MESSAGE
        );

        if (confirm == JOptionPane.YES_OPTION) {
            try {
                int id = Integer.parseInt(txtDeviceId.getText());
                deviceService.deleteDevice(id);
                JOptionPane.showMessageDialog(this, "Device removed successfully.", "Success", JOptionPane.INFORMATION_MESSAGE);
                clearForm();
                loadDeviceData();
            } catch (SQLException ex) {
                JOptionPane.showMessageDialog(this, "Cannot delete device: " + ex.getMessage(), "Error", JOptionPane.ERROR_MESSAGE);
            }
        }
    }

    private void onSearchDevice() {
        String keyword = txtSearch.getText().trim();
        try {
            List<Device> list = deviceService.searchDevices(keyword);
            updateTable(list);
        } catch (SQLException ex) {
            JOptionPane.showMessageDialog(this, "Search failed: " + ex.getMessage(), "Error", JOptionPane.ERROR_MESSAGE);
        }
    }

    private void populateFormFromSelectedRow() {
        int row = deviceTable.getSelectedRow();
        if (row != -1) {
            txtDeviceId.setText(tableModel.getValueAt(row, 0).toString());
            int customerId = Integer.parseInt(tableModel.getValueAt(row, 1).toString());

            for (int i = 0; i < cmbCustomer.getItemCount(); i++) {
                if (cmbCustomer.getItemAt(i).getId() == customerId) {
                    cmbCustomer.setSelectedIndex(i);
                    break;
                }
            }

            Object brand = tableModel.getValueAt(row, 3);
            txtBrand.setText(brand != null ? brand.toString() : "");

            Object model = tableModel.getValueAt(row, 4);
            txtModel.setText(model != null ? model.toString() : "");

            Object serial = tableModel.getValueAt(row, 5);
            txtSerialNumber.setText(serial != null ? serial.toString() : "");

            Object type = tableModel.getValueAt(row, 6);
            cmbDeviceType.setSelectedItem(type != null ? type.toString() : null);

            Object desc = tableModel.getValueAt(row, 7);
            txtIssueDescription.setText(desc != null ? desc.toString() : "");
        }
    }

    private void clearForm() {
        txtDeviceId.setText("");
        if (cmbCustomer.getItemCount() > 0) cmbCustomer.setSelectedIndex(0);
        txtBrand.setText("");
        txtModel.setText("");
        txtSerialNumber.setText("");
        cmbDeviceType.setSelectedIndex(0);
        txtIssueDescription.setText("");
        deviceTable.clearSelection();
    }
}