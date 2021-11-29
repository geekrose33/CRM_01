package com.geekrose.crm.workbench.dao;

import com.geekrose.crm.workbench.domain.Customer;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface CustomerMapper {
    int deleteByPrimaryKey(String id);

    int insert(Customer record);

    int insertSelective(Customer record);

    Customer selectByPrimaryKey(String id);

    int updateByPrimaryKeySelective(Customer record);

    int updateByPrimaryKey(Customer record);

    Customer getCustomerByName(String company);

    List<Customer> getCustomersByName(String name);

    List<Customer> getCustomersByCondition(@Param("skipCount") Integer skipCount,@Param("pageSize") Integer pageSize,@Param("cus") Customer customer);

    Integer selectToalCount();
}