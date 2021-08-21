package com.stjomd.railway.endpoint;

import com.stjomd.railway.entity.query.JourneyQuery;
import com.stjomd.railway.service.JourneyService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

@Slf4j
@RestController
@RequestMapping("/journeys")
public class JourneyEndpoint {

    private final JourneyService journeyService;

    @Autowired
    public JourneyEndpoint(JourneyService journeyService) {
        this.journeyService = journeyService;
    }

    @GetMapping()
    @Transactional
    @ResponseBody
    public JourneyQuery journey(JourneyQuery query) {
        journeyService.getJourneys(query);
        return query;
    }

}
