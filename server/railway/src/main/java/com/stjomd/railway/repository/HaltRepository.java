package com.stjomd.railway.repository;

import com.stjomd.railway.entity.Halt;
import org.springframework.data.jpa.repository.JpaRepository;

import java.time.LocalTime;
import java.util.List;

public interface HaltRepository extends JpaRepository<Halt, Long> {

    List<Halt> findByStopIdAndDepartureGreaterThanEqual(Long stopId, LocalTime departure);

    List<Halt> findByStopIdAndArrivalLessThanEqual(Long stopId, LocalTime arrival);

}
