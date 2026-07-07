package com.agriSmart.model.domain;

import java.util.List;
import java.util.Date;
import com.fasterxml.jackson.annotation.JsonFormat;
import org.apache.commons.lang3.builder.ToStringBuilder;
import org.apache.commons.lang3.builder.ToStringStyle;
import com.agriSmart.common.annotation.Excel;
import com.agriSmart.common.core.domain.BaseEntity;

/**
 * 检测日志对象 detection_log
 * 
 * @author 羊离子
 * @date 2026-04-15
 */
public class DetectionLog extends BaseEntity
{
    private static final long serialVersionUID = 1L;

    /** ID */
    @Excel(name = "ID")
    private Long id;

    /** 检测类型 */
    @Excel(name = "检测类型")
    private Integer logType;

    /** 检测类型 */
    @Excel(name = "检测类型")
    private Integer detectType;

    /** 操作用户ID（sys_user.user_id） */
    private Long userId;

    @Excel(name = "操作用户")
    private String userName;

    /** 使用的模型关联ID（model_config.id） */
    private Long modelConfigId;

    private Boolean modelConfigIsDel;

    private Boolean modelConfigIsActive;

    @Excel(name = "使用的模型")
    private String modelName;

    @Excel(name = "模型版本")
    private String modelVersion;

    /** 结果（带标注）存储路径 */
    private String resultImagePath;

    private String originImagePath;

    /** 推理耗时（毫秒） */
    @Excel(name = "推理耗时", readConverterExp = "毫=秒")
    private Long durationMs;

    /** 检测到的目标总数 */
    @Excel(name = "检测到的目标总数")
    private Long totalTargets;

    /** 用户反馈 */
    @Excel(name = "用户反馈")
    private Integer feedbackStatus;

    /** 不准确时的原因文本 */
    @Excel(name = "不准确时的原因文本")
    private String feedbackText;

    /** 反馈提交时间 */
    @JsonFormat(pattern = "yyyy-MM-dd")
    @Excel(name = "反馈提交时间", width = 30, dateFormat = "yyyy-MM-dd")
    private Date feedbackTime;

    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    @Excel(name = "=检测时间", width = 30, dateFormat = "yyyy-MM-dd HH:mm:ss")
    private Date detectTime;

    /** 密度数据（JSON格式） */
    private String densityJson;

    /** 检测日志详情信息 */
    private List<DetectionLogDetail> detectionLogDetailList;


    public Date getDetectTime() {
        return detectTime;
    }

    public void setDetectTime(Date detectTime) {
        this.detectTime = detectTime;
    }

    public void setId(Long id) 
    {
        this.id = id;
    }

    public Long getId() 
    {
        return id;
    }

    public void setLogType(Integer logType) 
    {
        this.logType = logType;
    }

    public Integer getLogType() 
    {
        return logType;
    }

    public void setDetectType(Integer detectType) 
    {
        this.detectType = detectType;
    }

    public Integer getDetectType() 
    {
        return detectType;
    }

    public void setUserId(Long userId) 
    {
        this.userId = userId;
    }

    public Long getUserId() 
    {
        return userId;
    }

    public void setModelConfigId(Long modelConfigId)
    {
        this.modelConfigId = modelConfigId;
    }

    public Long getModelConfigId()
    {
        return modelConfigId;
    }

    public void setResultImagePath(String resultImagePath) 
    {
        this.resultImagePath = resultImagePath;
    }

    public String getResultImagePath() 
    {
        return resultImagePath;
    }

    public void setDurationMs(Long durationMs) 
    {
        this.durationMs = durationMs;
    }

    public Long getDurationMs() 
    {
        return durationMs;
    }

    public void setTotalTargets(Long totalTargets) 
    {
        this.totalTargets = totalTargets;
    }

    public Long getTotalTargets() 
    {
        return totalTargets;
    }

    public void setFeedbackStatus(Integer feedbackStatus) 
    {
        this.feedbackStatus = feedbackStatus;
    }

    public Integer getFeedbackStatus() 
    {
        return feedbackStatus;
    }

    public void setFeedbackText(String feedbackText) 
    {
        this.feedbackText = feedbackText;
    }

    public String getFeedbackText() 
    {
        return feedbackText;
    }

    public void setFeedbackTime(Date feedbackTime) 
    {
        this.feedbackTime = feedbackTime;
    }

    public Date getFeedbackTime() 
    {
        return feedbackTime;
    }

    public void setDensityJson(String densityJson) 
    {
        this.densityJson = densityJson;
    }

    public String getDensityJson() 
    {
        return densityJson;
    }

    public List<DetectionLogDetail> getDetectionLogDetailList()
    {
        return detectionLogDetailList;
    }

    public void setDetectionLogDetailList(List<DetectionLogDetail> detectionLogDetailList)
    {
        this.detectionLogDetailList = detectionLogDetailList;
    }

    @Override
    public String toString() {
        return "DetectionLog{" +
                "id=" + id +
                ", logType=" + logType +
                ", detectType=" + detectType +
                ", userId=" + userId +
                ", userName='" + userName + '\'' +
                ", modelConfigId='" + modelConfigId + '\'' +
                ", modelConfigIsDel=" + modelConfigIsDel +
                ", modelConfigIsActive=" + modelConfigIsActive +
                ", modelName='" + modelName + '\'' +
                ", modelVersion='" + modelVersion + '\'' +
                ", resultImagePath='" + resultImagePath + '\'' +
                ", durationMs=" + durationMs +
                ", totalTargets=" + totalTargets +
                ", feedbackStatus=" + feedbackStatus +
                ", feedbackText='" + feedbackText + '\'' +
                ", feedbackTime=" + feedbackTime +
                ", detectTime=" + detectTime +
                ", densityJson='" + densityJson + '\'' +
                ", detectionLogDetailList=" + detectionLogDetailList +
                '}';
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public Boolean getModelConfigIsDel() {
        return modelConfigIsDel;
    }

    public void setModelConfigIsDel(Boolean modelConfigIsDel) {
        this.modelConfigIsDel = modelConfigIsDel;
    }

    public Boolean getModelConfigIsActive() {
        return modelConfigIsActive;
    }

    public void setModelConfigIsActive(Boolean modelConfigIsActive) {
        this.modelConfigIsActive = modelConfigIsActive;
    }

    public String getModelName() {
        return modelName;
    }

    public void setModelName(String modelName) {
        this.modelName = modelName;
    }

    public String getModelVersion() {
        return modelVersion;
    }

    public void setModelVersion(String modelVersion) {
        this.modelVersion = modelVersion;
    }

    public String getOriginImagePath() {
        return originImagePath;
    }

    public void setOriginImagePath(String originImagePath) {
        this.originImagePath = originImagePath;
    }
}
