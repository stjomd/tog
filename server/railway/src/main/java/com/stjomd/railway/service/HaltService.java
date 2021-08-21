package com.stjomd.railway.service;

import com.stjomd.railway.entity.Halt;

import java.time.LocalTime;
import java.util.List;

public interface HaltService {

    List<Halt> getDepartures(Long stopId, LocalTime afterTime);

}
