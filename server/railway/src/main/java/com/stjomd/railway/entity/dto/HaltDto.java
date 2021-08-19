package com.stjomd.railway.entity.dto;

import com.stjomd.railway.entity.Stop;
import com.stjomd.railway.entity.Trip;
import lombok.Data;

import java.time.LocalTime;

@Data
public class HaltDto {

    private Long id;

    private LocalTime arrival;

    private LocalTime departure;

    private Stop stop;

    private Trip trip;

    private Integer stopSequence;

}
