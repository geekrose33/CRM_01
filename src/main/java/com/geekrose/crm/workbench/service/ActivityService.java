package com.geekrose.crm.workbench.service;

import com.geekrose.crm.settings.domain.User;
import com.geekrose.crm.workbench.domain.Activity;
import com.geekrose.crm.workbench.domain.ActivityRemark;

import java.util.List;

public interface ActivityService {
    List<User> getUserList();

    boolean saveActivity(Activity activity);
    // 分页查询 （动态sql 条件查询）
    List<Activity> searchPageList(String pageNo, String pageSize,Activity activity);

    Integer searchTotalCount();

    boolean deleteActivities(String[] ids);

    Activity getActivityById(String id);

    boolean updateAct(Activity activity);

    Activity getActDetail(String id);

    List<ActivityRemark> getRemarkList(String actId);

    boolean deleteActRemark(String id);

    boolean saveActivityRemark(String activityid, String notecontent, String id,String createby);

    ActivityRemark getActivityRemarkById(String id);

    boolean updateRemark(String id, String noteContent,String editby);
}
