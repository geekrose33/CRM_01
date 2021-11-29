package com.geekrose.crm.workbench.service.impl;

import com.geekrose.crm.utils.UUIDUtil;
import com.geekrose.crm.workbench.dao.CustomerMapper;
import com.geekrose.crm.workbench.domain.Customer;
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
}
