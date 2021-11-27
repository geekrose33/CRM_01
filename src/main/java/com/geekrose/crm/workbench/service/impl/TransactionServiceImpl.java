package com.geekrose.crm.workbench.service.impl;

import com.geekrose.crm.settings.dao.UserMapper;
import com.geekrose.crm.settings.domain.User;
import com.geekrose.crm.workbench.dao.CustomerMapper;
import com.geekrose.crm.workbench.dao.TransactionMapper;
import com.geekrose.crm.workbench.domain.Customer;
import com.geekrose.crm.workbench.domain.Transaction;
import com.geekrose.crm.workbench.service.TransactionService;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.ArrayList;
import java.util.List;

/**
 * @author Joker_Dong
 * @date 2021-11-18 21:17
 */
@Service("transactionService")
public class TransactionServiceImpl implements TransactionService {

    @Resource
    private TransactionMapper tranDao;

    @Resource
    private UserMapper userDao;

    @Resource
    private CustomerMapper cusDao;

    public List<Transaction> getTranList(Transaction tran, String pageNo, String pageSize) {

        // 这里tran的owner -> name || customerid -> cusname || contactsid -> conname


        // 这里pageNo 要更为skipCount
        Integer ipageNo = Integer.valueOf(pageNo);
        Integer ipageSize = Integer.valueOf(pageSize);
        Integer skipCount = (ipageNo - 1)* ipageSize;

        List<Transaction> list = tranDao.getTransByCondition(tran,skipCount,ipageSize);

        return list;
    }


    public int getTotalCount() {

        int total = tranDao.selectCount();
        return total;
    }

    public List<User> getUsers() {

        List<User> users = userDao.selectUserList();

        return users;
    }

    public List<String> getCustomerName(String name) {

        List<Customer> customers = cusDao.getCustomersByName(name);
        List<String> list = new ArrayList<String>();
        for (Customer customer:customers){
            list.add(customer.getName());
        }
        return list;
    }
}
