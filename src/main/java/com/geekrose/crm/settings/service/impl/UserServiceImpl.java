package com.geekrose.crm.settings.service.impl;

import com.geekrose.crm.exception.UserException;
import com.geekrose.crm.exception.login.*;
import com.geekrose.crm.settings.dao.UserMapper;
import com.geekrose.crm.settings.domain.User;
import com.geekrose.crm.settings.service.UserService;
import com.geekrose.crm.settings.vo.Info;
import com.geekrose.crm.utils.DateTimeUtil;
import com.geekrose.crm.utils.MD5Util;
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


    public User checkLogin(String loginAct, String loginPwd, String ip,Info info) throws LoginException {
        User user = null;


        loginPwd = MD5Util.getMD5(loginPwd);
        Integer num = dao.selectCountByActAndPwd(loginAct, loginPwd);
        if (num == 0){
            throw new NameAndPassException(info);
        }
        if (num == 1){
            // 账号密码验证成功

            user = dao.selectUserByActAndPwd(loginAct,loginPwd);

            if ("0".equals(user.getLockstate())){
                throw new LockException(info);
            }
            if (!user.getAllowips().contains(ip)){
                throw new IpException(info);
            }
            if (user.getExpiretime().compareTo(DateTimeUtil.getSysTime()) < 0){
                throw new TimeException(info);
            }


        }

        return user;
    }
}
