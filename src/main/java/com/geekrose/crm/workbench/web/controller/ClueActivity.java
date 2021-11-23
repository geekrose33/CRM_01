package com.geekrose.crm.workbench.web.controller;

import com.geekrose.crm.settings.domain.User;
import com.geekrose.crm.workbench.service.ClueService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import java.util.List;

/**
 * @author Joker_Dong
 * @date 2021-11-23 20:34
 */
@Controller
@RequestMapping("/workbench/clue")
public class ClueActivity {

    @Resource
    private ClueService clueService;

    @RequestMapping("/getUsers.do")
    public @ResponseBody List<User> doGetUsers(){

        List<User> users = clueService.getUsers();

        return users;

    }

}
