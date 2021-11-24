package com.geekrose.crm.workbench.dao;

import com.geekrose.crm.workbench.domain.ClueRemark;

import java.util.List;

public interface ClueRemarkMapper {
    int deleteByPrimaryKey(String id);

    int insert(ClueRemark record);

    int insertSelective(ClueRemark record);

    ClueRemark selectByPrimaryKey(String id);

    int updateByPrimaryKeySelective(ClueRemark record);

    int updateByPrimaryKey(ClueRemark record);

    List<ClueRemark> getRemarksByClueId(String id);

    int addRemark(ClueRemark remark);
}