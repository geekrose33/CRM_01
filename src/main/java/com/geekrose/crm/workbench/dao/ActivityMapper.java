package com.geekrose.crm.workbench.dao;

import com.geekrose.crm.settings.domain.User;
import com.geekrose.crm.workbench.domain.Activity;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface ActivityMapper {
    int deleteByPrimaryKey(String id);

    int insert(Activity record);

    int insertSelective(Activity record);

    Activity selectByPrimaryKey(String id);

    int updateByPrimaryKeySelective(Activity record);

    int updateByPrimaryKey(Activity record);

//    List<User> selectUserList();

    List<Activity> selectActivitiesByPage(@Param("skipCount") Integer skipCount,@Param("pageSize") Integer pageSize,@Param("act") Activity activity);

    Integer selectTotalCount();

    Integer deleteInKeys(String[] ids);

    Activity selectActDetailById(String id);

    List<Activity> getActsByClueId(String id);

    List<Activity> getActsForNameNotByClueId(@Param("name") String name, @Param("clueId") String clueId);

    List<Activity> selectActivitiesByName(@Param("name") String name);

    List<Activity> getActsByName(String name);

//    List<Activity> selectActsByIds(String[] actIds);

//    List<User> selectUserById(List<String> owners);

//    Integer saveActivity(Activity activity);
}