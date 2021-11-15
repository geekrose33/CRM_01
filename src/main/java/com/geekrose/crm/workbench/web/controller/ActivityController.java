package com.geekrose.crm.workbench.web.controller;

import com.geekrose.crm.workbench.service.ActivityService;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.annotation.Resource;

/**
 * @author Joker_Dong
 * @date 2021-11-15 16:47
 */
@Controller
@RequestMapping(value = "/workbench/activity")
public class ActivityController {
    @Resource
    private ActivityService service;


}
