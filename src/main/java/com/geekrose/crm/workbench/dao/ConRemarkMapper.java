package com.geekrose.crm.workbench.dao;

import com.geekrose.crm.workbench.domain.ConRemark;

public interface ConRemarkMapper {
    int deleteByPrimaryKey(String id);

    int insert(ConRemark record);

    int insertSelective(ConRemark record);

    ConRemark selectByPrimaryKey(String id);

    int updateByPrimaryKeySelective(ConRemark record);

    int updateByPrimaryKey(ConRemark record);
}