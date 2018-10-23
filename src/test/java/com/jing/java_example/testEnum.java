package com.jing.java_example;
import org.junit.Test;

public class testEnum {
    public enum DRAW_TYPE {
        LOSE(),      // 0 未中奖
        WIN(),   // 1 中奖
        REWARD(),  // 2 中奖且已经领奖
        MAIL_REWARD() // 3 中奖已发邮件

    }
    @Test
    public void testM(){
        System.out.println(DRAW_TYPE.MAIL_REWARD.ordinal());
    }
}
