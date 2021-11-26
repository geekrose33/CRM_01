package com.geekrose.crm.workbench.domain;

public class Transaction {
    private String id;

    private String owner; // ------- 外键 关联 tbl_user

    private String money;

    private String name;

    private String expecteddate;

    private String customerid; // ------- 外键 关联 tbl_customer

    private String stage;

    private String type;

    private String source;

    private String activityid; // ------- 外键 关联 tbl_activity

    private String contactsid; // ------- 外键 关联 tbl_contacts

    private String createby;

    private String createtime;

    private String editby;

    private String edittime;

    private String description;

    private String contactsummary;

    private String nextcontacttime;



    @Override
    public String toString() {
        return "Transaction{" +
                "id='" + id + '\'' +
                ", owner='" + owner + '\'' +
                ", money='" + money + '\'' +
                ", name='" + name + '\'' +
                ", expecteddate='" + expecteddate + '\'' +
                ", customerid='" + customerid + '\'' +
                ", stage='" + stage + '\'' +
                ", type='" + type + '\'' +
                ", source='" + source + '\'' +
                ", activityid='" + activityid + '\'' +
                ", contactsid='" + contactsid + '\'' +
                ", createby='" + createby + '\'' +
                ", createtime='" + createtime + '\'' +
                ", editby='" + editby + '\'' +
                ", edittime='" + edittime + '\'' +
                ", description='" + description + '\'' +
                ", contactsummary='" + contactsummary + '\'' +
                ", nextcontacttime='" + nextcontacttime + '\'' +
                '}';
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getOwner() {
        return owner;
    }

    public void setOwner(String owner) {
        this.owner = owner;
    }

    public String getMoney() {
        return money;
    }

    public void setMoney(String money) {
        this.money = money;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getExpecteddate() {
        return expecteddate;
    }

    public void setExpecteddate(String expecteddate) {
        this.expecteddate = expecteddate;
    }

    public String getCustomerid() {
        return customerid;
    }

    public void setCustomerid(String customerid) {
        this.customerid = customerid;
    }

    public String getStage() {
        return stage;
    }

    public void setStage(String stage) {
        this.stage = stage;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getSource() {
        return source;
    }

    public void setSource(String source) {
        this.source = source;
    }

    public String getActivityid() {
        return activityid;
    }

    public void setActivityid(String activityid) {
        this.activityid = activityid;
    }

    public String getContactsid() {
        return contactsid;
    }

    public void setContactsid(String contactsid) {
        this.contactsid = contactsid;
    }

    public String getCreateby() {
        return createby;
    }

    public void setCreateby(String createby) {
        this.createby = createby;
    }

    public String getCreatetime() {
        return createtime;
    }

    public void setCreatetime(String createtime) {
        this.createtime = createtime;
    }

    public String getEditby() {
        return editby;
    }

    public void setEditby(String editby) {
        this.editby = editby;
    }

    public String getEdittime() {
        return edittime;
    }

    public void setEdittime(String edittime) {
        this.edittime = edittime;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getContactsummary() {
        return contactsummary;
    }

    public void setContactsummary(String contactsummary) {
        this.contactsummary = contactsummary;
    }

    public String getNextcontacttime() {
        return nextcontacttime;
    }

    public void setNextcontacttime(String nextcontacttime) {
        this.nextcontacttime = nextcontacttime;
    }
}