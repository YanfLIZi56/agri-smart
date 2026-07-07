package com.agriSmart.alert.service.impl;

import java.util.List;
import com.agriSmart.common.utils.DateUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.agriSmart.alert.mapper.AlertTypeMapper;
import com.agriSmart.alert.domain.AlertType;
import com.agriSmart.alert.service.IAlertTypeService;

/**
 * 预警阈值类型Service业务层处理
 * 
 * @author 羊离子
 * @date 2026-04-13
 */
@Service
public class AlertTypeServiceImpl implements IAlertTypeService 
{
    @Autowired
    private AlertTypeMapper alertTypeMapper;

    /**
     * 查询预警阈值类型
     * 
     * @param id 预警阈值类型主键
     * @return 预警阈值类型
     */
    @Override
    public AlertType selectAlertTypeById(Long id)
    {
        return alertTypeMapper.selectAlertTypeById(id);
    }

    /**
     * 查询预警阈值类型列表
     * 
     * @param alertType 预警阈值类型
     * @return 预警阈值类型
     */
    @Override
    public List<AlertType> selectAlertTypeList(AlertType alertType)
    {
        return alertTypeMapper.selectAlertTypeList(alertType);
    }

    /**
     * 新增预警阈值类型
     * 
     * @param alertType 预警阈值类型
     * @return 结果
     */
    @Override
    public int insertAlertType(AlertType alertType)
    {
        alertType.setCreateTime(DateUtils.getNowDate());
        return alertTypeMapper.insertAlertType(alertType);
    }

    /**
     * 修改预警阈值类型
     * 
     * @param alertType 预警阈值类型
     * @return 结果
     */
    @Override
    public int updateAlertType(AlertType alertType)
    {
        alertType.setUpdateTime(DateUtils.getNowDate());
        return alertTypeMapper.updateAlertType(alertType);
    }

    /**
     * 批量删除预警阈值类型
     * 
     * @param ids 需要删除的预警阈值类型主键
     * @return 结果
     */
    @Override
    public int deleteAlertTypeByIds(Long[] ids)
    {
        return alertTypeMapper.deleteAlertTypeByIds(ids);
    }

    /**
     * 删除预警阈值类型信息
     * 
     * @param id 预警阈值类型主键
     * @return 结果
     */
    @Override
    public int deleteAlertTypeById(Long id)
    {
        return alertTypeMapper.deleteAlertTypeById(id);
    }
}
