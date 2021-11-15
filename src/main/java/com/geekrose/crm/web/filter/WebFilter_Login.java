package com.geekrose.crm.web.filter;

import com.geekrose.crm.settings.domain.User;

import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * @author Joker_Dong
 * @date 2021-11-15 14:38
 */

public class WebFilter_Login implements Filter {
    public void init(FilterConfig filterConfig) throws ServletException {

    }

    public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain filterChain) throws IOException, ServletException {
        HttpServletRequest request = (HttpServletRequest) servletRequest;
        HttpServletResponse response = (HttpServletResponse) servletResponse;
        // 如果是登录操作的请求 放行
        String path = request.getServletPath();
        if ("/login.jsp".equals(path) || "/settings/user/login.do".equals(path)){

            filterChain.doFilter(servletRequest,servletResponse);

        }else {
            User user = (User) request.getSession().getAttribute("user");

            if (user != null){
                // 放行
                filterChain.doFilter(servletRequest,servletResponse);

            }else {
                // 重定向到登录
                response.sendRedirect(request.getContextPath() + "/login.jsp");
            }
        }



    }

    public void destroy() {

    }
}
