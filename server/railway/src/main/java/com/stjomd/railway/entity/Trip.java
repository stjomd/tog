package com.stjomd.railway.entity;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
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

    @ManyToOne(cascade = CascadeType.MERGE)
    @JoinColumn(name = "route_id", referencedColumnName = "id", nullable = false)
    private Route route;

    public Trip(Long id, String headsign, String shortName, Route route) {
        this.id = id;
        this.headsign = headsign;
        this.shortName = shortName;
        this.route = route;
    }

}
