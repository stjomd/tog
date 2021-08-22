package com.stjomd.railway.entity.mapper;

import com.stjomd.railway.entity.Halt;
import com.stjomd.railway.entity.dto.HaltDto;
import org.mapstruct.Mapper;

import java.util.List;

@Mapper
public interface HaltMapper {

    HaltDto toDto(Halt entity);

    List<HaltDto> toDto(List<Halt> entities);

}
