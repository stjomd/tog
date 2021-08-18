package com.stjomd.railway.generator;

import com.stjomd.railway.entity.Trip;
import com.stjomd.railway.generator.util.CSVHandler;
import com.stjomd.railway.repository.TripRepository;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Profile;
import org.springframework.stereotype.Component;

import javax.annotation.PostConstruct;

@Profile("datagen")
@Component
public class TripGenerator {

    private static final Logger LOGGER = LoggerFactory.getLogger(StopGenerator.class);
    private final TripRepository tripRepository;

    @Autowired
    public TripGenerator(TripRepository tripRepository) {
        this.tripRepository = tripRepository;
    }

    @PostConstruct
    private void generate() {
        if (tripRepository.findAll().size() > 0) {
            LOGGER.info("Trips have already been generated");
        } else {
            LOGGER.info("Generating trips...");
            int count = CSVHandler.forEachRowIn("trips.txt", cells -> {
                Long   id        = Long.valueOf(cells.get("trip_id"));
                String headsign  = cells.get("trip_headsign");
                String shortName = cells.get("trip_short_name");
                Trip trip = new Trip(id, headsign, shortName);
                tripRepository.save(trip);
            });
            LOGGER.info("Generated {} trip(s)", count);
        }
    }

}
