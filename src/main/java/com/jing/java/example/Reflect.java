package com.jing.java.example;

import org.junit.Test;

import java.lang.reflect.Method;
import java.util.HashMap;
import java.util.Map;

public class Reflect {


    @Test
    public void testRe() {

        System.out.println(Integer.toBinaryString(Integer.MAX_VALUE));
        final int MAXIMUM_CAPACITY = 1 << 30;
        int n = 17 - 1;
        n |= n >>> 1;
        n |= n >>> 2;
        n |= n >>> 4;
        n |= n >>> 8;
        n |= n >>> 16;
        System.out.println((n < 0) ? 1 : (n >= MAXIMUM_CAPACITY) ? MAXIMUM_CAPACITY : n + 1);


        try {
            Map<String, String> map = new HashMap<String, String>(4);
            map.put("hahaha", "hollischuang");
            map.put("hahaha2", "hollischuang");
            map.put("hahaha3", "hollischuang");
            map.put("hahaha4", "hollischuang");


            Class<?> mapType = map.getClass();
            Method capacity = mapType.getDeclaredMethod("capacity");
            capacity.setAccessible(true);
            System.out.println("capacity : " + capacity.invoke(map));
        } catch (Exception e) {

        }
    }
}
