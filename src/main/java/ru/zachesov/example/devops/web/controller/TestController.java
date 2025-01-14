package ru.zachesov.example.devops.web.controller;

import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@Slf4j
@RequestMapping("/test")
@RestController
public class TestController {

  @Value("${test}")
  private String test;

  @GetMapping("/hello")
  public ResponseEntity<String> getTest() {
    log.info("hello");
    return ResponseEntity.ok("Hello world, test!!!!!!!!!!!!!!!!!!!!!!");
  }
}
