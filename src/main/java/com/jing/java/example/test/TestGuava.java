package com.jing.java.example.test;

import com.google.common.cache.*;

import java.util.concurrent.TimeUnit;

public class TestGuava {
    //build方法中可以指定CacheLoader，在缓存不存在时通过CacheLoader的实现自动加载缓存
    // 当本地缓存命没有中时，调用load方法获取结果并将结果缓存　
    LoadingCache<String, String> cache = CacheBuilder.newBuilder()
            //refreshAfterWrite(3, TimeUnit.HOURS)// 给定时间内没有被读/写访问，则回收。
            .concurrencyLevel(8)
            //设置写缓存后8秒钟过期
            .expireAfterWrite(8, TimeUnit.SECONDS)
            //设置缓存容器的初始容量为10
            .initialCapacity(10)
            //设置缓存最大容量为100，超过100之后就会按照LRU最近虽少使用算法来移除缓存项
            .maximumSize(100)
            //设置要统计缓存的命中率
            .recordStats()
            //设置缓存的移除通知
            .removalListener(new RemovalListener<Object, Object>() {
                @Override
                public void onRemoval(RemovalNotification<Object, Object> notification) {
                    System.out.println(notification.getKey() + " was removed, cause is " + notification.getCause());
                }
            })
            .build(

                    new CacheLoader<String, String>() {
                        @Override
                        public String load(String key) throws Exception {
                            return "";
                        }
                    }
            );

    public void testGet() {
        try {
            cache.get("dd");
        } catch (Exception e) {

        }
    }
}
