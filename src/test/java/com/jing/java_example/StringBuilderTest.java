package com.jing.java_example;

import org.junit.Test;

public class StringBuilderTest {
    StringBuilder sb = new StringBuilder();
    @Test
    public void Test(){
        sb.append("12;2|22;44");
        System.out.println(sb.chars().sum() + "");
        System.out.println(sb.length()+"");
    }
}
