package com.geekrose.crm.test;

import com.geekrose.crm.workbench.domain.Contacts;
import com.geekrose.crm.workbench.domain.Transaction;
import com.geekrose.crm.workbench.service.ContactsService;
import com.geekrose.crm.workbench.service.TransactionService;
import org.junit.Test;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import java.util.List;

/**
 * @author Joker_Dong
 * @date 2021-11-27 18:35
 */

public class TranTest {

    @Test
    public void testTranPageList(){

        ApplicationContext context = new ClassPathXmlApplicationContext("applicationContext.xml");
        TransactionService service = context.getBean("transactionService", TransactionService.class);
        Transaction tran = new Transaction();
        tran.setName("直播");
        service.getTranList(tran, "1", "3");

    }

    @Test
    public void testGetContact(){

        ApplicationContext context = new ClassPathXmlApplicationContext("applicationContext.xml");
        ContactsService service = context.getBean("contactsService", ContactsService.class);
        List<Contacts> contacts = service.getContactsByName("王");
        for (Contacts contact : contacts) {
            System.out.println(contact);
        }


    }

    @Test
    public void testGetCusNames(){

        ApplicationContext context = new ClassPathXmlApplicationContext("applicationContext.xml");
        TransactionService service = context.getBean("transactionService", TransactionService.class);
        List<String> names = service.getCustomerName("阿里");
        for (String name : names) {
            System.out.println(name);
        }


    }

}
