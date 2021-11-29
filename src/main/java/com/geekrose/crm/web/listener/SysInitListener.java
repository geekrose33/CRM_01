package com.geekrose.crm.web.listener;

import com.geekrose.crm.settings.dao.DicTypeMapper;
import com.geekrose.crm.settings.domain.DicValue;
import com.geekrose.crm.settings.domain.User;
import com.geekrose.crm.settings.service.DictoryService;
import com.geekrose.crm.settings.service.UserService;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;
import org.springframework.stereotype.Component;
import org.springframework.web.context.support.WebApplicationContextUtils;

import javax.annotation.Resource;
import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;
import java.util.*;

/**
 * @author Joker_Dong
 * @date 2021-11-23 16:30
 */
@WebListener
public class SysInitListener implements ServletContextListener {

//    @Resource
//    private DictoryService dicService;

    public void contextInitialized(ServletContextEvent event) {
        DictoryService dicService =(DictoryService) WebApplicationContextUtils
                .getWebApplicationContext(event.getServletContext()).getBean("dictoryService");
        ServletContext application = event.getServletContext();
//        application.setAttribute();

        Map<String, List<DicValue>> map = dicService.getAll();
        // 将map转为上下文域对象
        Set<String> keys = map.keySet();
        for (String key:keys){

            List<DicValue> list = map.get(key);
            application.setAttribute(key,list);

        }

        //-------------------------------------------------------------
        // 将users表数据 name id 存放缓存中
        ApplicationContext context = new ClassPathXmlApplicationContext("applicationContext.xml");
        UserService userService = context.getBean("userService", UserService.class);
        List<User> users = userService.getUserList();
        application.setAttribute("userList",users);



        //---------------------------------------------------------------
        // 处理完数据字典 处理Stage2Possibility.properties文件
        /*
              解析该文件处理成java中键值对的关系
              Map<String(阶段stage),String(可能性possibility)> pMap = ...
              pMap.put("01资质审查",10)
              ...
              pMap保存值后 存储到服务器缓存中
              application.setAttribute("pMap",pMap);
        */
        // 解析Stage2Possibility.properties文件
        ResourceBundle rb = ResourceBundle.getBundle("Stage2Possibility");
        Enumeration<String> rbKeys = rb.getKeys();
        HashMap<String, String> pMap = new HashMap<String, String>();

        // 取出数据
        while (rbKeys.hasMoreElements()){
            // stage
            String stage = rbKeys.nextElement();
            // possibility
            String possibility = rb.getString(stage);

            pMap.put(stage,possibility);
        }

        // 将pMap保存到缓存中
        application.setAttribute("pMap",pMap);

    }
}
