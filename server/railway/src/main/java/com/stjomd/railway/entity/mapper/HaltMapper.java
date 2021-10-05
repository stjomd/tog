package com.stjomd.railway.entity.mapper;

import com.stjomd.railway.entity.Halt;
import com.stjomd.railway.entity.dto.HaltDto;
import org.mapstruct.Mapper;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.List;

@Mapper
public interface HaltMapper {

    HaltDto toDto(Halt entity);

    List<HaltDto> toDtos(List<Halt> entities);

    default LocalDateTime map(LocalTime value) {
        return LocalDateTime.of(LocalDate.now(), value);
    }

}
