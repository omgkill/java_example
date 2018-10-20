package com.jing.java_example;

import java.util.concurrent.ConcurrentHashMap;

public class ConCurrentHashMapExam {


    private ConcurrentHashMap<String, String> concurrentHashMap
            = new ConcurrentHashMap<>();


    public void testRemove(){
        concurrentHashMap.put("abc", "yy");
        Object obj = concurrentHashMap.remove("bvc");
        System.out.println(String.valueOf(obj));

    }
}
