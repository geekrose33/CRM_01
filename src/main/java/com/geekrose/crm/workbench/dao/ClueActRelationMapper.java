package com.geekrose.crm.workbench.dao;

import com.geekrose.crm.workbench.domain.ClueActRelation;

import java.util.List;

public interface ClueActRelationMapper {
    int deleteByPrimaryKey(String id);

    int insert(ClueActRelation record);

    int insertSelective(ClueActRelation record);

    ClueActRelation selectByPrimaryKey(String id);

    int updateByPrimaryKeySelective(ClueActRelation record);

    int updateByPrimaryKey(ClueActRelation record);

    List<ClueActRelation> getListByClueId(String clueid);

//    String[] selectActIdsByClueId(String id);
}