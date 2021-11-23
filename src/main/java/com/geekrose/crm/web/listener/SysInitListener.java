package com.geekrose.crm.web.listener;

import com.geekrose.crm.settings.dao.DicTypeMapper;
import com.geekrose.crm.settings.domain.DicValue;
import com.geekrose.crm.settings.service.DictoryService;
import org.springframework.stereotype.Component;
import org.springframework.web.context.support.WebApplicationContextUtils;

import javax.annotation.Resource;
import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;
import java.util.List;
import java.util.Map;
import java.util.Set;

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


    }
}
