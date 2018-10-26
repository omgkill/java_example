package com.jing.java.example.test;

import com.jing.java.example.model.UserLuckyLottoScore;
import org.junit.Test;

import java.util.LinkedHashMap;
import java.util.Map;

public class testReference {
    /**
     * 如果是对象的set
     * 其实是引用的地址，必须new对象
     */

    @Test
    public void testReference() {
        UserLuckyLottoScore userLuckyLottoScore = new UserLuckyLottoScore();
        userLuckyLottoScore.setCreateTime(1000L);
        Map<String, UserLuckyLottoScore> map = new LinkedHashMap<>();
        map.put("aa", userLuckyLottoScore);
        userLuckyLottoScore.setCreateTime(3000L);
        map.put("bb", userLuckyLottoScore);
        System.out.println(Long.toString(map.get("aa").getCreateTime()));

    }

    @Test
    public void test(){
        int myaa  = 1 ^ 4;
        System.out.println(myaa);
    }
}
