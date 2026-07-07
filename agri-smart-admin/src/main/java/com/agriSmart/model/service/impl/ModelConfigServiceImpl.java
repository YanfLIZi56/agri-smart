package com.agriSmart.model.service.impl;

import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import java.util.stream.Stream;

import com.agriSmart.common.core.redis.RedisCache;
import com.agriSmart.common.utils.DateUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import com.agriSmart.model.mapper.ModelConfigMapper;
import com.agriSmart.model.domain.ModelConfig;
import com.agriSmart.model.service.IModelConfigService;

import static com.agriSmart.constant.ModelConstant.MODEL_SCAN_LIST;
import static com.agriSmart.utils.FileUtils.scanModels;

/**
 * 模型配置Service业务层处理
 * 
 * @author 羊离子
 * @date 2026-04-13
 */
@Service
public class ModelConfigServiceImpl implements IModelConfigService 
{
    private static final Logger log = LoggerFactory.getLogger(ModelConfigServiceImpl.class);
    @Value("${ruoyi.yolo.model-path}")
    private String modelPath;

    @Autowired
    private ModelConfigMapper modelConfigMapper;
    @Autowired
    private RedisCache redisCache;
    

    /**
     * 查询模型配置
     * 
     * @param id 模型配置主键
     * @return 模型配置
     */
    @Override
    public ModelConfig selectModelConfigById(Long id)
    {
        return modelConfigMapper.selectModelConfigById(id);
    }

    /**
     * 查询模型配置列表
     * 
     * @param modelConfig 模型配置
     * @return 模型配置
     */
    @Override
    public List<ModelConfig> selectModelConfigList(ModelConfig modelConfig)
    {
        return modelConfigMapper.selectModelConfigList(modelConfig);
    }

    /**
     * 新增模型配置
     * 
     * @param modelConfig 模型配置
     * @return 结果
     */
    @Override
    public int insertModelConfig(ModelConfig modelConfig)
    {
        modelConfig.setCreateTime(DateUtils.getNowDate());
        if (modelConfig.getVersion() == null) {
            modelConfig.setVersion("latest");
        }
        return modelConfigMapper.insertModelConfig(modelConfig);
    }

    /**
     * 修改模型配置
     * 
     * @param modelConfig 模型配置
     * @return 结果
     */
    @Override
    public int updateModelConfig(ModelConfig modelConfig)
    {
        modelConfig.setUpdateTime(DateUtils.getNowDate());
        if (modelConfig.getVersion() == null) {
            modelConfig.setVersion("latest");
        }
        return modelConfigMapper.updateModelConfig(modelConfig);
    }

    /**
     * 批量删除模型配置 - 软删除
     * 
     * @param ids 需要删除的模型配置主键
     * @return 结果
     */
    @Override
    public int deleteModelConfigByIds(Long[] ids)
    {
        return modelConfigMapper.softDeleteModelConfigByIds(ids);
    }

    /**
     * 删除模型配置信息
     * 
     * @param id 模型配置主键
     * @return 结果
     */
    @Override
    public int deleteModelConfigById(Long id)
    {
        return modelConfigMapper.deleteModelConfigById(id);
    }

    /**
     * 扫描模型文件
     * @return 新模型列表
     */
    @Override
    public List<ModelConfig> findModels() {
//        if (redisCache.hasKey(MODEL_SCAN_LIST)) {
//            return redisCache.getCacheList(MODEL_SCAN_LIST);
//        }

        List<ModelConfig> scannedModels = scanModels(modelPath);
        List<ModelConfig> models = new ArrayList<>();

        List<ModelConfig> dbModels = modelConfigMapper.selectModelConfigList(new ModelConfig());

        Map<String, ModelConfig> dbModelMap = dbModels.stream()
                .collect(Collectors.toMap(ModelConfig::getFilePath, model -> model, (k1, k2) -> k1));

        for (ModelConfig scannedModel : scannedModels) {
            ModelConfig dbModel = dbModelMap.get(scannedModel.getFilePath());
            if (dbModel == null) {
                String modelName = scannedModel
                        .getFilePath()
                        .substring(scannedModel.getFilePath().lastIndexOf("/") + 1,
                                scannedModel.getFilePath().lastIndexOf("."));
                scannedModel.setModelSize(scannedModel.getModelSize());
//                用户只需填写: 模型名称, 模型类型, 版本号
                scannedModel.setModelName(modelName);
                models.add(scannedModel);
            }
        }
//        redisCache.setCacheList(MODEL_SCAN_LIST, models);
        return models;
    }

    @Override
    public int addBatchConfig(List<ModelConfig>  models) {
        for (int i = 0; i < models.size() - 1; i++) {
            ModelConfig modelConfig = models.get(i);
            modelConfig.setCreateTime(DateUtils.getNowDate());
            if (modelConfig.getVersion() == null) {
                modelConfig.setVersion("latest");
            }
        }
        int i = modelConfigMapper.addBatchConfig(models);
        if (i > 0) {
            redisCache.deleteObject(MODEL_SCAN_LIST);
        }
        return i;
    }

    @Override
    public String getServerPath() {
        return modelPath;
    }

    @Override
    public List<ModelConfig> remoteModelConfigList(ModelConfig modelConfig) {
        return modelConfigMapper.remoteModelConfigList(modelConfig);
    }


}
