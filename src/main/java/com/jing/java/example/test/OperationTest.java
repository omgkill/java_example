package com.jing.java.example.test;

import org.junit.Test;

public class OperationTest {
    /**
     * 位的操作
     *
     */

    @Test
    public void TestOperation(){

        int initInt = 4;
        //这个其实128/2^4
        System.out.println(128 >> 4);
        //4 * 2^4
        System.out.println(initInt << 4);
    }
}
