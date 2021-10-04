package com.stjomd.railway.entity.mapper;

import com.stjomd.railway.entity.JourneyLeg;
import com.stjomd.railway.entity.dto.JourneyLegDto;
import com.stjomd.railway.entity.query.JourneyQuery;
import org.mapstruct.Mapper;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.List;

@Mapper
public interface JourneyLegMapper {

    JourneyLegDto toDto(JourneyLeg entity, JourneyQuery query);

    List<JourneyLegDto> toDto(List<JourneyLeg> entities);

    default LocalDateTime map(LocalTime value) {
        return LocalDateTime.of(LocalDate.now(), value);
    }

}
