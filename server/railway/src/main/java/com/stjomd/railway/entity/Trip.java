package com.stjomd.railway.entity;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Entity
public class Trip {

    @Id
    @Column(nullable = false)
    private Long id;

    @Column(nullable = false)
    private String headsign;

    @Column(nullable = true)
    private String shortName;

}
