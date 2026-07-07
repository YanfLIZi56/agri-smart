package com.agriSmart.alert.service;

import java.util.List;
import com.agriSmart.alert.domain.AlertThreshold;

/**
 * 预警阈值配置Service接口
 * 
 * @author 羊离子
 * @date 2026-04-13
 */
public interface IAlertThresholdService 
{
    /**
     * 查询预警阈值配置
     * 
     * @param id 预警阈值配置主键
     * @return 预警阈值配置
     */
    public AlertThreshold selectAlertThresholdById(Long id);

    /**
     * 查询预警阈值配置列表
     * 
     * @param alertThreshold 预警阈值配置
     * @return 预警阈值配置集合
     */
    public List<AlertThreshold> selectAlertThresholdList(AlertThreshold alertThreshold);

    /**
     * 新增预警阈值配置
     * 
     * @param alertThreshold 预警阈值配置
     * @return 结果
     */
    public int insertAlertThreshold(AlertThreshold alertThreshold);

    /**
     * 修改预警阈值配置
     * 
     * @param alertThreshold 预警阈值配置
     * @return 结果
     */
    public int updateAlertThreshold(AlertThreshold alertThreshold);

    /**
     * 批量删除预警阈值配置
     * 
     * @param ids 需要删除的预警阈值配置主键集合
     * @return 结果
     */
    public int deleteAlertThresholdByIds(Long[] ids);

    /**
     * 删除预警阈值配置信息
     * 
     * @param id 预警阈值配置主键
     * @return 结果
     */
    public int deleteAlertThresholdById(Long id);
}
