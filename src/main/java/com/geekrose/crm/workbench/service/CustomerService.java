package com.geekrose.crm.workbench.service;

import com.geekrose.crm.workbench.domain.Contacts;
import com.geekrose.crm.workbench.domain.Customer;
import com.geekrose.crm.workbench.domain.CustomerRemark;

import java.util.List;

public interface CustomerService {
    List<Customer> getCustomersForPage(String pageNo, String pageSize, Customer customer);

    Integer getTotalCount();

    boolean saveCustomer(Customer customer);

    Customer getCustomerById(String id);

    boolean editCustomer(Customer customer);

    boolean removeCustomer(String id);

    List<CustomerRemark> getRemarksByCusId(String id);

    Contacts getContactByCusId(String id);

    boolean editCusRemark(CustomerRemark remark);

    boolean removeCusRemark(String id);

    boolean addRemark(CustomerRemark remark);

    List<Contacts> getContactsByCusId(String customerId);

    boolean createContact(Contacts contact);
}
