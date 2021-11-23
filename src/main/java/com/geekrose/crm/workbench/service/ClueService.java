package com.geekrose.crm.workbench.service;

import com.geekrose.crm.settings.domain.User;
import com.geekrose.crm.workbench.domain.Clue;

import java.util.List;

public interface ClueService {

    List<User> getUsers();

    boolean saveClue(Clue clue);

    List<Clue> getClues(String pageNo,String pageSize,Clue clue);

    int getTotalCount();
}
