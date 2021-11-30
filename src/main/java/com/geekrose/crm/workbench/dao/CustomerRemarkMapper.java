package com.geekrose.crm.workbench.dao;

import com.geekrose.crm.workbench.domain.CustomerRemark;

import java.util.List;

public interface CustomerRemarkMapper {
    int deleteByPrimaryKey(String id);

    int insert(CustomerRemark record);

    int insertSelective(CustomerRemark record);

    CustomerRemark selectByPrimaryKey(String id);

    int updateByPrimaryKeySelective(CustomerRemark record);

    int updateByPrimaryKey(CustomerRemark record);

    List<String> selectIdsByCusId(String id);

    List<CustomerRemark> selectRemarksByCusId(String id);
}