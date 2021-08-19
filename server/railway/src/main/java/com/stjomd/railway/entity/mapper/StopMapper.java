package com.stjomd.railway.entity.mapper;

import com.stjomd.railway.entity.Stop;
import com.stjomd.railway.entity.dto.StopDto;
import org.mapstruct.Mapper;

import java.util.Set;

@Mapper
public interface StopMapper {

    Stop toEntity(StopDto dto);

    StopDto toDto(Stop entity);

    Set<StopDto> toDto(Set<Stop> entities);

}
