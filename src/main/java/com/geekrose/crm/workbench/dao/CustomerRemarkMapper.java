package com.geekrose.crm.workbench.dao;

import com.geekrose.crm.workbench.domain.CustomerRemark;

public interface CustomerRemarkMapper {
    int deleteByPrimaryKey(String id);

    int insert(CustomerRemark record);

    int insertSelective(CustomerRemark record);

    CustomerRemark selectByPrimaryKey(String id);

    int updateByPrimaryKeySelective(CustomerRemark record);

    int updateByPrimaryKey(CustomerRemark record);
}