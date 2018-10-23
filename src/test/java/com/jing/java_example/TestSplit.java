package com.jing.java_example;

import org.junit.Test;

public class TestSplit {

    @Test
    public void testSplit(){
        String ss="2432423|||";
        String[] ar = ss.split(",");
        System.out.println(ar[0]);
     }
}
