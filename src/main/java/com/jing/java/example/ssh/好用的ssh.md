 1. 通配符删除redis key -- 重点学会使用xargs
    - redis-cli keys "user*" | xargs redis-cli del
 2. 上面在使用redis-cluster 报错。 可以用这个命令 -- xargs 是个好东西
    -  redis-cli -c -h 10.86.182.123  keys "*battle_league_users*" | xargs -i -t redis-cli -h 10.86.182.101 del {}
          - -i  keys 是好多个，xargs 会把数据转换成一行，也就是 redis-cli -h ... del xxxx xxx xxx. 加上-i 就是一个就是一行
                - 例如redis-cli -h ... del xxxx   redis-cli -h ... del xxxx
          - -t 表示先打印命令，然后再执行。
 3. 示例
    - cat mm.txt | xargs -i -t redis-cli -c -h 10.0.3.190 -p 6383 rpush  tl_ga_116069760410001 {}