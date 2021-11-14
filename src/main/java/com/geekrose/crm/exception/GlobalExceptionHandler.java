package com.geekrose.crm.exception;

import com.geekrose.crm.exception.login.*;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.servlet.ModelAndView;


/**
 * @author Joker_Dong
 * @date 2021-11-13 22:19
 */
// 统一处理异常类（SpringMVC）
@ControllerAdvice
public class GlobalExceptionHandler {
    // 在方法上加 @ExceptionHandler
    // 返回ajax的请求 异常提示信息 使用void即可
    @ExceptionHandler(value = NameAndPassException.class)
    public ModelAndView doNameAndPassException(Exception ex){
        ModelAndView mv = new ModelAndView();
        mv.addObject("msg","姓名或密码不正确");
        mv.setViewName("/login.jsp");
        return mv;
    }

    @ExceptionHandler(value = IpException.class)
    public ModelAndView doIpException(Exception ex){
        ModelAndView mv = new ModelAndView();
        mv.addObject("msg","当前IP不被允许访问");
        mv.setViewName("/login.jsp");
        return mv;
    }
    @ExceptionHandler(value = TimeException.class)
    public ModelAndView doTimeException(Exception ex){
        ModelAndView mv = new ModelAndView();
        mv.addObject("msg","账号已过期");
        mv.setViewName("/login.jsp");
        return mv;
    }
    @ExceptionHandler(value = LockException.class)
    public ModelAndView doLockException(Exception ex){
        ModelAndView mv = new ModelAndView();
        mv.addObject("msg","当前账号处于封禁状态");
        mv.setViewName("/login.jsp");
        return mv;
    }


}
