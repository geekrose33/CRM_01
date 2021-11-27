package com.geekrose.crm.workbench.service.impl;

import com.geekrose.crm.workbench.dao.ContactsMapper;
import com.geekrose.crm.workbench.domain.Contacts;
import com.geekrose.crm.workbench.service.ContactsService;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

/**
 * @author Joker_Dong
 * @date 2021-11-18 21:17
 */
@Service("contactsService")
public class ContactsServiceImpl implements ContactsService {

    @Resource
    private ContactsMapper conDao;

    public List<Contacts> getContactsByName(String name) {

        List<Contacts> contacts = conDao.getContactByName(name);

        return contacts;
    }
}
