package com.stjomd.railway.repository;

import com.stjomd.railway.entity.Route;
import org.springframework.data.jpa.repository.JpaRepository;

public interface RouteRepository extends JpaRepository<Route, Long> {
}
