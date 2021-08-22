package com.stjomd.railway.service;

import com.stjomd.railway.entity.Journey;
import com.stjomd.railway.entity.query.JourneyQuery;

import java.util.List;

public interface JourneyService {

    List<Journey> getJourneys(JourneyQuery query);

}
