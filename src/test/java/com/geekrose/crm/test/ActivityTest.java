package com.geekrose.crm.test;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.geekrose.crm.settings.domain.User;
import com.geekrose.crm.workbench.dao.ActivityMapper;
import com.geekrose.crm.workbench.domain.Activity;
import com.geekrose.crm.workbench.service.ActivityService;
import org.junit.Test;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

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
        ActivityMapper dao = context.getBean("activityMapper", ActivityMapper.class);
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
}
