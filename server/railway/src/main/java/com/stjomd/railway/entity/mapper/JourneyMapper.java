package com.stjomd.railway.entity.mapper;

import com.stjomd.railway.entity.Journey;
import com.stjomd.railway.entity.dto.HaltDto;
import com.stjomd.railway.entity.dto.JourneyDto;
import com.stjomd.railway.entity.dto.JourneyLegDto;
import org.mapstruct.Mapper;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.List;

@Mapper
public interface JourneyMapper {

    JourneyDto toDto(Journey entity);

    List<JourneyDto> toDto(List<Journey> entities);

    default LocalDateTime map(LocalTime value) {
        return LocalDateTime.of(LocalDate.now(), value);
    }

    default void fixDates(List<JourneyDto> dtos, LocalDateTime queryDate) {
        for (JourneyDto dto : dtos) {
            for (JourneyLegDto leg : dto.getLegs()) {
                for (HaltDto halt : leg.getHalts()) {
                    LocalDateTime arrival   = LocalDateTime.of(
                        queryDate.toLocalDate(), halt.getArrival().toLocalTime()
                    );
                    LocalDateTime departure = LocalDateTime.of(
                        queryDate.toLocalDate(), halt.getDeparture().toLocalTime()
                    );
                    if (halt.getArrivalNextDay())
                        arrival = arrival.plusDays(1);
                    if (halt.getDepartureNextDay())
                        departure = departure.plusDays(1);
                    halt.setArrival(arrival);
                    halt.setDeparture(departure);
                }
            }
        }
    }

}
