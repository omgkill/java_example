package com.jing.java_example;

import org.junit.Test;

import java.util.Arrays;

public class TestLine {

    String LINE = ";";
    @Test
    public void testLine(){
        String str = "aa"+LINE +"bb";
        String[] arr = str.split("");
        System.out.println(Arrays.toString(arr));
    }
}
