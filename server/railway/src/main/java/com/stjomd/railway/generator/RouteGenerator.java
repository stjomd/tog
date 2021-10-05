package com.stjomd.railway.generator;

import com.stjomd.railway.entity.Route;
import com.stjomd.railway.generator.util.CSVHandler;
import com.stjomd.railway.repository.RouteRepository;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Profile;
import org.springframework.stereotype.Component;

import javax.annotation.PostConstruct;
import java.util.List;

@Slf4j
@Profile("datagen")
@Component
public class RouteGenerator {

    private final RouteRepository routeRepository;

    @Autowired
    public RouteGenerator(RouteRepository routeRepository) {
        this.routeRepository = routeRepository;
    }

    @PostConstruct
    private void generate() {
        if (routeRepository.findAll().size() > 0) {
            log.info("Routes have already been generated");
        } else {
            log.info("Generating routes...");
            int count = CSVHandler.forEachRowIn("routes.txt", cells -> {
                Long id = Long.valueOf(cells.get("route_id"));
                String shortName = cells.get("route_short_name");
                Route route = new Route(id, shortName);
                routeRepository.save(route);
            });
            log.info("Generated {} route(s)", count);
        }
    }

}
