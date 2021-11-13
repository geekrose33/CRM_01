package com.geekrose.crm.exception;

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
    @ExceptionHandler(value = LoginException.class)
    public void doLoginException(){

    }

}
