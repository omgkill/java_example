package com.jing.java.example.test;

import com.jing.java.example.model.User;
import com.jing.java.example.model.UserTask;
import sun.net.www.protocol.file.FileURLConnection;

import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.Callable;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.Future;

public class FutureTest {


    public static void main(String[] args) throws Exception {
        ExecutorService threadPool = Executors.newFixedThreadPool(22);
//        FutureTest futureTest = new FutureTest();
//        System.out.println(futureTest.getClass().getClassLoader());
//        int aa = 0;
        List<Future> list = new ArrayList<>();
//        Map<String, User> map = new HashMap<>();
        User user =  new User();
//        String key = "pp";
//        SimpleTask task = new SimpleTask(3_000); // task 需要运行 3 秒
        Future future = null;
        for (int i = 0; i < 1; i++) {
            int a = i - i;
            String key = String.valueOf(a);
            threadPool.execute(() -> {
                try {
                    Thread.sleep(1000);
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
//                UserTask userTask = user.getTask(kk);
//                userTask.getUid();
                user.add(key);
            });
            threadPool.execute(() -> {
                try {
                    Thread.sleep(1000);
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
//                UserTask userTask = user.getTask(kk);
//                userTask.getUid();
                user.add(key);
            });
            future = threadPool.submit(() -> {
                System.out.println("1111111111111111");

                try {
                    Thread.sleep(1000);
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
                list.get(0).cancel(true);
                for (int r = 1000; r < 1000000000 ; r++) {
                    System.out.println(String.valueOf(r));
                }

                user.add(key);
            });
            list.add(future);
        }

        threadPool.shutdown();
//        future.cancel(true);
//        if (future.isCancelled()) {
//            System.out.println("2222222222222222");
//        }

////        future.cancel(true);
        Thread.sleep(5000L);
        System.out.println("任务运行时间");

    }



    private static final class SimpleTask implements Callable<Double> {

        private final int sleepTime; // ms

        public SimpleTask(int sleepTime) {
            this.sleepTime = sleepTime;
        }

        @Override
        public Double call() throws Exception {
            double begin = System.nanoTime();

            Thread.sleep(sleepTime);

            double end = System.nanoTime();
            double time = (end - begin) / 1E9;

            return time; // 返回任务运行的时间，以 秒 计
        }

    }
}