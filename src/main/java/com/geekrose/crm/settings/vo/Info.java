package com.geekrose.crm.settings.vo;

/**
 * @author Joker_Dong
 * @date 2021-11-14 21:52
 */

public class Info {
    // 用于返回给前端登录页面
    private boolean success;
    private String msg;

    @Override
    public String toString() {
        return "Info{" +
                "success=" + success +
                ", msg='" + msg + '\'' +
                '}';
    }

    public Info(boolean success, String msg) {
        this.success = success;
        this.msg = msg;
    }

    public Info() {
    }

    public boolean isSuccess() {
        return success;
    }

    public void setSuccess(boolean success) {
        this.success = success;
    }

    public String getMsg() {
        return msg;
    }

    public void setMsg(String msg) {
        this.msg = msg;
    }
}
