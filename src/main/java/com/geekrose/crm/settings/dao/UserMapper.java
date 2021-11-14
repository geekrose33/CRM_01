package com.geekrose.crm.settings.dao;

import com.geekrose.crm.settings.domain.User;
import org.apache.ibatis.annotations.Param;

public interface UserMapper {
    int deleteByPrimaryKey(String id);

    int insert(User record);

    int insertSelective(User record);

    User selectByPrimaryKey(String id);

    int updateByPrimaryKeySelective(User record);

    int updateByPrimaryKey(User record);

    User selectUserByActAndPwd(@Param(value = "user") String loginAct,@Param(value = "pass") String loginPwd);

    Integer selectCountByActAndPwd(@Param(value = "user")String loginAct,@Param(value = "pass") String loginPwd);
}