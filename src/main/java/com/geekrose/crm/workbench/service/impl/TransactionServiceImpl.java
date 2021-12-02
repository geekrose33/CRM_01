package com.geekrose.crm.workbench.service.impl;

import com.geekrose.crm.settings.dao.UserMapper;
import com.geekrose.crm.settings.domain.User;
import com.geekrose.crm.utils.DateTimeUtil;
import com.geekrose.crm.utils.UUIDUtil;
import com.geekrose.crm.workbench.dao.*;
import com.geekrose.crm.workbench.domain.*;
import com.geekrose.crm.workbench.service.TransactionService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

/**
 * @author Joker_Dong
 * @date 2021-11-18 21:17
 */
@Service("transactionService")
public class TransactionServiceImpl implements TransactionService {

    // 交易模块
    @Resource
    private TransactionMapper tranDao;

    @Resource
    private TranRemarkMapper tranRemDao;

    @Resource
    private TranHistoryMapper tranHisDao;
    // 用户模块
    @Resource
    private UserMapper userDao;
    // 客户
    @Resource
    private CustomerMapper cusDao;
    // 活动
    @Resource
    private ActivityMapper actDao;

    // 联系人
    @Resource
    private ContactsMapper conDao;



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



    @Transactional
    public boolean addTran(Transaction tran) {
        boolean flag = true;
        // customerid 保存的是name 需要根据name查询id
        Customer customer = cusDao.getCustomerByName(tran.getCustomerid());

        if (customer == null){
            // 需要新增一个客户
            customer = new Customer();
            customer.setId(UUIDUtil.getUUID());
            customer.setName(tran.getCustomerid());
            customer.setCreateby(tran.getCreateby());
            customer.setCreatetime(DateTimeUtil.getSysTime());
            customer.setNextcontacttime(tran.getNextcontacttime());
            customer.setDescription(tran.getDescription());
            // 这里存储的是id
            customer.setOwner(tran.getOwner());

            int cusCount = cusDao.insertSelective(customer);
            if (cusCount != 1){
                flag = false;
            }
        }
        // contactsid 不需要设置
        tran.setCustomerid(customer.getId());
        tran.setCreatetime(DateTimeUtil.getSysTime());
        tran.setId(UUIDUtil.getUUID());

        int count = tranDao.insert(tran);

        if (count == 1){
            // 添加历史记录
            TranHistory tranHistory = new TranHistory();
            tranHistory.setTranid(tran.getId());
            tranHistory.setStage(tran.getStage());
            tranHistory.setMoney(tran.getMoney());
            tranHistory.setId(UUIDUtil.getUUID());
            tranHistory.setExpecteddate(tranHistory.getExpecteddate());
            tranHistory.setCreatetime(DateTimeUtil.getSysTime());
            tranHistory.setCreateby(tran.getCreateby());

            int hisCount = tranHisDao.insert(tranHistory);
            if (hisCount != 1){
                flag = false;
            }


        }else {
            flag = false;
        }


        return flag;
    }


    public Transaction getTranById(String id) {

        Transaction transaction = tranDao.selectByPrimaryKey(id);

        return transaction;
    }

    public List<Activity> getActsByName(String name) {

        List<Activity> list = actDao.getActsByName(name);

        return list;
    }


    public List<Contacts> getContactsByName(String name) {

        List<Contacts> contacts = conDao.getContactByName(name);

        return contacts;
    }

    @Transactional
    public boolean editTran(Transaction tran) {
        boolean flag = true;
        Customer customer = cusDao.getCustomerByName(tran.getCustomerid());
        if (customer == null){
            // 如果没有查到customer就新建一个customer
            Customer newCustomer = new Customer();
            newCustomer.setCreatetime(tran.getCreatetime());
            newCustomer.setCreateby(tran.getCreateby());
            newCustomer.setDescription(tran.getDescription());
            newCustomer.setNextcontacttime(tran.getNextcontacttime());
            newCustomer.setName(tran.getCustomerid());
            newCustomer.setId(UUIDUtil.getUUID());
            newCustomer.setOwner(tran.getOwner());
            newCustomer.setContactsummary(tran.getContactsummary());

            int count = cusDao.insertSelective(newCustomer);
            if (count != 1){
                flag = false;
            }
            customer = newCustomer;

        }

        // 修改name为id
        tran.setCustomerid(customer.getId());

        int count = tranDao.updateByPrimaryKeySelective(tran);

        if (count != 1){
             flag = false;
        }

        return flag;
    }
    /*

        如果删除交易
            交易历史不用变化
            交易备注也要删除

    */
    @Transactional
    public boolean removeTranById(String id) {
        boolean flag = true;

        // 先删除备注 先根据交易id 查询备注id
        List<String> ids = tranRemDao.selectCountsByTranId(id);

        for (String remId : ids) {

            int remCount = tranRemDao.deleteByPrimaryKey(remId);
            if (remCount != 1){
                flag = false;
            }

        }



        int count = tranDao.deleteByPrimaryKey(id);

        if (count == 1){
            flag = false;
        }


        return flag;
    }

    public Transaction getDetailInfoById(String id) {

        Transaction transaction = tranDao.selectDetailInfoById(id);
        return transaction;
    }

    public List<TranHistory> getHisListByTranId(String tranId) {

        List<TranHistory> list = tranHisDao.selectByTranId(tranId);

        return list;
    }

    @Transactional
    public boolean changeStage(Transaction transaction) {
        boolean flag = true;
        transaction.setEdittime(DateTimeUtil.getSysTime());

        int editCount = tranDao.updateByPrimaryKeySelective(transaction);
        if (editCount != 1){
            // 修改失败
            flag = false;
        }else{
            // 修改成功 - 添加历史
            TranHistory history = new TranHistory();
            history.setId(UUIDUtil.getUUID());
            history.setCreateby(transaction.getEditby());
            history.setCreatetime(DateTimeUtil.getSysTime());
            history.setExpecteddate(transaction.getExpecteddate());
            history.setMoney(transaction.getMoney());
            history.setStage(transaction.getStage());
            history.setTranid(transaction.getId());
            // 添加历史
            int hisCount = tranHisDao.insert(history);
            if (hisCount != 1){
                flag = false;
            }
        }
        return flag;
    }
}
