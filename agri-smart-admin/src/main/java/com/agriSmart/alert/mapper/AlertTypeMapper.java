package com.agriSmart.alert.mapper;

import java.util.List;
import com.agriSmart.alert.domain.AlertType;

/**
 * 预警阈值类型Mapper接口
 * 
 * @author 羊离子
 * @date 2026-04-13
 */
public interface AlertTypeMapper 
{
    /**
     * 查询预警阈值类型
     * 
     * @param id 预警阈值类型主键
     * @return 预警阈值类型
     */
    public AlertType selectAlertTypeById(Long id);

    /**
     * 查询预警阈值类型列表
     * 
     * @param alertType 预警阈值类型
     * @return 预警阈值类型集合
     */
    public List<AlertType> selectAlertTypeList(AlertType alertType);

    /**
     * 新增预警阈值类型
     * 
     * @param alertType 预警阈值类型
     * @return 结果
     */
    public int insertAlertType(AlertType alertType);

    /**
     * 修改预警阈值类型
     * 
     * @param alertType 预警阈值类型
     * @return 结果
     */
    public int updateAlertType(AlertType alertType);

    /**
     * 删除预警阈值类型
     * 
     * @param id 预警阈值类型主键
     * @return 结果
     */
    public int deleteAlertTypeById(Long id);

    /**
     * 批量删除预警阈值类型
     * 
     * @param ids 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteAlertTypeByIds(Long[] ids);
}
