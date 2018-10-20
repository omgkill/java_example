package com.jing.java_example;

import org.junit.Test;

import java.util.concurrent.ConcurrentHashMap;

public class ConCurrentHashMapExam extends  JavaExampleApplicationTests{


    private ConcurrentHashMap<String, String> concurrentHashMap
            = new ConcurrentHashMap<>();

    @Test
    public void testRemove() {
        concurrentHashMap.put("abc", "yy");
        Object obj = concurrentHashMap.remove("bvc");
        System.out.println(String.valueOf(obj));
        System.out.println(concurrentHashMap.toString());
    }
}
