package com.stjomd.railway.entity;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.OneToMany;
import java.util.Set;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
@Entity
public class Trip {

    @Id
    @Column(nullable = false)
    private Long id;

    @Column(nullable = false)
    private String headsign;

    private String shortName;

    @OneToMany(mappedBy = "trip")
    private Set<Halt> halts;

    public Trip(Long id, String headsign, String shortName) {
        this.id = id;
        this.headsign = headsign;
        this.shortName = shortName;
    }

}
