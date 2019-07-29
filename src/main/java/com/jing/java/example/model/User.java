package com.jing.java.example.model;

public class User implements Comparable<User>{

    private Integer userName;

    public Integer getUserName() {
        return userName;
    }

    public void setUserName(Integer userName) {
        this.userName = userName;
    }


    @Override
    public int compareTo(User o) {
        return Long.compare(o.getUserName(), o.getUserName());
    }
}
