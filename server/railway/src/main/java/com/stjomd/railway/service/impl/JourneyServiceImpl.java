package com.stjomd.railway.service.impl;

import com.stjomd.railway.entity.Halt;
import com.stjomd.railway.entity.Trip;
import com.stjomd.railway.entity.query.JourneyQuery;
import com.stjomd.railway.service.HaltService;
import com.stjomd.railway.service.JourneyService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

@Slf4j
@Service
public class JourneyServiceImpl implements JourneyService {

    private final HaltService haltService;

    @Autowired
    public JourneyServiceImpl(HaltService haltService) {
        this.haltService = haltService;
    }

    @Override
    public void getJourneys(JourneyQuery query) {
        log.trace("getJourneys({})", query);
        List<Halt> relevantHalts = null;
        if (query.getDateMode() == JourneyQuery.DateMode.DEPARTURE) {
            relevantHalts = haltService.getDepartures(query.getOriginId(), query.getDate().toLocalTime());
            Set<Trip> allTrips = relevantHalts.stream().map(Halt::getTrip).collect(Collectors.toSet());
            Set<Trip> relevantTrips = new HashSet<>();
            for (Trip t : allTrips) {
                for (Halt h : t.getHalts()) {
                    if (h.getStop().getId().equals(query.getDestinationId()))
                        relevantTrips.add(t);
                }
            }
            // relevantTrips contains trips that halt at origin after specified time
            // TODO: check if these trips also halt at destination (take sequence into account)
        } else {
            // getArrivals
        }
    }

}
