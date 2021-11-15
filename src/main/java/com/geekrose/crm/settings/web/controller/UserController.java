package com.geekrose.crm.settings.web.controller;

import com.geekrose.crm.exception.login.LoginException;
import com.geekrose.crm.exception.login.NameAndPassException;
import com.geekrose.crm.settings.domain.User;
import com.geekrose.crm.settings.service.UserService;

import com.geekrose.crm.settings.vo.Info;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;


import javax.annotation.Resource;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;


/**
 * @author Joker_Dong
 * @date 2021-11-13 17:08
 */
@Controller
@RequestMapping("/settings/user")
public class UserController {

    @Resource
    private UserService service;

    // 用于验证登录
    @RequestMapping(value = "/login.do",method = {RequestMethod.POST})
    @ResponseBody
    public Info doCheckLogin(HttpServletRequest request, HttpSession session , String loginAct, String loginPwd) throws LoginException {
        Info info = new Info();

        User user = null;

        String ip = request.getRemoteAddr();


        user = service.checkLogin(loginAct,loginPwd,ip,info);

        if (user == null){
            info.setSuccess(false);
        }else {
            info.setSuccess(true);
            session.setAttribute("user",user);
        }



        return info;

    }


}
