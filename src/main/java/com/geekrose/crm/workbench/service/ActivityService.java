package com.geekrose.crm.workbench.service;

import com.geekrose.crm.settings.domain.User;
import com.geekrose.crm.workbench.domain.Activity;

import java.util.List;

public interface ActivityService {
    List<User> getUserList();

    boolean saveActivity(Activity activity);
    // 分页查询 （动态sql 条件查询）
    List<Activity> searchPageList(String pageNo, String pageSize,Activity activity);

    Integer searchTotalCount();

    boolean deleteActivities(String[] ids);

}
