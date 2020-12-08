package com.jing.java.example.thread;

import org.checkerframework.checker.units.qual.C;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.lang.management.*;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.Semaphore;
import java.util.concurrent.atomic.AtomicInteger;

public class TestSemaphore {


    private static ExecutorService exec = Executors.newCachedThreadPool();

    private static Semaphore semaphore = new Semaphore(1);
    private static Set<Integer> set = new HashSet<>(10);
    private static CountDownLatch countDownLatch = new CountDownLatch(1);
    private static AtomicInteger num = new AtomicInteger();
    private static final Logger logger = LoggerFactory.getLogger(TestSemaphore.class);

    public static void addValue(int value) {
        boolean isAdd = false;
        try {
            System.out.println(num.incrementAndGet() + "--");;
            if (num.get() == 2785) {
                printJvmInfo();
            }
            countDownLatch.await();
            semaphore.acquire();
            isAdd = set.add(value);
            Thread.sleep(1000L);

        } catch (InterruptedException e) {
            e.printStackTrace();
        } finally {
//            if (!isAdd) {
//                semaphore.release();
//            } else {
//                System.out.println("add" + set.toString());
//            }
            System.out.println("add" + set.toString());
            semaphore.release();
        }

    }

    public static void removeValue() {
        if (set.remove(1)) {
            System.out.println("remove" + set.toString());
            semaphore.release();

        }
    }

    public static void main(String[] args) {
        for(int i =0; i < 10000; i++) {
            int a = i;
            exec.execute(() -> {
                addValue(a);
            });
//            exec.execute(() -> {
//                removeValue();
//            });
        }

        try {
            Thread.sleep(5000);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        countDownLatch.countDown();

        exec.shutdown();
    }

    public static void printJvmInfo() {
        MemoryMXBean memoryMXBean = ManagementFactory.getMemoryMXBean();
        MemoryUsage usage = memoryMXBean.getHeapMemoryUsage();
        System.out.println("INT HEAP:" + usage.getInit()/1024/1024 + "Mb");
        System.out.println("MAX HEAP:" + usage.getMax()/1024/1024 + "Mb");
        System.out.println("USED HEAP:" + usage.getUsed()/1024/1024 + "Mb");

        System.out.println("\nFull Information:");
        System.out.println("Heap Memory Usage:" + memoryMXBean.getHeapMemoryUsage());
        System.out.println("Non-Heap Memory Usage:" + memoryMXBean.getNonHeapMemoryUsage());

        List<String> inputArguments = ManagementFactory.getRuntimeMXBean().getInputArguments();
        System.out.println("=====================java options==================");
        System.out.println(inputArguments);

        System.out.println("=====================通过java来获取相关系统状态====================");
        long i = Runtime.getRuntime().totalMemory()/1024/1024;//Java 虚拟机中的内存总量，以字节为单位
        System.out.println("总的内存量为:" + i + "Mb");
        long j = Runtime.getRuntime().freeMemory()/1024/1024;//Java 虚拟机中的空闲内存量
        System.out.println("空闲内存量:" + j + "Mb");
        long k = Runtime.getRuntime().maxMemory()/1024/1024;
        System.out.println("最大可用内存量:" + k + "Mb");

        System.out.println("\nFull Information:");
        System.out.println("Heap Memory Usage:" + memoryMXBean.getHeapMemoryUsage().getUsed() / 1024/1024);
        System.out.println("Non-Heap Memory Usage:" + memoryMXBean.getNonHeapMemoryUsage().getUsed() / 1024/ 1024);


        // 获取所有内存池MXBean列表，并遍历
        List<MemoryPoolMXBean> memoryPoolMXBeans = ManagementFactory.getMemoryPoolMXBeans();
        for (MemoryPoolMXBean memoryPoolMXBean : memoryPoolMXBeans) {
            // 内存分区名
            String name = memoryPoolMXBean.getName();
            // 内存管理器名称
            String[] memoryManagerNames = memoryPoolMXBean.getMemoryManagerNames();
            // 内存分区类型
            MemoryType type = memoryPoolMXBean.getType();
            // 内存使用情况
            MemoryUsage usage2 = memoryPoolMXBean.getUsage();
            // 内存使用峰值情况
            MemoryUsage peakUsage = memoryPoolMXBean.getPeakUsage();
            // 打印
            logger.info(name + ":");
            logger.info("    managers: {}", memoryManagerNames);
            logger.info("    type: {}", type.toString());
            logger.info("    usage: {}", usage2.toString());
            logger.info("    peakUsage: {}", peakUsage.toString());
            logger.info("");
        }
    }
}
