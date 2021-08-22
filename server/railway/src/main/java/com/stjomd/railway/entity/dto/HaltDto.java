package com.stjomd.railway.entity.dto;

import lombok.Data;

import java.time.LocalTime;

@Data
public class HaltDto {

    private Long id;

    private LocalTime arrival;

    private LocalTime departure;

    private StopDto stop;

    private Integer stopSequence;

}
