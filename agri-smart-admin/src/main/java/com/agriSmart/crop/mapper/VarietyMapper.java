package com.agriSmart.crop.mapper;

import java.util.List;
import com.agriSmart.crop.domain.Variety;
import org.apache.ibatis.annotations.Mapper;

/**
 * 农作物品种Mapper接口
 * 
 * @author 羊离子
 * @date 2026-04-09
 */
@Mapper
public interface VarietyMapper 
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
     * 删除农作物品种
     * 
     * @param id 农作物品种主键
     * @return 结果
     */
    public int deleteVarietyById(Long id);

    /**
     * 批量删除农作物品种
     * 
     * @param ids 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteVarietyByIds(Long[] ids);
}
