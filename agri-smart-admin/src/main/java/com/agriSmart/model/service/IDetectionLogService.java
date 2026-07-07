package com.agriSmart.model.service;

import java.util.List;
import com.agriSmart.model.domain.DetectionLog;

/**
 * 检测日志Service接口
 * 
 * @author 羊离子
 * @date 2026-04-15
 */
public interface IDetectionLogService 
{
    /**
     * 查询检测日志
     * 
     * @param id 检测日志主键
     * @return 检测日志
     */
    public DetectionLog selectDetectionLogById(Long id);

    /**
     * 查询检测日志列表
     * 
     * @param detectionLog 检测日志
     * @return 检测日志集合
     */
    public List<DetectionLog> selectDetectionLogList(DetectionLog detectionLog);

    /**
     * 新增检测日志
     * 
     * @param detectionLog 检测日志
     * @return 结果
     */
    public int insertDetectionLog(DetectionLog detectionLog);

    /**
     * 修改检测日志
     * 
     * @param detectionLog 检测日志
     * @return 结果
     */
    public int updateDetectionLog(DetectionLog detectionLog);

    /**
     * 批量删除检测日志
     * 
     * @param ids 需要删除的检测日志主键集合
     * @return 结果
     */
    public int deleteDetectionLogByIds(Long[] ids);

    /**
     * 删除检测日志信息
     * 
     * @param id 检测日志主键
     * @return 结果
     */
    public int deleteDetectionLogById(Long id);
}
