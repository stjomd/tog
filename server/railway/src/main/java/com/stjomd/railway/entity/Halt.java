package com.stjomd.railway.entity;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import java.time.LocalTime;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Entity
public class Halt {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long id;

    @Column(nullable = false)
    private LocalTime arrival;

    @Column(nullable = false)
    private LocalTime departure;

    @ManyToOne(cascade = CascadeType.MERGE)
    @JoinColumn(name = "stop_id", referencedColumnName = "id", nullable = false)
    private Stop stop;

    @ManyToOne(cascade = CascadeType.MERGE)
    @JoinColumn(name = "trip_id", referencedColumnName = "id", nullable = false)
    private Trip trip;

    private Integer stopSequence;

}
