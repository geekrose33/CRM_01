package com.geekrose.crm.workbench.web.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.geekrose.crm.settings.domain.User;
import com.geekrose.crm.workbench.domain.Clue;
import com.geekrose.crm.workbench.service.ClueService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.HashMap;
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

    @RequestMapping("/saveClue.do")
    public void doSaveClue(HttpSession session,HttpServletResponse response,Clue clue) throws IOException {
        boolean success = false;
        User user =(User) session.getAttribute("user");
        clue.setCreateby(user.getName());
        success = clueService.saveClue(clue);
        ObjectMapper mapper = new ObjectMapper();
        HashMap<String, Boolean> map = new HashMap<String, Boolean>();
        map.put("success",success);
        String json = mapper.writeValueAsString(map);
        response.getWriter().print(json);
    }

    @RequestMapping("/pageList.do")
//    @ResponseBody
    public void doPageList(HttpServletResponse response,String pageNo,String pageSize,Clue clue) throws IOException {

        System.out.println("----------"+ clue + "---------------");

        // 查询线索集合
        List<Clue> list = clueService.getClues(pageNo,pageSize,clue);
        // 查询总记录数
        int total = clueService.getTotalCount();

        ObjectMapper mapper = new ObjectMapper();
        HashMap<String, Object> map = new HashMap<String, Object>();
        map.put("clues",list);
        map.put("totalCount",total);
        String jsons = mapper.writeValueAsString(map);
        response.getWriter().print(jsons);

    }

}
