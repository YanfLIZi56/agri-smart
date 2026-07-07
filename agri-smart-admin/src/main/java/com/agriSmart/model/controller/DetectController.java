package com.agriSmart.model.controller;

import com.agriSmart.common.core.domain.AjaxResult;
import com.agriSmart.common.utils.DateUtils;
import com.agriSmart.common.utils.SecurityUtils;
import com.agriSmart.crop.domain.Crop;
import com.agriSmart.crop.mapper.CropMapper;
import com.agriSmart.model.domain.DetectionLog;
import com.agriSmart.model.domain.DetectionLogDetail;
import com.agriSmart.model.domain.ModelConfig;
import com.agriSmart.model.domain.dto.YoloRes;
import com.agriSmart.model.mapper.ModelConfigMapper;
import com.agriSmart.model.service.IDetectionLogService;
import com.agriSmart.utils.HttpUtis;
import com.alibaba.fastjson2.JSON;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.FileSystemResource;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.util.*;
import java.util.stream.Collectors;

/**
 * @author 羊离子
 */

@RestController
@RequestMapping("/yolo")
public class DetectController {

    @Value("${ruoyi.yolo.url}")
    private String yoloApiUrl;
    @Value("${ruoyi.yolo.model-path}")
    private String modelPath;
    @Value("${ruoyi.yolo.result-path}")
    private String resultPath;
    @Value("${ruoyi.yolo.origin-path}")
    private String originPath;

    @Autowired
    private ModelConfigMapper modelConfigMapper;
    @Autowired
    private IDetectionLogService detectionLogService;
    @Autowired
    private CropMapper cropMapper;


    @PostMapping("/detect")
    public AjaxResult detect(
            @RequestParam("file") MultipartFile file,
            @RequestParam(value = "conf", defaultValue = "0.25") Double conf,
            @RequestParam(value = "modelId", required = false) Long modelId,
            @RequestParam("detectType") Integer detectType) {
        try{
            // 验证置信度阈值范围 (0, 1]
            if (conf <= 0 || conf > 1) {
                return AjaxResult.error("检测置信度阈值必须在(0, 1]范围内");
            }

            // 验证文件是否为空
            if (file.isEmpty()) {
                return AjaxResult.error("上传文件不能为空");
            }

            if (modelId == null){
                return AjaxResult.error("请选择模型");
            }

            ModelConfig modelConfig = modelConfigMapper.selectModelConfigById(modelId);
            if (modelConfig == null){
                return AjaxResult.error("模型不存在");
            }
            if (modelConfig.getIsActive() == 0){
                return AjaxResult.error("模型未激活");
            }

            String filePath = modelPath + modelConfig.getFilePath();

            Map<String, Object> params = new HashMap<>();
            params.put("conf", conf);
            params.put("model_path", filePath);

            String detectApiUrl = yoloApiUrl.endsWith("/") ? yoloApiUrl + "detect" : yoloApiUrl + "/detect";

            String result = HttpUtis.sendPostWithFile(detectApiUrl, file, params);
            if (result == null) {
                return AjaxResult.error("检测失败");
            }
            YoloRes response = JSON.parseObject(result, YoloRes.class);

            if (!"0".equals(response.getCode())) {
                return AjaxResult.error("检测失败：" + response.getMsg());
            }

            HashMap<String, Integer> map = new HashMap<>();
            List<DetectionLogDetail> details = new ArrayList<>();
            List<YoloRes.Detection> detections = response.getDetections();

            Set<String> labels = detections.stream()
                    .map(YoloRes.Detection::getClassName)
                    .collect(Collectors.toSet());
            List<Crop> crops =cropMapper.getIdByLabel(labels);

            Map<String, Crop> labelToCropIdMap = crops.stream()
                    .collect(Collectors.toMap(Crop::getAlias, crop -> crop, (k1, k2) -> k1));

            for (YoloRes.Detection detection : detections){
                map.put(detection.getClassName(), map.getOrDefault(detection.getClassName(), 0) + 1);

                String label = detection.getClassName();
                Crop crop = labelToCropIdMap.get(label);

                DetectionLogDetail detail = new DetectionLogDetail();
                detail.setLabel(label);
                detail.setConf(detection.getConf());
                detail.setBbox(detection.getBbox());
                if (crop != null) {
                    detail.setLinkedEncyclopedia(crop.getId());
                    detail.setCropName(crop.getName());
                    detail.setVarietyName(crop.getVarietyName());
                    detail.setCropStatus(crop.getStatus());
                } else {
                    detail.setLinkedEncyclopedia(null);
                    detail.setCropName(label);
                    detail.setVarietyName(null);
                    detail.setCropStatus(null);
                }
                details.add(detail);
            };

//          map转json
            String json = JSON.toJSONString(map);

            DetectionLog detectionLog = new DetectionLog();
            detectionLog.setModelConfigId(modelConfig.getId());
            detectionLog.setDetectType(detectType);
            detectionLog.setLogType(modelConfig.getModelType());
            detectionLog.setUserId(SecurityUtils.getUserId());
            detectionLog.setResultImagePath(response.getResult());
            detectionLog.setOriginImagePath(response.getOrigin());
            detectionLog.setDurationMs(response.getTime());
            detectionLog.setTotalTargets(response.getCount());
            detectionLog.setDensityJson(json);
            detectionLog.setDetectTime(DateUtils.getNowDate());

            detectionLog.setDetectionLogDetailList(details);

            detectionLogService.insertDetectionLog(detectionLog);

            return AjaxResult.success(detectionLog);

        }
        catch (Exception e) {
            return AjaxResult.error("检测失败：" + e.getMessage());
        }
    }


    @GetMapping("/result")
    public ResponseEntity<Resource> getImage(
            @RequestParam("fileName") String fileName) {
        return getImg(resultPath,fileName);
    }

    @GetMapping("/origin")
    public ResponseEntity<Resource> getOriginImage(
            @RequestParam("fileName") String fileName) {
        return getImg(originPath,fileName);
    }

    private ResponseEntity<Resource> getImg(String resultPath, String fileName) {
        try {
            String fullPath = resultPath + fileName;
            File file = new File(fullPath);

            if (!file.exists()) {
                return ResponseEntity.notFound().build();
            }

            Resource resource = new FileSystemResource(file);

            String contentType = MediaType.IMAGE_JPEG_VALUE;
            if (fileName.toLowerCase().endsWith(".png")) {
                contentType = MediaType.IMAGE_PNG_VALUE;
            } else if (fileName.toLowerCase().endsWith(".gif")) {
                contentType = MediaType.IMAGE_GIF_VALUE;
            }

            return ResponseEntity.ok()
                    .contentType(MediaType.parseMediaType(contentType))
                    .header(HttpHeaders.CONTENT_DISPOSITION, "inline; filename=\"" + fileName + "\"")
                    .body(resource);

        } catch (Exception e) {
            return ResponseEntity.internalServerError().build();
        }
    }

}
