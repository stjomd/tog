package com.stjomd.railway.repository;

import com.stjomd.railway.entity.Stop;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Set;

public interface StopRepository extends JpaRepository<Stop, Long> {

    Set<Stop> findByNameContainingIgnoreCase(String name);

}
