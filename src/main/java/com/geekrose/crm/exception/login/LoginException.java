package com.geekrose.crm.exception.login;

import com.geekrose.crm.exception.UserException;

/**
 * @author Joker_Dong
 * @date 2021-11-13 22:25
 */

public class LoginException extends UserException {
    public LoginException(){}

    public LoginException(String msg){
        super(msg);
    }
}
