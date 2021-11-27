package com.geekrose.crm.workbench.service;

import com.geekrose.crm.settings.domain.User;
import com.geekrose.crm.workbench.domain.Transaction;

import java.util.List;

public interface TransactionService {
    List<Transaction> getTranList(Transaction tran, String pageNo, String pageSize);

    int getTotalCount();

    List<User> getUsers();

    List<String> getCustomerName(String name);
}
