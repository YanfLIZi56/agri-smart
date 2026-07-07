package com.agriSmart.crop.service;

import java.util.List;
import com.agriSmart.crop.domain.Variety;

/**
 * 农作物品种Service接口
 * 
 * @author 羊离子
 * @date 2026-04-09
 */
public interface IVarietyService 
{
    /**
     * 查询农作物品种
     * 
     * @param id 农作物品种主键
     * @return 农作物品种
     */
    public Variety selectVarietyById(Long id);

    /**
     * 查询农作物品种列表
     * 
     * @param variety 农作物品种
     * @return 农作物品种集合
     */
    public List<Variety> selectVarietyList(Variety variety);

    /**
     * 新增农作物品种
     * 
     * @param variety 农作物品种
     * @return 结果
     */
    public int insertVariety(Variety variety);

    /**
     * 修改农作物品种
     * 
     * @param variety 农作物品种
     * @return 结果
     */
    public int updateVariety(Variety variety);

    /**
     * 批量删除农作物品种
     * 
     * @param ids 需要删除的农作物品种主键集合
     * @return 结果
     */
    public int deleteVarietyByIds(Long[] ids);

    /**
     * 删除农作物品种信息
     * 
     * @param id 农作物品种主键
     * @return 结果
     */
    public int deleteVarietyById(Long id);
}
