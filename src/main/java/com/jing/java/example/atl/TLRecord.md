#### TL-1.27

 - 解析/验证/发货










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
- 代充处理jira
    - AMS-31030
      【运营】IOS代充方案处理
      
    - AMS-39212 当前玩家的设备ID和注册的设备ID一致，不计入代充
    - AMS-50928 iOS沙盒测试的开关改造，可以指定渠道及版本

- 需要做的功能
    - 参数验证,/密钥验证/请求验证
    - 发货
    - 退款过多封号（监控）
    - 扣除玩家装备
    - 支付前有支付动作
    
- 定一下流程
    - 客户发起支付
    - 玩家下单
    - 苹果回调
    - 客户端回调服务器发货
    - 服务器验证，并发货
    


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
    - 监控支付
        ```
        CREATE TABLE `uid_monitor_device` (
          `uid` varchar(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
          `devices` varchar(1024) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT '' COMMENT '设备Id，逗号分隔,最多60个',
          `pay_times` int(10) NOT NULL DEFAULT '0' COMMENT '付费次数',
          `create_time` bigint(20) DEFAULT '0' COMMENT '记录创建时间',
          `update_time` bigint(20) DEFAULT '0' COMMENT '记录修改时间',
          `devices_history` text COLLATE utf8_unicode_ci COMMENT 'ban设备历史  实际[设备id]',
           PRIMARY KEY (`uid`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci
       ```
