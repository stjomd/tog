package com.stjomd.railway.endpoint;

import com.stjomd.railway.entity.dto.StopDto;
import com.stjomd.railway.entity.mapper.StopMapper;
import com.stjomd.railway.service.StopService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import java.util.Set;

@Slf4j
@RestController
@RequestMapping("/stops")
public class StopEndpoint {

    private final StopService stopService;
    private final StopMapper  stopMapper;

    @Autowired
    public StopEndpoint(StopService stopService, StopMapper stopMapper) {
        this.stopService = stopService;
        this.stopMapper  = stopMapper;
    }

    @GetMapping
    @ResponseBody
    public Set<StopDto> hello(@RequestParam String name) {
        log.info("GET /stops?name={}", name);
        return stopMapper.toDto(stopService.getStopsBy(name));
    }

}
