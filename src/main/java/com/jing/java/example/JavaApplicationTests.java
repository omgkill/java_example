package com.jing.java.example;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.junit4.SpringRunner;

import javax.annotation.Resource;
import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.ScheduledFuture;

@RunWith(SpringRunner.class)
@SpringBootTest
public class JavaApplicationTests {

//    @Resource
//    UserLuckyLottoScoreMapper userLuckyLottoScoreMapper;

    Logger logger = LoggerFactory.getLogger(JavaApplicationTests.class);

//    ExecutorService executorService = new ScheduledThreadPoolExecutor(10000);

    @Test
    public void testCase1() {

//        executorService.execute(() -> {
//            try {
//                Thread.sleep(100000000);
//            } catch (Exception e) {
//
//            }
//            System.out.println("3333333333333333");
//        });
//
//        logger.error("333333333333333333");
//        System.out.println("3333333333333333");
//        while(!executorService.isShutdown()) {
//            try {
//                executorService.awaitTermination(100, TimeUnit.MINUTES);
//
//            } catch (Exception e) {
//
//            }
//        }
    }

    @Test
    public void contextLoads() {


        System.out.println(2 | 1);
        System.out.println(3 & 1);
//        for (int i = 0; i < 1000; i++) {
//            UserLuckyLottoScore userInfo = new UserLuckyLottoScore();
//            userInfo.setType(1);
//            userInfo.setCreateTime(0L);
//            userInfo.setUid("" + i);
//            userInfo.setRoundId("1");
//            userInfo.setDrawInfo("11111");
//            userLuckyLottoScoreMapper.insert(userInfo);
//        }

//
//        String aa = "101551\n" +
//                "101553\n" +
//                "101555\n" +
//                "101557\n" +
//                "101559\n" +
//                "101561\n" +
//                "101563\n" +
//                "101565\n" +
//                "101567\n" +
//                "101569\n" +
//                "101571\n" +
//                "101573\n" +
//                "101575\n" +
//                "101577\n" +
//                "101579\n" +
//                "101581\n" +
//                "101583\n" +
//                "101585\n" +
//                "101587\n" +
//                "101589\n" +
//                "101591\n" +
//                "101593\n" +
//                "101595\n" +
//                "101597\n" +
//                "101599\n" +
//                "101601\n" +
//                "101603\n" +
//                "101605\n" +
//                "101607\n" +
//                "101609\n" +
//                "101611\n" +
//                "101613\n" +
//                "101615\n" +
//                "101617\n" +
//                "101619\n" +
//                "101621\n" +
//                "101623\n" +
//                "700295\n" +
//                "700786\n" +
//                "2000000\n" +
//                "2000003\n" +
//                "2000006\n" +
//                "2000009\n" +
//                "200000\n" +
//                "200001\n" +
//                "200002\n" +
//                "200003\n" +
//                "200004\n" +
//                "200005\n" +
//                "200006\n" +
//                "200007\n" +
//                "200008\n" +
//                "200009\n" +
//                "200010\n" +
//                "200011\n" +
//                "200012\n" +
//                "200013\n" +
//                "200014\n" +
//                "200015\n" +
//                "200016\n" +
//                "200017\n" +
//                "200018\n" +
//                "200019\n" +
//                "200020\n" +
//                "200021\n" +
//                "200022";
//
//        aa = aa.replaceAll("\n", "|");
//        aa = aa.replaceAll(" ", "");
//        System.out.println(aa);
    }


    public void testInsert(String id) {
//        userLuckyLottoScoreMapper.deleteByPrimaryKey(id, "1");
//        UserLuckyLottoScore userInfo = new UserLuckyLottoScore();
//        userInfo.setType(1);
//        userInfo.setCreateTime(0L);
//        userInfo.setUid(id);
//        userInfo.setRoundId("1");
//        userInfo.setDrawInfo("11111");
//        userLuckyLottoScoreMapper.insert(userInfo);



    }



//
//    public void testInsert(String id) {
//        userLuckyLottoScoreMapper.deleteByPrimaryKey(id, "1");
//        UserLuckyLottoScore userInfo = new UserLuckyLottoScore();
//        userInfo.setType(1);
//        userInfo.setCreateTime(0L);
//        userInfo.setUid(id);
//        userInfo.setRoundId("1");
//        userInfo.setDrawInfo("11111");
//        userLuckyLottoScoreMapper.insert(userInfo);
//    }



}
