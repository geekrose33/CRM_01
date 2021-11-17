package com.geekrose.crm.workbench.dao;

import com.geekrose.crm.workbench.domain.ActivityRemark;

import java.util.List;

public interface ActivityRemarkMapper {
    int deleteByPrimaryKey(String id);

    int insert(ActivityRemark record);

    int insertSelective(ActivityRemark record);

    ActivityRemark selectByPrimaryKey(String id);

    int updateByPrimaryKeySelective(ActivityRemark record);

    int updateByPrimaryKey(ActivityRemark record);

    Integer selectCountByAids(String[] ids);

    Integer deleteByAids(String[] ids);

    List<ActivityRemark> selectRemarksByActId(String actId);
}