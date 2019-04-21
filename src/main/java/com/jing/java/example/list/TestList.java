package com.jing.java.example.list;

import org.junit.Test;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.Iterator;
import java.util.List;
import java.util.stream.Collectors;

public class TestList {

    /**
     * 测试list只有一个，iterator remove会不会报错
     */
    @Test
    public void testListRemove() {
        List<String> alList = new ArrayList<>();
        alList.add("111");
//      //  new Thread(() -> {
            for(int i =1000; i > 0; i--) {
                alList.add(i + "");
            }
            alList.stream().filter(a -> {
                if (a.equals("111")) {
                     alList.sort(Comparator.comparing(l -> l));
                    //alList.remove("11");
                    return true;
                }
                return false;
            }).collect(Collectors.toList());
//            for (String i : alList){
//                if (i.equals("11")) {
//                   // alList.sort(Comparator.comparing(l -> l));
//                    alList.remove("11");
//                }
//            }
//      //  }).start();
//        new Thread(() -> {
//
//            alList.sort(Comparator.comparing(s ->s));
//        });
//        //alList.sort(Comparator.comparing(s ->s));
//
//        try {
//            Thread.sleep(5000);
//        } catch (InterruptedException e) {
//            e.printStackTrace();
//        }
//        alList.remove(100);
//        System.out.println(alList);
        //empty().stream().sorted();
    }

    private List<String> empty() {
        return null;
    }
}
