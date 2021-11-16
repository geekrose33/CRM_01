package com.geekrose.crm.workbench.service.impl;

import com.geekrose.crm.settings.dao.UserMapper;
import com.geekrose.crm.settings.domain.User;
import com.geekrose.crm.utils.DateTimeUtil;
import com.geekrose.crm.utils.UUIDUtil;
import com.geekrose.crm.workbench.dao.ActivityMapper;
import com.geekrose.crm.workbench.dao.ActivityRemarkMapper;
import com.geekrose.crm.workbench.domain.Activity;
import com.geekrose.crm.workbench.service.ActivityService;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

/**
 * @author Joker_Dong
 * @date 2021-11-15 16:45
 */
@Service(value = "activityService")
public class ActivityServiceImpl implements ActivityService {
    @Resource
    private ActivityMapper actDao;

    @Resource
    private ActivityRemarkMapper remDao;

    @Resource
    private UserMapper userDao;


    public List<User> getUserList() {
        List<User> users = userDao.selectUserList();
        return users;
    }

    public boolean saveActivity(Activity activity) {

        // 设置活动的id 和 创建时间
        activity.setId(UUIDUtil.getUUID());
        activity.setCreatetime(DateTimeUtil.getSysTime());


        int num = actDao.insertSelective(activity);
        if (num == 1){
            return true;
        }
        return false;
    }

    public List<Activity> searchPageList(String pageNo, String pageSize, Activity activity) {
        // 分页 条件查询
        // 将字符串转为数值
        Integer pageNoInt = Integer.valueOf(pageNo);
        Integer pageSizeInt = Integer.valueOf(pageSize);
        Integer skipCount = (pageNoInt - 1)* pageSizeInt;
        List<Activity> list = actDao.selectActivitiesByPage(skipCount,pageSizeInt,activity);
        // 将所有的owner 根据user表换为姓名
        /*List<String> owners = new ArrayList<String>();
        for (Activity act : list) {
            String owner = act.getOwner();
            owners.add(owner);
        }
        List<User> users = dao.selectUserById(owners);
        for (Activity act : list) {
            String owner = act.getOwner();
            for (User user : users) {
                if (user.getId() == owner){
                    act.setOwner(user.getName());
                }
            }
        }*/

        return list;
    }

    public Integer searchTotalCount() {
        Integer totalCount = actDao.selectTotalCount();
        return totalCount;
    }

    public boolean deleteActivities(String[] ids) {
        boolean flag = true;
        // 除了删除市场活动还要删除市场活动备注
        Integer count1 = remDao.selectCountByAids(ids);

        Integer count2 = remDao.deleteByAids(ids);

        if (count1 != count2){
            flag = false;
        }


        Integer count3 = actDao.deleteInKeys(ids);
        if (count3 == ids.length){
            return true;
        }
        return flag;
    }
}
