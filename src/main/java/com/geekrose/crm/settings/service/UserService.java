package com.geekrose.crm.settings.service;

import com.geekrose.crm.exception.login.LoginException;
import com.geekrose.crm.settings.domain.User;

public interface UserService {
    User checkLogin(String loginAct, String loginPwd, String ip) throws LoginException;
}
