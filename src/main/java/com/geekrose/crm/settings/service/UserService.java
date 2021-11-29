package com.geekrose.crm.settings.service;

import com.geekrose.crm.exception.login.LoginException;
import com.geekrose.crm.settings.domain.User;
import com.geekrose.crm.settings.vo.Info;

import java.util.List;

public interface UserService {
    User checkLogin(String loginAct, String loginPwd, String ip, Info info) throws LoginException;


    List<User> getUserList();
}
