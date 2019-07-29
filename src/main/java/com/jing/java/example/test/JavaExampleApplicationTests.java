package com.jing.java.example.test;

import com.google.gson.JsonObject;
import com.google.gson.stream.JsonWriter;
import org.junit.Test;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;


public class JavaExampleApplicationTests {

	@Test
	public void contextLoads() {
		Integer a = 1;
		long start = 0;
		long end = 0;
		System.gc();
		start = Runtime.getRuntime().freeMemory();
		Map<String, List<user>> map = new ConcurrentHashMap<>();
		for(int i = 0; i< 2500; i++) {
			String aa = "dfsdfsdfsfsfsdfsfd"+i;
			List<user> users = new ArrayList<>();
			users.add(user.newInstance());
			users.add(user.newInstance());
			users.add(user.newInstance());
			map.put(aa, users);
		}
		System.gc();
		end = Runtime.getRuntime().freeMemory();
		System.out.println("一个HashMap对象占内存:" + (end - start)/1024);

	}

}
