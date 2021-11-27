package com.geekrose.crm.workbench.service;

import com.geekrose.crm.workbench.domain.Contacts;

import java.util.List;

public interface ContactsService {
    List<Contacts> getContactsByName(String name);
}
