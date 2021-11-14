package com.geekrose.crm.settings.service.impl;

import com.geekrose.crm.exception.UserException;
import com.geekrose.crm.exception.login.IpException;
import com.geekrose.crm.exception.login.LockException;
import com.geekrose.crm.exception.login.LoginException;
import com.geekrose.crm.exception.login.TimeException;
import com.geekrose.crm.settings.dao.UserMapper;
import com.geekrose.crm.settings.domain.User;
import com.geekrose.crm.settings.service.UserService;
import com.geekrose.crm.utils.DateTimeUtil;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;

/**
 * @author Joker_Dong
 * @date 2021-11-13 17:08
 */
@Service(value = "userService")
public class UserServiceImpl implements UserService {
    @Resource
    private UserMapper dao;


    public User checkLogin(String loginAct, String loginPwd, String ip) throws LoginException {
        User user = null;
        Integer num = dao.selectCountByActAndPwd(loginAct,loginPwd);
        if (num == 1){
            // 账号密码验证成功

            user = dao.selectUserByActAndPwd(loginAct,loginPwd);
            if ("0".equals(user.getLockstate())){
                throw new LockException();
            }
            if (!user.getAllowips().contains(ip)){
                throw new IpException();
            }
            if (user.getExpiretime().compareTo(DateTimeUtil.getSysTime()) < 0){
                throw new TimeException();
            }


        }

        return user;
    }
}
