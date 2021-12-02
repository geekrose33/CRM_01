package com.geekrose.crm.workbench.web.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.geekrose.crm.settings.domain.User;
import com.geekrose.crm.utils.DateTimeUtil;
import com.geekrose.crm.workbench.domain.*;
import com.geekrose.crm.workbench.service.ClueService;
import com.geekrose.crm.workbench.service.ContactsService;
import com.geekrose.crm.workbench.service.TransactionService;
import javafx.beans.binding.ObjectExpression;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
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


    @RequestMapping("/saveTran.do")
    public void doSaveTran(HttpServletRequest request,HttpSession session, HttpServletResponse response, Transaction tran) throws IOException {

        User user = (User)session.getAttribute("user");
        tran.setCreateby(user.getName());
        boolean flag = tranService.addTran(tran);
        if (flag){
            // 添加操作完成后 重定向 getContextPath 项目名
            response.sendRedirect(request.getContextPath() + "/workbench/transaction/index.jsp");
        }
    }


    @RequestMapping("/getTranById.do")
    @ResponseBody
    public Transaction doGetTranById(String id){

        Transaction transaction = tranService.getTranById(id);

        return transaction;

    }

    @RequestMapping("/getActsByName.do")
    @ResponseBody
    public List<Activity> doGetActsByName(String name){

        List<Activity> list = tranService.getActsByName(name);

        return list;
    }

    @RequestMapping("/getContactsByName.do")
    @ResponseBody
    public List<Contacts> doGetContactsByName(String name){

        List<Contacts> list =tranService.getContactsByName(name);

        return list;
    }

    @RequestMapping("/editTran.do")
    public void doEditTran(HttpServletRequest request,HttpServletResponse response,Transaction tran) throws IOException {

        // 设置修改人
        User user = (User) request.getSession().getAttribute("user");
        tran.setEditby(user.getName());
        tran.setEdittime(DateTimeUtil.getSysTime());

        boolean flag = tranService.editTran(tran);

        /*
            customerid 根据name查询id

            {id='713b4d3447194d36a7adb0fc3c277848', owner='06f5fc056eac41558a964f96daa7f27c', money='666666', name='开发朝阳银行系统001',
            expecteddate='2021-12-01', customerid='朝阳银行', stage='04确定决策者', type='新业务', source='外部介绍',
            activityid='92410e358cf242f48b31907d72e116fc', contactsid='c6e1fd9d851341d5befd4d9a7cd7b6c6', createby='null', createtime='null',
            editby='null', edittime='null',
            description='jsp：pageContext page request response session application out config exception',
            contactsummary='jsp：pageContext page request response session application out config exception',
            nextcontacttime='2021-11-30'}
        */
        if (flag == true){
            // 重定向
            response.sendRedirect(request.getContextPath() + "/workbench/transaction/index.jsp");
        }

    }

    @RequestMapping("/removeTran.do")
    public void doRemoveTran(HttpServletResponse response,String id) throws IOException {
        boolean success = false;
        success = tranService.removeTranById(id);


        ObjectMapper mapper = new ObjectMapper();
        HashMap<String, Boolean> map = new HashMap<String, Boolean>();
        map.put("success",success);
        String json = mapper.writeValueAsString(map);
        response.getWriter().print(json);


    }

    // 详情页
    @RequestMapping("/detail.do")
    public ModelAndView doDetail(String id){

        ModelAndView mv = new ModelAndView();
        Transaction transaction = tranService.getDetailInfoById(id);

        mv.addObject("tran",transaction);
        mv.setViewName("forward:/workbench/transaction/detail.jsp");

        return mv;
    }

    @RequestMapping("/getHisListByTranId.do")
    @ResponseBody
    public List<TranHistory> doGetHisListByTranId(String tranId){

        List<TranHistory> list = tranService.getHisListByTranId(tranId);
        return list;
    }

    @RequestMapping("/changeStage.do")
    public void doChangeStage(HttpServletResponse response,HttpSession session,Transaction transaction) throws IOException {
        User user = (User) session.getAttribute("user");
        transaction.setEditby(user.getName());
        boolean success = tranService.changeStage(transaction);
        // 修改成功返回一个交易对象 封住那所需信息
        Transaction tran = null;
        if (success){
            //  java.lang.NullPointerException
            tran = new Transaction();
            tran.setEdittime(DateTimeUtil.getSysTime());
            tran.setEditby(user.getName());
            tran.setStage(transaction.getStage());
        }

        ObjectMapper mapper = new ObjectMapper();
        HashMap<String, Object> map = new HashMap<String, Object>();
        map.put("success",success);
        map.put("tran",tran);
        String jsons = mapper.writeValueAsString(map);
        response.getWriter().print(jsons);
    }

}
