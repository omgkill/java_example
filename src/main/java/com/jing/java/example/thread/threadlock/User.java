package com.jing.java.example.thread.threadlock;

import com.jing.java.example.test.ScheduleService;

import java.util.concurrent.locks.Condition;
import java.util.concurrent.locks.ReentrantLock;

public class User {



    public volatile String name = "initial";

    ReentrantLock reentrantLock = new ReentrantLock();

    public  String getName() throws InterruptedException {
        try {
            reentrantLock.lock();
            Thread.sleep(1000);
            return name;
        } finally {
            reentrantLock.unlock();
        }


    }

    public  void setName(String name) throws InterruptedException {
        Condition condition = reentrantLock.newCondition();
        Thread.sleep(1000);
        this.name = name;
        reentrantLock.unlock();
    }


    public static void main(String[] args) {
        User user = new User();


    for(int i = 0; i < 100; i ++) {
        String m = String.valueOf(i);
        ScheduleService.addRunnable(() -> {
//            long old = System.currentTimeMillis();
            try {
                user.setName(m);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
            System.out.println("set " + m);
//            System.out.println(System.currentTimeMillis() - old);

        });
    }


        for(int i = 0; i < 100; i ++) {
            ScheduleService.addRunnable(() -> {
                try {
                    System.out.println("get" + user.getName());
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }

            });
        }

//        ScheduleService.executorService.shutdown();
    }
}
