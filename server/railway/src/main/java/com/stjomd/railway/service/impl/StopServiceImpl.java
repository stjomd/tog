package com.stjomd.railway.service.impl;

import com.stjomd.railway.endpoint.StopEndpoint;
import com.stjomd.railway.repository.StopRepository;
import com.stjomd.railway.service.StopService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class StopServiceImpl implements StopService {

    private static final Logger LOGGER = LoggerFactory.getLogger(StopServiceImpl.class);
    private final StopRepository stopRepository;

    @Autowired
    public StopServiceImpl(StopRepository stopRepository) {
        this.stopRepository = stopRepository;
    }

}
