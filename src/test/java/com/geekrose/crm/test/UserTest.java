package com.geekrose.crm.test;

import com.geekrose.crm.utils.DateTimeUtil;
import com.geekrose.crm.utils.MD5Util;
import org.junit.Test;

import java.text.SimpleDateFormat;
import java.util.Date;

/**
 * @author Joker_Dong
 * @date 2021-11-13 22:29
 */

public class UserTest {
    @Test
    public void testLogin(){


    }
    // 失效时间
    @Test
    public void testExpireDate(){
        Date date = new Date();
        System.out.println(date);
        // Sat Nov 13 22:37:43 CST 2021

        // 将当前时间按照指定格式进行输出
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        String dateFormat = sdf.format(date);
        System.out.println(dateFormat);
        // 2021-11-13 22:37:43

        // 获取当前系统时间 （使用工具包）
        String currentTime = DateTimeUtil.getSysTime();
        System.out.println(currentTime);
        // 2021-11-13 22:41:29

        String expireTime = "2012-11-13 22:41:29";
        int i = expireTime.compareTo(currentTime);
        // i > 0 -> expireTime > currentTime 未失效
        // i < 0 -> expireTime < expireTime 失效
        System.out.println(i);


    }
    @Test
    public void testLock(){
        String lockState = "0";
        // 字符串写前面 不会空指针
        if ("0".equals(lockState)){
            System.out.println("账号已锁定");
        }else {
            System.out.println("pass");
        }
    }
    @Test
    public void testIps(){
        String ip = "192.168.1.10";
        String allIps = "192.168.1.10,192.168.5.21";
        if (allIps.contains(ip)){
            System.out.println("有效的ip");
        }else {
            System.out.println("无效的ip");
        }
    }

    @Test
    public void testMD5(){
        String pwd = "123";
        pwd = MD5Util.getMD5(pwd);
        System.out.println(pwd);
        // 202cb962ac59075b964b07152d234b70
    }

}
