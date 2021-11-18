package com.geekrose.crm.workbench.dao;

import com.geekrose.crm.workbench.domain.ConActRelation;

public interface ConActRelationMapper {
    int deleteByPrimaryKey(String id);

    int insert(ConActRelation record);

    int insertSelective(ConActRelation record);

    ConActRelation selectByPrimaryKey(String id);

    int updateByPrimaryKeySelective(ConActRelation record);

    int updateByPrimaryKey(ConActRelation record);
}