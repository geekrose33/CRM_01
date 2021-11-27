package com.geekrose.crm.workbench.web.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.geekrose.crm.settings.domain.User;
import com.geekrose.crm.workbench.domain.Activity;
import com.geekrose.crm.workbench.domain.Clue;
import com.geekrose.crm.workbench.domain.ClueRemark;
import com.geekrose.crm.workbench.domain.Transaction;
import com.geekrose.crm.workbench.service.ClueService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;

/**
 * @author Joker_Dong
 * @date 2021-11-23 20:34
 */
@Controller
@RequestMapping("/workbench/clue")
public class ClueController {

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
    public void doPageList(HttpServletResponse response,String pageNo,String pageSize,Clue clue) throws IOException {

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
    @RequestMapping("/editClue.do")
    public void doEditClueInfo(HttpServletResponse response,String id) throws IOException {
        // 1. 获取clue信息
        Clue clue = clueService.getEditInfoById(id);

        // 2. 获取users信息
        List<User> users = clueService.getUsers();

        ObjectMapper mapper = new ObjectMapper();
        HashMap<String, Object> map = new HashMap<String, Object>();
        map.put("users",users);
        map.put("clue",clue);
        String jsons = mapper.writeValueAsString(map);
        response.getWriter().print(jsons);

    }
    @RequestMapping("/updateClue.do")
    public void doUpdateClue(HttpSession session,HttpServletResponse response,Clue clue) throws IOException {
        boolean success = false;
        // 设置修改人
        User user =(User) session.getAttribute("user");
        clue.setEditby(user.getName());

        success = clueService.updateClue(clue);

        ObjectMapper mapper = new ObjectMapper();

        HashMap<String, Boolean> map = new HashMap<String, Boolean>();
        map.put("success",success);

        String json = mapper.writeValueAsString(map);

        response.getWriter().print(json);
    }



    @RequestMapping("/deleteClue.do")
    public void doDeleteClue(HttpServletResponse response,String id) throws IOException {
        boolean success = false;
        success = clueService.deleteClue(id);


        ObjectMapper mapper = new ObjectMapper();
        HashMap<String, Boolean> map = new HashMap<String, Boolean>();

        map.put("success",success);
        String json = mapper.writeValueAsString(map);
        response.getWriter().print(json);
    }

    @RequestMapping("/detailClue.do")
    public ModelAndView doDetailClue(String id){
        ModelAndView mv = new ModelAndView();

        Clue clue = clueService.getClueById(id);
        mv.addObject("clue",clue);
        mv.setViewName("forward:/workbench/clue/detail.jsp");

        return mv;

    }
    @RequestMapping("/showClueRemark.do")
    @ResponseBody
    public List<ClueRemark> doShowClueRemark(String id){

        List<ClueRemark> list = clueService.showClueRemark(id);

        return list;
    }

    @RequestMapping("/addClueRemark.do")
    public void doAddClueRemark(HttpServletResponse response,ClueRemark remark) throws IOException {
        boolean success = false;
        success = clueService.addClueRemark(remark);

        ObjectMapper mapper = new ObjectMapper();
        HashMap<String, Boolean> map = new HashMap<String, Boolean>();
        map.put("success",success);
        String json = mapper.writeValueAsString(map);
        response.getWriter().print(json);
    }
    @RequestMapping("/removeRemark.do")
    public void doRemoveRemark(HttpServletResponse response,String id) throws IOException {
        boolean success = false;
        success = clueService.removeRemark(id);

        ObjectMapper mapper = new ObjectMapper();
        HashMap<String, Boolean> map = new HashMap<String, Boolean>();
        map.put("success",success);
        String json = mapper.writeValueAsString(map);
        response.getWriter().print(json);

    }
    @RequestMapping("/updateRemark.do")
    public void doUpdateRemark(HttpServletResponse response,String id ,String notecontent) throws IOException {
        boolean success = false;
        success = clueService.updateClueRemark(id,notecontent);

        ObjectMapper mapper = new ObjectMapper();
        HashMap<String, Object> map = new HashMap<String, Object>();
        map.put("success",success);

        String json = mapper.writeValueAsString(map);
        response.getWriter().print(json);
    }

    @RequestMapping("/showActivityList.do")
    public @ResponseBody List<Activity> doShowActivityList(String id){

        List<Activity> list = clueService.getActivityListByClueId(id);
        return list;
    }
    @RequestMapping("/unbond.do")
    public void doUnBond(HttpServletResponse response,String id) throws IOException {

        boolean success = false;
        success = clueService.deleteRelation(id);

        ObjectMapper mapper = new ObjectMapper();
        HashMap<String, Object> map = new HashMap<String, Object>();
        map.put("success",success);
        String json = mapper.writeValueAsString(map);
        response.getWriter().print(json);

    }
    @RequestMapping("/getActListForNameNotByClueId.do")
    public @ResponseBody List<Activity> doGetActListForNameNotByClueId(String name,String clueId){

        List<Activity> list = clueService.getActListForNameNotByClueId(name,clueId);
        return list;
    }
    @RequestMapping("/bond.do")
    public void doBond(HttpServletResponse response,String clueId,@RequestParam(value = "actIds[]") String[] actIds) throws IOException {


        boolean success = false;
        success = clueService.bondActClue(clueId,actIds);

        ObjectMapper mapper = new ObjectMapper();
        HashMap<String, Boolean> map = new HashMap<String, Boolean>();
        map.put("success",success);
        String json = mapper.writeValueAsString(map);
        response.getWriter().print(json);

    }
    @RequestMapping("/getActListByName.do")
    public @ResponseBody List<Activity> doGetActListByName(String name){

        List<Activity> list = clueService.getActListByName(name);
        return list;
    }

    @RequestMapping("/convertClue.do")
    public void doConvertClue(HttpSession session,HttpServletResponse response,String flag , String clueid, Transaction tran) throws IOException {
        String createby = ((User)session.getAttribute("user")).getName();

        // 当Flag不是true时说明没有添加transaction
        if (!"true".equals(flag)){
            tran = null;
        }


        boolean success = clueService.convertClue(clueid,tran,createby);


        /*if ("true".equals(flag)){
            // 添加市场活动
            clueService.convertClue();
        }else{
            // 不添加市场活动

        }*/
        if (success){
            response.sendRedirect("index.jsp");
        }


    }

}
