package com.geekrose.crm.workbench.service.impl;

import com.geekrose.crm.workbench.dao.ActivityMapper;
import com.geekrose.crm.workbench.service.ActivityService;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;

/**
 * @author Joker_Dong
 * @date 2021-11-15 16:45
 */
@Service
public class ActivityServiceImpl implements ActivityService {
    @Resource
    private ActivityMapper dao;


}
