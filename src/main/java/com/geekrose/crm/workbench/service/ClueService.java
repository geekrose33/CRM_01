package com.geekrose.crm.workbench.service;

import com.geekrose.crm.settings.domain.User;
import com.geekrose.crm.workbench.domain.Activity;
import com.geekrose.crm.workbench.domain.Clue;
import com.geekrose.crm.workbench.domain.ClueRemark;
import com.geekrose.crm.workbench.domain.Transaction;

import java.util.List;

public interface ClueService {

    List<User> getUsers();

    boolean saveClue(Clue clue);

    List<Clue> getClues(String pageNo,String pageSize,Clue clue);

    int getTotalCount();

    Clue getEditInfoById(String id);

    boolean updateClue(Clue clue);

    boolean deleteClue(String id);

    Clue getClueById(String id);

    List<ClueRemark> showClueRemark(String id);

    boolean addClueRemark(ClueRemark remark);

    boolean removeRemark(String id);

    boolean updateClueRemark(String id, String notecontent);

    List<Activity> getActivityListByClueId(String id);

    boolean deleteRelation(String id);

    List<Activity> getActListForNameNotByClueId(String name, String clueId);

    boolean bondActClue(String clueId, String[] actIds);

    List<Activity> getActListByName(String name);

    boolean convertClue(String clueid, Transaction tran, String createby);
}
