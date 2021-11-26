package com.geekrose.crm.test;

import com.geekrose.crm.workbench.domain.Activity;
import com.geekrose.crm.workbench.domain.Clue;
import com.geekrose.crm.workbench.service.ClueService;
import org.junit.Test;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import java.util.List;

/**
 * @author Joker_Dong
 * @date 2021-11-24 0:13
 */

public class ClueTest {
    @Test
    public void testClueSelect(){
        ApplicationContext context = new ClassPathXmlApplicationContext("applicationContext.xml");
        ClueService service = context.getBean("clueService", ClueService.class);
        Clue clue = new Clue();
        clue.setFullname("马云");
        List<Clue> clues = service.getClues("1", "5", clue);
        for (Clue cl:clues){
            System.out.println(cl);
        }

    }
    @Test
    public void testEditInfo(){
        ApplicationContext context = new ClassPathXmlApplicationContext("applicationContext.xml");
        ClueService clueService = context.getBean("clueService", ClueService.class);
        clueService.deleteClue("d25afa8878724352b06fc537c0b80fb1");


    }

    @Test
    public void testGetActsByClueId(){
//        323bf3c7627b4247877bd3de4c797867
        ApplicationContext context = new ClassPathXmlApplicationContext("applicationContext.xml");
        ClueService clueService = context.getBean("clueService", ClueService.class);
        List<Activity> activities = clueService.getActListByName("抖音");
        for (Activity activity : activities) {
            System.out.println(activity);
        }

    }
    }


