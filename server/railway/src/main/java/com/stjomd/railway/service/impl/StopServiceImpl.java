package com.stjomd.railway.service.impl;

import com.stjomd.railway.entity.Stop;
import com.stjomd.railway.repository.StopRepository;
import com.stjomd.railway.service.StopService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Service;

import java.util.List;

@Slf4j
@Service
public class StopServiceImpl implements StopService {

    private final StopRepository stopRepository;

    @Autowired
    public StopServiceImpl(StopRepository stopRepository) {
        this.stopRepository = stopRepository;
    }

    @Override
    public List<Stop> getStopsBy(String name) {
        log.trace("getStopsBy({})", name);
        if (name.equals(""))
            return stopRepository.findByNameContainingIgnoreCase("Wien", PageRequest.of(0, 9));
        else
            return stopRepository.findByNameContainingIgnoreCase(name);
    }

}
