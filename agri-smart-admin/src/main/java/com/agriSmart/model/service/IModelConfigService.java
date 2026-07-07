package com.agriSmart.model.service;

import java.util.List;
import com.agriSmart.model.domain.ModelConfig;

/**
 * 模型配置Service接口
 * 
 * @author 羊离子
 * @date 2026-04-13
 */
public interface IModelConfigService 
{
    /**
     * 查询模型配置
     * 
     * @param id 模型配置主键
     * @return 模型配置
     */
    public ModelConfig selectModelConfigById(Long id);

    /**
     * 查询模型配置列表
     * 
     * @param modelConfig 模型配置
     * @return 模型配置集合
     */
    public List<ModelConfig> selectModelConfigList(ModelConfig modelConfig);

    /**
     * 新增模型配置
     * 
     * @param modelConfig 模型配置
     * @return 结果
     */
    public int insertModelConfig(ModelConfig modelConfig);

    /**
     * 修改模型配置
     * 
     * @param modelConfig 模型配置
     * @return 结果
     */
    public int updateModelConfig(ModelConfig modelConfig);

    /**
     * 批量删除模型配置
     * 
     * @param ids 需要删除的模型配置主键集合
     * @return 结果
     */
    public int deleteModelConfigByIds(Long[] ids);

    /**
     * 删除模型配置信息
     * 
     * @param id 模型配置主键
     * @return 结果
     */
    public int deleteModelConfigById(Long id);

    List<ModelConfig> findModels();

    int addBatchConfig(List<ModelConfig>  models);

    String getServerPath();

    List<ModelConfig> remoteModelConfigList(ModelConfig modelConfig);
}
