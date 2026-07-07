package com.agriSmart.monitor.domain.dto;

import java.io.Serializable;

public class JobResDto implements Serializable {
    private static final long serialVersionUID = 1L;
    /**
     * 任务调用远程响应类
     */
    private Integer status;
    private String message;
    private String streamId;
    private String rtspUrl;
    private String webrtcUrl;

    public JobResDto() {
    }

    public Integer getStatus() {
        return status;
    }

    public void setStatus(Integer status) {
        this.status = status;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }


    public String getStreamId() {
        return streamId;
    }

    public void setStreamId(String streamId) {
        this.streamId = streamId;
    }

    public String getRtspUrl() {
        return rtspUrl;
    }

    public void setRtspUrl(String rtspUrl) {
        this.rtspUrl = rtspUrl;
    }

    public String getWebrtcUrl() {
        return webrtcUrl;
    }

    public void setWebrtcUrl(String webrtcUrl) {
        this.webrtcUrl = webrtcUrl;
    }
}
