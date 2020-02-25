package com.jing.java.example.test;

public class ThreadLocalTest {



    public static ThreadLocalTest getInstance(){
        return new ThreadLocalTest();
    }

    public ThreadLocal<String> getThreadLocal() {
        ThreadLocal<String> threadLocal = ThreadLocal.withInitial(() -> {
            return "333";
        });

        return threadLocal;
    }
}
