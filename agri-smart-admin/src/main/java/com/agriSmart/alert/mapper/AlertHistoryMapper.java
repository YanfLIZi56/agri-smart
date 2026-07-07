package com.agriSmart.alert.mapper;

import java.util.List;
import com.agriSmart.alert.domain.AlertHistory;

/**
 * 预警历史记录Mapper接口
 * 
 * @author 羊离子
 * @date 2026-04-15
 */
public interface AlertHistoryMapper 
{
    /**
     * 查询预警历史记录
     * 
     * @param id 预警历史记录主键
     * @return 预警历史记录
     */
    public AlertHistory selectAlertHistoryById(Long id);

    /**
     * 查询预警历史记录列表
     * 
     * @param alertHistory 预警历史记录
     * @return 预警历史记录集合
     */
    public List<AlertHistory> selectAlertHistoryList(AlertHistory alertHistory);

    /**
     * 新增预警历史记录
     * 
     * @param alertHistory 预警历史记录
     * @return 结果
     */
    public int insertAlertHistory(AlertHistory alertHistory);

    /**
     * 修改预警历史记录
     * 
     * @param alertHistory 预警历史记录
     * @return 结果
     */
    public int updateAlertHistory(AlertHistory alertHistory);

    /**
     * 删除预警历史记录
     * 
     * @param id 预警历史记录主键
     * @return 结果
     */
    public int deleteAlertHistoryById(Long id);

    /**
     * 批量删除预警历史记录
     * 
     * @param ids 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteAlertHistoryByIds(Long[] ids);

    AlertHistory selectUnrecoveredAlert(Long plotId, Long alertTypeId);

    int selectUnrecoveredAlertsByPlotId(Long plotId);
}
