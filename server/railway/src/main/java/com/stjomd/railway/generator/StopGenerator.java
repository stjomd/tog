package com.stjomd.railway.generator;

import com.stjomd.railway.entity.Stop;
import com.stjomd.railway.generator.util.CSVHandler;
import com.stjomd.railway.repository.StopRepository;

import lombok.extern.slf4j.Slf4j;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Profile;
import org.springframework.stereotype.Component;

import javax.annotation.PostConstruct;

@Slf4j
@Profile("datagen")
@Component
public class StopGenerator {

    private final StopRepository stopRepository;

    @Autowired
    public StopGenerator(StopRepository stopRepository) {
        this.stopRepository = stopRepository;
    }

    @PostConstruct
    private void generate() {
        if (stopRepository.findAll().size() > 0) {
            log.info("Stops have already been generated");
        } else {
            log.info("Generating stops...");
            int count = CSVHandler.forEachRowIn("stops.txt", cells -> {
                Long   id        = Long.valueOf(cells.get("stop_id"));
                String name      = cells.get("stop_name");
                Double latitude  = Double.valueOf(cells.get("stop_lat"));
                Double longitude = Double.valueOf(cells.get("stop_lon"));
                Stop stop = new Stop(id, name, latitude, longitude);
                stopRepository.save(stop);
            });
            log.info("Generated {} stop(s)", count);
        }
    }

}
