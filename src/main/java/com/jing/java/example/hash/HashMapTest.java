package com.jing.java.example.hash;

import org.junit.Test;

import java.util.HashMap;
import java.util.Map;

public class HashMapTest {


    Map<String, String> map = new HashMap<>();
    int num = 64;
    int num2 = -1;
    @Test
    public void testHashMap() {
        System.out.println(num >>> 4);
        System.out.println(num2 >>> 16);
        System.out.println(num2 >>> 4);
        System.out.println(num2 >> 4);
        System.out.println(Integer.toBinaryString(num2));
    }
}
