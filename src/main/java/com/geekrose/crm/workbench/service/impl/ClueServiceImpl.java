package com.geekrose.crm.workbench.service.impl;

import com.geekrose.crm.settings.dao.UserMapper;
import com.geekrose.crm.settings.domain.User;
import com.geekrose.crm.utils.DateTimeUtil;
import com.geekrose.crm.utils.UUIDUtil;
import com.geekrose.crm.workbench.dao.ClueMapper;
import com.geekrose.crm.workbench.domain.Clue;
import com.geekrose.crm.workbench.service.ClueService;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

/**
 * @author Joker_Dong
 * @date 2021-11-18 21:16
 */
@Service("clueService")
public class ClueServiceImpl implements ClueService {
    @Resource
    private UserMapper userDao;

    @Resource
    private ClueMapper clueDao;

    public List<User> getUsers() {
        List<User> users = userDao.selectUserList();
        return users;
    }

    public boolean saveClue(Clue clue) {
        boolean flag = false;
        // 设置id
        clue.setId(UUIDUtil.getUUID());
        // 设置创建时间
        clue.setCreatetime(DateTimeUtil.getSysTime());
        int i = clueDao.insert(clue);
        if (i == 1){
            flag = true;
        }

        return flag;
    }

    public List<Clue> getClues(String pageNo,String pageSize,Clue clue) {
        Integer ipageNo = Integer.valueOf(pageNo);
        Integer ipageSize = Integer.valueOf(pageSize);

        ipageNo = (ipageNo - 1)*ipageSize;

        List<Clue> list = clueDao.selectClues(ipageNo,ipageSize,clue);
        return list;
    }

    public int getTotalCount() {
        int num = clueDao.getTotalCount();
        return num;
    }
}
