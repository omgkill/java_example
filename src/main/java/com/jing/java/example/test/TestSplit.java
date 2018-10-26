package com.jing.java.example.test;

import org.junit.Test;

import java.util.Arrays;

public class TestSplit {

    /**
     * 测试组合字符串加入"|"，是否需要加入转义字符"\\|"。
     * 结果，不需要。而且这样通过str.split("\\|")错误。解析成   a a \ b b
     * 但是解析时需要加入转义字符"\\|",不然解析的结果和split("")是一样的
     */
    private static final String LINE = "\\|";
    @Test
    public void testLine(){
        String str = "aa"+LINE +"bb";
        String[] arr = str.split(LINE);
        System.out.println(Arrays.toString(arr));
    }
}
