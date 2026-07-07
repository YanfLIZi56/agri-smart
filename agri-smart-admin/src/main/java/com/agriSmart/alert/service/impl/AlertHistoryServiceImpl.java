package com.agriSmart.alert.service.impl;

import java.util.List;
import com.agriSmart.common.utils.DateUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.agriSmart.alert.mapper.AlertHistoryMapper;
import com.agriSmart.alert.domain.AlertHistory;
import com.agriSmart.alert.service.IAlertHistoryService;

/**
 * 预警历史记录Service业务层处理
 * 
 * @author 羊离子
 * @date 2026-04-15
 */
@Service
public class AlertHistoryServiceImpl implements IAlertHistoryService 
{
    @Autowired
    private AlertHistoryMapper alertHistoryMapper;

    /**
     * 查询预警历史记录
     * 
     * @param id 预警历史记录主键
     * @return 预警历史记录
     */
    @Override
    public AlertHistory selectAlertHistoryById(Long id)
    {
        return alertHistoryMapper.selectAlertHistoryById(id);
    }

    /**
     * 查询预警历史记录列表
     * 
     * @param alertHistory 预警历史记录
     * @return 预警历史记录
     */
    @Override
    public List<AlertHistory> selectAlertHistoryList(AlertHistory alertHistory)
    {
        return alertHistoryMapper.selectAlertHistoryList(alertHistory);
    }

    /**
     * 新增预警历史记录
     * 
     * @param alertHistory 预警历史记录
     * @return 结果
     */
    @Override
    public int insertAlertHistory(AlertHistory alertHistory)
    {
        return alertHistoryMapper.insertAlertHistory(alertHistory);
    }

    /**
     * 修改预警历史记录
     * 
     * @param alertHistory 预警历史记录
     * @return 结果
     */
    @Override
    public int updateAlertHistory(AlertHistory alertHistory)
    {
        alertHistory.setUpdateTime(DateUtils.getNowDate());
        return alertHistoryMapper.updateAlertHistory(alertHistory);
    }

    /**
     * 批量删除预警历史记录
     * 
     * @param ids 需要删除的预警历史记录主键
     * @return 结果
     */
    @Override
    public int deleteAlertHistoryByIds(Long[] ids)
    {
        return alertHistoryMapper.deleteAlertHistoryByIds(ids);
    }

    /**
     * 删除预警历史记录信息
     * 
     * @param id 预警历史记录主键
     * @return 结果
     */
    @Override
    public int deleteAlertHistoryById(Long id)
    {
        return alertHistoryMapper.deleteAlertHistoryById(id);
    }
}
