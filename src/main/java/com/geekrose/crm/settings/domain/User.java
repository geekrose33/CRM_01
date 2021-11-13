package com.geekrose.crm.settings.domain;

public class User {

    /*
        关乎登录
        验证账号和密码
        select count(*) from tbl_user where LoginAct=? and LoginPwd = ?
        查询记录为0 表示没查到
        查询记录为1 表示符合
        查询记录大于1 有垃圾数据
        执行sql语句 返回 User对象
            如果User对象为空：账号密码错误
            如果不为空：只能说明账号密码正确 需要继续向下验证字段信息
            从User中get expireTime 验证失效时间 lockState 锁定状态 allowips 验证浏览器端的ip地址是否有效
    */

    private String id; // 主键

    private String loginact; // 登录账号

    private String name; // 用户真实姓名

    private String loginpwd; // 登录密码

    private String email; // 邮箱

    /*
        关于字符串中表现的日期及时间
        我们在市场上常用的有两种方式
        日期：年月日
            yyyy-MM-dd 10位字符串 使用char 固定十位
        日期 + 时间：年月日时分秒
            yyyy-MM-dd HH:mm:ss 19位字符串
    */

    private String expiretime; // 失效时间 日期 + 时间 组成

    private String lockstate; // 锁定状态 0 表示锁定 1 表示启用

    private String deptno; // 部门编号

    private String allowips; // 允许访问的ip地址

    private String createtime; // 创建时间

    private String createby; // 创建人

    private String edittime; // 修改时间

    private String editby; // 修改人

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getLoginact() {
        return loginact;
    }

    public void setLoginact(String loginact) {
        this.loginact = loginact;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getLoginpwd() {
        return loginpwd;
    }

    public void setLoginpwd(String loginpwd) {
        this.loginpwd = loginpwd;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getExpiretime() {
        return expiretime;
    }

    public void setExpiretime(String expiretime) {
        this.expiretime = expiretime;
    }

    public String getLockstate() {
        return lockstate;
    }

    public void setLockstate(String lockstate) {
        this.lockstate = lockstate;
    }

    public String getDeptno() {
        return deptno;
    }

    public void setDeptno(String deptno) {
        this.deptno = deptno;
    }

    public String getAllowips() {
        return allowips;
    }

    public void setAllowips(String allowips) {
        this.allowips = allowips;
    }

    public String getCreatetime() {
        return createtime;
    }

    public void setCreatetime(String createtime) {
        this.createtime = createtime;
    }

    public String getCreateby() {
        return createby;
    }

    public void setCreateby(String createby) {
        this.createby = createby;
    }

    public String getEdittime() {
        return edittime;
    }

    public void setEdittime(String edittime) {
        this.edittime = edittime;
    }

    public String getEditby() {
        return editby;
    }

    public void setEditby(String editby) {
        this.editby = editby;
    }
}