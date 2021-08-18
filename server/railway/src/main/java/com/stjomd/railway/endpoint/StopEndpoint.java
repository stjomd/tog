package com.stjomd.railway.endpoint;

import com.stjomd.railway.service.StopService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/stops")
public class StopEndpoint {

    private static final Logger LOGGER = LoggerFactory.getLogger(StopEndpoint.class);
    private final StopService stopService;

    @Autowired
    public StopEndpoint(StopService stopService) {
        this.stopService = stopService;
    }

    @GetMapping("/hello")
    public String hello() {
        LOGGER.info("GET /hello");
        return "Hello, world!";
    }

}
