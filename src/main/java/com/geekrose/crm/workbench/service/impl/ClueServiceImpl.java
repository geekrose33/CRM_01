package com.geekrose.crm.workbench.service.impl;

import com.geekrose.crm.settings.dao.UserMapper;
import com.geekrose.crm.settings.domain.User;
import com.geekrose.crm.workbench.service.ClueService;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

/**
 * @author Joker_Dong
 * @date 2021-11-18 21:16
 */
@Service("/clueService")
public class ClueServiceImpl implements ClueService {
    @Resource
    private UserMapper userDao;

    public List<User> getUsers() {
        List<User> users = userDao.selectUserList();
        return users;
    }
}
