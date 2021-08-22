package com.stjomd.railway.entity.mapper;

import com.stjomd.railway.entity.JourneyLeg;
import com.stjomd.railway.entity.dto.JourneyLegDto;
import org.mapstruct.Mapper;

import java.util.List;

@Mapper
public interface JourneyLegMapper {

    JourneyLegDto toDto(JourneyLeg entity);

    List<JourneyLegDto> toDto(List<JourneyLeg> entities);

}
