package com.stjomd.railway.generator;

import com.stjomd.railway.entity.Halt;
import com.stjomd.railway.entity.Stop;
import com.stjomd.railway.entity.Trip;
import com.stjomd.railway.generator.util.CSVHandler;
import com.stjomd.railway.repository.HaltRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.DependsOn;
import org.springframework.context.annotation.Profile;
import org.springframework.stereotype.Component;

import javax.annotation.PostConstruct;
import java.time.LocalTime;
import java.util.Arrays;

@Profile("datagen")
@DependsOn({"stopGenerator", "tripGenerator"})
@Component
public class HaltGenerator {

    private static final Logger LOGGER = LoggerFactory.getLogger(StopGenerator.class);
    private final HaltRepository haltRepository;

    @Autowired
    public HaltGenerator(HaltRepository haltRepository) {
        this.haltRepository = haltRepository;
    }

    @PostConstruct
    private void generate() {
        if (haltRepository.findAll().size() > 0) {
            LOGGER.info("Halts have already been generated");
        } else {
            LOGGER.info("Generating halts...");
            int count = CSVHandler.forEachRowIn("stop_times.txt", cells -> {
                LocalTime arrival = null, departure = null;
                boolean arrivalNextDay = false, departureNextDay = false;
                // Time handling
                String arr = cells.get("arrival_time"), dep = cells.get("departure_time");
                int arrHours = Integer.parseInt(arr.substring(0, 2));
                int depHours = Integer.parseInt(dep.substring(0, 2));
                if (arrHours >= 0 && arrHours < 24) {
                    arrival = LocalTime.parse(arr);
                } else if (arrHours < 48) {
                    arrival = LocalTime.parse("00" + arr.substring(2));
                    arrivalNextDay = true;
                }
                if (depHours >= 0 && depHours < 24) {
                    departure = LocalTime.parse(dep);
                } else if (depHours < 48) {
                    departure = LocalTime.parse("00" + dep.substring(2));
                    departureNextDay = true;
                }
                // Parsing
                Long    stopId    = Long.valueOf(cells.get("stop_id"));
                Long    tripId    = Long.valueOf(cells.get("trip_id"));
                Integer sequence  = Integer.valueOf(cells.get("stop_sequence"));
                // Entities
                Stop stop = Stop.builder().id(stopId).build();
                Trip trip = Trip.builder().id(tripId).build();
                Halt halt = new Halt(null, arrival, arrivalNextDay, departure, departureNextDay,
                                     stop, trip, sequence);
                haltRepository.save(halt);
            });
            LOGGER.info("Generated {} halt(s)", count);
        }
    }

}
