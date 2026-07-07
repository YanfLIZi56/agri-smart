package com.agriSmart.crop.service;

import java.util.List;
import com.agriSmart.crop.domain.Crop;

/**
 * 农作物信息Service接口
 * 
 * @author 羊离子
 * @date 2026-04-09
 */
public interface ICropService 
{
    /**
     * 查询农作物信息
     * 
     * @param id 农作物信息主键
     * @return 农作物信息
     */
    public Crop selectCropById(Long id);

    /**
     * 查询农作物信息列表
     * 
     * @param crop 农作物信息
     * @return 农作物信息集合
     */
    public List<Crop> selectCropList(Crop crop);

    /**
     * 新增农作物信息
     * 
     * @param crop 农作物信息
     * @return 结果
     */
    public int insertCrop(Crop crop);

    /**
     * 修改农作物信息
     * 
     * @param crop 农作物信息
     * @return 结果
     */
    public int updateCrop(Crop crop);

    /**
     * 批量删除农作物信息
     * 
     * @param ids 需要删除的农作物信息主键集合
     * @return 结果
     */
    public int deleteCropByIds(Long[] ids);

    /**
     * 删除农作物信息信息
     * 
     * @param id 农作物信息主键
     * @return 结果
     */
    public int deleteCropById(Long id);
}
