package com.geekrose.crm.workbench.web.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.geekrose.crm.settings.domain.User;
import com.geekrose.crm.workbench.domain.Activity;
import com.geekrose.crm.workbench.domain.Contacts;
import com.geekrose.crm.workbench.domain.Transaction;
import com.geekrose.crm.workbench.service.ClueService;
import com.geekrose.crm.workbench.service.ContactsService;
import com.geekrose.crm.workbench.service.TransactionService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;

/**
 * @author Joker_Dong
 * @date 2021-11-27 16:58
 */
@Controller
@RequestMapping("/workbench/tran")
public class TranController {

    @Resource
    private TransactionService tranService;

    @Resource
    private ClueService clueService;

    @Resource
    private ContactsService conService;




    // 刷新交易列表信息
    @RequestMapping("/getTransactionList.do")
    @ResponseBody
    public void doGetTransactionList(HttpServletResponse response,Transaction tran, String pageNo, String pageSize) throws IOException {

        List<Transaction> list = tranService.getTranList(tran,pageNo,pageSize);

        int totalCount = tranService.getTotalCount();

        ObjectMapper mapper = new ObjectMapper();
        HashMap<String, Object> map = new HashMap<String, Object>();
        map.put("totalCount",totalCount);
        map.put("trans",list);
        String jsons = mapper.writeValueAsString(map);
        response.getWriter().print(jsons);
    }
    @RequestMapping("/searchActs.do")
    public @ResponseBody List<Activity> doSearchActs(String name){
        List<Activity> acts = clueService.getActListByName(name);
        return acts;
    }



    @RequestMapping("/searchContacts.do")
    @ResponseBody
    public List<Contacts> doSearchContacts(String name){
        System.out.println("------ name -----" + name);
        List<Contacts> cons = conService.getContactsByName(name);
        return cons;
    }

    @RequestMapping("/getUsers.do")
    public @ResponseBody List<User> doGetUsers(){

        List<User> users = tranService.getUsers();
        return users;
    }

    @RequestMapping("/getCustomerName.do")
    public @ResponseBody List<String> doGetCustomerName(String name){

        List<String> list = tranService.getCustomerName(name);
        return list;
    }






}
