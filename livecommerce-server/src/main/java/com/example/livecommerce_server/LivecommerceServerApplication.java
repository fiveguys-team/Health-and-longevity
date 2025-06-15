package com.example.livecommerce_server;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.scheduling.annotation.EnableScheduling;

@EnableScheduling
@SpringBootApplication
public class LivecommerceServerApplication {

	public static void main(String[] args) {
		System.out.println("DB_URL = " + System.getProperty("DB_URL"));
		System.out.println("DB_USERNAME = " + System.getProperty("DB_USERNAME"));
		System.out.println("DB_PASSWORD = " + System.getProperty("DB_PASSWORD"));

		SpringApplication.run(LivecommerceServerApplication.class, args);
	}

}
