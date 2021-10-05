package com.stjomd.railway.entity.dto;

import lombok.Data;

@Data
public class TripDto {

    private Long id;

    private String headsign;

    private String shortName;

    private RouteDto route;

}
