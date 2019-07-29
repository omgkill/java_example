package com.jing.java.example.map;

import com.sun.xml.internal.ws.util.StringUtils;
import org.junit.Test;

import java.sql.SQLOutput;
import java.util.*;
import java.util.stream.Collectors;

public class testMap {


    /**
     * 验证了，拷贝数据通过new HashMap<>(map);
     */
    @Test
    public void testMapTest(){
//        Map<String, String> map = new HashMap<>();
//        map.put("1", "2");
//        Map<String, String> map2 = new HashMap<>(map);
//        map2.put("2","3");
//      //  map2.remove("1");
//        System.out.println(map2);
//        int aa = 2;
//        System.out.println(System.currentTimeMillis());
//        System.out.println(map2.get(aa +""));

        Map<String, String>  map = new LinkedHashMap<>();
        map.put("0", "4");

        map.put("922223", "111");
        map.put("2","1");
        map.put("3", "6");
        map.put("1", "2");
        int index = 0;
        for(Map.Entry entry : map.entrySet()) {

            if(index == 4) {
                System.out.println(entry.getValue());

            }
            index++;
        }
        List<String> list =  new ArrayList<>(map.values());
        test(list);
        list = null;
      //  System.out.println(list);

        String str = null;
        list.forEach(
                e->{
                    throw new NullPointerException();
                }
        );

    }

    public void test(List<String> list) {
        list.removeIf(t -> t.equals("2"));
    }
}
