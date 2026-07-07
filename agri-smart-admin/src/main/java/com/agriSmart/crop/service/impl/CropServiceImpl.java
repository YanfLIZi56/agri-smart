package com.agriSmart.crop.service.impl;

import java.util.List;
import com.agriSmart.common.utils.DateUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.agriSmart.crop.mapper.CropMapper;
import com.agriSmart.crop.domain.Crop;
import com.agriSmart.crop.service.ICropService;

/**
 * 农作物信息Service业务层处理
 * 
 * @author 羊离子
 * @date 2026-04-09
 */
@Service
public class CropServiceImpl implements ICropService 
{
    @Autowired
    private CropMapper cropMapper;

    /**
     * 查询农作物信息
     * 
     * @param id 农作物信息主键
     * @return 农作物信息
     */
    @Override
    public Crop selectCropById(Long id)
    {
        return cropMapper.selectCropById(id);
    }

    /**
     * 查询农作物信息列表
     * 
     * @param crop 农作物信息
     * @return 农作物信息
     */
    @Override
    public List<Crop> selectCropList(Crop crop)
    {
        return cropMapper.selectCropList(crop);
    }

    /**
     * 新增农作物信息
     * 
     * @param crop 农作物信息
     * @return 结果
     */
    @Override
    public int insertCrop(Crop crop)
    {
        crop.setCreateTime(DateUtils.getNowDate());
        return cropMapper.insertCrop(crop);
    }

    /**
     * 修改农作物信息
     * 
     * @param crop 农作物信息
     * @return 结果
     */
    @Override
    public int updateCrop(Crop crop)
    {
        crop.setUpdateTime(DateUtils.getNowDate());
        return cropMapper.updateCrop(crop);
    }

    /**
     * 批量删除农作物信息
     * 
     * @param ids 需要删除的农作物信息主键
     * @return 结果
     */
    @Override
    public int deleteCropByIds(Long[] ids)
    {
        return cropMapper.deleteCropByIds(ids);
    }

    /**
     * 删除农作物信息信息
     * 
     * @param id 农作物信息主键
     * @return 结果
     */
    @Override
    public int deleteCropById(Long id)
    {
        return cropMapper.deleteCropById(id);
    }
}
