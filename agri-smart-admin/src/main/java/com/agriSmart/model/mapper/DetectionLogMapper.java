package com.agriSmart.model.mapper;

import java.util.List;
import com.agriSmart.model.domain.DetectionLog;
import com.agriSmart.model.domain.DetectionLogDetail;

/**
 * 检测日志Mapper接口
 * 
 * @author 羊离子
 * @date 2026-04-15
 */
public interface DetectionLogMapper 
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
     * 删除检测日志
     * 
     * @param id 检测日志主键
     * @return 结果
     */
    public int deleteDetectionLogById(Long id);

    /**
     * 批量删除检测日志
     * 
     * @param ids 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteDetectionLogByIds(Long[] ids);

    /**
     * 批量删除检测日志详情
     * 
     * @param ids 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteDetectionLogDetailByLogIds(Long[] ids);
    
    /**
     * 批量新增检测日志详情
     * 
     * @param detectionLogDetailList 检测日志详情列表
     * @return 结果
     */
    public int batchDetectionLogDetail(List<DetectionLogDetail> detectionLogDetailList);
    

    /**
     * 通过检测日志主键删除检测日志详情信息
     * 
     * @param id 检测日志ID
     * @return 结果
     */
    public int deleteDetectionLogDetailByLogId(Long id);
}
