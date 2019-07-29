package com.jing.java.example.list;

import com.jing.java.example.model.User;
import org.junit.Test;

import java.util.*;
import java.util.concurrent.CopyOnWriteArrayList;
import java.util.stream.Collectors;

/**
 * 测试并发的时候，可以直接在里面改值就可以了
 * 就是一个改动在另一个方法里面执行
 */
public class TestList {

    /**
     * 测试list只有一个，iterator remove会不会报错
     */
    @Test
    public void testListRemove() {
       // List<String> alList = new CopyOnWriteArrayList<>();
        List<String> alList = new ArrayList<>();

        alList.add("111");
//      //  new Thread(() -> {
            for(int i =1000; i > 0; i--) {
                alList.add(i + "");
            }
            alList.stream().filter(a -> {
                if (a.equals("111")) {
                    alList.sort(Comparator.comparing(l -> l));
                    System.out.println(alList);
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
        System.out.println(alList);
        //empty().stream().sorted();


    }
    // 排序
    @Test
    public void testCompare() {
        List<User> myList = new ArrayList<>();

        for(int i = 50; i > 0; i --) {
            User user = new User();
            user.setUserName(i);
            myList.add(user);
        }
        System.out.println(myList.stream().sorted().map(s -> s.getUserName()).collect(Collectors.toList()));

        Vector<String> vector = new Vector<>();
        vector.add("121321");
        vector.add("333");
        vector.get(1);

        Map<String, Integer> mkap = new HashMap<>();
        mkap.compute("aa", (k,v) -> {
            if (v == null) {
                v = 0;
            }
            v += 3;
            return v;
        });
        System.out.println(mkap.toString());
    }

    private List<String> empty() {
        return null;
    }
}
