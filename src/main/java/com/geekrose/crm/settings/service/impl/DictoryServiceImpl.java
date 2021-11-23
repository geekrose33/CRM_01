package com.geekrose.crm.settings.service.impl;

import com.geekrose.crm.settings.dao.DicTypeMapper;
import com.geekrose.crm.settings.dao.DicValueMapper;
import com.geekrose.crm.settings.domain.DicType;
import com.geekrose.crm.settings.domain.DicValue;
import com.geekrose.crm.settings.service.DictoryService;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * @author Joker_Dong
 * @date 2021-11-18 21:17
 */
@Service(value = "dictoryService")
public class DictoryServiceImpl implements DictoryService {
    @Resource
    private DicTypeMapper typeDao;
    @Resource
    private DicValueMapper valueDao;

    public Map<String, List<DicValue>> getAll() {
        HashMap<String, List<DicValue>> map = new HashMap<String, List<DicValue>>();

        List<DicType> types = typeDao.getTypeList();

        for (DicType type : types){

            List<DicValue> values = valueDao.selectByTypeCode(type.getCode());

            // 将查询到的数据字典值放入Map
            map.put(type.getCode()+"List",values);

        }

        return map;
    }
}
