package com.stjomd.railway.entity.mapper;

import com.stjomd.railway.entity.Route;
import com.stjomd.railway.entity.dto.RouteDto;
import org.mapstruct.Mapper;

@Mapper
public interface RouteMapper {

    RouteDto toDto(Route entity);

}
