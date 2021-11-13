package com.geekrose.crm.settings.web.controller;

import com.geekrose.crm.settings.service.UserService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.annotation.Resource;

/**
 * @author Joker_Dong
 * @date 2021-11-13 17:08
 */
@Controller
@RequestMapping("/user")
public class UserController {

    @Resource
    private UserService service;



}
