package com.geekrose.crm.workbench.dao;

import com.geekrose.crm.workbench.domain.ClueActRelation;

public interface ClueActRelationMapper {
    int deleteByPrimaryKey(String id);

    int insert(ClueActRelation record);

    int insertSelective(ClueActRelation record);

    ClueActRelation selectByPrimaryKey(String id);

    int updateByPrimaryKeySelective(ClueActRelation record);

    int updateByPrimaryKey(ClueActRelation record);
}