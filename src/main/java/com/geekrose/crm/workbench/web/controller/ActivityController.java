package com.geekrose.crm.workbench.web.controller;

import com.alibaba.druid.support.json.JSONUtils;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.geekrose.crm.settings.domain.User;
import com.geekrose.crm.utils.PrintJson;
import com.geekrose.crm.workbench.domain.Activity;
import com.geekrose.crm.workbench.service.ActivityService;
import org.apache.ibatis.reflection.wrapper.ObjectWrapper;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;

/**
 * @author Joker_Dong
 * @date 2021-11-15 16:47
 */
@Controller
@RequestMapping(value = "/workbench/activity")
public class ActivityController {
    @Resource
    private ActivityService service;

    @RequestMapping("/getUserList.do")
    public @ResponseBody List<User> doGetUserList(){

        List<User> users = service.getUserList();

        return users;
    }



    @RequestMapping(value = "/saveActivity.do",method = {RequestMethod.POST})
    @ResponseBody
    public void doSaveActivity(HttpServletRequest request, HttpServletResponse response,Activity activity) throws IOException {
        boolean success = false;
        // 设置对象的创建人
        User user =(User) request.getSession().getAttribute("user");
        activity.setCreateby(user.getName());
        // 调用service方法
        success = service.saveActivity(activity);
        // 返回json格式数据 将布尔值转为json
        ObjectMapper mapper = new ObjectMapper();
        HashMap<String, Boolean> map = new HashMap<String, Boolean>();
        map.put("success",success);
        String json = mapper.writeValueAsString(map);

        response.getWriter().print(json);
//        PrintJson.printJsonFlag(response,success);
    }

    @RequestMapping("/pageList.do")
    @ResponseBody
    public void doPageList(HttpServletResponse response,String pageNo,String pageSize,Activity activity) throws IOException {

        // 查询所有记录数返回
        Integer totalCount = service.searchTotalCount();
        // 分页查询
        List<Activity> list = service.searchPageList(pageNo,pageSize,activity);
        /*for (Activity activity1 : list) {
            System.out.println(activity1);
        }*/
        ObjectMapper mapper = new ObjectMapper();
        HashMap<String, Object> map = new HashMap<String, Object>();
        map.put("activityList",list);
        map.put("totalCount",totalCount);
        String json = mapper.writeValueAsString(map);
        response.getWriter().print(json);


    }
    @RequestMapping("/deleteActivites.do")
    public void doDeleteActivites(HttpServletResponse response,HttpServletRequest request) throws IOException {
        String ids[] = request.getParameterValues("id");
        System.out.println(Arrays.toString(ids));

        boolean flag = service.deleteActivities(ids);
        ObjectMapper mapper = new ObjectMapper();
        HashMap<String, Boolean> map = new HashMap<String, Boolean>();
        map.put("success",flag);
        String json = mapper.writeValueAsString(map);
        response.getWriter().print(json);
    }

}
