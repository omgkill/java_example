package com.jing.java.example.test;

import com.google.gson.Gson;
import org.junit.Test;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public class ArraysTest {

    public enum statusEnum{
        no_collect("0"),
        no_reward("1"),
        rewar("2");
        private String status;
        statusEnum(String status) {
            this.status = status;
        }
        public String value() {
            return status;
        }
    }

    @Test
    public void TestArray() {
        String str = "[0,0,0,0]";
        String[] array = str.substring(1, str.length()-1).split(",");

        Gson gson = new Gson();
        String[] my = gson.fromJson(str, String[].class);
        String aaStr = Arrays.toString(my);
        String[] array222 = str.substring(1, str.length()-1).split(",");

        array222[2] = statusEnum.rewar.value();
        System.out.println(Arrays.toString(array222).replace(" ",""));
//        array[2] = statusEnum.rewar.value();
//        System.out.println(Arrays.toString(array));
//        String dd = Arrays.toString(array);
//        String[] array2 = str.substring(1, str.length()-1).split(",");
//        array[2] = statusEnum.no_collect.value();
//        System.out.println(Arrays.toString(array2));

        List<Integer> list = new ArrayList<>();

        int sum= list.stream().mapToInt(s-> s).sum();
        System.out.println(sum);
    }
}
