package com.geekrose.crm.workbench.dao;

import com.geekrose.crm.workbench.domain.Contacts;

public interface ContactsMapper {
    int deleteByPrimaryKey(String id);

    int insert(Contacts record);

    int insertSelective(Contacts record);

    Contacts selectByPrimaryKey(String id);

    int updateByPrimaryKeySelective(Contacts record);

    int updateByPrimaryKey(Contacts record);
}