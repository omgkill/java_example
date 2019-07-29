package com.jing.java.example.test;

import org.junit.Test;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.regex.Pattern;

public class TimeTest {

    /**
     * 测试
     * 把毫秒谁转为时间
     */
    @Test
    public void testTime(){
//        long time1 = 1547099940000L;
//        long time2= System.currentTimeMillis();
//        Date date=new Date(time2);
//        SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
//        String time = sdf.format(date);
//        System.out.println(time);
//        time = time.substring(8, 10) + "d:" + time.substring(11);
//        System.out.println(time);
        //^([0-9]{1,}(;|\|){0,1})+
        Pattern pattern  = Pattern.compile("([0-9]+;?([0-9]+;)[0-9]+[|])+");
        String message = "2255;100;100|2255;100|2255;100|2255;33;444|2255;100";
        if(pattern.matcher(message).matches()) {
            System.out.println("yyyyyyyyyyyyy");
        }
        Map<String, Integer> map = new HashMap<>();
        int aa = 22;
        map.put("1", aa);
        aa = 44;
        System.out.println(map);

    }
}
