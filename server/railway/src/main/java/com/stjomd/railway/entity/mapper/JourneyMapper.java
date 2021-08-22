package com.stjomd.railway.entity.mapper;

import com.stjomd.railway.entity.Journey;
import com.stjomd.railway.entity.dto.JourneyDto;
import org.mapstruct.Mapper;

import java.util.List;

@Mapper
public interface JourneyMapper {

    JourneyDto toDto(Journey entity);

    List<JourneyDto> toDto(List<Journey> entities);

}
