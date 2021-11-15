package com.geekrose.crm.web.filter;

import com.geekrose.crm.settings.domain.User;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * @author Joker_Dong
 * @date 2021-11-14 23:14
 */

public class LoginFilter implements HandlerInterceptor {

    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {

        // 判断session域中是否有user对象
        String path = request.getServletPath();
        System.out.println("11111111111");
        // 不应该拦截的资源 自动放行
        if ("/login.jsp".equals(path) || "/settings/user/login.do".equals(path)){
            System.out.println("2222222222222222");
            return true;
        }else {
            System.out.println("333333333333333333333");
            User user =(User) request.getSession().getAttribute("user");
            // 其他资源 拦截
            if (user == null){
                response.sendRedirect( request.getContextPath() + "/login.jsp ");
                return false;
            }else {
                return true;
            }
        }
    }
}
