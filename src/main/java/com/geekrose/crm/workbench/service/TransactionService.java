package com.geekrose.crm.workbench.service;

import com.geekrose.crm.settings.domain.User;
import com.geekrose.crm.workbench.domain.Activity;
import com.geekrose.crm.workbench.domain.Contacts;
import com.geekrose.crm.workbench.domain.TranHistory;
import com.geekrose.crm.workbench.domain.Transaction;

import java.util.List;
import java.util.Map;

public interface TransactionService {
    List<Transaction> getTranList(Transaction tran, String pageNo, String pageSize);

    int getTotalCount();

    List<User> getUsers();

    List<String> getCustomerName(String name);

    boolean addTran(Transaction tran);

    Transaction getTranById(String id);

    List<Activity> getActsByName(String name);

    List<Contacts> getContactsByName(String name);

    boolean editTran(Transaction tran);

    boolean removeTranById(String id);

    Transaction getDetailInfoById(String id);

    List<TranHistory> getHisListByTranId(String tranId);

    boolean changeStage(Transaction transaction);

    Map<String, Object> getChars();
}
