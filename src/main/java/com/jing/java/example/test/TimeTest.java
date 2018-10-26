package com.jing.java.example.test;

import org.junit.Test;

import java.text.SimpleDateFormat;
import java.util.Date;

public class TimeTest {

    /**
     * 测试
     * 把毫秒谁转为时间
     */
    @Test
    public void testTime(){
        long time = 1539141037355L;
        Date date=new Date(time);
        SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
        System.out.println(sdf.format(date));

    }
}
