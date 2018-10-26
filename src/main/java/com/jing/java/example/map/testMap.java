package com.jing.java.example.map;

import org.junit.Test;

import java.util.HashMap;
import java.util.Map;

public class testMap {


    /**
     * 验证了，拷贝数据通过new HashMap<>(map);
     */
    @Test
    public void testMap(){
        Map<String, String> map = new HashMap<>();
        map.put("1", "2");
        Map<String, String> map2 = new HashMap<>(map);
        map2.put("2","3");
      //  map2.remove("1");
        System.out.println(map2);
        int aa = 2;
        System.out.println(System.currentTimeMillis());
        System.out.println(map2.get(aa +""));
    }
}
