package com.geekrose.crm.workbench.service;

import com.geekrose.crm.workbench.domain.Customer;

import java.util.List;

public interface CustomerService {
    List<Customer> getCustomersForPage(String pageNo, String pageSize, Customer customer);

    Integer getTotalCount();

    boolean saveCustomer(Customer customer);
}
