package com.agriSmart.crop.mapper;

import java.util.List;
import java.util.Set;

import com.agriSmart.crop.domain.Crop;
import com.agriSmart.model.domain.dto.YoloRes;
import org.apache.ibatis.annotations.Mapper;

/**
 * 农作物信息Mapper接口
 * 
 * @author 羊离子
 * @date 2026-04-09
 */
@Mapper
public interface CropMapper 
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
     * 删除农作物信息
     * 
     * @param id 农作物信息主键
     * @return 结果
     */
    public int deleteCropById(Long id);

    /**
     * 批量删除农作物信息
     * 
     * @param ids 需要删除的数据主键集合
     * @return 结果
     */
    public int deleteCropByIds(Long[] ids);

    List<Crop> getIdByLabel(Set<String> aliases);
}
