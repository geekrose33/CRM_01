package com.geekrose.crm.workbench.service;

import com.geekrose.crm.settings.domain.User;
import com.geekrose.crm.workbench.domain.Activity;

import java.util.List;

public interface ActivityService {
    List<User> getUserList();

    boolean saveActivity(Activity activity);
}
