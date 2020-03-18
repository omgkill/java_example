package com.jing.java.example.test.collection;

import org.junit.Test;

import java.util.Collections;
import java.util.Map;

public class TestMap {


    @Test
    public void testEmptyMap() {
        Map<String, String> map = Collections.emptyMap();
        map.clear();
    }
}
