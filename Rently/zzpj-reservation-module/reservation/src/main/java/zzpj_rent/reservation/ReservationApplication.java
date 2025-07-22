package zzpj_rent.reservation;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.client.discovery.EnableDiscoveryClient;
import org.springframework.cloud.openfeign.EnableFeignClients;

@SpringBootApplication
@EnableDiscoveryClient
@EnableFeignClients(basePackages = "zzpj_rent.reservation.microservices")
public class ReservationApplication {

	public static void main(String[] args) {

		SpringApplication.run(ReservationApplication.class, args);
	}

}
