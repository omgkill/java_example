package com.jing.java.example.set;

import com.jing.java.example.model.User;
import com.jing.java.example.model.UserLuckyLottoScore;
import org.junit.Test;
import org.springframework.boot.autoconfigure.security.SecurityProperties;

import java.util.*;
import java.util.stream.Collectors;


public class TestSet {


    SortedSet<UserLuckyLottoScore> set = Collections.synchronizedSortedSet(new TreeSet<>());

    @Test
    public void test() {
        List<UserLuckyLottoScore> orList = new ArrayList<>();
        Map<String, UserLuckyLottoScore> map = new HashMap<>();
        for (int i = 0; i< 20; i++) {
            UserLuckyLottoScore s = new UserLuckyLottoScore();
            s.setType(i);
            orList.add(s);
            map.put("" + i, s);
        }

        Collections.sort(orList);
        for(UserLuckyLottoScore us : orList) {
            set.add(us);
        }

        UserLuckyLottoScore score = map.get(1 +"");
        score.setType(2222);
        set.add(score);
        System.out.println(set);


    }


    /**
     * 测一个stream set 会不会有null
     */
    @Test
    public void testStreamSet() {
        Map<String, String> myMap = new HashMap<>();
        myMap.put("1", "2222");
        List<String> myList = new ArrayList<>();
        myList.add("1");
        myList.add("222");
        myList.add("222");
        myList.add("222");
        myList.add("222");myList.add("222");myList.add("222");myList.add("222");myList.add("222");
        Set<String> mySet = myList.stream().map(m -> myMap.get(m)).collect(Collectors.toSet());
        mySet.remove(null);
        System.out.println(mySet);
    }
    @Test
    public void testSort() {
        List<User> list = new ArrayList<>();
        User user = new User();
        user.setUserName(324234);
        User user1 = new User();
        user1.setUserName(111);
        list.add(user);
        list.add(user1);
        list.sort(Comparator.comparing(User::getUserName));
        System.out.println(list.get(1).getUserName());

        String message = String.format("user buy discount exchange over times, uid:%s, exchangeId:%s, times:%d", "333", "333444", 1);
        System.out.println(message);
    }



}
