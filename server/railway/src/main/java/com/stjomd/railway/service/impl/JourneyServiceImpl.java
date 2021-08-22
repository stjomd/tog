package com.stjomd.railway.service.impl;

import com.stjomd.railway.entity.Halt;
import com.stjomd.railway.entity.Journey;
import com.stjomd.railway.entity.JourneyLeg;
import com.stjomd.railway.entity.Trip;
import com.stjomd.railway.entity.query.JourneyQuery;
import com.stjomd.railway.service.HaltService;
import com.stjomd.railway.service.JourneyService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
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
    public List<Journey> getJourneys(JourneyQuery query) {
        log.trace("getJourneys({})", query);
        List<Halt> relevantHalts;
        List<Journey> journeys = new ArrayList<>();
        if (query.getDateMode() == JourneyQuery.DateMode.DEPARTURE) {
            relevantHalts = haltService.getDepartures(query.getOriginId(), query.getDate().toLocalTime());
            for (Halt rh : relevantHalts) {
                Trip trip = rh.getTrip();
                List<Halt> sortedTripHalts = trip.getHalts().stream()
                        .sorted(Comparator.comparing(Halt::getStopSequence))
                        .collect(Collectors.toList());
                // Halts are sorted by sequence - in order as halts occur in real life in this trip.
                // Build journey leg: iterate over sorted halts and look for origin stop first. After that point, add
                // halts to the leg until destination stop. If destination stop is found before origin stop, this trip
                // is moving in the opposite direction - discard it.
                List<Halt> leg = new ArrayList<>();
                boolean isWriting = false;
                for (Halt currentHalt : sortedTripHalts) {
                    if (!isWriting) {
                        if (currentHalt.getStop().getId().equals(query.getOriginId())) {
                            // Found origin stop, start writing to leg
                            isWriting = true;
                            leg.add(currentHalt);
                        } else if (currentHalt.getStop().getId().equals(query.getDestinationId())) {
                            // Trip is moving in the opposite direction, discard
                            break;
                        }
                    } else {
                        leg.add(currentHalt);
                        if (currentHalt.getStop().getId().equals(query.getDestinationId())) {
                            // Reached destination
                            break;
                        }
                    }
                }
                // Check if last added halt in the leg is at destination
                if (leg.size() > 0) {
                    Long lastStopId = leg.get(leg.size() - 1).getStop().getId();
                    if (!lastStopId.equals(query.getDestinationId()))
                        continue;
                } else {
                    // Empty leg
                    continue;
                }
                // Successfully found a journey, proceed
                List<JourneyLeg> journeyLegs = new ArrayList<>();
                journeyLegs.add(new JourneyLeg(leg, trip));
                Journey journey = new Journey(journeyLegs, 1L);
                journeys.add(journey);
            }
        } else {
            // TODO
        }
        return journeys;
    }

}
