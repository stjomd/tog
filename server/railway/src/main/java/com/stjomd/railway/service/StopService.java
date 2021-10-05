package com.stjomd.railway.service;

import com.stjomd.railway.entity.Stop;

import java.util.List;

public interface StopService {

    /**
     * Retrieves stops that match <code>name</code>.
     *
     * @param name the query to perform search against. Case is ignored.
     * @return a set of matching stops.
     */
    List<Stop> getStopsBy(String name);

}
