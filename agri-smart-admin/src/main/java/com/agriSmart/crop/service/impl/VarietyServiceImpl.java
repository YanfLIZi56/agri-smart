package com.agriSmart.crop.service.impl;

import java.util.List;

import com.agriSmart.common.core.redis.RedisCache;
import com.agriSmart.common.utils.DateUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.agriSmart.crop.mapper.VarietyMapper;
import com.agriSmart.crop.domain.Variety;
import com.agriSmart.crop.service.IVarietyService;

/**
 * 农作物品种Service业务层处理
 * 
 * @author 羊离子
 * @date 2026-04-09
 */
@Service
public class VarietyServiceImpl implements IVarietyService 
{
    @Autowired
    private VarietyMapper varietyMapper;

    /**
     * 查询农作物品种
     * 
     * @param id 农作物品种主键
     * @return 农作物品种
     */
    @Override
    public Variety selectVarietyById(Long id)
    {
        return varietyMapper.selectVarietyById(id);
    }

    /**
     * 查询农作物品种列表
     * 
     * @param variety 农作物品种
     * @return 农作物品种
     */
    @Override
    public List<Variety> selectVarietyList(Variety variety)
    {
        return varietyMapper.selectVarietyList(variety);
    }

    /**
     * 新增农作物品种
     * 
     * @param variety 农作物品种
     * @return 结果
     */
    @Override
    public int insertVariety(Variety variety)
    {
        variety.setCreateTime(DateUtils.getNowDate());
        return varietyMapper.insertVariety(variety);
    }

    /**
     * 修改农作物品种
     * 
     * @param variety 农作物品种
     * @return 结果
     */
    @Override
    public int updateVariety(Variety variety)
    {
        variety.setUpdateTime(DateUtils.getNowDate());
        return varietyMapper.updateVariety(variety);
    }

    /**
     * 批量删除农作物品种
     * 
     * @param ids 需要删除的农作物品种主键
     * @return 结果
     */
    @Override
    public int deleteVarietyByIds(Long[] ids)
    {
        return varietyMapper.deleteVarietyByIds(ids);
    }

    /**
     * 删除农作物品种信息
     * 
     * @param id 农作物品种主键
     * @return 结果
     */
    @Override
    public int deleteVarietyById(Long id)
    {
        return varietyMapper.deleteVarietyById(id);
    }
}
