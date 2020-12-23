#### TL-1.27
 - 请求流程
   -  线程锁
   -  解析参数
      - 白名单
      - 解密
      - 验证了金额
       - 兑换码
       
   - 验证参数
      - 给的一个字符串，和自己用key加密的字符串，判断是否一致
   - 订单是否已存在
   - 更新支付数据
    
- 要哪些数据库表
    - 历史记录数据
    - payRequest请求
        ```
      CREATE TABLE `pay_request` (
          `uid` varchar(40) COLLATE utf8_unicode_ci NOT NULL,
          `pf` varchar(20) COLLATE utf8_unicode_ci NOT NULL,
          `time` bigint(20) NOT NULL,
          `purchaseId` varchar(10) COLLATE utf8_unicode_ci DEFAULT '',
          `productId` varchar(10) COLLATE utf8_unicode_ci DEFAULT '',
          `status` int(4) DEFAULT '0',
          `finishTime` bigint(20) DEFAULT '0',
           PRIMARY KEY (`uid`,`pf`,`time`),
           KEY `index_uid_pf_productId` (`uid`,`pf`,`purchaseId`),
           KEY `index_uid_pf_purchaseId` (`uid`,`pf`,`purchaseId`)
       ) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci
       ```
    - 订单数据,global db
      ```
        CREATE TABLE `exchange` (
          `orderId` varchar(200) COLLATE utf8_unicode_ci NOT NULL,
          `pf` varchar(20) COLLATE utf8_unicode_ci NOT NULL,
          PRIMARY KEY (`pf`,`orderId`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci
      ```
    - 支付失败/支付log
        ```
            CREATE TABLE `paylog` (
              `uid` varchar(40) COLLATE utf8_unicode_ci NOT NULL,
              `orderId` varchar(200) COLLATE utf8_unicode_ci NOT NULL,
              `pf` varchar(20) COLLATE utf8_unicode_ci NOT NULL,
              `productId` varchar(10) COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
              `orderInfo` varchar(200) COLLATE utf8_unicode_ci DEFAULT NULL,
              `orderParam` blob,
              `order_items` varchar(500) COLLATE utf8_unicode_ci DEFAULT '{}' COMMENT '订单获得的物品',
              `purchase_token` varchar(200) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT '订单token',
              `sku` varchar(10) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT '订单sku',
              `time` bigint(20) DEFAULT NULL,
              `currency` int(10) DEFAULT '0',
              `spend` double(10,2) NOT NULL DEFAULT '0.00',
              `paid` double(10,2) DEFAULT '0.00',
              `status` int(4) DEFAULT '0',
              `payLevel` int(10) NOT NULL,
              `buildingLv` int(11) DEFAULT NULL,
              `receiverId` varchar(40) COLLATE utf8_unicode_ci DEFAULT NULL,
              `deviceId` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
              `ip` varchar(20) COLLATE utf8_unicode_ci DEFAULT '',
              `type` int(10) NOT NULL DEFAULT '0' COMMENT '用户类型,衮服,重玩,新用户',
              `vipLevel` int(10) NOT NULL DEFAULT '0' COMMENT '支付时候的VIP等级',
              PRIMARY KEY (`uid`,`orderId`,`pf`),
              KEY `index_time_pf` (`time`,`pf`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci  
        
        ```
