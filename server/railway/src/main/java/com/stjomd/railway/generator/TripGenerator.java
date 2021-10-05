package com.stjomd.railway.generator;

import com.stjomd.railway.entity.Route;
import com.stjomd.railway.entity.Trip;
import com.stjomd.railway.generator.util.CSVHandler;
import com.stjomd.railway.repository.RouteRepository;
import com.stjomd.railway.repository.TripRepository;

import lombok.extern.slf4j.Slf4j;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.DependsOn;
import org.springframework.context.annotation.Profile;
import org.springframework.stereotype.Component;

import javax.annotation.PostConstruct;
import java.util.List;

@Slf4j
@Profile("datagen")
@DependsOn({"routeGenerator"})
@Component
public class TripGenerator {

    private final TripRepository tripRepository;
    private final RouteRepository routeRepository;

    @Autowired
    public TripGenerator(TripRepository tripRepository, RouteRepository routeRepository) {
        this.tripRepository = tripRepository;
        this.routeRepository = routeRepository;
    }

    @PostConstruct
    private void generate() {
        if (tripRepository.findAll().size() > 0) {
            log.info("Trips have already been generated");
        } else {
            log.info("Generating trips...");
            List<Route> routes = routeRepository.findAll();
            int count = CSVHandler.forEachRowIn("trips.txt", cells -> {
                Long   id        = Long.valueOf(cells.get("trip_id"));
                Long   routeId   = Long.valueOf(cells.get("route_id"));
                String headsign  = cells.get("trip_headsign");
                String shortName = cells.get("trip_short_name");
                // Entities
                Route route = routes.stream().filter(r -> r.getId().equals(routeId)).findFirst()
                        .orElse(Route.builder().id(routeId).build());
                Trip trip = new Trip(id, headsign, shortName, route);
                tripRepository.save(trip);
            });
            log.info("Generated {} trip(s)", count);
        }
    }

}
