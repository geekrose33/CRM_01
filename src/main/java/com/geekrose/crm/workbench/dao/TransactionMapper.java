package com.geekrose.crm.workbench.dao;

import com.geekrose.crm.workbench.domain.Transaction;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface TransactionMapper {
    int deleteByPrimaryKey(String id);

    int insert(Transaction record);

    int insertSelective(Transaction record);

    Transaction selectByPrimaryKey(String id);

    int updateByPrimaryKeySelective(Transaction record);

    int updateByPrimaryKey(Transaction record);

    int selectTranByName(String name);

    List<Transaction> getTransByCondition(@Param("tran") Transaction tran, @Param("skipCount") Integer skipCount,@Param("pageSize") Integer ipageSize);

    int selectCount();

    Transaction selectDetailInfoById(String id);
}