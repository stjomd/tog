package com.stjomd.railway.service.impl;

import com.stjomd.railway.entity.Halt;
import com.stjomd.railway.repository.HaltRepository;
import com.stjomd.railway.service.HaltService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalTime;
import java.util.List;

@Slf4j
@Service
public class HaltServiceImpl implements HaltService {

    private final HaltRepository haltRepository;

    @Autowired
    public HaltServiceImpl(HaltRepository haltRepository) {
        this.haltRepository = haltRepository;
    }

    public List<Halt> getDepartures(Long stopId, LocalTime afterTime) {
        log.trace("getDepartures({}, {})", stopId, afterTime);
        return haltRepository.findByStopIdAndDepartureGreaterThanEqual(stopId, afterTime);
    }

}
