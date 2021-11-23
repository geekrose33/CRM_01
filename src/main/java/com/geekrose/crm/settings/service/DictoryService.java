package com.geekrose.crm.settings.service;

import com.geekrose.crm.settings.domain.DicValue;

import java.util.List;
import java.util.Map;

public interface DictoryService {
    Map<String, List<DicValue>> getAll();
}
