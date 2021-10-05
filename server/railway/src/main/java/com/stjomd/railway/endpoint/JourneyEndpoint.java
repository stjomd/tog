package com.stjomd.railway.endpoint;

import com.stjomd.railway.entity.dto.JourneyDto;
import com.stjomd.railway.entity.mapper.JourneyMapper;
import com.stjomd.railway.entity.query.JourneyQuery;
import com.stjomd.railway.service.JourneyService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@Slf4j
@RestController
@RequestMapping("/journeys")
public class JourneyEndpoint {

    private final JourneyService journeyService;
    private final JourneyMapper journeyMapper;

    @Autowired
    public JourneyEndpoint(JourneyService journeyService, JourneyMapper journeyMapper) {
        this.journeyService = journeyService;
        this.journeyMapper = journeyMapper;
    }

    @GetMapping()
    @Transactional
    @ResponseBody
    public List<JourneyDto> journey(JourneyQuery query) {
        log.info("GET /journeys?{}", query);
        List<JourneyDto> dtos = journeyMapper.toDto(journeyService.getJourneys(query));
        journeyMapper.fixDates(dtos, query.getDate());
        return dtos;
    }

}
