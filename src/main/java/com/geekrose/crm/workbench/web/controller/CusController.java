package com.geekrose.crm.workbench.web.controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.geekrose.crm.settings.domain.User;
import com.geekrose.crm.utils.DateTimeUtil;
import com.geekrose.crm.workbench.domain.Customer;
import com.geekrose.crm.workbench.service.CustomerService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.Mapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;

/**
 * @author Joker_Dong
 * @date 2021-11-29 16:58
 */
@Controller
@RequestMapping("/workbench/cus")
public class CusController {

    @Resource
    private CustomerService cusService;

    @RequestMapping("/getCustomers.do")

    public void doGetCustomers(HttpServletResponse response,String pageNo, String pageSize, Customer customer) throws IOException {

        System.out.println("----cus----" + customer);
        // 获取客户集合
        List<Customer> customers = cusService.getCustomersForPage(pageNo,pageSize,customer);
        // 获取总客户数
        Integer totalCount = cusService.getTotalCount();

        ObjectMapper mapper = new ObjectMapper();
        HashMap<String, Object> map = new HashMap<String, Object>();
        map.put("customers",customers);
        map.put("totalCount",totalCount);
        String jsons = mapper.writeValueAsString(map);
        response.getWriter().print(jsons);


    }

    @RequestMapping("/saveCustomer.do")
    public void doSaveCustomer(HttpSession session,HttpServletResponse response, Customer customer) throws IOException {

        User user = (User) session.getAttribute("user");
        customer.setCreateby(user.getName());
        customer.setCreatetime(DateTimeUtil.getSysTime());

        /*
            Customer{id='null', owner='758c3a06356f560099e3eeaeeba657cb', name='百度', website='www.baidu.com', phone='999999999',
            createby='王二麻子', createtime='2021-11-29 20:25:00', editby='null', edittime='null',
            contactsummary='jsp：pageContext、page、Request、Response、session、application、config、out、exception',
            nextcontacttime='2021-12-01', description='搜索引擎、人工智能', address='北京大兴大族企业湾'}
        */
        boolean success = cusService.saveCustomer(customer);

        ObjectMapper mapper = new ObjectMapper();
        HashMap<String, Boolean> map = new HashMap<String, Boolean>();
        map.put("success",success);
        String json = mapper.writeValueAsString(map);
        response.getWriter().print(json);

    }


    @RequestMapping("/getCustomerById.do")
    @ResponseBody
    public Customer doGetCustomerById(String id){

        Customer customer = cusService.getCustomerById(id);

        return customer;
    }

    @RequestMapping("/editCustomer.do")
    public void doEditCustomer(HttpSession session,HttpServletResponse response,Customer customer) throws IOException {

        System.out.println("--------customer-------" + customer);
        /*
            --------customer-------
            Customer{id='ec88298e624b47579988fee1cf43f443', owner='王二麻子', name='百度',
            website='www.baidu.com', phone='9999999999', createby='null', createtime='null', editby='null', edittime='null',
            contactsummary='jsp：pageContext、page、request、response、session、application、config、out、exception',
            nextcontacttime='2021-12-01', description='搜索引擎、人工智能', address=''}
        */
        User user = (User) session.getAttribute("user");
        customer.setEditby(user.getName());

        boolean success = cusService.editCustomer(customer);

        System.out.println("---------success---------" + success);

        ObjectMapper mapper = new ObjectMapper();
        HashMap<String, Boolean> map = new HashMap<String, Boolean>();

        map.put("success",success);
        String json = mapper.writeValueAsString(map);

        response.getWriter().print(json);

    }

}
