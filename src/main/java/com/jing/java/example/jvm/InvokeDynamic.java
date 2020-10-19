package com.jing.java.example.jvm;

import java.lang.invoke.MethodHandle;
import java.lang.invoke.MethodHandles;
import java.lang.invoke.MethodType;
import java.lang.reflect.Field;

import static java.lang.invoke.MethodHandles.lookup;

public class InvokeDynamic {

    class GradeFather {
        void thinking() {
            System.out.println("i am gradeFather 0-----------------");
        }
    }

    class Father extends  GradeFather {
        void thinking() {
            System.out.println("i am father");
        }
    }


    class Son extends Father {
        void thinking() {
            try {
//                //super.thinking();
//                MethodType mt = MethodType.methodType(void.class);
//                MethodHandle mh = lookup().findSpecial(GradeFather.class, "thinking", mt, getClass());
//                mh.invoke(this);


                try{
                    MethodType mt = MethodType.methodType(void.class);
                    Field IMPL_LOOKUP = MethodHandles.Lookup.class.getDeclaredField("IMPL_LOOKUP");
                    IMPL_LOOKUP.setAccessible(true);
                    MethodHandles.Lookup lkp = (MethodHandles.Lookup)IMPL_LOOKUP.get(null);
                    MethodHandle h1 = lkp.findSpecial(GradeFather.class, "thinking", mt, GradeFather.class);
                    h1.invoke(this);
                }catch(Throwable e){
                    e.printStackTrace();
                }
            } catch (Throwable e) {

            }
        }

    }

    public static void main(String[] args) {
        (new InvokeDynamic().new Son()).thinking();
    }

}
