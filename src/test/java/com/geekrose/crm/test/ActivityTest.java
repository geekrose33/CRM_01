package com.geekrose.crm.test;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.geekrose.crm.settings.dao.UserMapper;
import com.geekrose.crm.settings.domain.User;
import com.geekrose.crm.workbench.dao.ActivityMapper;
import com.geekrose.crm.workbench.dao.ActivityRemarkMapper;
import com.geekrose.crm.workbench.domain.Activity;
import com.geekrose.crm.workbench.domain.ActivityRemark;
import com.geekrose.crm.workbench.service.ActivityService;
import org.junit.Test;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import java.util.Arrays;
import java.util.HashMap;
import java.util.List;

/**
 * @author Joker_Dong
 * @date 2021-11-15 22:35
 */

public class ActivityTest {
    @Test
    public void testGetUsers(){
        ApplicationContext context = new ClassPathXmlApplicationContext("applicationContext.xml");
        UserMapper dao = context.getBean("userMapper", UserMapper.class);
        List<User> users = dao.selectUserList();
        for (User user : users) {
            System.out.println(user);
        }

    }

    @Test
    public void testJson() throws JsonProcessingException {
        Boolean success = new Boolean(true);
        ObjectMapper mapper = new ObjectMapper();
        HashMap<String, Object> map = new HashMap<String, Object>();
        map.put("success",success);
        String value = mapper.writeValueAsString(map);

        User user = new User();
        String s = mapper.writeValueAsString(user);
//        System.out.println(s);

        System.out.println(value);
    }
    @Test
    public void testAddUser(){
        ApplicationContext context = new ClassPathXmlApplicationContext("applicationContext.xml");
        ActivityService service = context.getBean("activityService", ActivityService.class);
        boolean b = service.saveActivity(new Activity());
        System.out.println(b);
    }
    @Test
    public void testSearchActivitiesDao(){
        ApplicationContext context = new ClassPathXmlApplicationContext("applicationContext.xml");
        ActivityMapper dao = context.getBean("activityMapper", ActivityMapper.class);
        List<Activity> list = dao.selectActivitiesByPage(2, 2, new Activity());
        for (Activity activity : list) {
            System.out.println(activity);
        }
    }
    @Test
    public void testSearchActivitiesService(){
        ApplicationContext context = new ClassPathXmlApplicationContext("applicationContext.xml");
        ActivityService service = context.getBean("activityService", ActivityService.class);
        List<Activity> list = service.searchPageList("1","2",new Activity());
        for (Activity activity : list) {
            System.out.println(activity);
        }
    }
    @Test
    public void testSelectCount(){
        ApplicationContext context = new ClassPathXmlApplicationContext("applicationContext.xml");
        ActivityService service = context.getBean("activityService", ActivityService.class);
        Integer integer = service.searchTotalCount();
        System.out.println(integer);
    }

    @Test
    public void testDeleteActivities(){
        ApplicationContext context = new ClassPathXmlApplicationContext("applicationContext.xml");
        ActivityRemarkMapper dao = context.getBean("activityRemarkMapper", ActivityRemarkMapper.class);
        Integer num = dao.selectCountByAids(new String[]{"20e0120f0f334a44a906027a82012bde"/*,"1f12250bb5c440d3aaf32723345e0b9b"*/});
        System.out.println(num);
    }
    @Test
    public void testArray(){
        String[] ids = new String[5];
        ids[0] = "111";
        ids[1] = "222";
        ids[2] = "333";
        System.out.println(Arrays.toString(ids));
    }

    @Test
    public void testSelectAct(){
        ApplicationContext context = new ClassPathXmlApplicationContext("applicationContext.xml");
        ActivityService service = context.getBean("activityService", ActivityService.class);
        Activity act = service.getActDetail("933a7278ba504da789d9746cd8a735e6");
        System.out.println(act);

    }

    @Test
    public void testGetRemarksByActId(){
        ApplicationContext context = new ClassPathXmlApplicationContext("applicationContext.xml");
        ActivityService service = context.getBean("activityService", ActivityService.class);
        List<ActivityRemark> list = service.getRemarkList("6af873baf3ac447ea30f920e86768a83");
        for (ActivityRemark remark : list) {
            System.out.println(remark);
        }
    }

    @Test
    public void testRemarkInsertAndGet(){
        ApplicationContext context = new ClassPathXmlApplicationContext("applicationContext.xml");
        ActivityService service = context.getBean("activityService", ActivityService.class);
        ActivityRemark remark = service.getActivityRemarkById("202111172300");
        System.out.println(remark);

    }

}
