package com.stjomd.railway.repository;

import com.stjomd.railway.entity.Halt;
import org.springframework.data.jpa.repository.JpaRepository;

public interface HaltRepository extends JpaRepository<Halt, Long> {
}
