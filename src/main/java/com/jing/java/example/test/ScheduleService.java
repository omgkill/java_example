package com.jing.java.example.test;

import org.junit.Test;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.test.context.SpringBootTest;

import java.util.concurrent.Executor;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.ScheduledThreadPoolExecutor;

public class ScheduleService {
    Logger logger = LoggerFactory.getLogger(ScheduleService.class);

    public static ExecutorService executorService = new ScheduledThreadPoolExecutor(10000);


    public void testCase1() {
        executorService.execute(() -> {
            logger.info(ThreadLocalTest.getInstance().getThreadLocal().get());
        });
    }


    public static void addRunnable(Runnable runnable) {
        executorService.execute(runnable);
    }
}
