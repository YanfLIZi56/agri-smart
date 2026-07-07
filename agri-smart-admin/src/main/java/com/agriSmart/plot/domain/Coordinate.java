package com.agriSmart.plot.domain;

import java.math.BigDecimal;

/**
 * @author 羊离子
 */
public class Coordinate {

    private Integer id;
    private Long plotId;
    private BigDecimal lng;
    private BigDecimal lat;

    public Coordinate() {
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public BigDecimal getLng() {
        return lng;
    }

    public void setLng(BigDecimal lng) {
        this.lng = lng;
    }

    public BigDecimal getLat() {
        return lat;
    }

    public void setLat(BigDecimal lat) {
        this.lat = lat;
    }

    public Long getPlotId() {
        return plotId;
    }

    public void setPlotId(Long plotId) {
        this.plotId = plotId;
    }

    @Override
    public String toString() {
        return "Coordinate{" +
                "id=" + id +
                ", plotId=" + plotId +
                ", lng=" + lng +
                ", lat=" + lat +
                '}';
    }
}
