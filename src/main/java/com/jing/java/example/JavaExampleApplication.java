package com.jing.java.example;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.EnableAutoConfiguration;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.jdbc.DataSourceAutoConfiguration;



@SpringBootApplication
public class JavaExampleApplication {

	public static void main(String[] args) {
		SpringApplication.run(JavaExampleApplication.class, args);
	}
}
