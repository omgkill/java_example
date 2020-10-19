package com.jing.java.example.test;

import com.sun.org.apache.xerces.internal.xs.datatypes.ObjectList;
import org.junit.Test;

import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.atomic.AtomicInteger;


/**
 * T 与 ？ 区别
 * 1. 都可以可以继承，可以超累，限制参数类型
 * 2. 可以作为方法返回值。而? 不可以， ？就是超类
 * 3. T可以作为一个参数，跑来跑去，而？ 只能用object来处理，  T 更能确定类型
 * 3. ？ 什么类型都可以接受, 如果是list<?>, 什么类型都可以加。而T只能加T
 * 4. T，如果是方法，必须确保，参数是T类型,有泛型 T
 * 5.T 必须在方法级/或类级，声明T类型, 而 ？ 不需要声明
 * 6. 类声明 T， 可以使用？代替
 */
public class TestGeneric <T> {




    private <T> Object  getValue(List<T> list) {
        return list.get(0);
    }

    private <T> String getValue1(List<T> list) {
        Object t = list.get(0);
        if (null == t) {
            return "";
        }
        return null;
    }

    /**
     * 1. <T> 是和参数的泛型使用的
     */

    public interface  mm {

    }

    public class  m1 implements mm {

    }

    public  void test() {
        TestGeneric testGeneric = new TestGeneric();
        List<T> list1 ;
        testGeneric.getValue(new ArrayList<Object>());

//        AtomicInteger

//        list1 = new ArrayList<m1>();
//        list1 = new ArrayList<T>();
    }

    @Test
    public void testFor() {
        int j = 1;
        for(int i = j; i < 10; j = i, i +=1) {
            System.out.println(j + "");
        }
        int a = 1;
        for (; a < 10; a++) {
            System.out.println(a + "");
        }
    }

}
