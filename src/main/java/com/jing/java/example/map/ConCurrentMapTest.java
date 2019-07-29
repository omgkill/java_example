package com.jing.java.example.map;

import org.junit.Test;

import java.util.concurrent.ConcurrentHashMap;

public class ConCurrentMapTest {


    /**
     * 测试当concurrentHashMap没有key，然后用remove会不会报错
     * 结果：不会报错
     */
    private ConcurrentHashMap<String, String> concurrentHashMap
            = new ConcurrentHashMap<>();

    @Test
    public void testRemove() {
        concurrentHashMap.put("abc", "yy");
        Object obj = concurrentHashMap.remove("bvc");
        System.out.println(String.valueOf(obj));
        System.out.println(concurrentHashMap.toString());

        String aa = concurrentHashMap.putIfAbsent("abc", "ddd");
        System.out.println(aa);
        System.out.println(concurrentHashMap.get("abc"));
    }
}
