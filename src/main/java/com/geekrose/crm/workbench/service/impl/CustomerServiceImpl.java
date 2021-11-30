package com.geekrose.crm.workbench.service.impl;

import com.geekrose.crm.utils.DateTimeUtil;
import com.geekrose.crm.utils.UUIDUtil;
import com.geekrose.crm.workbench.dao.ContactsMapper;
import com.geekrose.crm.workbench.dao.CustomerMapper;
import com.geekrose.crm.workbench.dao.CustomerRemarkMapper;
import com.geekrose.crm.workbench.domain.Contacts;
import com.geekrose.crm.workbench.domain.Customer;
import com.geekrose.crm.workbench.domain.CustomerRemark;
import com.geekrose.crm.workbench.service.CustomerService;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.util.List;

/**
 * @author Joker_Dong
 * @date 2021-11-18 21:17
 */
@Service("customerService")
public class CustomerServiceImpl implements CustomerService {

    @Resource
    private CustomerMapper cusDao;

    @Resource
    private CustomerRemarkMapper cusRemDao;
    // 联系人
    @Resource
    private ContactsMapper conDao;


    public List<Customer> getCustomersForPage(String pageNo, String pageSize, Customer customer) {

        // 将序号 转换 为忽略的数量
        Integer ipageNo = Integer.valueOf(pageNo);
        Integer ipageSize = Integer.valueOf(pageSize);

        Integer skipCount = (ipageNo - 1)* ipageSize;

        List<Customer> customers = cusDao.getCustomersByCondition(skipCount,ipageSize,customer);


        return customers;
    }

    public Integer getTotalCount() {

        Integer toatl = cusDao.selectToalCount();

        return toatl;
    }

    @Transactional
    public boolean saveCustomer(Customer customer) {
        customer.setId(UUIDUtil.getUUID());

        int i = cusDao.insertSelective(customer);

        if (i == 1){
            return true;
        }

        return false;
    }

    public Customer getCustomerById(String id) {

        Customer customer = cusDao.selectByPrimaryKey(id);

        return customer;
    }


    @Transactional
    public boolean editCustomer(Customer customer) {

        customer.setEdittime(DateTimeUtil.getSysTime());

        int count = cusDao.updateByPrimaryKeySelective(customer);

        if (count == 1){
            return true;
        }

        return false;
    }

    @Transactional
    public boolean removeCustomer(String id) {
        boolean flag = true;
        // 删除客户 前提先删除客户备注
        List<String> ids = cusRemDao.selectIdsByCusId(id);

        for (String remId : ids) {
            // 根据id删除
            int remCount = cusRemDao.deleteByPrimaryKey(id);
            if (remCount != 1){
                flag = false;
            }
        }

        // 删完备注删除客户信息
        int count = cusDao.deleteByPrimaryKey(id);
        if (count != 1){
            flag = false;
        }

        return flag;
    }

    public Contacts getContactByCusId(String id) {

        Contacts contact = conDao.getContactByCusId(id);

        return contact;
    }

    public List<CustomerRemark> getRemarksByCusId(String id) {

        List<CustomerRemark> remarks = cusRemDao.selectRemarksByCusId(id);

        return remarks;
    }

    @Transactional
    public boolean editCusRemark(CustomerRemark remark) {
        remark.setEditflag("1");
        remark.setEdittime(DateTimeUtil.getSysTime());
        int count = cusRemDao.updateByPrimaryKeySelective(remark);
        if (count == 1){
            return true;
        }

        return false;
    }
    @Transactional
    public boolean removeCusRemark(String id) {

        int count = cusRemDao.deleteByPrimaryKey(id);
        if (count == 1){
            return true;
        }

        return false;
    }

    @Transactional
    public boolean addRemark(CustomerRemark remark) {

        remark.setCreatetime(DateTimeUtil.getSysTime());
        remark.setEditflag("0");
        remark.setId(UUIDUtil.getUUID());

        int count = cusRemDao.insert(remark);
        if (count == 1){
            return true;
        }
        return false;
    }
}
