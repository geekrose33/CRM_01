package com.geekrose.crm.settings.dao;

import com.geekrose.crm.settings.domain.User;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface UserMapper {
    int deleteByPrimaryKey(String id);

    int insert(User record);

    int insertSelective(User record);

    User selectByPrimaryKey(String id);

    int updateByPrimaryKeySelective(User record);

    int updateByPrimaryKey(User record);

    // 市场互动查询所有用户
    List<User> selectUserList();

    User selectUserByActAndPwd(@Param(value = "user") String loginAct,@Param(value = "pass") String loginPwd);

    Integer selectCountByActAndPwd(@Param(value = "user")String loginAct,@Param(value = "pass") String loginPwd);
}