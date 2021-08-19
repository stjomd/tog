package com.stjomd.railway.repository;

import com.stjomd.railway.entity.Stop;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface StopRepository extends JpaRepository<Stop, Long> {

    List<Stop> findByNameContainingIgnoreCase(String name);

    List<Stop> findByNameContainingIgnoreCase(String name, Pageable page);

}
