package com.geekrose.crm.workbench.dao;

import com.geekrose.crm.workbench.domain.Clue;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface ClueMapper {
    int deleteByPrimaryKey(String id);

    int insert(Clue record);

    int insertSelective(Clue record);

    Clue selectByPrimaryKey(String id);

    int updateByPrimaryKeySelective(Clue record);

    int updateByPrimaryKey(Clue record);


    List<Clue> selectClues(@Param(value = "skipCount") Integer pageNo,@Param(value = "pageSize") Integer pageSize,@Param(value = "clue") Clue clue);

    int getTotalCount();
}