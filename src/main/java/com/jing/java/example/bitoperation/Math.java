package com.jing.java.example.bitoperation;

import org.junit.Test;

public class Math {

    private static final int COUNT_BITS = Integer.SIZE - 3;
    // runState is stored in the high-order bits
    private static final int RUNNING    = -1 << COUNT_BITS;
    private static final int SHUTDOWN   =  0 << COUNT_BITS;
    private static final int STOP       =  1 << COUNT_BITS;
    private static final int TIDYING    =  2 << COUNT_BITS;
    private static final int TERMINATED =  3 << COUNT_BITS;


    @Test
    public void testMath() {
        System.out.println(Integer.toBinaryString(-1));
        System.out.println(Integer.toBinaryString(Integer.MAX_VALUE));
        System.out.println(RUNNING);

    }
}
