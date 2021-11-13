package com.geekrose.crm.exception;

/**
 * @author Joker_Dong
 * @date 2021-11-13 22:23
 */

public class UserException extends Exception {
    public UserException(){
    }
    public UserException(String msg){
        super(msg);
    }
}
