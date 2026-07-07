package com.agriSmart.model.service.impl;

import java.util.List;
import com.agriSmart.common.utils.DateUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.ArrayList;
import com.agriSmart.common.utils.StringUtils;
import org.springframework.transaction.annotation.Transactional;
import com.agriSmart.model.domain.DetectionLogDetail;
import com.agriSmart.model.mapper.DetectionLogMapper;
import com.agriSmart.model.domain.DetectionLog;
import com.agriSmart.model.service.IDetectionLogService;

/**
 * 检测日志Service业务层处理
 * 
 * @author 羊离子
 * @date 2026-04-15
 */
@Service
public class DetectionLogServiceImpl implements IDetectionLogService 
{
    @Autowired
    private DetectionLogMapper detectionLogMapper;

    /**
     * 查询检测日志
     * 
     * @param id 检测日志主键
     * @return 检测日志
     */
    @Override
    public DetectionLog selectDetectionLogById(Long id)
    {
        return detectionLogMapper.selectDetectionLogById(id);
    }

    /**
     * 查询检测日志列表
     * 
     * @param detectionLog 检测日志
     * @return 检测日志
     */
    @Override
    public List<DetectionLog> selectDetectionLogList(DetectionLog detectionLog)
    {
        return detectionLogMapper.selectDetectionLogList(detectionLog);
    }

    /**
     * 新增检测日志
     * 
     * @param detectionLog 检测日志
     * @return 结果
     */
    @Transactional
    @Override
    public int insertDetectionLog(DetectionLog detectionLog)
    {
        detectionLog.setCreateTime(DateUtils.getNowDate());
        int rows = detectionLogMapper.insertDetectionLog(detectionLog);
        insertDetectionLogDetail(detectionLog);
        return rows;
    }

    /**
     * 修改检测日志
     * 
     * @param detectionLog 检测日志
     * @return 结果
     */
    @Transactional
    @Override
    public int updateDetectionLog(DetectionLog detectionLog)
    {
        detectionLogMapper.deleteDetectionLogDetailByLogId(detectionLog.getId());
        insertDetectionLogDetail(detectionLog);
        return detectionLogMapper.updateDetectionLog(detectionLog);
    }

    /**
     * 批量删除检测日志
     * 
     * @param ids 需要删除的检测日志主键
     * @return 结果
     */
    @Transactional
    @Override
    public int deleteDetectionLogByIds(Long[] ids)
    {
        detectionLogMapper.deleteDetectionLogDetailByLogIds(ids);
        return detectionLogMapper.deleteDetectionLogByIds(ids);
    }

    /**
     * 删除检测日志信息
     * 
     * @param id 检测日志主键
     * @return 结果
     */
    @Transactional
    @Override
    public int deleteDetectionLogById(Long id)
    {
        detectionLogMapper.deleteDetectionLogDetailByLogId(id);
        return detectionLogMapper.deleteDetectionLogById(id);
    }

    /**
     * 新增检测日志详情信息
     * 
     * @param detectionLog 检测日志对象
     */
    public void insertDetectionLogDetail(DetectionLog detectionLog)
    {
        List<DetectionLogDetail> detectionLogDetailList = detectionLog.getDetectionLogDetailList();
        Long id = detectionLog.getId();
        if (StringUtils.isNotNull(detectionLogDetailList))
        {
            List<DetectionLogDetail> list = new ArrayList<DetectionLogDetail>();
            for (DetectionLogDetail detectionLogDetail : detectionLogDetailList)
            {
                detectionLogDetail.setLogId(id);
                list.add(detectionLogDetail);
            }
            if (list.size() > 0)
            {
                detectionLogMapper.batchDetectionLogDetail(list);
            }
        }
    }
}
