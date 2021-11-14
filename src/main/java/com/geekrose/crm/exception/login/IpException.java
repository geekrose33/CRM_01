package com.geekrose.crm.exception.login;

import com.geekrose.crm.settings.vo.Info;

/**
 * @author Joker_Dong
 * @date 2021-11-14 16:52
 */

public class IpException extends LoginException {
    private Info info;
    public IpException(){}
    public IpException(Info info){
        this.info = info;
    }

    public Info getInfo() {
        return info;
    }

    public void setInfo(Info info) {
        this.info = info;
    }
}
