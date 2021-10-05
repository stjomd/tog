package com.stjomd.railway.entity.mapper;

import com.stjomd.railway.entity.Trip;
import com.stjomd.railway.entity.dto.TripDto;
import org.mapstruct.Mapper;

@Mapper
public interface TripMapper {

    TripDto toDto(Trip entity);

}
