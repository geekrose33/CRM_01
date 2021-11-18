package com.geekrose.crm.workbench.domain;

public class ConActRelation {
    private String id;

    private String contactsid;

    private String activityid;

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getContactsid() {
        return contactsid;
    }

    public void setContactsid(String contactsid) {
        this.contactsid = contactsid;
    }

    public String getActivityid() {
        return activityid;
    }

    public void setActivityid(String activityid) {
        this.activityid = activityid;
    }
}