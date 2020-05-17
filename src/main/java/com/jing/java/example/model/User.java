package com.jing.java.example.model;

import java.util.HashMap;
import java.util.Map;

public class User implements Comparable<User>{

    private Integer userName;
    private String uid;
    private String sex;

    private Map<String, UserTask> map = new HashMap<>();


    public String getUid() {
        return uid;
    }

    public void setUid(String uid) {
        this.uid = uid;
    }

    public String getSex() {
        return sex;
    }

    public void setSex(String sex) {
        this.sex = sex;
    }

    public Integer getUserName() {
        return userName;
    }

    public void setUserName(Integer userName) {
        this.userName = userName;
    }


    public  UserTask getTask(String key) {
        String uid = key + "---";
        synchronized (uid) {
            if (!map.containsKey(key)) {
                Map<String, UserTask> newMap = new HashMap<>(map);
                UserTask userTask = new UserTask();
                newMap.put(key, userTask);
                map = newMap;
            }
            return map.get(key);
        }
    }

    int aa = 0;

    public void  add(String dd) {
            synchronized (dd.intern()) {
            aa++;
            System.out.println(aa + "-" + dd);
        }
    }

    @Override
    public int compareTo(User o) {
        return Long.compare(o.getUserName(), o.getUserName());
    }
}
