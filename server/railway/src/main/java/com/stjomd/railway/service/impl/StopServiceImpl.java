package com.stjomd.railway.service.impl;

import com.stjomd.railway.entity.Stop;
import com.stjomd.railway.repository.StopRepository;
import com.stjomd.railway.service.StopService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Set;

@Slf4j
@Service
public class StopServiceImpl implements StopService {

    private final StopRepository stopRepository;

    @Autowired
    public StopServiceImpl(StopRepository stopRepository) {
        this.stopRepository = stopRepository;
    }

    @Override
    public Set<Stop> getStopsBy(String name) {
        log.trace("getStopsBy({})", name);
        return stopRepository.findByNameContainingIgnoreCase(name);
    }

}
