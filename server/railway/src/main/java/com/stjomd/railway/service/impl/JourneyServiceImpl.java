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
import java.util.Collections;
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

        // Get all halts at the relevant stop
        if (query.getDateMode() == JourneyQuery.DateMode.DEPARTURE) {
            relevantHalts = haltService.getDepartures(query.getOriginId(), query.getDate().toLocalTime());
        } else {
            relevantHalts = haltService.getArrivals(query.getDestinationId(), query.getDate().toLocalTime());
        }

        // Check these halts' trips
        for (Halt haltCandidate : relevantHalts) {
            Trip trip = haltCandidate.getTrip();
            List<Halt> sortedTripHalts = trip.getHalts().stream()
                    .sorted(Comparator.comparing(Halt::getStopSequence))
                    .collect(Collectors.toList());
            // Halts sorted in the same order as they occur in the trip. Iterate over, save the part between
            // origin and destination. If destination occurs before origin, discard this candidate (opposite direction).
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
            // Successfully found a journey, add leg
            List<JourneyLeg> journeyLegs = new ArrayList<>();
            journeyLegs.add(new JourneyLeg(leg, trip));
            // Add to journeys
            int last = leg.size() - 1;
            Long price = price(
                    leg.get(0).getStop().getLatitude(), leg.get(0).getStop().getLongitude(),
                    leg.get(last).getStop().getLatitude(), leg.get(last).getStop().getLongitude()
            );
            Journey journey = new Journey(journeyLegs, query.getPassengers(), price * query.getPassengers());
            journeys.add(journey);
        }

        // Sort by time
        if (query.getDateMode() == JourneyQuery.DateMode.DEPARTURE) {
            journeys.sort(Comparator.comparing(a -> a.getLegs().get(0).getHalts().get(0).getDeparture()));
        } else {
            journeys.sort(Comparator.comparing(a -> a.getLegs().get(0).getHalts().get(0).getArrival()));
            Collections.reverse(journeys);
        }

        // Take limit into account
        if (query.getLimit() == null) {
            return journeys;
        } else {
            List<Journey> cutJourneys = new ArrayList<>();
            for (int i = 0; i < query.getLimit() && i < journeys.size(); i++) {
                cutJourneys.add(journeys.get(i));
            }
            return cutJourneys;
        }
    }

    private Long price(Double x1, Double y1, Double x2, Double y2) {
        log.trace("price({}, {}, {}, {})", x1, y1, x2, y2);
        return (long) (Math.sqrt((x1-x2)*(x1-x2) + (y1-y2)*(y1-y2)) * 100 * 13.5);
    }

}
