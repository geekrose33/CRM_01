package com.geekrose.crm.workbench.dao;

import com.geekrose.crm.workbench.domain.Transaction;

public interface TransactionMapper {
    int deleteByPrimaryKey(String id);

    int insert(Transaction record);

    int insertSelective(Transaction record);

    Transaction selectByPrimaryKey(String id);

    int updateByPrimaryKeySelective(Transaction record);

    int updateByPrimaryKey(Transaction record);
}