package com.jing.java.example.test;

import org.junit.Test;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

public class TestDateformat extends JavaApplicationTests {


    @Test
    public void testDateFormat() {
        SimpleDateFormat sp = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        try {
            Date date = sp.parse("2018-08-01 23:59:00");
            long datee = date.getTime();
            System.out.println("------------------------");
            System.out.println(datee);
            System.out.println("------------------------");
            System.out.println(System.currentTimeMillis());

            String formatDate = sp.format(datee);
            System.out.println(formatDate);
        } catch (ParseException e) {
            e.printStackTrace();
        }
    }
}
