package com.example.frauddetection;

import org.junit.jupiter.api.Test;

import org.springframework.boot.micrometer.tracing.test.autoconfigure.AutoConfigureTracing;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;

@SpringBootTest
@ActiveProfiles("test")
@AutoConfigureTracing
class FraudDetectionApplicationTests {

	@Test
	void contextLoads() {
	}

}
