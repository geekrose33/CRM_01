package com.geekrose.crm.exception;

import com.geekrose.crm.exception.login.*;
import com.geekrose.crm.settings.vo.Info;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;


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
    @ResponseBody
    public Info doNameAndPassException(NameAndPassException ex){

        ex.getInfo().setMsg("用户名或密码出现错误");

        return ex.getInfo();
    }

    @ExceptionHandler(value = IpException.class)
    @ResponseBody
    public Info doIpException(IpException ex){
        ex.getInfo().setMsg("ip地址不被允许访问");

        return ex.getInfo();
    }
    @ExceptionHandler(value = TimeException.class)
    @ResponseBody
    public Info doTimeException(TimeException ex){
        ex.getInfo().setMsg("账号已过期");

        return ex.getInfo();
    }
    @ExceptionHandler(value = LockException.class)
    @ResponseBody
    public Info doLockException(LockException ex){
        ex.getInfo().setMsg("账号处于封禁状态");

        return ex.getInfo();
    }



}
