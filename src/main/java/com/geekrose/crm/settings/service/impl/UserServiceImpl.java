package com.geekrose.crm.settings.service.impl;

import com.geekrose.crm.settings.dao.UserMapper;
import com.geekrose.crm.settings.service.UserService;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;

/**
 * @author Joker_Dong
 * @date 2021-11-13 17:08
 */
@Service
public class UserServiceImpl implements UserService {
    @Resource
    private UserMapper dao;


}
