package com.geekrose.crm.settings.web.controller;

import com.geekrose.crm.exception.login.LoginException;
import com.geekrose.crm.exception.login.NameAndPassException;
import com.geekrose.crm.settings.domain.User;
import com.geekrose.crm.settings.service.UserService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

/**
 * @author Joker_Dong
 * @date 2021-11-13 17:08
 */
@Controller
@RequestMapping("/settings/user")
public class UserController {

    @Resource
    private UserService service;

    @RequestMapping("/login.do")
    public ModelAndView doCheckLogin(HttpServletRequest request,String loginAct, String loginPwd) throws LoginException {
        ModelAndView mv = new ModelAndView();

        String ip = request.getRemoteAddr();

        User user = service.checkLogin(loginAct,loginPwd,ip);

        if (user == null){
            mv.addObject("success",false);
            mv.setViewName("forward:/login.jsp");
            throw new NameAndPassException();
        }else {
            mv.addObject("success",true);
            mv.setViewName("forward:/login.jsp");
        }
        return mv;




    }


}
