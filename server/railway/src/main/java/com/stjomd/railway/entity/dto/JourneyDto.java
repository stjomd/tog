package com.stjomd.railway.entity.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.List;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class JourneyDto {

    private List<JourneyLegDto> legs;

    private Integer passengers;

    private Long price;

}
