/*
 Navicat Premium Data Transfer

 Source Server         : localhost
 Source Server Type    : MySQL
 Source Server Version : 80040
 Source Host           : localhost:3306
 Source Schema         : agri-smart

 Target Server Type    : MySQL
 Target Server Version : 80040
 File Encoding         : 65001

 Date: 04/07/2026 17:02:16
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for alert_history
-- ----------------------------
DROP TABLE IF EXISTS `alert_history`;
CREATE TABLE `alert_history`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `plot_id` int NOT NULL COMMENT '片区ID',
  `alert_type_id` int NOT NULL COMMENT '预警类型ID',
  `trigger_value` decimal(10, 2) NOT NULL COMMENT '触发时的实际值',
  `min_value` decimal(10, 2) NULL DEFAULT NULL COMMENT '当时的下限阈值',
  `max_value` decimal(10, 2) NULL DEFAULT NULL COMMENT '当时的上限阈值',
  `status` tinyint(1) NOT NULL DEFAULT 0 COMMENT '预警状态：0-异常开始，1-异常恢复',
  `trigger_time` datetime NOT NULL COMMENT '触发时间（异常开始时间）',
  `recovery_time` datetime NULL DEFAULT NULL COMMENT '恢复时间（异常结束时间）',
  `duration_minutes` int NULL DEFAULT NULL COMMENT '持续时长（分钟）',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_plot_id`(`plot_id` ASC) USING BTREE,
  INDEX `idx_alert_type_id`(`alert_type_id` ASC) USING BTREE,
  INDEX `idx_alert_time`(`trigger_time` ASC) USING BTREE,
  INDEX `idx_alert_status`(`status` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '预警历史记录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of alert_history
-- ----------------------------
INSERT INTO `alert_history` VALUES (1, 3, 3, 500.00, NULL, 400.00, 1, '2026-04-15 02:12:38', '2026-04-15 02:18:29', 5, '2026-04-15 02:18:29', NULL);
INSERT INTO `alert_history` VALUES (2, 1, 3, 7.00, 100.00, 200.00, 1, '2026-04-15 03:01:34', '2026-04-15 03:05:09', 3, '2026-04-15 03:05:09', '设备数据脱离而恢复');
INSERT INTO `alert_history` VALUES (3, 1, 2, 20.00, 40.00, 50.00, 1, '2026-04-15 04:02:21', '2026-04-15 04:03:15', 0, '2026-04-15 04:03:15', '阈值调整使数据恢复正常');
INSERT INTO `alert_history` VALUES (4, 1, 2, 20.00, 34.00, 50.00, 1, '2026-04-15 04:03:46', '2026-04-15 04:06:27', 2, '2026-04-15 04:06:27', '预警阈值配置删除而恢复');
INSERT INTO `alert_history` VALUES (5, 1, 1, 88.00, 20.00, 27.00, 1, '2026-04-16 18:45:28', '2026-04-18 17:50:04', 2824, '2026-04-18 17:50:04', '数据恢复正常');
INSERT INTO `alert_history` VALUES (6, 1, 2, 20.00, 60.00, 75.00, 1, '2026-04-18 17:50:23', '2026-04-18 17:54:35', 4, '2026-04-18 17:54:35', '数据恢复正常');
INSERT INTO `alert_history` VALUES (7, 1, 4, 7.50, 5.50, 6.50, 1, '2026-04-18 17:55:47', '2026-04-18 17:56:25', 0, '2026-04-18 17:56:25', '数据恢复正常');
INSERT INTO `alert_history` VALUES (8, 1, 4, 7.10, 5.50, 6.50, 0, '2026-04-18 17:57:03', NULL, NULL, NULL, '设备数据异常');
INSERT INTO `alert_history` VALUES (9, 3, 1, 26.00, 27.00, 35.00, 1, '2026-06-10 20:24:14', '2026-06-10 20:29:51', 5, '2026-06-10 20:29:51', '阈值调整使数据恢复正常');

-- ----------------------------
-- Table structure for alert_threshold
-- ----------------------------
DROP TABLE IF EXISTS `alert_threshold`;
CREATE TABLE `alert_threshold`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `plot_id` int NOT NULL COMMENT '片区ID（farm_plot.id）',
  `alert_type_id` int NOT NULL COMMENT '预警类型(alert_type.id)',
  `min_value` decimal(10, 2) NULL DEFAULT NULL COMMENT '下限阈值（低于此值触发预警，可为空）',
  `max_value` decimal(10, 2) NULL DEFAULT NULL COMMENT '上限阈值（高于此值触发预警，可为空）',
  `enabled` tinyint(1) NOT NULL DEFAULT 1 COMMENT '是否启用：0-停用，1-启用',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_plotId_alertTypeId`(`plot_id` ASC, `alert_type_id` ASC) USING BTREE,
  INDEX `idx_plot_id`(`plot_id` ASC) USING BTREE,
  INDEX `idx_alert_type`(`alert_type_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '预警阈值配置表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of alert_threshold
-- ----------------------------
INSERT INTO `alert_threshold` VALUES (1, 3, 1, 25.00, 35.00, 1, '2026-04-13 22:02:50', '2026-06-10 20:29:50');
INSERT INTO `alert_threshold` VALUES (2, 3, 2, 20.00, NULL, 1, '2026-04-13 22:09:31', '2026-04-13 22:27:53');
INSERT INTO `alert_threshold` VALUES (3, 3, 3, NULL, 400.00, 1, '2026-04-14 00:07:00', '2026-04-14 01:35:49');
INSERT INTO `alert_threshold` VALUES (4, 3, 4, 5.60, 7.80, 1, '2026-04-14 00:08:57', NULL);
INSERT INTO `alert_threshold` VALUES (5, 1, 3, 600.00, 800.00, 1, '2026-04-14 01:42:18', '2026-04-18 17:53:48');
INSERT INTO `alert_threshold` VALUES (7, 1, 1, 20.00, 28.00, 1, '2026-04-16 18:45:28', '2026-04-18 17:53:39');
INSERT INTO `alert_threshold` VALUES (8, 1, 2, 60.00, 75.00, 1, '2026-04-18 17:50:23', NULL);
INSERT INTO `alert_threshold` VALUES (9, 1, 4, 5.50, 6.50, 1, '2026-04-18 17:55:47', NULL);

-- ----------------------------
-- Table structure for alert_type
-- ----------------------------
DROP TABLE IF EXISTS `alert_type`;
CREATE TABLE `alert_type`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '预警阈值类型名称',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `unit` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '预警阈值类型表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of alert_type
-- ----------------------------
INSERT INTO `alert_type` VALUES (1, '温度', NULL, '', '2026-04-13 21:49:53', '', '2026-04-13 21:56:58', '℃');
INSERT INTO `alert_type` VALUES (2, '湿度', NULL, '', '2026-04-13 21:49:58', '', '2026-04-13 21:57:03', '%');
INSERT INTO `alert_type` VALUES (3, '二氧化碳浓度', NULL, '', '2026-04-13 21:50:17', '', '2026-04-13 21:57:08', 'ppm');
INSERT INTO `alert_type` VALUES (4, '土壤pH值', NULL, '', '2026-04-13 21:57:55', '', NULL, 'pH');

-- ----------------------------
-- Table structure for crop
-- ----------------------------
DROP TABLE IF EXISTS `crop`;
CREATE TABLE `crop`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '农作物ID',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '农作物名称',
  `alias` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '别名',
  `symptoms` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '症状描述',
  `causes` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '病因描述',
  `prevention` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL COMMENT '防治方法',
  `variety_id` int NULL DEFAULT NULL COMMENT '品种 variety.id',
  `status` tinyint(1) NOT NULL DEFAULT 0 COMMENT '状态：0-正常，1-病害，2-虫害',
  `images` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '图片路径（多张用逗号分隔）',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 11 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '农作物信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of crop
-- ----------------------------
INSERT INTO `crop` VALUES (1, '马铃薯', 'potato', NULL, NULL, NULL, 1, 0, '/profile/upload/2026/04/12/71cea3a14813411c8f146a98f47bfb3d.jpg', NULL, '', '2026-04-09 17:36:47', '', '2026-04-12 20:45:57');
INSERT INTO `crop` VALUES (2, '马铃薯黑胫病', 'potato black leg', '马铃薯黑胫病从苗期到生育后期均可发病，主要为害植株茎基部和薯块。当幼苗生长到15-20厘米开始出现症状，表现植株矮小，叶色褪绿黄化，节间短缩或叶片上卷，茎基以上部位组织发黑腐烂，最终萎蔫而死', '由胡萝卜软腐欧文氏菌马铃薯黑胫亚种引起的', '选用抗病品种、加强栽培管理、选用无病种薯、及时摘除病株、加强入窖管理以及化学防治（药剂浸泡种薯、药剂喷雾）。', 1, 1, '/profile/upload/2026/04/12/bf305912741441e7902092787f8f8f74.png', NULL, '', '2026-04-09 17:48:23', '', '2026-04-18 17:21:06');
INSERT INTO `crop` VALUES (3, '马铃薯蚜虫', 'myzus persicae sulzer', '叶片卷皱发黄,诱发煤污病,马铃薯卷叶病毒', '该虫以刺吸式口器吸食植物汁液，导致叶片卷皱发黄，分泌蜜露诱发煤污病，并传播马铃薯卷叶病毒', '铲除田间、地边杂草，有助于切断蚜虫中间寄主和栖息场所，消灭部分蚜虫。', 5, 2, '/profile/upload/2026/04/12/2ce1aaf6f7c04e859fc63b7f4dfece13.png', NULL, '', '2026-04-09 17:52:57', '', '2026-04-18 17:22:17');
INSERT INTO `crop` VALUES (4, '草莓', 'strawberry', NULL, NULL, NULL, 2, 0, '/profile/upload/2026/04/12/230d2ff19ac3443f97387781d0b7814d.jpg', NULL, '', '2026-04-10 01:56:41', '', '2026-04-12 20:46:39');
INSERT INTO `crop` VALUES (6, '水稻', 'paddy', NULL, NULL, NULL, 3, 0, '/profile/upload/2026/04/12/b02121cf98ba4725a02fffb37459a8fd.png', NULL, '', '2026-04-12 20:58:57', '', NULL);
INSERT INTO `crop` VALUES (7, '稻纵卷叶螟', 'rice leaf roller', '叶片发白、枯死，严重影响水稻的光合作用和产量。', '幼虫会把水稻叶片纵卷成筒状，并在里面啃食叶肉，导致叶片发白、枯死，严重影响水稻的光合作用和产量。', '灭虫', 6, 2, '/profile/upload/2026/04/18/865e7ea5598a4494996d901616131875.jpg', NULL, '', '2026-04-15 22:29:01', '', '2026-04-18 17:27:50');
INSERT INTO `crop` VALUES (8, '麦圆蜘蛛', 'penthaleus major', NULL, '偏好低温潮湿环境，出现在冬春季节的麦田', NULL, 7, 2, '/profile/upload/2026/04/18/1cde01a8b278460a940471c489ae072b.jpg', NULL, '', '2026-04-15 22:38:55', '', '2026-04-18 17:32:19');
INSERT INTO `crop` VALUES (9, '草莓白粉病', 'strawberry powdery mildew', '叶片、叶柄、果实、花萼上出现白色粉状物\n叶片向上卷曲、发黄干枯\n果实染病后布满白粉，停止膨大、变硬畸形，完全失去商品价值\n高湿、闷、不通风环境下爆发极快', 'Podosphaera aphanis 等真菌感染', '控制棚内湿度，加强通风透光\n及时摘除病叶、病果\n药剂可选用：醚菌酯、戊唑醇、腈菌唑等\n发病初期就要及时控，否则整棚快速蔓延', 2, 1, '/profile/upload/2026/04/18/e9a4baaaf83443868107f42adb1ca4c7.png', NULL, '', '2026-04-15 22:39:40', '', '2026-04-18 17:37:04');
INSERT INTO `crop` VALUES (10, '生菜', 'ramosa hort', NULL, NULL, NULL, 8, 0, '/profile/upload/2026/04/18/85bbf8e6087a4179a720f0854a0f70ae.png', NULL, '', '2026-04-18 17:45:41', '', NULL);

-- ----------------------------
-- Table structure for detection_log
-- ----------------------------
DROP TABLE IF EXISTS `detection_log`;
CREATE TABLE `detection_log`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '日志ID',
  `log_type` tinyint(1) NOT NULL DEFAULT 0 COMMENT '检测类型：0-病虫害检测，1-实例分割',
  `detect_type` tinyint(1) NOT NULL DEFAULT 0 COMMENT '检测类型：0-图像检测，1-视频检测',
  `user_id` int NOT NULL COMMENT '操作用户ID（sys_user.user_id）',
  `model_config_id` int NOT NULL COMMENT '使用的模型关联ID（model_config.id）',
  `result_image_path` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '结果（带标注）存储路径',
  `duration_ms` int NULL DEFAULT NULL COMMENT '推理耗时（毫秒）',
  `total_targets` int NOT NULL DEFAULT 0 COMMENT '检测到的目标总数',
  `feedback_status` tinyint(1) NOT NULL DEFAULT 1 COMMENT '用户反馈：1-准确，0-不准确',
  `feedback_text` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '不准确时的原因文本',
  `feedback_time` datetime NULL DEFAULT NULL COMMENT '反馈提交时间',
  `detect_time` datetime NOT NULL COMMENT '检测时间',
  `density_json` json NULL COMMENT '密度数据（JSON格式）',
  `origin_image_path` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '原始文件储存路径',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 25 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '检测日志主表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of detection_log
-- ----------------------------
INSERT INTO `detection_log` VALUES (8, 0, 0, 1, 2, '2026/04/15/279c2907-add3-48b6-9c18-8fd2c1a82d22.jpg', 0, 4, 1, NULL, NULL, '2026-04-15 22:42:54', '{\"cup\": 1, \"bottle\": 1, \"laptop\": 1, \"teddy bear\": 1}', '');
INSERT INTO `detection_log` VALUES (9, 0, 0, 1, 1, '2026/04/15/468ecb1d-ebd2-42ea-87f7-9093474033b7.jpg', 0, 4, 1, NULL, NULL, '2026-04-15 22:43:12', '{\"cup\": 1, \"bottle\": 1, \"laptop\": 1, \"teddy bear\": 1}', '');
INSERT INTO `detection_log` VALUES (10, 0, 0, 1, 1, '2026/04/16/b43bd569-4d80-47c4-bf0a-941ab246d6cd.jpg', 0, 4, 1, NULL, NULL, '2026-04-16 15:45:21', '{\"person\": 4}', '');
INSERT INTO `detection_log` VALUES (11, 0, 0, 1, 1, '2026/04/16/71b1f142-3933-437a-9294-8ecdefbbe03e.jpg', 0, 4, 1, NULL, NULL, '2026-04-16 18:13:08', '{\"cup\": 1, \"bottle\": 1, \"laptop\": 1, \"teddy bear\": 1}', '');
INSERT INTO `detection_log` VALUES (12, 0, 0, 1, 1, '2026/04/16/a3c4e824-a4ca-417a-8ccb-500c39685d88.jpg', 0, 4, 1, NULL, NULL, '2026-04-16 19:25:07', '{\"cup\": 1, \"bottle\": 1, \"laptop\": 1, \"teddy bear\": 1}', '');
INSERT INTO `detection_log` VALUES (13, 0, 0, 1, 1, '2026/04/18/0838bd14-de7e-45a3-abbf-a1d7089d43dd.jpg', 0, 4, 1, NULL, NULL, '2026-04-18 12:54:00', '{\"cup\": 1, \"bottle\": 1, \"laptop\": 1, \"teddy bear\": 1}', NULL);
INSERT INTO `detection_log` VALUES (14, 0, 0, 1, 1, '2026/04/18/619efe24-83c1-43cd-95f8-550d086120c0.jpg', 0, 5, 1, NULL, NULL, '2026-04-18 13:02:29', '{\"cup\": 1, \"book\": 1, \"bottle\": 1, \"laptop\": 1, \"teddy bear\": 1}', NULL);
INSERT INTO `detection_log` VALUES (15, 0, 0, 1, 1, '2026/04/18/78c68f26-2d7c-4ae8-b4d8-dc58b56df2f9.jpg', 0, 6, 1, NULL, NULL, '2026-04-18 13:06:30', '{\"cup\": 1, \"book\": 1, \"bottle\": 1, \"laptop\": 1, \"teddy bear\": 2}', NULL);
INSERT INTO `detection_log` VALUES (16, 0, 0, 1, 1, '2026/04/18/a1996ae5-e452-4643-bed0-5bafa6b071cb.jpg', 0, 6, 1, NULL, NULL, '2026-04-18 13:09:10', '{\"cup\": 1, \"book\": 1, \"bottle\": 1, \"laptop\": 1, \"teddy bear\": 2}', NULL);
INSERT INTO `detection_log` VALUES (17, 0, 0, 1, 1, '2026/04/18/6ed753a8-321b-4c89-9186-0b1ed38b4f3f.jpg', 0, 6, 1, NULL, NULL, '2026-04-18 13:11:25', '{\"cup\": 1, \"book\": 1, \"bottle\": 1, \"laptop\": 1, \"teddy bear\": 2}', NULL);
INSERT INTO `detection_log` VALUES (18, 0, 0, 1, 6, '2026/04/18/f1c8b7db-ca38-45d9-b28c-9a570d772477.jpg', 2, 0, 1, NULL, NULL, '2026-04-18 18:41:47', '{}', NULL);
INSERT INTO `detection_log` VALUES (19, 0, 0, 1, 6, '2026/04/18/fcee27c5-8ff9-427b-a52c-e832dbcbc9f5.jpg', 1, 0, 1, NULL, NULL, '2026-04-18 18:42:47', '{}', NULL);
INSERT INTO `detection_log` VALUES (20, 0, 0, 1, 6, '2026/04/18/898b6dc7-b370-4968-a173-ed16378768d1.jpg', 0, 2, 1, NULL, NULL, '2026-04-18 18:43:31', '{\"person\": 2}', NULL);
INSERT INTO `detection_log` VALUES (21, 0, 0, 1, 6, '2026/04/18/a2b47287-711b-43c0-816f-8a812bb9ebb3.jpg', 1, 2, 1, NULL, NULL, '2026-04-18 18:46:00', '{\"rice leaf roller\": 2}', NULL);
INSERT INTO `detection_log` VALUES (22, 0, 0, 1, 6, '2026/04/18/a900948f-2ebc-4f18-992a-6d5944fd4573.jpg', 0, 0, 1, NULL, NULL, '2026-04-18 18:47:02', '{}', NULL);
INSERT INTO `detection_log` VALUES (23, 0, 0, 1, 6, '2026/04/18/19c0b570-1004-40a5-ae14-53cf76be0622.jpg', 0, 0, 1, NULL, NULL, '2026-04-18 18:47:05', '{}', NULL);
INSERT INTO `detection_log` VALUES (24, 0, 0, 1, 6, '2026/04/18/54872e92-3765-4ac5-806a-238aeaad6699.jpg', 0, 1, 1, NULL, NULL, '2026-04-18 18:47:30', '{\"Ceroplastes rubens\": 1}', NULL);

-- ----------------------------
-- Table structure for detection_log_detail
-- ----------------------------
DROP TABLE IF EXISTS `detection_log_detail`;
CREATE TABLE `detection_log_detail`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '详情ID',
  `log_id` int NOT NULL COMMENT '所属日志ID（detection_log.id）',
  `label` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '类别名称（模型输出标签）',
  `conf` decimal(5, 4) NOT NULL COMMENT '置信度（0-1）',
  `location_json` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '位置信息（JSON格式：检测任务存[x1,y1,x2,y2]；分割任务存多边形点集数组）',
  `linked_encyclopedia` int NULL DEFAULT NULL COMMENT '关联crop表ID（corp.id）',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 69 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '检测日志详情表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of detection_log_detail
-- ----------------------------
INSERT INTO `detection_log_detail` VALUES (17, 8, 'laptop', 0.9432, '{\"x1\":1.96,\"y1\":264.18,\"x2\":1009.68,\"y2\":1236.18}', 7);
INSERT INTO `detection_log_detail` VALUES (18, 8, 'bottle', 0.7043, '{\"x1\":1449.3,\"y1\":492.47,\"x2\":1584.92,\"y2\":706.01}', 8);
INSERT INTO `detection_log_detail` VALUES (19, 8, 'teddy bear', 0.6696, '{\"x1\":1008.84,\"y1\":609.34,\"x2\":1224.37,\"y2\":883.25}', 9);
INSERT INTO `detection_log_detail` VALUES (20, 8, 'cup', 0.5820, '{\"x1\":907.58,\"y1\":596.62,\"x2\":975.59,\"y2\":729.23}', NULL);
INSERT INTO `detection_log_detail` VALUES (21, 9, 'laptop', 0.9432, '{\"x1\":1.96,\"y1\":264.18,\"x2\":1009.68,\"y2\":1236.18}', 7);
INSERT INTO `detection_log_detail` VALUES (22, 9, 'bottle', 0.7043, '{\"x1\":1449.3,\"y1\":492.47,\"x2\":1584.92,\"y2\":706.01}', 8);
INSERT INTO `detection_log_detail` VALUES (23, 9, 'teddy bear', 0.6696, '{\"x1\":1008.84,\"y1\":609.34,\"x2\":1224.37,\"y2\":883.25}', 9);
INSERT INTO `detection_log_detail` VALUES (24, 9, 'cup', 0.5820, '{\"x1\":907.58,\"y1\":596.62,\"x2\":975.59,\"y2\":729.23}', NULL);
INSERT INTO `detection_log_detail` VALUES (25, 10, 'person', 0.8900, '{\"x1\":945.92,\"y1\":221.1,\"x2\":1398.29,\"y2\":1314.15}', NULL);
INSERT INTO `detection_log_detail` VALUES (26, 10, 'person', 0.8737, '{\"x1\":228.44,\"y1\":334.91,\"x2\":714.37,\"y2\":1311.49}', NULL);
INSERT INTO `detection_log_detail` VALUES (27, 10, 'person', 0.8552, '{\"x1\":1314.74,\"y1\":268.12,\"x2\":1926.03,\"y2\":1310.34}', NULL);
INSERT INTO `detection_log_detail` VALUES (28, 10, 'person', 0.7672, '{\"x1\":596.91,\"y1\":324.71,\"x2\":1001.55,\"y2\":1311.85}', NULL);
INSERT INTO `detection_log_detail` VALUES (29, 11, 'laptop', 0.9432, '{\"x1\":1.96,\"y1\":264.18,\"x2\":1009.68,\"y2\":1236.18}', 7);
INSERT INTO `detection_log_detail` VALUES (30, 11, 'bottle', 0.7043, '{\"x1\":1449.3,\"y1\":492.47,\"x2\":1584.92,\"y2\":706.01}', 8);
INSERT INTO `detection_log_detail` VALUES (31, 11, 'teddy bear', 0.6696, '{\"x1\":1008.84,\"y1\":609.34,\"x2\":1224.37,\"y2\":883.25}', 9);
INSERT INTO `detection_log_detail` VALUES (32, 11, 'cup', 0.5820, '{\"x1\":907.58,\"y1\":596.62,\"x2\":975.59,\"y2\":729.23}', NULL);
INSERT INTO `detection_log_detail` VALUES (33, 12, 'laptop', 0.9432, '{\"x1\":1.96,\"y1\":264.18,\"x2\":1009.68,\"y2\":1236.18}', 7);
INSERT INTO `detection_log_detail` VALUES (34, 12, 'bottle', 0.7043, '{\"x1\":1449.3,\"y1\":492.47,\"x2\":1584.92,\"y2\":706.01}', 8);
INSERT INTO `detection_log_detail` VALUES (35, 12, 'teddy bear', 0.6696, '{\"x1\":1008.84,\"y1\":609.34,\"x2\":1224.37,\"y2\":883.25}', 9);
INSERT INTO `detection_log_detail` VALUES (36, 12, 'cup', 0.5820, '{\"x1\":907.58,\"y1\":596.62,\"x2\":975.59,\"y2\":729.23}', NULL);
INSERT INTO `detection_log_detail` VALUES (37, 13, 'laptop', 0.9432, '{\"x1\":1.96,\"y1\":264.18,\"x2\":1009.68,\"y2\":1236.18}', 7);
INSERT INTO `detection_log_detail` VALUES (38, 13, 'bottle', 0.7043, '{\"x1\":1449.3,\"y1\":492.47,\"x2\":1584.92,\"y2\":706.01}', 8);
INSERT INTO `detection_log_detail` VALUES (39, 13, 'teddy bear', 0.6696, '{\"x1\":1008.84,\"y1\":609.34,\"x2\":1224.37,\"y2\":883.25}', 9);
INSERT INTO `detection_log_detail` VALUES (40, 13, 'cup', 0.5820, '{\"x1\":907.58,\"y1\":596.62,\"x2\":975.59,\"y2\":729.23}', NULL);
INSERT INTO `detection_log_detail` VALUES (41, 14, 'laptop', 0.9432, '{\"x1\":1.96,\"y1\":264.18,\"x2\":1009.68,\"y2\":1236.18}', 7);
INSERT INTO `detection_log_detail` VALUES (42, 14, 'bottle', 0.7043, '{\"x1\":1449.3,\"y1\":492.47,\"x2\":1584.92,\"y2\":706.01}', 8);
INSERT INTO `detection_log_detail` VALUES (43, 14, 'teddy bear', 0.6696, '{\"x1\":1008.84,\"y1\":609.34,\"x2\":1224.37,\"y2\":883.25}', 9);
INSERT INTO `detection_log_detail` VALUES (44, 14, 'cup', 0.5820, '{\"x1\":907.58,\"y1\":596.62,\"x2\":975.59,\"y2\":729.23}', NULL);
INSERT INTO `detection_log_detail` VALUES (45, 14, 'book', 0.4754, '{\"x1\":959.55,\"y1\":862.02,\"x2\":1612.89,\"y2\":1125.9}', NULL);
INSERT INTO `detection_log_detail` VALUES (46, 15, 'laptop', 0.9432, '{\"x1\":1.96,\"y1\":264.18,\"x2\":1009.68,\"y2\":1236.18}', 7);
INSERT INTO `detection_log_detail` VALUES (47, 15, 'bottle', 0.7043, '{\"x1\":1449.3,\"y1\":492.47,\"x2\":1584.92,\"y2\":706.01}', 8);
INSERT INTO `detection_log_detail` VALUES (48, 15, 'teddy bear', 0.6696, '{\"x1\":1008.84,\"y1\":609.34,\"x2\":1224.37,\"y2\":883.25}', 9);
INSERT INTO `detection_log_detail` VALUES (49, 15, 'cup', 0.5820, '{\"x1\":907.58,\"y1\":596.62,\"x2\":975.59,\"y2\":729.23}', NULL);
INSERT INTO `detection_log_detail` VALUES (50, 15, 'book', 0.4754, '{\"x1\":959.55,\"y1\":862.02,\"x2\":1612.89,\"y2\":1125.9}', NULL);
INSERT INTO `detection_log_detail` VALUES (51, 15, 'teddy bear', 0.4366, '{\"x1\":1328.91,\"y1\":644.36,\"x2\":1556.39,\"y2\":946.46}', 9);
INSERT INTO `detection_log_detail` VALUES (52, 16, 'laptop', 0.9432, '{\"x1\":1.96,\"y1\":264.18,\"x2\":1009.68,\"y2\":1236.18}', 7);
INSERT INTO `detection_log_detail` VALUES (53, 16, 'bottle', 0.7043, '{\"x1\":1449.3,\"y1\":492.47,\"x2\":1584.92,\"y2\":706.01}', 8);
INSERT INTO `detection_log_detail` VALUES (54, 16, 'teddy bear', 0.6696, '{\"x1\":1008.84,\"y1\":609.34,\"x2\":1224.37,\"y2\":883.25}', 9);
INSERT INTO `detection_log_detail` VALUES (55, 16, 'cup', 0.5820, '{\"x1\":907.58,\"y1\":596.62,\"x2\":975.59,\"y2\":729.23}', NULL);
INSERT INTO `detection_log_detail` VALUES (56, 16, 'book', 0.4754, '{\"x1\":959.55,\"y1\":862.02,\"x2\":1612.89,\"y2\":1125.9}', NULL);
INSERT INTO `detection_log_detail` VALUES (57, 16, 'teddy bear', 0.4366, '{\"x1\":1328.91,\"y1\":644.36,\"x2\":1556.39,\"y2\":946.46}', 9);
INSERT INTO `detection_log_detail` VALUES (58, 17, 'laptop', 0.9432, '{\"x1\":1.96,\"y1\":264.18,\"x2\":1009.68,\"y2\":1236.18}', 7);
INSERT INTO `detection_log_detail` VALUES (59, 17, 'bottle', 0.7043, '{\"x1\":1449.3,\"y1\":492.47,\"x2\":1584.92,\"y2\":706.01}', 8);
INSERT INTO `detection_log_detail` VALUES (60, 17, 'teddy bear', 0.6696, '{\"x1\":1008.84,\"y1\":609.34,\"x2\":1224.37,\"y2\":883.25}', 9);
INSERT INTO `detection_log_detail` VALUES (61, 17, 'cup', 0.5820, '{\"x1\":907.58,\"y1\":596.62,\"x2\":975.59,\"y2\":729.23}', NULL);
INSERT INTO `detection_log_detail` VALUES (62, 17, 'book', 0.4754, '{\"x1\":959.55,\"y1\":862.02,\"x2\":1612.89,\"y2\":1125.9}', NULL);
INSERT INTO `detection_log_detail` VALUES (63, 17, 'teddy bear', 0.4366, '{\"x1\":1328.91,\"y1\":644.36,\"x2\":1556.39,\"y2\":946.46}', 9);
INSERT INTO `detection_log_detail` VALUES (64, 20, 'person', 0.6573, '{\"x1\":52.37,\"y1\":50.57,\"x2\":208.26,\"y2\":219.46}', NULL);
INSERT INTO `detection_log_detail` VALUES (65, 20, 'person', 0.5541, '{\"x1\":206.33,\"y1\":64.54,\"x2\":361.86,\"y2\":229.08}', NULL);
INSERT INTO `detection_log_detail` VALUES (66, 21, 'rice leaf roller', 0.6573, '{\"x1\":52.37,\"y1\":50.57,\"x2\":208.26,\"y2\":219.46}', 7);
INSERT INTO `detection_log_detail` VALUES (67, 21, 'rice leaf roller', 0.5541, '{\"x1\":206.33,\"y1\":64.54,\"x2\":361.86,\"y2\":229.08}', 7);
INSERT INTO `detection_log_detail` VALUES (68, 24, 'Ceroplastes rubens', 0.4090, '{\"x1\":364.01,\"y1\":109.05,\"x2\":490.58,\"y2\":226.41}', NULL);

-- ----------------------------
-- Table structure for farm_plot
-- ----------------------------
DROP TABLE IF EXISTS `farm_plot`;
CREATE TABLE `farm_plot`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '片区ID',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '片区名称',
  `location` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '地理位置（经纬度或文字描述）',
  `area` decimal(10, 2) NULL DEFAULT NULL COMMENT '面积（公顷）',
  `manager_id` int NULL DEFAULT NULL COMMENT '管理者',
  `plot_type_id` int NOT NULL COMMENT '片区类型(plot_type.id)',
  `status` tinyint(1) NOT NULL DEFAULT 1 COMMENT '状态：0-停用，1-启用, 2-异常',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `max_lng` decimal(10, 6) NULL DEFAULT NULL COMMENT '最大经度',
  `min_lng` decimal(10, 6) NULL DEFAULT NULL COMMENT '最小经度',
  `max_lat` decimal(10, 6) NULL DEFAULT NULL COMMENT '最大纬度',
  `min_lat` decimal(10, 6) NULL DEFAULT NULL COMMENT '最小纬度',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '片区信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of farm_plot
-- ----------------------------
INSERT INTO `farm_plot` VALUES (1, '1号温室', '农小智农场1号温室', 92.58, 100, 1, 2, NULL, '', NULL, '', '2026-06-13 00:40:38', 113.109009, 113.100000, 22.709009, 22.700000);
INSERT INTO `farm_plot` VALUES (2, '2号温室', '农小智农场2号温室', 79.78, 101, 1, 1, NULL, '', '2026-04-10 00:18:52', '', '2026-06-13 00:36:24', 116.678747, 116.670000, 23.368035, 23.360000);
INSERT INTO `farm_plot` VALUES (3, '露天草莓园', '农小智农场露天草莓园', 30.00, 100, 2, 1, NULL, '', '2026-04-10 15:54:12', '', '2026-04-18 17:41:06', NULL, NULL, NULL, NULL);
INSERT INTO `farm_plot` VALUES (4, '金黄稻田', '农小智粮食研究基地', 100.00, 102, 2, 0, NULL, '', '2026-04-10 20:25:22', '', '2026-06-13 12:43:29', NULL, NULL, NULL, NULL);

-- ----------------------------
-- Table structure for gen_table
-- ----------------------------
DROP TABLE IF EXISTS `gen_table`;
CREATE TABLE `gen_table`  (
  `table_id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `table_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '表名称',
  `table_comment` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '表描述',
  `sub_table_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '关联子表的表名',
  `sub_table_fk_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '子表关联的外键名',
  `class_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '实体类名称',
  `tpl_category` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'crud' COMMENT '使用的模板（crud单表操作 tree树表操作）',
  `tpl_web_type` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '前端模板类型（element-ui模版 element-plus模版）',
  `package_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '生成包路径',
  `module_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '生成模块名',
  `business_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '生成业务名',
  `function_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '生成功能名',
  `function_author` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '生成功能作者',
  `form_col_num` int NULL DEFAULT 1 COMMENT '表单布局（单列 双列 三列）',
  `gen_type` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '生成代码方式（0zip压缩包 1自定义路径）',
  `gen_path` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '/' COMMENT '生成路径（不填默认项目路径）',
  `options` varchar(1000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '其它生成选项',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`table_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 26 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '代码生成业务表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of gen_table
-- ----------------------------
INSERT INTO `gen_table` VALUES (4, 'crop', '农作物信息表', NULL, NULL, 'Crop', 'crud', 'element-plus', 'com.agriSmart.crop', 'crop', 'crop', '农作物信息', '羊离子', 1, '0', '/', '{\"parentMenuId\":2006}', 'admin', '2026-04-09 16:13:32', '', '2026-04-09 17:06:37', NULL);
INSERT INTO `gen_table` VALUES (6, 'variety', '农作物品种表', NULL, NULL, 'Variety', 'crud', 'element-plus', 'com.agriSmart.crop', 'crop', 'variety', '农作物品种', '羊离子', 1, '0', '/', '{\"parentMenuId\":2006}', 'admin', '2026-04-09 17:06:03', '', '2026-04-09 17:07:57', NULL);
INSERT INTO `gen_table` VALUES (7, 'farm_plot', '片区信息表', 'alert_threshold', 'plot_id', 'FarmPlot', 'sub', 'element-plus', 'com.agriSmart.plot', 'plot', 'plot', '片区信息', '羊离子', 1, '0', '/', '{\"parentMenuId\":2019}', 'admin', '2026-04-09 22:15:15', '', '2026-04-13 21:08:54', NULL);
INSERT INTO `gen_table` VALUES (8, 'plot_crop', '片区与农作物关联表', NULL, NULL, 'PlotCrop', 'crud', 'element-plus', 'com.agriSmart.system', 'system', 'crop', '片区与农作物关联', 'ruoyi', 1, '0', '/', NULL, 'admin', '2026-04-09 22:23:17', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (10, 'plot_type', '片区类型', NULL, NULL, 'PlotType', 'crud', 'element-plus', 'com.agriSmart.plot', 'plot', 'type', '片区类型', '羊离子', 1, '0', '/', '{\"parentMenuId\":2019}', 'admin', '2026-04-09 22:47:30', '', '2026-04-09 22:49:09', NULL);
INSERT INTO `gen_table` VALUES (12, 'model_config', '模型配置表', NULL, NULL, 'ModelConfig', 'crud', 'element-plus', 'com.agriSmart.model', 'model', 'config', '模型配置', '羊离子', 1, '0', '/', '{\"parentMenuId\":2038}', 'admin', '2026-04-12 23:45:42', '', '2026-04-13 00:17:11', NULL);
INSERT INTO `gen_table` VALUES (14, 'alert_threshold', '预警阈值配置表', NULL, NULL, 'AlertThreshold', 'crud', 'element-plus', 'com.agriSmart.alert', 'alert', 'threshold', '预警阈值配置', '羊离子', 1, '0', '/', '{\"parentMenuId\":2045}', 'admin', '2026-04-13 21:21:06', '', '2026-04-13 21:36:37', NULL);
INSERT INTO `gen_table` VALUES (15, 'alert_type', '预警阈值类型表', NULL, NULL, 'AlertType', 'crud', 'element-plus', 'com.agriSmart.alert', 'alert', 'type', '预警阈值类型', '羊离子', 1, '0', '/', '{\"parentMenuId\":2045}', 'admin', '2026-04-13 21:21:06', '', '2026-04-13 21:46:49', NULL);
INSERT INTO `gen_table` VALUES (16, 'plot_env_realtime', '片区环境实时数据表', NULL, NULL, 'PlotEnvRealtime', 'crud', 'element-plus', 'com.agriSmart.plot', 'plot', 'realtime', '片区环境实时数据', '羊离子', 1, '0', '/', '{\"parentMenuId\":2019}', 'admin', '2026-04-13 22:55:16', '', '2026-04-13 23:00:39', NULL);
INSERT INTO `gen_table` VALUES (17, 'alert_history', '预警历史记录表', NULL, NULL, 'AlertHistory', 'crud', 'element-plus', 'com.agriSmart.alert', 'alert', 'history', '预警历史记录', '羊离子', 1, '0', '/', '{\"parentMenuId\":2045}', 'admin', '2026-04-15 00:57:34', '', '2026-04-15 01:33:33', NULL);
INSERT INTO `gen_table` VALUES (21, 'detection_log', '检测日志主表', 'detection_log_detail', 'log_id', 'DetectionLog', 'sub', 'element-plus', 'com.agriSmart.model', 'model', 'log', '检测日志', '羊离子', 1, '0', '/', '{\"parentMenuId\":2065}', 'admin', '2026-04-15 17:09:57', '', '2026-04-15 17:26:58', NULL);
INSERT INTO `gen_table` VALUES (22, 'detection_log_detail', '检测日志详情表', NULL, NULL, 'DetectionLogDetail', 'crud', 'element-plus', 'com.agriSmart.system', 'system', 'detail', '检测日志详情', 'ruoyi', 1, '0', '/', NULL, 'admin', '2026-04-15 17:09:57', '', NULL, NULL);
INSERT INTO `gen_table` VALUES (23, 'monitor', '监控管理表', NULL, NULL, 'Monitor', 'crud', 'element-plus', 'com.agriSmart.monitor', 'monitor', 'manage', '监控管理', '羊离子', 1, '0', '/', '{\"parentMenuId\":2073}', 'admin', '2026-06-13 12:48:36', '', '2026-06-13 12:55:25', NULL);
INSERT INTO `gen_table` VALUES (25, 'monitor_job', '监控任务表', NULL, NULL, 'MonitorJob', 'crud', 'element-plus', 'com.agriSmart.monitor', 'monitor', 'job', '监控任务', '羊离子', 1, '0', '/', '{\"parentMenuId\":2073}', 'admin', '2026-06-13 15:11:01', '', '2026-06-13 15:13:31', NULL);

-- ----------------------------
-- Table structure for gen_table_column
-- ----------------------------
DROP TABLE IF EXISTS `gen_table_column`;
CREATE TABLE `gen_table_column`  (
  `column_id` bigint NOT NULL AUTO_INCREMENT COMMENT '编号',
  `table_id` bigint NULL DEFAULT NULL COMMENT '归属表编号',
  `column_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '列名称',
  `column_comment` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '列描述',
  `column_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '列类型',
  `java_type` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'JAVA类型',
  `java_field` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT 'JAVA字段名',
  `is_pk` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '是否主键（1是）',
  `is_increment` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '是否自增（1是）',
  `is_required` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '是否必填（1是）',
  `is_insert` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '是否为插入字段（1是）',
  `is_edit` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '是否编辑字段（1是）',
  `is_list` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '是否列表字段（1是）',
  `is_query` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '是否查询字段（1是）',
  `query_type` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'EQ' COMMENT '查询方式（等于、不等于、大于、小于、范围）',
  `html_type` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '显示类型（文本框、文本域、下拉框、复选框、单选框、日期控件）',
  `dict_type` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '字典类型',
  `sort` int NULL DEFAULT NULL COMMENT '排序',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`column_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 217 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '代码生成业务表字段' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of gen_table_column
-- ----------------------------
INSERT INTO `gen_table_column` VALUES (32, 4, 'id', '主键', 'int', 'Long', 'id', '1', '1', '0', '0', NULL, '1', NULL, 'EQ', 'input', '', 1, 'admin', '2026-04-09 16:13:32', '', '2026-04-09 17:06:37');
INSERT INTO `gen_table_column` VALUES (33, 4, 'name', '农作物名称', 'varchar(100)', 'String', 'name', '0', '0', '1', '1', '1', '1', '1', 'LIKE', 'input', '', 2, 'admin', '2026-04-09 16:13:32', '', '2026-04-09 17:06:37');
INSERT INTO `gen_table_column` VALUES (34, 4, 'alias', '别名', 'varchar(100)', 'String', 'alias', '0', '0', '0', '1', '1', '1', '1', 'LIKE', 'input', '', 3, 'admin', '2026-04-09 16:13:32', '', '2026-04-09 17:06:37');
INSERT INTO `gen_table_column` VALUES (35, 4, 'symptoms', '症状描述', 'text', 'String', 'symptoms', '0', '0', '0', '1', '1', '0', '0', 'EQ', 'textarea', '', 4, 'admin', '2026-04-09 16:13:32', '', '2026-04-09 17:06:37');
INSERT INTO `gen_table_column` VALUES (36, 4, 'causes', '病因描述', 'text', 'String', 'causes', '0', '0', '0', '1', '1', '0', '0', 'EQ', 'textarea', '', 5, 'admin', '2026-04-09 16:13:32', '', '2026-04-09 17:06:37');
INSERT INTO `gen_table_column` VALUES (37, 4, 'prevention', '防治方法', 'text', 'String', 'prevention', '0', '0', '0', '1', '1', '0', '0', 'EQ', 'textarea', '', 6, 'admin', '2026-04-09 16:13:32', '', '2026-04-09 17:06:37');
INSERT INTO `gen_table_column` VALUES (38, 4, 'variety_id', '品种 variety.id', 'int', 'Long', 'varietyId', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 7, 'admin', '2026-04-09 16:13:32', '', '2026-04-09 17:06:37');
INSERT INTO `gen_table_column` VALUES (39, 4, 'status', '状态', 'tinyint(1)', 'Integer', 'status', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'select', 'crop_status', 8, 'admin', '2026-04-09 16:13:32', '', '2026-04-09 17:06:37');
INSERT INTO `gen_table_column` VALUES (40, 4, 'images', '图片路径（多张用逗号分隔）', 'varchar(2000)', 'String', 'images', '0', '0', '0', '1', '1', '1', '0', 'EQ', 'imageUpload', '', 9, 'admin', '2026-04-09 16:13:32', '', '2026-04-09 17:06:37');
INSERT INTO `gen_table_column` VALUES (41, 4, 'remark', '备注', 'varchar(500)', 'String', 'remark', '0', '0', '0', '0', '0', '0', NULL, 'EQ', 'textarea', '', 10, 'admin', '2026-04-09 16:13:32', '', '2026-04-09 17:06:37');
INSERT INTO `gen_table_column` VALUES (42, 4, 'create_by', '创建者', 'varchar(64)', 'String', 'createBy', '0', '0', '0', '0', '0', NULL, NULL, 'EQ', 'input', '', 11, 'admin', '2026-04-09 16:13:32', '', '2026-04-09 17:06:37');
INSERT INTO `gen_table_column` VALUES (43, 4, 'create_time', '创建时间', 'datetime', 'Date', 'createTime', '0', '0', '0', '0', NULL, NULL, NULL, 'EQ', 'datetime', '', 12, 'admin', '2026-04-09 16:13:32', '', '2026-04-09 17:06:37');
INSERT INTO `gen_table_column` VALUES (44, 4, 'update_by', '更新者', 'varchar(64)', 'String', 'updateBy', '0', '0', '0', '0', '0', NULL, NULL, 'EQ', 'input', '', 13, 'admin', '2026-04-09 16:13:32', '', '2026-04-09 17:06:37');
INSERT INTO `gen_table_column` VALUES (45, 4, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '0', '0', '1', '1', 'BETWEEN', 'datetime', '', 14, 'admin', '2026-04-09 16:13:32', '', '2026-04-09 17:06:37');
INSERT INTO `gen_table_column` VALUES (49, 6, 'id', '品种ID', 'int', 'Long', 'id', '1', '1', '0', '0', NULL, '1', NULL, 'EQ', 'input', '', 1, 'admin', '2026-04-09 17:06:03', '', '2026-04-09 17:07:57');
INSERT INTO `gen_table_column` VALUES (50, 6, 'name', '品种名称', 'varchar(100)', 'String', 'name', '0', '0', '1', '1', '1', '1', '1', 'LIKE', 'input', '', 2, 'admin', '2026-04-09 17:06:03', '', '2026-04-09 17:07:57');
INSERT INTO `gen_table_column` VALUES (51, 6, 'remark', '备注', 'varchar(500)', 'String', 'remark', '0', '0', '0', '1', '1', '0', NULL, 'EQ', 'textarea', '', 3, 'admin', '2026-04-09 17:06:03', '', '2026-04-09 17:07:57');
INSERT INTO `gen_table_column` VALUES (52, 6, 'create_by', '创建者', 'varchar(64)', 'String', 'createBy', '0', '0', '0', '0', NULL, NULL, NULL, 'EQ', 'input', '', 4, 'admin', '2026-04-09 17:06:03', '', '2026-04-09 17:07:57');
INSERT INTO `gen_table_column` VALUES (53, 6, 'create_time', '创建时间', 'datetime', 'Date', 'createTime', '0', '0', '0', '0', '0', '1', NULL, 'EQ', 'datetime', '', 5, 'admin', '2026-04-09 17:06:03', '', '2026-04-09 17:07:57');
INSERT INTO `gen_table_column` VALUES (54, 6, 'update_by', '更新者', 'varchar(64)', 'String', 'updateBy', '0', '0', '0', '0', '0', NULL, NULL, 'EQ', 'input', '', 6, 'admin', '2026-04-09 17:06:03', '', '2026-04-09 17:07:57');
INSERT INTO `gen_table_column` VALUES (55, 6, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '0', '0', '1', NULL, 'EQ', 'datetime', '', 7, 'admin', '2026-04-09 17:06:03', '', '2026-04-09 17:07:57');
INSERT INTO `gen_table_column` VALUES (56, 7, 'id', '片区ID', 'int', 'Long', 'id', '1', '1', '0', '0', NULL, '1', NULL, 'EQ', 'input', '', 1, 'admin', '2026-04-09 22:15:15', '', '2026-04-13 21:08:54');
INSERT INTO `gen_table_column` VALUES (57, 7, 'name', '片区名称', 'varchar(100)', 'String', 'name', '0', '0', '1', '1', '1', '1', '1', 'LIKE', 'input', '', 2, 'admin', '2026-04-09 22:15:15', '', '2026-04-13 21:08:54');
INSERT INTO `gen_table_column` VALUES (58, 7, 'location', '地理位置（经纬度或文字描述）', 'varchar(255)', 'String', 'location', '0', '0', '1', '1', '1', '1', '0', 'EQ', 'input', '', 3, 'admin', '2026-04-09 22:15:15', '', '2026-04-13 21:08:54');
INSERT INTO `gen_table_column` VALUES (59, 7, 'area', '面积（亩）', 'decimal(10,2)', 'BigDecimal', 'area', '0', '0', '1', '1', '1', '1', '0', 'EQ', 'input', '', 4, 'admin', '2026-04-09 22:15:15', '', '2026-04-13 21:08:54');
INSERT INTO `gen_table_column` VALUES (60, 7, 'manager_id', '管理者', 'int', 'Long', 'managerId', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 5, 'admin', '2026-04-09 22:15:15', '', '2026-04-13 21:08:54');
INSERT INTO `gen_table_column` VALUES (61, 7, 'plot_type_id', '片区类型(plot_type.id)', 'int', 'Long', 'plotTypeId', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 6, 'admin', '2026-04-09 22:15:15', '', '2026-04-13 21:08:54');
INSERT INTO `gen_table_column` VALUES (62, 7, 'status', '状态', 'tinyint(1)', 'Integer', 'status', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'radio', 'plot_status', 7, 'admin', '2026-04-09 22:15:15', '', '2026-04-13 21:08:54');
INSERT INTO `gen_table_column` VALUES (63, 7, 'remark', '备注', 'varchar(500)', 'String', 'remark', '0', '0', '0', '1', '1', '0', NULL, 'EQ', 'textarea', '', 8, 'admin', '2026-04-09 22:15:15', '', '2026-04-13 21:08:54');
INSERT INTO `gen_table_column` VALUES (64, 7, 'create_by', '创建者', 'varchar(64)', 'String', 'createBy', '0', '0', '0', '0', NULL, NULL, NULL, 'EQ', 'input', '', 9, 'admin', '2026-04-09 22:15:15', '', '2026-04-13 21:08:54');
INSERT INTO `gen_table_column` VALUES (65, 7, 'create_time', '创建时间', 'datetime', 'Date', 'createTime', '0', '0', '0', '0', NULL, NULL, NULL, 'EQ', 'datetime', '', 10, 'admin', '2026-04-09 22:15:15', '', '2026-04-13 21:08:54');
INSERT INTO `gen_table_column` VALUES (66, 7, 'update_by', '更新者', 'varchar(64)', 'String', 'updateBy', '0', '0', '0', '0', '0', NULL, NULL, 'EQ', 'input', '', 11, 'admin', '2026-04-09 22:15:15', '', '2026-04-13 21:08:54');
INSERT INTO `gen_table_column` VALUES (67, 7, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '0', '0', NULL, NULL, 'EQ', 'datetime', '', 12, 'admin', '2026-04-09 22:15:15', '', '2026-04-13 21:08:54');
INSERT INTO `gen_table_column` VALUES (68, 8, 'id', 'ID', 'int', 'Long', 'id', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2026-04-09 22:23:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (69, 8, 'plot_id', '片区ID（farm_plot.id）', 'int', 'Long', 'plotId', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2026-04-09 22:23:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (70, 8, 'crop_id', '农作物ID（crop.id）', 'int', 'Long', 'cropId', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2026-04-09 22:23:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (71, 8, 'nums', '数量', 'int', 'Long', 'nums', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 4, 'admin', '2026-04-09 22:23:17', '', NULL);
INSERT INTO `gen_table_column` VALUES (74, 10, 'id', '片区类型ID', 'int', 'Long', 'id', '1', '1', '0', '0', NULL, '1', NULL, 'EQ', 'input', '', 1, 'admin', '2026-04-09 22:47:30', '', '2026-04-09 22:49:09');
INSERT INTO `gen_table_column` VALUES (75, 10, 'name', '片区类型名称', 'varchar(100)', 'String', 'name', '0', '0', '1', '1', '1', '1', '1', 'LIKE', 'input', '', 2, 'admin', '2026-04-09 22:47:30', '', '2026-04-09 22:49:09');
INSERT INTO `gen_table_column` VALUES (76, 10, 'remark', '备注', 'varchar(500)', 'String', 'remark', '0', '0', '0', '1', '1', '0', NULL, 'EQ', 'textarea', '', 3, 'admin', '2026-04-09 22:47:30', '', '2026-04-09 22:49:09');
INSERT INTO `gen_table_column` VALUES (77, 10, 'create_by', '创建者', 'varchar(64)', 'String', 'createBy', '0', '0', '0', '0', NULL, NULL, NULL, 'EQ', 'input', '', 4, 'admin', '2026-04-09 22:47:30', '', '2026-04-09 22:49:09');
INSERT INTO `gen_table_column` VALUES (78, 10, 'create_time', '创建时间', 'datetime', 'Date', 'createTime', '0', '0', '0', '0', '0', '1', NULL, 'EQ', 'datetime', '', 5, 'admin', '2026-04-09 22:47:30', '', '2026-04-09 22:49:09');
INSERT INTO `gen_table_column` VALUES (79, 10, 'update_by', '更新者', 'varchar(64)', 'String', 'updateBy', '0', '0', '0', '0', '0', NULL, NULL, 'EQ', 'input', '', 6, 'admin', '2026-04-09 22:47:30', '', '2026-04-09 22:49:09');
INSERT INTO `gen_table_column` VALUES (80, 10, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '0', '0', '1', NULL, 'EQ', 'datetime', '', 7, 'admin', '2026-04-09 22:47:30', '', '2026-04-09 22:49:09');
INSERT INTO `gen_table_column` VALUES (89, 12, 'id', 'ID', 'int', 'Long', 'id', '1', '1', '0', '0', NULL, '1', NULL, 'EQ', 'input', '', 1, 'admin', '2026-04-12 23:45:42', '', '2026-04-13 00:17:11');
INSERT INTO `gen_table_column` VALUES (90, 12, 'model_name', '模型显示名称', 'varchar(100)', 'String', 'modelName', '0', '0', '1', '1', '1', '1', '1', 'LIKE', 'input', '', 2, 'admin', '2026-04-12 23:45:42', '', '2026-04-13 00:17:11');
INSERT INTO `gen_table_column` VALUES (91, 12, 'model_type', '模型类型', 'tinyint(1)', 'Integer', 'modelType', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'select', 'model_type', 3, 'admin', '2026-04-12 23:45:42', '', '2026-04-13 00:17:11');
INSERT INTO `gen_table_column` VALUES (92, 12, 'version', '版本号', 'varchar(50)', 'String', 'version', '0', '0', '1', '1', '1', '1', '0', 'EQ', 'input', '', 4, 'admin', '2026-04-12 23:45:42', '', '2026-04-13 00:17:11');
INSERT INTO `gen_table_column` VALUES (93, 12, 'file_path', '模型文件路径', 'varchar(500)', 'String', 'filePath', '0', '0', '1', '1', '1', '1', '0', 'EQ', 'input', '', 5, 'admin', '2026-04-12 23:45:42', '', '2026-04-13 00:17:11');
INSERT INTO `gen_table_column` VALUES (94, 12, 'is_active', '状态', 'tinyint(1)', 'Integer', 'isActive', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'radio', 'model_status', 6, 'admin', '2026-04-12 23:45:42', '', '2026-04-13 00:17:11');
INSERT INTO `gen_table_column` VALUES (95, 12, 'remark', '备注', 'varchar(500)', 'String', 'remark', '0', '0', '0', '1', '1', '0', NULL, 'EQ', 'textarea', '', 7, 'admin', '2026-04-12 23:45:42', '', '2026-04-13 00:17:11');
INSERT INTO `gen_table_column` VALUES (96, 12, 'create_time', '创建时间', 'datetime', 'Date', 'createTime', '0', '0', '0', '0', NULL, NULL, NULL, 'EQ', 'datetime', '', 8, 'admin', '2026-04-12 23:45:42', '', '2026-04-13 00:17:11');
INSERT INTO `gen_table_column` VALUES (97, 12, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '0', '0', NULL, NULL, 'EQ', 'datetime', '', 9, 'admin', '2026-04-12 23:45:42', '', '2026-04-13 00:17:11');
INSERT INTO `gen_table_column` VALUES (106, 14, 'id', 'ID', 'int', 'Long', 'id', '1', '1', '0', '0', NULL, '1', NULL, 'EQ', 'input', '', 1, 'admin', '2026-04-13 21:21:06', '', '2026-04-13 21:36:37');
INSERT INTO `gen_table_column` VALUES (107, 14, 'plot_id', '片区', 'int', 'Long', 'plotId', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2026-04-13 21:21:06', '', '2026-04-13 21:36:37');
INSERT INTO `gen_table_column` VALUES (108, 14, 'alert_type_id', '预警类型', 'int', 'Long', 'alertTypeId', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'select', 'alert_threshold_status', 3, 'admin', '2026-04-13 21:21:06', '', '2026-04-13 21:36:37');
INSERT INTO `gen_table_column` VALUES (109, 14, 'min_value', '下限阈值（低于此值触发预警，可为空）', 'decimal(10,2)', 'BigDecimal', 'minValue', '0', '0', '0', '1', '1', '1', '0', 'EQ', 'input', '', 4, 'admin', '2026-04-13 21:21:06', '', '2026-04-13 21:36:37');
INSERT INTO `gen_table_column` VALUES (110, 14, 'max_value', '上限阈值（高于此值触发预警，可为空）', 'decimal(10,2)', 'BigDecimal', 'maxValue', '0', '0', '0', '1', '1', '1', '0', 'EQ', 'input', '', 5, 'admin', '2026-04-13 21:21:06', '', '2026-04-13 21:36:37');
INSERT INTO `gen_table_column` VALUES (111, 14, 'enabled', '是否启用：0-停用，1-启用', 'tinyint(1)', 'Integer', 'enabled', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 6, 'admin', '2026-04-13 21:21:06', '', '2026-04-13 21:36:37');
INSERT INTO `gen_table_column` VALUES (112, 14, 'create_time', '创建时间', 'datetime', 'Date', 'createTime', '0', '0', '0', '0', NULL, NULL, NULL, 'EQ', 'datetime', '', 7, 'admin', '2026-04-13 21:21:06', '', '2026-04-13 21:36:37');
INSERT INTO `gen_table_column` VALUES (113, 14, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '0', '0', NULL, NULL, 'EQ', 'datetime', '', 8, 'admin', '2026-04-13 21:21:06', '', '2026-04-13 21:36:37');
INSERT INTO `gen_table_column` VALUES (114, 15, 'id', 'ID', 'int', 'Long', 'id', '1', '1', '0', '0', NULL, '1', NULL, 'EQ', 'input', '', 1, 'admin', '2026-04-13 21:21:06', '', '2026-04-13 21:46:49');
INSERT INTO `gen_table_column` VALUES (115, 15, 'name', '预警阈值类型名称', 'varchar(100)', 'String', 'name', '0', '0', '1', '1', '1', '1', '1', 'LIKE', 'input', '', 2, 'admin', '2026-04-13 21:21:06', '', '2026-04-13 21:46:49');
INSERT INTO `gen_table_column` VALUES (116, 15, 'remark', '备注', 'varchar(500)', 'String', 'remark', '0', '0', '0', '1', '1', '0', NULL, 'EQ', 'textarea', '', 3, 'admin', '2026-04-13 21:21:06', '', '2026-04-13 21:46:49');
INSERT INTO `gen_table_column` VALUES (117, 15, 'create_by', '创建者', 'varchar(64)', 'String', 'createBy', '0', '0', '0', '0', NULL, NULL, NULL, 'EQ', 'input', '', 4, 'admin', '2026-04-13 21:21:06', '', '2026-04-13 21:46:49');
INSERT INTO `gen_table_column` VALUES (118, 15, 'create_time', '创建时间', 'datetime', 'Date', 'createTime', '0', '0', '0', '0', NULL, '1', NULL, 'EQ', 'datetime', '', 5, 'admin', '2026-04-13 21:21:06', '', '2026-04-13 21:46:49');
INSERT INTO `gen_table_column` VALUES (119, 15, 'update_by', '更新者', 'varchar(64)', 'String', 'updateBy', '0', '0', '0', '0', '0', NULL, NULL, 'EQ', 'input', '', 6, 'admin', '2026-04-13 21:21:06', '', '2026-04-13 21:46:49');
INSERT INTO `gen_table_column` VALUES (120, 15, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '0', '0', '1', NULL, 'EQ', 'datetime', '', 7, 'admin', '2026-04-13 21:21:06', '', '2026-04-13 21:46:49');
INSERT INTO `gen_table_column` VALUES (121, 16, 'id', 'ID', 'int', 'Long', 'id', '1', '1', '0', '0', NULL, '1', NULL, 'EQ', 'input', '', 1, 'admin', '2026-04-13 22:55:16', '', '2026-04-13 23:00:39');
INSERT INTO `gen_table_column` VALUES (122, 16, 'plot_id', '片区ID（farm_plot.id）', 'int', 'Long', 'plotId', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2026-04-13 22:55:16', '', '2026-04-13 23:00:39');
INSERT INTO `gen_table_column` VALUES (123, 16, 'collect_time', '采集时间', 'datetime', 'Date', 'collectTime', '0', '0', '0', '0', '0', '1', '0', 'EQ', 'datetime', '', 3, 'admin', '2026-04-13 22:55:16', '', '2026-04-13 23:00:39');
INSERT INTO `gen_table_column` VALUES (124, 16, 'create_time', '创建时间', 'datetime', 'Date', 'createTime', '0', '0', '0', '0', NULL, NULL, NULL, 'EQ', 'datetime', '', 4, 'admin', '2026-04-13 22:55:16', '', '2026-04-13 23:00:39');
INSERT INTO `gen_table_column` VALUES (125, 16, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '0', '0', NULL, NULL, 'EQ', 'datetime', '', 5, 'admin', '2026-04-13 22:55:16', '', '2026-04-13 23:00:39');
INSERT INTO `gen_table_column` VALUES (126, 16, 'env_value', '实际值', 'decimal(6,2)', 'BigDecimal', 'envValue', '0', '0', '1', '1', '1', '1', '0', 'EQ', 'input', '', 6, 'admin', '2026-04-13 22:55:16', '', '2026-04-13 23:00:39');
INSERT INTO `gen_table_column` VALUES (127, 16, 'alert_type_id', '阈值类型', 'int', 'Long', 'alertTypeId', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 7, 'admin', '2026-04-13 22:55:16', '', '2026-04-13 23:00:39');
INSERT INTO `gen_table_column` VALUES (128, 17, 'id', 'ID', 'int', 'Long', 'id', '1', '1', '0', '0', NULL, '1', NULL, 'EQ', 'input', '', 1, 'admin', '2026-04-15 00:57:34', '', '2026-04-15 01:33:33');
INSERT INTO `gen_table_column` VALUES (129, 17, 'plot_id', '片区ID', 'int', 'Long', 'plotId', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2026-04-15 00:57:34', '', '2026-04-15 01:33:33');
INSERT INTO `gen_table_column` VALUES (130, 17, 'alert_type_id', '预警类型ID', 'int', 'Long', 'alertTypeId', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2026-04-15 00:57:34', '', '2026-04-15 01:33:33');
INSERT INTO `gen_table_column` VALUES (131, 17, 'trigger_value', '实际值', 'decimal(10,2)', 'BigDecimal', 'triggerValue', '0', '0', '1', '1', '1', '1', '0', 'EQ', 'input', '', 4, 'admin', '2026-04-15 00:57:34', '', '2026-04-15 01:33:33');
INSERT INTO `gen_table_column` VALUES (132, 17, 'min_value', '下限阈值', 'decimal(10,2)', 'BigDecimal', 'minValue', '0', '0', '0', '1', '1', '1', '0', 'EQ', 'input', '', 5, 'admin', '2026-04-15 00:57:34', '', '2026-04-15 01:33:33');
INSERT INTO `gen_table_column` VALUES (133, 17, 'max_value', '上限阈值', 'decimal(10,2)', 'BigDecimal', 'maxValue', '0', '0', '0', '1', '1', '1', '0', 'EQ', 'input', '', 6, 'admin', '2026-04-15 00:57:34', '', '2026-04-15 01:33:33');
INSERT INTO `gen_table_column` VALUES (134, 17, 'status', '预警状态', 'tinyint(1)', 'Integer', 'status', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'radio', 'alert_history_status', 7, 'admin', '2026-04-15 00:57:34', '', '2026-04-15 01:33:33');
INSERT INTO `gen_table_column` VALUES (135, 17, 'trigger_time', '触发时间', 'datetime', 'Date', 'triggerTime', '0', '0', '1', '1', '1', '1', '1', 'BETWEEN', 'datetime', '', 8, 'admin', '2026-04-15 00:57:34', '', '2026-04-15 01:33:33');
INSERT INTO `gen_table_column` VALUES (136, 17, 'recovery_time', '恢复时间', 'datetime', 'Date', 'recoveryTime', '0', '0', '0', '1', '1', '1', '1', 'BETWEEN', 'datetime', '', 9, 'admin', '2026-04-15 00:57:34', '', '2026-04-15 01:33:33');
INSERT INTO `gen_table_column` VALUES (137, 17, 'duration_minutes', '持续时长(minute)', 'int', 'Long', 'durationMinutes', '0', '0', '0', '1', '1', '1', '0', 'EQ', 'input', '', 10, 'admin', '2026-04-15 00:57:34', '', '2026-04-15 01:33:33');
INSERT INTO `gen_table_column` VALUES (138, 17, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '0', '0', NULL, NULL, 'EQ', 'datetime', '', 11, 'admin', '2026-04-15 00:57:34', '', '2026-04-15 01:33:33');
INSERT INTO `gen_table_column` VALUES (139, 17, 'remark', '备注', 'varchar(500)', 'String', 'remark', '0', '0', '0', '1', '1', '0', NULL, 'EQ', 'textarea', '', 12, 'admin', '2026-04-15 00:57:34', '', '2026-04-15 01:33:33');
INSERT INTO `gen_table_column` VALUES (173, 21, 'id', 'ID', 'int', 'Long', 'id', '1', '1', '0', '0', NULL, '1', NULL, 'EQ', 'input', '', 1, 'admin', '2026-04-15 17:09:57', '', '2026-04-15 17:26:58');
INSERT INTO `gen_table_column` VALUES (174, 21, 'log_type', '检测类型', 'tinyint(1)', 'Integer', 'logType', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'select', 'model_type', 2, 'admin', '2026-04-15 17:09:57', '', '2026-04-15 17:26:58');
INSERT INTO `gen_table_column` VALUES (175, 21, 'detect_type', '检测类型', 'tinyint(1)', 'Integer', 'detectType', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'select', 'detect_type', 3, 'admin', '2026-04-15 17:09:57', '', '2026-04-15 17:26:58');
INSERT INTO `gen_table_column` VALUES (176, 21, 'user_id', '操作用户ID（sys_user.user_id）', 'int', 'Long', 'userId', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 4, 'admin', '2026-04-15 17:09:57', '', '2026-04-15 17:26:58');
INSERT INTO `gen_table_column` VALUES (177, 21, 'model_config_id', '使用的模型关联ID（model_config.id）', 'varchar(100)', 'String', 'modelConfigId', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 5, 'admin', '2026-04-15 17:09:57', '', '2026-04-15 17:26:58');
INSERT INTO `gen_table_column` VALUES (178, 21, 'result_image_path', '结果（带标注）存储路径', 'varchar(500)', 'String', 'resultImagePath', '0', '0', '1', '1', '1', '1', '0', 'EQ', 'textarea', '', 6, 'admin', '2026-04-15 17:09:57', '', '2026-04-15 17:26:58');
INSERT INTO `gen_table_column` VALUES (179, 21, 'duration_ms', '推理耗时（毫秒）', 'int', 'Long', 'durationMs', '0', '0', '0', '1', '1', '1', '0', 'EQ', 'input', '', 7, 'admin', '2026-04-15 17:09:57', '', '2026-04-15 17:26:58');
INSERT INTO `gen_table_column` VALUES (180, 21, 'total_targets', '检测到的目标总数', 'int', 'Long', 'totalTargets', '0', '0', '1', '1', '1', '1', '0', 'EQ', 'input', '', 8, 'admin', '2026-04-15 17:09:57', '', '2026-04-15 17:26:58');
INSERT INTO `gen_table_column` VALUES (181, 21, 'feedback_status', '用户反馈', 'tinyint(1)', 'Integer', 'feedbackStatus', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'select', 'feedback_status', 9, 'admin', '2026-04-15 17:09:57', '', '2026-04-15 17:26:58');
INSERT INTO `gen_table_column` VALUES (182, 21, 'feedback_text', '不准确时的原因文本', 'varchar(500)', 'String', 'feedbackText', '0', '0', '0', '1', '1', '1', '0', 'EQ', 'textarea', '', 10, 'admin', '2026-04-15 17:09:57', '', '2026-04-15 17:26:58');
INSERT INTO `gen_table_column` VALUES (183, 21, 'feedback_time', '反馈提交时间', 'datetime', 'Date', 'feedbackTime', '0', '0', '0', '1', '1', '1', '0', 'EQ', 'datetime', '', 11, 'admin', '2026-04-15 17:09:57', '', '2026-04-15 17:26:58');
INSERT INTO `gen_table_column` VALUES (184, 21, 'create_time', '检测时间', 'datetime', 'Date', 'createTime', '0', '0', '0', '1', '1', '1', '1', 'BETWEEN', 'datetime', '', 12, 'admin', '2026-04-15 17:09:57', '', '2026-04-15 17:26:58');
INSERT INTO `gen_table_column` VALUES (185, 21, 'density_json', '密度数据（JSON格式）', 'json', 'String', 'densityJson', '0', '0', '0', '1', '1', '0', '0', 'EQ', NULL, '', 13, 'admin', '2026-04-15 17:09:57', '', '2026-04-15 17:26:58');
INSERT INTO `gen_table_column` VALUES (186, 22, 'id', '详情ID', 'int', 'Long', 'id', '1', '1', '0', '1', NULL, NULL, NULL, 'EQ', 'input', '', 1, 'admin', '2026-04-15 17:09:57', '', NULL);
INSERT INTO `gen_table_column` VALUES (187, 22, 'log_id', '所属日志ID（detection_log.id）', 'int', 'Long', 'logId', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2026-04-15 17:09:57', '', NULL);
INSERT INTO `gen_table_column` VALUES (188, 22, 'label', '类别名称（模型输出标签）', 'varchar(100)', 'String', 'label', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2026-04-15 17:09:57', '', NULL);
INSERT INTO `gen_table_column` VALUES (189, 22, 'confidence', '置信度（0-1）', 'decimal(5,4)', 'BigDecimal', 'confidence', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 4, 'admin', '2026-04-15 17:09:57', '', NULL);
INSERT INTO `gen_table_column` VALUES (190, 22, 'location_json', '位置信息（JSON格式：检测任务存[x1,y1,x2,y2]；分割任务存多边形点集数组）', 'text', 'String', 'locationJson', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'textarea', '', 5, 'admin', '2026-04-15 17:09:57', '', NULL);
INSERT INTO `gen_table_column` VALUES (191, 22, 'linked_encyclopedia', '关联crop表ID（corp.id）', 'int', 'Long', 'linkedEncyclopedia', '0', '0', '0', '1', '1', '1', '1', 'EQ', 'input', '', 6, 'admin', '2026-04-15 17:09:57', '', NULL);
INSERT INTO `gen_table_column` VALUES (192, 23, 'id', 'ID', 'int', 'Long', 'id', '1', '1', '0', '0', NULL, '1', NULL, 'EQ', 'input', '', 1, 'admin', '2026-06-13 12:48:36', '', '2026-06-13 12:55:25');
INSERT INTO `gen_table_column` VALUES (193, 23, 'name', '监控名称', 'varchar(255)', 'String', 'name', '0', '0', '1', '1', '1', '1', '1', 'LIKE', 'input', '', 2, 'admin', '2026-06-13 12:48:36', '', '2026-06-13 12:55:25');
INSERT INTO `gen_table_column` VALUES (194, 23, 'rtsp_url', 'rtsp流地址', 'varchar(255)', 'String', 'rtspUrl', '0', '0', '1', '1', '1', '1', '0', 'EQ', 'input', '', 3, 'admin', '2026-06-13 12:48:36', '', '2026-06-13 12:55:25');
INSERT INTO `gen_table_column` VALUES (195, 23, 'monitor_type', '型号', 'varchar(255)', 'String', 'monitorType', '0', '0', '1', '1', '1', '1', '0', 'EQ', 'input', '', 4, 'admin', '2026-06-13 12:48:36', '', '2026-06-13 12:55:25');
INSERT INTO `gen_table_column` VALUES (196, 23, 'status', '状态', 'tinyint', 'Long', 'status', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'select', 'monitor_status', 5, 'admin', '2026-06-13 12:48:36', '', '2026-06-13 12:55:25');
INSERT INTO `gen_table_column` VALUES (197, 23, 'create_time', '创建时间', 'datetime', 'Date', 'createTime', '0', '0', '0', '0', NULL, '1', NULL, 'EQ', 'datetime', '', 6, 'admin', '2026-06-13 12:48:36', '', '2026-06-13 12:55:25');
INSERT INTO `gen_table_column` VALUES (198, 23, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '0', '0', NULL, NULL, 'EQ', 'datetime', '', 7, 'admin', '2026-06-13 12:48:36', '', '2026-06-13 12:55:25');
INSERT INTO `gen_table_column` VALUES (199, 23, 'remark', '备注', 'varchar(500)', 'String', 'remark', '0', '0', '0', '1', '1', '0', NULL, 'EQ', 'textarea', '', 8, 'admin', '2026-06-13 12:48:36', '', '2026-06-13 12:55:25');
INSERT INTO `gen_table_column` VALUES (208, 25, 'id', 'ID', 'int', 'Long', 'id', '1', '1', '0', '0', NULL, '1', NULL, 'EQ', 'input', '', 1, 'admin', '2026-06-13 15:11:01', '', '2026-06-13 15:13:31');
INSERT INTO `gen_table_column` VALUES (209, 25, 'monitor_id', '监控ID', 'int', 'Long', 'monitorId', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 2, 'admin', '2026-06-13 15:11:01', '', '2026-06-13 15:13:31');
INSERT INTO `gen_table_column` VALUES (210, 25, 'model_config_id', '模型ID', 'int', 'Long', 'modelConfigId', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'input', '', 3, 'admin', '2026-06-13 15:11:01', '', '2026-06-13 15:13:31');
INSERT INTO `gen_table_column` VALUES (211, 25, 'duration', '持续时间(秒)', 'int', 'Long', 'duration', '0', '0', '1', '1', '1', '1', '0', 'EQ', 'input', '', 4, 'admin', '2026-06-13 15:11:01', '', '2026-06-13 15:13:31');
INSERT INTO `gen_table_column` VALUES (212, 25, 'status', '状态', 'tinyint', 'Long', 'status', '0', '0', '1', '1', '1', '1', '1', 'EQ', 'select', 'monitor_job_status', 5, 'admin', '2026-06-13 15:11:01', '', '2026-06-13 15:13:31');
INSERT INTO `gen_table_column` VALUES (213, 25, 'create_time', '开始时间', 'datetime', 'Date', 'createTime', '0', '0', '0', '0', NULL, '1', '1', 'BETWEEN', 'datetime', '', 6, 'admin', '2026-06-13 15:11:01', '', '2026-06-13 15:13:31');
INSERT INTO `gen_table_column` VALUES (214, 25, 'update_time', '更新时间', 'datetime', 'Date', 'updateTime', '0', '0', '0', '0', '0', '0', NULL, 'EQ', 'datetime', '', 7, 'admin', '2026-06-13 15:11:01', '', '2026-06-13 15:13:31');
INSERT INTO `gen_table_column` VALUES (215, 25, 'end_time', '结束时间', 'datetime', 'Date', 'endTime', '0', '0', '0', '0', '0', '1', '1', 'BETWEEN', 'datetime', '', 8, 'admin', '2026-06-13 15:11:01', '', '2026-06-13 15:13:31');
INSERT INTO `gen_table_column` VALUES (216, 25, 'remark', '备注', 'varchar(500)', 'String', 'remark', '0', '0', '0', '1', '1', '0', NULL, 'EQ', 'textarea', '', 9, 'admin', '2026-06-13 15:11:01', '', '2026-06-13 15:13:31');

-- ----------------------------
-- Table structure for model_config
-- ----------------------------
DROP TABLE IF EXISTS `model_config`;
CREATE TABLE `model_config`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '模型ID',
  `model_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '模型显示名称',
  `model_type` tinyint(1) NOT NULL DEFAULT 0 COMMENT '模型类型：0-目标检测，1-实例分割',
  `version` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '版本号',
  `file_path` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '模型文件路径（.pt文件）',
  `is_active` tinyint(1) NOT NULL DEFAULT 1 COMMENT '是否启用：0-停用，1-启用',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `model_size` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '模型大小',
  `is_del` tinyint(1) NOT NULL DEFAULT 0 COMMENT '是否删除(1-是,0-否)',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_name_version`(`model_name` ASC, `version` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 7 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '模型配置表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of model_config
-- ----------------------------
INSERT INTO `model_config` VALUES (1, '病虫害检测模型', 0, 'v2', 'yolo11n-v1.pt', 1, NULL, '2026-04-13 00:23:01', '2026-06-13 17:18:24', '5.53MB', 0);
INSERT INTO `model_config` VALUES (2, 'yolo11n-v2', 0, 'latest', 'yolo11n-v2.pt', 1, NULL, '2026-04-13 09:47:27', '2026-04-13 09:51:05', '5.35MB', 1);
INSERT INTO `model_config` VALUES (3, 'yolo11n-v3', 1, 'v11', 'yolo11n-v3.pt', 1, NULL, '2026-04-13 09:47:27', NULL, '5.35MB', 1);
INSERT INTO `model_config` VALUES (4, 'yolo11n', 0, 'v1', 'yolo11n-v2.pt', 0, NULL, '2026-04-15 15:45:09', '2026-04-18 18:00:27', '5.35MB', 0);
INSERT INTO `model_config` VALUES (5, 'yolo11n-seg', 1, 'v1', 'yolo11n-v3.pt', 1, NULL, NULL, '2026-04-18 18:00:24', '5.35MB', 0);
INSERT INTO `model_config` VALUES (6, '病虫害检测模型', 0, 'v1', 'best.pt', 0, NULL, NULL, '2026-06-13 17:19:46', '15.56MB', 0);

-- ----------------------------
-- Table structure for monitor
-- ----------------------------
DROP TABLE IF EXISTS `monitor`;
CREATE TABLE `monitor`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '监控名称',
  `rtsp_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'rtsp流地址',
  `monitor_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '型号',
  `status` tinyint NOT NULL DEFAULT 0 COMMENT '状态（0空闲 1工作中 2异常）',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '监控管理表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of monitor
-- ----------------------------
INSERT INTO `monitor` VALUES (1, 'aaa', 'aaa', 'aaa', 0, '2026-06-13 14:33:16', NULL, NULL);
INSERT INTO `monitor` VALUES (2, '跳舞检测器', 'rtsp://192.168.233.128:8554/dance', '摄像头', 0, '2026-06-13 17:21:40', NULL, NULL);

-- ----------------------------
-- Table structure for monitor_job
-- ----------------------------
DROP TABLE IF EXISTS `monitor_job`;
CREATE TABLE `monitor_job`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `monitor_id` int NOT NULL COMMENT '监控ID',
  `model_config_id` int NOT NULL COMMENT '模型ID',
  `duration` int NOT NULL COMMENT '持续时间（秒）',
  `status` tinyint NOT NULL DEFAULT 1 COMMENT '状态（1-处理中 2-处理完成 3-处理失败）',
  `create_time` datetime NULL DEFAULT NULL COMMENT '开始时间',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `end_time` datetime NULL DEFAULT NULL COMMENT '结束时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 41 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '监控任务表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of monitor_job
-- ----------------------------
INSERT INTO `monitor_job` VALUES (39, 2, 1, 20, 2, '2026-06-14 19:13:35', NULL, '2026-06-14 19:13:58', '');
INSERT INTO `monitor_job` VALUES (40, 2, 1, 300, 2, '2026-06-14 19:15:07', NULL, '2026-06-14 19:20:10', '');

-- ----------------------------
-- Table structure for plot_coordinatelist
-- ----------------------------
DROP TABLE IF EXISTS `plot_coordinatelist`;
CREATE TABLE `plot_coordinatelist`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `plot_id` int NOT NULL COMMENT '片区id',
  `lng` decimal(10, 6) NULL DEFAULT NULL COMMENT '经度',
  `lat` decimal(10, 6) NULL DEFAULT NULL COMMENT '纬度',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 113 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '片区经纬度表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of plot_coordinatelist
-- ----------------------------
INSERT INTO `plot_coordinatelist` VALUES (105, 2, 116.670000, 23.360000);
INSERT INTO `plot_coordinatelist` VALUES (106, 2, 116.678747, 23.360000);
INSERT INTO `plot_coordinatelist` VALUES (107, 2, 116.678747, 23.368035);
INSERT INTO `plot_coordinatelist` VALUES (108, 2, 116.670000, 23.368035);
INSERT INTO `plot_coordinatelist` VALUES (109, 1, 113.100000, 22.700000);
INSERT INTO `plot_coordinatelist` VALUES (110, 1, 113.109009, 22.700000);
INSERT INTO `plot_coordinatelist` VALUES (111, 1, 113.109009, 22.709009);
INSERT INTO `plot_coordinatelist` VALUES (112, 1, 113.100000, 22.709009);

-- ----------------------------
-- Table structure for plot_crop
-- ----------------------------
DROP TABLE IF EXISTS `plot_crop`;
CREATE TABLE `plot_crop`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `plot_id` int NOT NULL COMMENT '片区ID（farm_plot.id）',
  `crop_id` int NOT NULL COMMENT '农作物ID（crop.id）',
  `nums` int NOT NULL DEFAULT 0 COMMENT '数量',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_plot_crop`(`plot_id` ASC, `crop_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 15 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '片区与农作物关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of plot_crop
-- ----------------------------
INSERT INTO `plot_crop` VALUES (1, 1, 1, 100);
INSERT INTO `plot_crop` VALUES (2, 1, 4, 200);
INSERT INTO `plot_crop` VALUES (4, 2, 4, 500);
INSERT INTO `plot_crop` VALUES (5, 3, 4, 300);
INSERT INTO `plot_crop` VALUES (13, 4, 6, 7000);
INSERT INTO `plot_crop` VALUES (14, 1, 10, 200);

-- ----------------------------
-- Table structure for plot_env_realtime
-- ----------------------------
DROP TABLE IF EXISTS `plot_env_realtime`;
CREATE TABLE `plot_env_realtime`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT 'ID',
  `plot_id` int NOT NULL COMMENT '片区ID（farm_plot.id）',
  `collect_time` datetime NULL DEFAULT NULL COMMENT '采集时间',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `env_value` decimal(6, 2) NOT NULL COMMENT '实际值',
  `alert_type_id` int NOT NULL COMMENT '阈值类型',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uk_plotId_alertTypeId`(`plot_id` ASC, `alert_type_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 28 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '片区环境实时数据表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of plot_env_realtime
-- ----------------------------
INSERT INTO `plot_env_realtime` VALUES (8, 3, '2026-06-10 20:24:14', '2026-04-13 23:26:50', '2026-06-10 20:24:14', 26.00, 1);
INSERT INTO `plot_env_realtime` VALUES (9, 1, '2026-04-18 17:50:04', '2026-04-13 23:27:26', '2026-04-18 17:50:04', 21.00, 1);
INSERT INTO `plot_env_realtime` VALUES (12, 3, '2026-04-14 01:34:18', '2026-04-13 23:41:32', '2026-04-14 01:34:18', 50.00, 2);
INSERT INTO `plot_env_realtime` VALUES (13, 3, '2026-04-13 23:42:01', '2026-04-13 23:42:01', NULL, 6.50, 4);
INSERT INTO `plot_env_realtime` VALUES (18, 1, '2026-04-18 17:57:03', '2026-04-13 23:44:44', '2026-04-18 17:57:03', 7.10, 4);
INSERT INTO `plot_env_realtime` VALUES (23, 3, '2026-04-15 02:18:29', '2026-04-14 02:42:15', '2026-04-15 02:18:29', 200.00, 3);
INSERT INTO `plot_env_realtime` VALUES (26, 1, '2026-04-18 17:54:35', '2026-04-15 03:13:07', '2026-04-18 17:54:35', 72.00, 2);
INSERT INTO `plot_env_realtime` VALUES (27, 1, '2026-04-18 17:56:52', '2026-04-18 17:56:52', NULL, 605.00, 3);

-- ----------------------------
-- Table structure for plot_type
-- ----------------------------
DROP TABLE IF EXISTS `plot_type`;
CREATE TABLE `plot_type`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '片区类型ID',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '片区类型名称',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '片区类型' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of plot_type
-- ----------------------------
INSERT INTO `plot_type` VALUES (1, '温室', NULL, '', '2026-04-09 22:51:22', '', '2026-04-13 08:23:22');
INSERT INTO `plot_type` VALUES (2, '耕地', NULL, '', '2026-04-09 22:51:28', '', NULL);

-- ----------------------------
-- Table structure for sys_config
-- ----------------------------
DROP TABLE IF EXISTS `sys_config`;
CREATE TABLE `sys_config`  (
  `config_id` int NOT NULL AUTO_INCREMENT COMMENT '参数主键',
  `config_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '参数名称',
  `config_key` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '参数键名',
  `config_value` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '参数键值',
  `config_type` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'N' COMMENT '系统内置（Y是 N否）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`config_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 100 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '参数配置表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_config
-- ----------------------------
INSERT INTO `sys_config` VALUES (1, '主框架页-默认皮肤样式名称', 'sys.index.skinName', 'skin-blue', 'Y', 'admin', '2026-04-08 23:16:39', '', NULL, '蓝色 skin-blue、绿色 skin-green、紫色 skin-purple、红色 skin-red、黄色 skin-yellow');
INSERT INTO `sys_config` VALUES (2, '用户管理-账号初始密码', 'sys.user.initPassword', '123456', 'Y', 'admin', '2026-04-08 23:16:39', '', NULL, '初始化密码 123456');
INSERT INTO `sys_config` VALUES (3, '主框架页-侧边栏主题', 'sys.index.sideTheme', 'theme-dark', 'Y', 'admin', '2026-04-08 23:16:39', '', NULL, '深色主题theme-dark，浅色主题theme-light');
INSERT INTO `sys_config` VALUES (4, '账号自助-验证码开关', 'sys.account.captchaEnabled', 'true', 'Y', 'admin', '2026-04-08 23:16:39', '', NULL, '是否开启验证码功能（true开启，false关闭）');
INSERT INTO `sys_config` VALUES (5, '账号自助-是否开启用户注册功能', 'sys.account.registerUser', 'false', 'Y', 'admin', '2026-04-08 23:16:39', '', NULL, '是否开启注册用户功能（true开启，false关闭）');
INSERT INTO `sys_config` VALUES (6, '用户登录-黑名单列表', 'sys.login.blackIPList', '', 'Y', 'admin', '2026-04-08 23:16:39', '', NULL, '设置登录IP黑名单限制，多个匹配项以;分隔，支持匹配（*通配、网段）');
INSERT INTO `sys_config` VALUES (7, '用户管理-初始密码修改策略', 'sys.account.initPasswordModify', '1', 'Y', 'admin', '2026-04-08 23:16:39', '', NULL, '0：初始密码修改策略关闭，没有任何提示，1：提醒用户，如果未修改初始密码，则在登录时就会提醒修改密码对话框');
INSERT INTO `sys_config` VALUES (8, '用户管理-账号密码更新周期', 'sys.account.passwordValidateDays', '0', 'Y', 'admin', '2026-04-08 23:16:39', '', NULL, '密码更新周期（填写数字，数据初始化值为0不限制，若修改必须为大于0小于365的正整数），如果超过这个周期登录系统时，则在登录时就会提醒修改密码对话框');

-- ----------------------------
-- Table structure for sys_dept
-- ----------------------------
DROP TABLE IF EXISTS `sys_dept`;
CREATE TABLE `sys_dept`  (
  `dept_id` bigint NOT NULL AUTO_INCREMENT COMMENT '部门id',
  `parent_id` bigint NULL DEFAULT 0 COMMENT '父部门id',
  `ancestors` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '祖级列表',
  `dept_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '部门名称',
  `order_num` int NULL DEFAULT 0 COMMENT '显示顺序',
  `leader` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '负责人',
  `phone` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '联系电话',
  `email` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '邮箱',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '部门状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`dept_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 200 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '部门表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_dept
-- ----------------------------
INSERT INTO `sys_dept` VALUES (100, 0, '0', '羊离子科技', 0, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2026-04-08 23:16:38', 'admin', '2026-04-10 19:52:32');
INSERT INTO `sys_dept` VALUES (101, 100, '0,100', '深圳总公司', 1, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2026-04-08 23:16:38', '', NULL);
INSERT INTO `sys_dept` VALUES (102, 100, '0,100', '长沙分公司', 2, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2026-04-08 23:16:38', '', NULL);
INSERT INTO `sys_dept` VALUES (103, 101, '0,100,101', '研发部门', 1, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2026-04-08 23:16:38', '', NULL);
INSERT INTO `sys_dept` VALUES (104, 101, '0,100,101', '市场部门', 2, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2026-04-08 23:16:38', '', NULL);
INSERT INTO `sys_dept` VALUES (105, 101, '0,100,101', '测试部门', 3, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2026-04-08 23:16:38', '', NULL);
INSERT INTO `sys_dept` VALUES (106, 101, '0,100,101', '财务部门', 4, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2026-04-08 23:16:38', '', NULL);
INSERT INTO `sys_dept` VALUES (107, 101, '0,100,101', '运维部门', 5, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2026-04-08 23:16:38', '', NULL);
INSERT INTO `sys_dept` VALUES (108, 102, '0,100,102', '市场部门', 1, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2026-04-08 23:16:38', '', NULL);
INSERT INTO `sys_dept` VALUES (109, 102, '0,100,102', '财务部门', 2, '若依', '15888888888', 'ry@qq.com', '0', '0', 'admin', '2026-04-08 23:16:38', '', NULL);

-- ----------------------------
-- Table structure for sys_dict_data
-- ----------------------------
DROP TABLE IF EXISTS `sys_dict_data`;
CREATE TABLE `sys_dict_data`  (
  `dict_code` bigint NOT NULL AUTO_INCREMENT COMMENT '字典编码',
  `dict_sort` int NULL DEFAULT 0 COMMENT '字典排序',
  `dict_label` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '字典标签',
  `dict_value` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '字典键值',
  `dict_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '字典类型',
  `css_class` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '样式属性（其他样式扩展）',
  `list_class` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '表格回显样式',
  `is_default` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT 'N' COMMENT '是否默认（Y是 N否）',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`dict_code`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 124 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '字典数据表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_dict_data
-- ----------------------------
INSERT INTO `sys_dict_data` VALUES (1, 1, '男', '0', 'sys_user_sex', '', '', 'Y', '0', 'admin', '2026-04-08 23:16:39', '', NULL, '性别男');
INSERT INTO `sys_dict_data` VALUES (2, 2, '女', '1', 'sys_user_sex', '', '', 'N', '0', 'admin', '2026-04-08 23:16:39', '', NULL, '性别女');
INSERT INTO `sys_dict_data` VALUES (3, 3, '未知', '2', 'sys_user_sex', '', '', 'N', '0', 'admin', '2026-04-08 23:16:39', '', NULL, '性别未知');
INSERT INTO `sys_dict_data` VALUES (4, 1, '显示', '0', 'sys_show_hide', '', 'primary', 'Y', '0', 'admin', '2026-04-08 23:16:39', '', NULL, '显示菜单');
INSERT INTO `sys_dict_data` VALUES (5, 2, '隐藏', '1', 'sys_show_hide', '', 'danger', 'N', '0', 'admin', '2026-04-08 23:16:39', '', NULL, '隐藏菜单');
INSERT INTO `sys_dict_data` VALUES (6, 1, '正常', '0', 'sys_normal_disable', '', 'primary', 'Y', '0', 'admin', '2026-04-08 23:16:39', '', NULL, '正常状态');
INSERT INTO `sys_dict_data` VALUES (7, 2, '停用', '1', 'sys_normal_disable', '', 'danger', 'N', '0', 'admin', '2026-04-08 23:16:39', '', NULL, '停用状态');
INSERT INTO `sys_dict_data` VALUES (8, 1, '正常', '0', 'sys_job_status', '', 'primary', 'Y', '0', 'admin', '2026-04-08 23:16:39', '', NULL, '正常状态');
INSERT INTO `sys_dict_data` VALUES (9, 2, '暂停', '1', 'sys_job_status', '', 'danger', 'N', '0', 'admin', '2026-04-08 23:16:39', '', NULL, '停用状态');
INSERT INTO `sys_dict_data` VALUES (10, 1, '默认', 'DEFAULT', 'sys_job_group', '', '', 'Y', '0', 'admin', '2026-04-08 23:16:39', '', NULL, '默认分组');
INSERT INTO `sys_dict_data` VALUES (11, 2, '系统', 'SYSTEM', 'sys_job_group', '', '', 'N', '0', 'admin', '2026-04-08 23:16:39', '', NULL, '系统分组');
INSERT INTO `sys_dict_data` VALUES (12, 1, '是', 'Y', 'sys_yes_no', '', 'primary', 'Y', '0', 'admin', '2026-04-08 23:16:39', '', NULL, '系统默认是');
INSERT INTO `sys_dict_data` VALUES (13, 2, '否', 'N', 'sys_yes_no', '', 'danger', 'N', '0', 'admin', '2026-04-08 23:16:39', '', NULL, '系统默认否');
INSERT INTO `sys_dict_data` VALUES (14, 1, '通知', '1', 'sys_notice_type', '', 'warning', 'Y', '0', 'admin', '2026-04-08 23:16:39', '', NULL, '通知');
INSERT INTO `sys_dict_data` VALUES (15, 2, '公告', '2', 'sys_notice_type', '', 'success', 'N', '0', 'admin', '2026-04-08 23:16:39', '', NULL, '公告');
INSERT INTO `sys_dict_data` VALUES (16, 1, '正常', '0', 'sys_notice_status', '', 'primary', 'Y', '0', 'admin', '2026-04-08 23:16:39', '', NULL, '正常状态');
INSERT INTO `sys_dict_data` VALUES (17, 2, '关闭', '1', 'sys_notice_status', '', 'danger', 'N', '0', 'admin', '2026-04-08 23:16:39', '', NULL, '关闭状态');
INSERT INTO `sys_dict_data` VALUES (18, 99, '其他', '0', 'sys_oper_type', '', 'info', 'N', '0', 'admin', '2026-04-08 23:16:39', '', NULL, '其他操作');
INSERT INTO `sys_dict_data` VALUES (19, 1, '新增', '1', 'sys_oper_type', '', 'info', 'N', '0', 'admin', '2026-04-08 23:16:39', '', NULL, '新增操作');
INSERT INTO `sys_dict_data` VALUES (20, 2, '修改', '2', 'sys_oper_type', '', 'info', 'N', '0', 'admin', '2026-04-08 23:16:39', '', NULL, '修改操作');
INSERT INTO `sys_dict_data` VALUES (21, 3, '删除', '3', 'sys_oper_type', '', 'danger', 'N', '0', 'admin', '2026-04-08 23:16:39', '', NULL, '删除操作');
INSERT INTO `sys_dict_data` VALUES (22, 4, '授权', '4', 'sys_oper_type', '', 'primary', 'N', '0', 'admin', '2026-04-08 23:16:39', '', NULL, '授权操作');
INSERT INTO `sys_dict_data` VALUES (23, 5, '导出', '5', 'sys_oper_type', '', 'warning', 'N', '0', 'admin', '2026-04-08 23:16:39', '', NULL, '导出操作');
INSERT INTO `sys_dict_data` VALUES (24, 6, '导入', '6', 'sys_oper_type', '', 'warning', 'N', '0', 'admin', '2026-04-08 23:16:39', '', NULL, '导入操作');
INSERT INTO `sys_dict_data` VALUES (25, 7, '强退', '7', 'sys_oper_type', '', 'danger', 'N', '0', 'admin', '2026-04-08 23:16:39', '', NULL, '强退操作');
INSERT INTO `sys_dict_data` VALUES (26, 8, '生成代码', '8', 'sys_oper_type', '', 'warning', 'N', '0', 'admin', '2026-04-08 23:16:39', '', NULL, '生成操作');
INSERT INTO `sys_dict_data` VALUES (27, 9, '清空数据', '9', 'sys_oper_type', '', 'danger', 'N', '0', 'admin', '2026-04-08 23:16:39', '', NULL, '清空操作');
INSERT INTO `sys_dict_data` VALUES (28, 1, '成功', '0', 'sys_common_status', '', 'primary', 'N', '0', 'admin', '2026-04-08 23:16:39', '', NULL, '正常状态');
INSERT INTO `sys_dict_data` VALUES (29, 2, '失败', '1', 'sys_common_status', '', 'danger', 'N', '0', 'admin', '2026-04-08 23:16:39', '', NULL, '停用状态');
INSERT INTO `sys_dict_data` VALUES (100, 0, '正常', '0', 'crop_status', NULL, 'success', 'N', '0', 'admin', '2026-04-09 16:22:38', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (101, 1, '病害', '1', 'crop_status', NULL, 'danger', 'N', '0', 'admin', '2026-04-09 16:23:03', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (102, 2, '虫害', '2', 'crop_status', NULL, 'danger', 'N', '0', 'admin', '2026-04-09 16:23:17', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (103, 0, '停用', '0', 'plot_status', NULL, 'info', 'N', '0', 'admin', '2026-04-09 22:18:03', 'admin', '2026-04-10 15:13:11', NULL);
INSERT INTO `sys_dict_data` VALUES (104, 1, '启用', '1', 'plot_status', NULL, 'primary', 'N', '0', 'admin', '2026-04-09 22:18:22', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (105, 2, '环境异常', '2', 'plot_status', NULL, 'danger', 'N', '0', 'admin', '2026-04-10 15:13:26', 'admin', '2026-04-10 19:19:32', NULL);
INSERT INTO `sys_dict_data` VALUES (106, 0, '目标检测det', '0', 'model_type', NULL, 'default', 'N', '0', 'admin', '2026-04-13 00:10:09', 'admin', '2026-04-13 00:12:11', NULL);
INSERT INTO `sys_dict_data` VALUES (107, 0, '实例分割ins', '1', 'model_type', NULL, 'default', 'N', '0', 'admin', '2026-04-13 00:10:47', 'admin', '2026-04-13 00:12:16', NULL);
INSERT INTO `sys_dict_data` VALUES (108, 0, '停用', '0', 'model_status', NULL, 'danger', 'N', '0', 'admin', '2026-04-13 00:13:05', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (109, 1, '启用', '1', 'model_status', NULL, 'success', 'N', '0', 'admin', '2026-04-13 00:13:19', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (110, 0, '停用', '0', 'alert_threshold_status', NULL, 'info', 'N', '0', 'admin', '2026-04-13 21:36:04', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (111, 1, '启用', '1', 'alert_threshold_status', NULL, 'success', 'N', '0', 'admin', '2026-04-13 21:36:14', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (112, 0, '异常中', '0', 'alert_history_status', NULL, 'danger', 'N', '0', 'admin', '2026-04-15 01:32:12', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (113, 1, '异常恢复', '1', 'alert_history_status', NULL, 'success', 'N', '0', 'admin', '2026-04-15 01:32:26', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (114, 0, '准确', '1', 'feedback_status', NULL, 'success', 'N', '0', 'admin', '2026-04-15 15:51:50', 'admin', '2026-04-15 15:52:28', NULL);
INSERT INTO `sys_dict_data` VALUES (115, 1, '不准确', '0', 'feedback_status', NULL, 'warning', 'N', '0', 'admin', '2026-04-15 15:52:15', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (116, 0, '图像检测', '0', 'detect_type', NULL, 'default', 'N', '0', 'admin', '2026-04-15 17:26:24', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (117, 0, '视频检测', '1', 'detect_type', NULL, 'default', 'N', '0', 'admin', '2026-04-15 17:26:32', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (118, 0, '空闲', '0', 'monitor_status', NULL, 'success', 'N', '0', 'admin', '2026-06-13 12:51:47', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (119, 1, '工作中', '1', 'monitor_status', NULL, 'warning', 'N', '0', 'admin', '2026-06-13 12:52:05', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (120, 2, '异常', '2', 'monitor_status', NULL, 'danger', 'N', '0', 'admin', '2026-06-13 12:52:20', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (121, 0, '处理中', '1', 'monitor_job_status', NULL, 'warning', 'N', '0', 'admin', '2026-06-13 13:00:22', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (122, 1, '处理完成', '2', 'monitor_job_status', NULL, 'success', 'N', '0', 'admin', '2026-06-13 13:00:48', '', NULL, NULL);
INSERT INTO `sys_dict_data` VALUES (123, 2, '处理失败', '3', 'monitor_job_status', NULL, 'danger', 'N', '0', 'admin', '2026-06-13 13:01:06', '', NULL, NULL);

-- ----------------------------
-- Table structure for sys_dict_type
-- ----------------------------
DROP TABLE IF EXISTS `sys_dict_type`;
CREATE TABLE `sys_dict_type`  (
  `dict_id` bigint NOT NULL AUTO_INCREMENT COMMENT '字典主键',
  `dict_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '字典名称',
  `dict_type` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '字典类型',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`dict_id`) USING BTREE,
  UNIQUE INDEX `dict_type`(`dict_type` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 110 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '字典类型表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_dict_type
-- ----------------------------
INSERT INTO `sys_dict_type` VALUES (1, '用户性别', 'sys_user_sex', '0', 'admin', '2026-04-08 23:16:39', '', NULL, '用户性别列表');
INSERT INTO `sys_dict_type` VALUES (2, '菜单状态', 'sys_show_hide', '0', 'admin', '2026-04-08 23:16:39', '', NULL, '菜单状态列表');
INSERT INTO `sys_dict_type` VALUES (3, '系统开关', 'sys_normal_disable', '0', 'admin', '2026-04-08 23:16:39', '', NULL, '系统开关列表');
INSERT INTO `sys_dict_type` VALUES (4, '任务状态', 'sys_job_status', '0', 'admin', '2026-04-08 23:16:39', '', NULL, '任务状态列表');
INSERT INTO `sys_dict_type` VALUES (5, '任务分组', 'sys_job_group', '0', 'admin', '2026-04-08 23:16:39', '', NULL, '任务分组列表');
INSERT INTO `sys_dict_type` VALUES (6, '系统是否', 'sys_yes_no', '0', 'admin', '2026-04-08 23:16:39', '', NULL, '系统是否列表');
INSERT INTO `sys_dict_type` VALUES (7, '通知类型', 'sys_notice_type', '0', 'admin', '2026-04-08 23:16:39', '', NULL, '通知类型列表');
INSERT INTO `sys_dict_type` VALUES (8, '通知状态', 'sys_notice_status', '0', 'admin', '2026-04-08 23:16:39', '', NULL, '通知状态列表');
INSERT INTO `sys_dict_type` VALUES (9, '操作类型', 'sys_oper_type', '0', 'admin', '2026-04-08 23:16:39', '', NULL, '操作类型列表');
INSERT INTO `sys_dict_type` VALUES (10, '系统状态', 'sys_common_status', '0', 'admin', '2026-04-08 23:16:39', '', NULL, '登录状态列表');
INSERT INTO `sys_dict_type` VALUES (100, '农产品状态', 'crop_status', '0', 'admin', '2026-04-09 16:22:10', '', NULL, NULL);
INSERT INTO `sys_dict_type` VALUES (101, '片区管理状态', 'plot_status', '0', 'admin', '2026-04-09 22:17:48', '', NULL, NULL);
INSERT INTO `sys_dict_type` VALUES (102, '模型类型', 'model_type', '0', 'admin', '2026-04-13 00:09:25', '', NULL, NULL);
INSERT INTO `sys_dict_type` VALUES (103, '模型状态', 'model_status', '0', 'admin', '2026-04-13 00:12:39', 'admin', '2026-04-13 00:12:45', NULL);
INSERT INTO `sys_dict_type` VALUES (104, '预警阈值配置状态', 'alert_threshold_status', '0', 'admin', '2026-04-13 21:35:40', '', NULL, NULL);
INSERT INTO `sys_dict_type` VALUES (105, '预警历史记录状态', 'alert_history_status', '0', 'admin', '2026-04-15 01:31:35', '', NULL, NULL);
INSERT INTO `sys_dict_type` VALUES (106, '用户反馈', 'feedback_status', '0', 'admin', '2026-04-15 15:51:14', '', NULL, NULL);
INSERT INTO `sys_dict_type` VALUES (107, '检测类型', 'detect_type', '0', 'admin', '2026-04-15 17:26:09', '', NULL, NULL);
INSERT INTO `sys_dict_type` VALUES (108, '监控状态', 'monitor_status', '0', 'admin', '2026-06-13 12:51:13', '', NULL, NULL);
INSERT INTO `sys_dict_type` VALUES (109, '监控任务状态', 'monitor_job_status', '0', 'admin', '2026-06-13 12:59:58', '', NULL, NULL);

-- ----------------------------
-- Table structure for sys_logininfor
-- ----------------------------
DROP TABLE IF EXISTS `sys_logininfor`;
CREATE TABLE `sys_logininfor`  (
  `info_id` bigint NOT NULL AUTO_INCREMENT COMMENT '访问ID',
  `user_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '用户账号',
  `ipaddr` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '登录IP地址',
  `login_location` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '登录地点',
  `browser` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '浏览器类型',
  `os` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '操作系统',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '登录状态（0成功 1失败）',
  `msg` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '提示消息',
  `login_time` datetime NULL DEFAULT NULL COMMENT '访问时间',
  PRIMARY KEY (`info_id`) USING BTREE,
  INDEX `idx_sys_logininfor_s`(`status` ASC) USING BTREE,
  INDEX `idx_sys_logininfor_lt`(`login_time` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 162 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '系统访问记录' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_logininfor
-- ----------------------------

-- ----------------------------
-- Table structure for sys_menu
-- ----------------------------
DROP TABLE IF EXISTS `sys_menu`;
CREATE TABLE `sys_menu`  (
  `menu_id` bigint NOT NULL AUTO_INCREMENT COMMENT '菜单ID',
  `menu_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '菜单名称',
  `parent_id` bigint NULL DEFAULT 0 COMMENT '父菜单ID',
  `order_num` int NULL DEFAULT 0 COMMENT '显示顺序',
  `path` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '路由地址',
  `component` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '组件路径',
  `query` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '路由参数',
  `route_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '路由名称',
  `is_frame` int NULL DEFAULT 1 COMMENT '是否为外链（0是 1否）',
  `is_cache` int NULL DEFAULT 0 COMMENT '是否缓存（0缓存 1不缓存）',
  `menu_type` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '菜单类型（M目录 C菜单 F按钮）',
  `visible` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '菜单状态（0显示 1隐藏）',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '菜单状态（0正常 1停用）',
  `perms` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '权限标识',
  `icon` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '#' COMMENT '菜单图标',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '备注',
  PRIMARY KEY (`menu_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2086 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '菜单权限表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_menu
-- ----------------------------
INSERT INTO `sys_menu` VALUES (1, '系统管理', 0, 1, 'system', NULL, '', '', 1, 0, 'M', '0', '0', '', 'system', 'admin', '2026-04-08 23:16:38', '', NULL, '系统管理目录');
INSERT INTO `sys_menu` VALUES (2, '系统监控', 0, 5, 'monitor', NULL, '', '', 1, 0, 'M', '0', '0', '', 'monitor', 'admin', '2026-04-08 23:16:38', 'admin', '2026-04-18 17:20:08', '系统监控目录');
INSERT INTO `sys_menu` VALUES (3, '系统工具', 0, 3, 'tool', NULL, '', '', 1, 0, 'M', '0', '0', '', 'tool', 'admin', '2026-04-08 23:16:38', 'admin', '2026-06-13 12:45:55', '系统工具目录');
INSERT INTO `sys_menu` VALUES (4, '若依官网', 0, 4, 'abv', NULL, '', '', 1, 0, 'M', '1', '1', '', 'guide', 'admin', '2026-04-08 23:16:38', 'admin', '2026-04-10 19:51:36', '若依官网地址');
INSERT INTO `sys_menu` VALUES (100, '用户管理', 1, 1, 'user', 'system/user/index', '', '', 1, 0, 'C', '0', '0', 'system:user:list', 'user', 'admin', '2026-04-08 23:16:38', '', NULL, '用户管理菜单');
INSERT INTO `sys_menu` VALUES (101, '角色管理', 1, 2, 'role', 'system/role/index', '', '', 1, 0, 'C', '0', '0', 'system:role:list', 'peoples', 'admin', '2026-04-08 23:16:38', '', NULL, '角色管理菜单');
INSERT INTO `sys_menu` VALUES (102, '菜单管理', 1, 3, 'menu', 'system/menu/index', '', '', 1, 0, 'C', '0', '0', 'system:menu:list', 'tree-table', 'admin', '2026-04-08 23:16:38', '', NULL, '菜单管理菜单');
INSERT INTO `sys_menu` VALUES (103, '部门管理', 1, 4, 'dept', 'system/dept/index', '', '', 1, 0, 'C', '0', '0', 'system:dept:list', 'tree', 'admin', '2026-04-08 23:16:38', '', NULL, '部门管理菜单');
INSERT INTO `sys_menu` VALUES (104, '岗位管理', 1, 5, 'post', 'system/post/index', '', '', 1, 0, 'C', '0', '0', 'system:post:list', 'post', 'admin', '2026-04-08 23:16:38', '', NULL, '岗位管理菜单');
INSERT INTO `sys_menu` VALUES (105, '字典管理', 1, 6, 'dict', 'system/dict/index', '', '', 1, 0, 'C', '0', '0', 'system:dict:list', 'dict', 'admin', '2026-04-08 23:16:38', '', NULL, '字典管理菜单');
INSERT INTO `sys_menu` VALUES (106, '参数设置', 1, 7, 'config', 'system/config/index', '', '', 1, 0, 'C', '0', '0', 'system:config:list', 'edit', 'admin', '2026-04-08 23:16:38', '', NULL, '参数设置菜单');
INSERT INTO `sys_menu` VALUES (107, '通知公告', 1, 8, 'notice', 'system/notice/index', '', '', 1, 0, 'C', '0', '0', 'system:notice:list', 'message', 'admin', '2026-04-08 23:16:38', '', NULL, '通知公告菜单');
INSERT INTO `sys_menu` VALUES (108, '日志管理', 1, 9, 'log', '', '', '', 1, 0, 'M', '0', '0', '', 'log', 'admin', '2026-04-08 23:16:38', '', NULL, '日志管理菜单');
INSERT INTO `sys_menu` VALUES (109, '在线用户', 2, 1, 'online', 'monitor/online/index', '', '', 1, 0, 'C', '0', '0', 'monitor:online:list', 'online', 'admin', '2026-04-08 23:16:38', '', NULL, '在线用户菜单');
INSERT INTO `sys_menu` VALUES (111, '数据监控', 2, 3, 'druid', 'monitor/druid/index', '', '', 1, 0, 'C', '0', '0', 'monitor:druid:list', 'druid', 'admin', '2026-04-08 23:16:38', '', NULL, '数据监控菜单');
INSERT INTO `sys_menu` VALUES (112, '服务监控', 2, 4, 'server', 'monitor/server/index', '', '', 1, 0, 'C', '0', '0', 'monitor:server:list', 'server', 'admin', '2026-04-08 23:16:38', '', NULL, '服务监控菜单');
INSERT INTO `sys_menu` VALUES (113, '缓存监控', 2, 5, 'cache', 'monitor/cache/index', '', '', 1, 0, 'C', '0', '0', 'monitor:cache:list', 'redis', 'admin', '2026-04-08 23:16:38', '', NULL, '缓存监控菜单');
INSERT INTO `sys_menu` VALUES (114, '缓存列表', 2, 6, 'cacheList', 'monitor/cache/list', '', '', 1, 0, 'C', '0', '0', 'monitor:cache:list', 'redis-list', 'admin', '2026-04-08 23:16:38', '', NULL, '缓存列表菜单');
INSERT INTO `sys_menu` VALUES (115, '表单构建', 3, 1, 'build', 'tool/build/index', '', '', 1, 0, 'C', '0', '0', 'tool:build:list', 'build', 'admin', '2026-04-08 23:16:38', '', NULL, '表单构建菜单');
INSERT INTO `sys_menu` VALUES (116, '代码生成', 3, 2, 'gen', 'tool/gen/index', '', '', 1, 0, 'C', '0', '0', 'tool:gen:list', 'code', 'admin', '2026-04-08 23:16:38', '', NULL, '代码生成菜单');
INSERT INTO `sys_menu` VALUES (117, '系统接口', 3, 3, 'swagger', 'tool/swagger/index', '', '', 1, 0, 'C', '0', '0', 'tool:swagger:list', 'swagger', 'admin', '2026-04-08 23:16:38', '', NULL, '系统接口菜单');
INSERT INTO `sys_menu` VALUES (500, '操作日志', 108, 1, 'operlog', 'monitor/operlog/index', '', '', 1, 0, 'C', '0', '0', 'monitor:operlog:list', 'form', 'admin', '2026-04-08 23:16:38', '', NULL, '操作日志菜单');
INSERT INTO `sys_menu` VALUES (501, '登录日志', 108, 2, 'logininfor', 'monitor/logininfor/index', '', '', 1, 0, 'C', '0', '0', 'monitor:logininfor:list', 'logininfor', 'admin', '2026-04-08 23:16:38', '', NULL, '登录日志菜单');
INSERT INTO `sys_menu` VALUES (1000, '用户查询', 100, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:query', '#', 'admin', '2026-04-08 23:16:38', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1001, '用户新增', 100, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:add', '#', 'admin', '2026-04-08 23:16:38', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1002, '用户修改', 100, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:edit', '#', 'admin', '2026-04-08 23:16:38', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1003, '用户删除', 100, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:remove', '#', 'admin', '2026-04-08 23:16:38', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1004, '用户导出', 100, 5, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:export', '#', 'admin', '2026-04-08 23:16:38', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1005, '用户导入', 100, 6, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:import', '#', 'admin', '2026-04-08 23:16:38', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1006, '重置密码', 100, 7, '', '', '', '', 1, 0, 'F', '0', '0', 'system:user:resetPwd', '#', 'admin', '2026-04-08 23:16:38', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1007, '角色查询', 101, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'system:role:query', '#', 'admin', '2026-04-08 23:16:38', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1008, '角色新增', 101, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'system:role:add', '#', 'admin', '2026-04-08 23:16:38', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1009, '角色修改', 101, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'system:role:edit', '#', 'admin', '2026-04-08 23:16:38', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1010, '角色删除', 101, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'system:role:remove', '#', 'admin', '2026-04-08 23:16:38', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1011, '角色导出', 101, 5, '', '', '', '', 1, 0, 'F', '0', '0', 'system:role:export', '#', 'admin', '2026-04-08 23:16:38', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1012, '菜单查询', 102, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'system:menu:query', '#', 'admin', '2026-04-08 23:16:38', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1013, '菜单新增', 102, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'system:menu:add', '#', 'admin', '2026-04-08 23:16:38', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1014, '菜单修改', 102, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'system:menu:edit', '#', 'admin', '2026-04-08 23:16:38', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1015, '菜单删除', 102, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'system:menu:remove', '#', 'admin', '2026-04-08 23:16:38', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1016, '部门查询', 103, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'system:dept:query', '#', 'admin', '2026-04-08 23:16:38', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1017, '部门新增', 103, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'system:dept:add', '#', 'admin', '2026-04-08 23:16:38', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1018, '部门修改', 103, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'system:dept:edit', '#', 'admin', '2026-04-08 23:16:38', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1019, '部门删除', 103, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'system:dept:remove', '#', 'admin', '2026-04-08 23:16:38', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1020, '岗位查询', 104, 1, '', '', '', '', 1, 0, 'F', '0', '0', 'system:post:query', '#', 'admin', '2026-04-08 23:16:38', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1021, '岗位新增', 104, 2, '', '', '', '', 1, 0, 'F', '0', '0', 'system:post:add', '#', 'admin', '2026-04-08 23:16:38', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1022, '岗位修改', 104, 3, '', '', '', '', 1, 0, 'F', '0', '0', 'system:post:edit', '#', 'admin', '2026-04-08 23:16:38', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1023, '岗位删除', 104, 4, '', '', '', '', 1, 0, 'F', '0', '0', 'system:post:remove', '#', 'admin', '2026-04-08 23:16:38', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1024, '岗位导出', 104, 5, '', '', '', '', 1, 0, 'F', '0', '0', 'system:post:export', '#', 'admin', '2026-04-08 23:16:38', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1025, '字典查询', 105, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:dict:query', '#', 'admin', '2026-04-08 23:16:38', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1026, '字典新增', 105, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:dict:add', '#', 'admin', '2026-04-08 23:16:38', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1027, '字典修改', 105, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:dict:edit', '#', 'admin', '2026-04-08 23:16:38', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1028, '字典删除', 105, 4, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:dict:remove', '#', 'admin', '2026-04-08 23:16:38', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1029, '字典导出', 105, 5, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:dict:export', '#', 'admin', '2026-04-08 23:16:38', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1030, '参数查询', 106, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:config:query', '#', 'admin', '2026-04-08 23:16:38', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1031, '参数新增', 106, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:config:add', '#', 'admin', '2026-04-08 23:16:38', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1032, '参数修改', 106, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:config:edit', '#', 'admin', '2026-04-08 23:16:38', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1033, '参数删除', 106, 4, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:config:remove', '#', 'admin', '2026-04-08 23:16:38', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1034, '参数导出', 106, 5, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:config:export', '#', 'admin', '2026-04-08 23:16:38', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1035, '公告查询', 107, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:notice:query', '#', 'admin', '2026-04-08 23:16:38', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1036, '公告新增', 107, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:notice:add', '#', 'admin', '2026-04-08 23:16:38', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1037, '公告修改', 107, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:notice:edit', '#', 'admin', '2026-04-08 23:16:38', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1038, '公告删除', 107, 4, '#', '', '', '', 1, 0, 'F', '0', '0', 'system:notice:remove', '#', 'admin', '2026-04-08 23:16:38', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1039, '操作查询', 500, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:operlog:query', '#', 'admin', '2026-04-08 23:16:38', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1040, '操作删除', 500, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:operlog:remove', '#', 'admin', '2026-04-08 23:16:38', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1041, '日志导出', 500, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:operlog:export', '#', 'admin', '2026-04-08 23:16:38', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1042, '登录查询', 501, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:query', '#', 'admin', '2026-04-08 23:16:38', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1043, '登录删除', 501, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:remove', '#', 'admin', '2026-04-08 23:16:38', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1044, '日志导出', 501, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:export', '#', 'admin', '2026-04-08 23:16:38', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1045, '账户解锁', 501, 4, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:logininfor:unlock', '#', 'admin', '2026-04-08 23:16:38', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1046, '在线查询', 109, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:online:query', '#', 'admin', '2026-04-08 23:16:38', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1047, '批量强退', 109, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:online:batchLogout', '#', 'admin', '2026-04-08 23:16:38', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1048, '单条强退', 109, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'monitor:online:forceLogout', '#', 'admin', '2026-04-08 23:16:38', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1055, '生成查询', 116, 1, '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:query', '#', 'admin', '2026-04-08 23:16:38', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1056, '生成修改', 116, 2, '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:edit', '#', 'admin', '2026-04-08 23:16:38', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1057, '生成删除', 116, 3, '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:remove', '#', 'admin', '2026-04-08 23:16:38', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1058, '导入代码', 116, 4, '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:import', '#', 'admin', '2026-04-08 23:16:38', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1059, '预览代码', 116, 5, '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:preview', '#', 'admin', '2026-04-08 23:16:38', '', NULL, '');
INSERT INTO `sys_menu` VALUES (1060, '生成代码', 116, 6, '#', '', '', '', 1, 0, 'F', '0', '0', 'tool:gen:code', '#', 'admin', '2026-04-08 23:16:38', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2006, '农作物管理', 0, 1, 'corp', NULL, NULL, '', 1, 0, 'M', '0', '0', NULL, 'bug', 'admin', '2026-04-09 17:05:44', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2007, '农作物数据库', 2006, 1, 'crop', 'crop/crop/index', NULL, '', 1, 1, 'C', '0', '0', 'crop:crop:list', '#', 'admin', '2026-04-09 17:08:54', 'admin', '2026-04-10 01:57:50', '农作物信息菜单');
INSERT INTO `sys_menu` VALUES (2008, '农作物信息查询', 2007, 1, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'crop:crop:query', '#', 'admin', '2026-04-09 17:08:54', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2009, '农作物信息新增', 2007, 2, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'crop:crop:add', '#', 'admin', '2026-04-09 17:08:54', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2010, '农作物信息修改', 2007, 3, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'crop:crop:edit', '#', 'admin', '2026-04-09 17:08:54', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2011, '农作物信息删除', 2007, 4, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'crop:crop:remove', '#', 'admin', '2026-04-09 17:08:54', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2012, '农作物信息导出', 2007, 5, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'crop:crop:export', '#', 'admin', '2026-04-09 17:08:54', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2013, '农作物品种', 2006, 1, 'variety', 'crop/variety/index', NULL, '', 1, 0, 'C', '0', '0', 'crop:variety:list', '#', 'admin', '2026-04-09 17:08:54', 'admin', '2026-04-15 02:21:20', '农作物品种菜单');
INSERT INTO `sys_menu` VALUES (2014, '农作物品种查询', 2013, 1, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'crop:variety:query', '#', 'admin', '2026-04-09 17:08:54', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2015, '农作物品种新增', 2013, 2, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'crop:variety:add', '#', 'admin', '2026-04-09 17:08:54', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2016, '农作物品种修改', 2013, 3, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'crop:variety:edit', '#', 'admin', '2026-04-09 17:08:54', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2017, '农作物品种删除', 2013, 4, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'crop:variety:remove', '#', 'admin', '2026-04-09 17:08:54', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2018, '农作物品种导出', 2013, 5, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'crop:variety:export', '#', 'admin', '2026-04-09 17:08:54', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2019, '片区管理', 0, 2, 'plotManager', NULL, NULL, '', 1, 0, 'M', '0', '0', '', 'component', 'admin', '2026-04-09 22:06:45', 'admin', '2026-04-10 01:59:15', '');
INSERT INTO `sys_menu` VALUES (2020, '片区信息', 2019, 1, 'plot', 'plot/plot/index', NULL, '', 1, 1, 'C', '0', '0', 'plot:plot:list', '#', 'admin', '2026-04-09 22:24:36', 'admin', '2026-04-10 01:59:19', '片区信息菜单');
INSERT INTO `sys_menu` VALUES (2021, '片区信息查询', 2020, 1, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'plot:plot:query', '#', 'admin', '2026-04-09 22:24:36', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2022, '片区信息新增', 2020, 2, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'plot:plot:add', '#', 'admin', '2026-04-09 22:24:36', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2023, '片区信息修改', 2020, 3, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'plot:plot:edit', '#', 'admin', '2026-04-09 22:24:36', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2024, '片区信息删除', 2020, 4, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'plot:plot:remove', '#', 'admin', '2026-04-09 22:24:36', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2025, '片区信息导出', 2020, 5, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'plot:plot:export', '#', 'admin', '2026-04-09 22:24:36', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2026, '片区类型', 2019, 1, 'plot-type', 'plot/type/index', NULL, '', 1, 0, 'C', '0', '0', 'plot:type:list', '#', 'admin', '2026-04-09 22:41:06', 'admin', '2026-04-13 23:38:47', '片区类型菜单');
INSERT INTO `sys_menu` VALUES (2027, '片区类型查询', 2026, 1, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'plot:type:query', '#', 'admin', '2026-04-09 22:41:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2028, '片区类型新增', 2026, 2, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'plot:type:add', '#', 'admin', '2026-04-09 22:41:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2029, '片区类型修改', 2026, 3, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'plot:type:edit', '#', 'admin', '2026-04-09 22:41:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2030, '片区类型删除', 2026, 4, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'plot:type:remove', '#', 'admin', '2026-04-09 22:41:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2031, '片区类型导出', 2026, 5, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'plot:type:export', '#', 'admin', '2026-04-09 22:41:06', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2032, '片区环境', 2019, 1, 'realtime', 'plot/realtime/index', NULL, '', 1, 0, 'C', '0', '0', 'plot:realtime:list', '#', 'admin', '2026-04-10 16:16:14', 'admin', '2026-04-10 17:12:18', '片区环境实时数据(仅限测试)菜单');
INSERT INTO `sys_menu` VALUES (2033, '片区环境实时数据(仅限测试)查询', 2032, 1, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'plot:realtime:query', '#', 'admin', '2026-04-10 16:16:14', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2034, '片区环境实时数据(仅限测试)新增', 2032, 2, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'plot:realtime:add', '#', 'admin', '2026-04-10 16:16:14', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2035, '片区环境实时数据(仅限测试)修改', 2032, 3, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'plot:realtime:edit', '#', 'admin', '2026-04-10 16:16:14', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2036, '片区环境实时数据(仅限测试)删除', 2032, 4, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'plot:realtime:remove', '#', 'admin', '2026-04-10 16:16:14', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2037, '片区环境实时数据(仅限测试)导出', 2032, 5, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'plot:realtime:export', '#', 'admin', '2026-04-10 16:16:14', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2038, '模型管理', 0, 3, 'models', NULL, NULL, '', 1, 0, 'M', '0', '0', NULL, 'phone', 'admin', '2026-04-12 23:45:22', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2039, '模型配置', 2038, 1, 'config', 'model/config/index', NULL, '', 1, 0, 'C', '0', '0', 'model:config:list', '#', 'admin', '2026-04-13 00:18:09', '', NULL, '模型配置菜单');
INSERT INTO `sys_menu` VALUES (2040, '模型配置查询', 2039, 1, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'model:config:query', '#', 'admin', '2026-04-13 00:18:09', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2041, '模型配置新增', 2039, 2, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'model:config:add', '#', 'admin', '2026-04-13 00:18:09', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2042, '模型配置修改', 2039, 3, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'model:config:edit', '#', 'admin', '2026-04-13 00:18:09', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2043, '模型配置删除', 2039, 4, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'model:config:remove', '#', 'admin', '2026-04-13 00:18:09', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2044, '模型配置导出', 2039, 5, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'model:config:export', '#', 'admin', '2026-04-13 00:18:09', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2045, '预警管理', 0, 4, 'alert', NULL, NULL, '', 1, 0, 'M', '0', '0', NULL, 'time-range', 'admin', '2026-04-13 21:20:43', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2046, '预警阈值配置', 2045, 1, 'threshold', 'alert/threshold/index', NULL, '', 1, 0, 'C', '0', '0', 'alert:threshold:list', '#', 'admin', '2026-04-13 21:25:23', '', NULL, '预警阈值配置菜单');
INSERT INTO `sys_menu` VALUES (2047, '预警阈值配置查询', 2046, 1, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'alert:threshold:query', '#', 'admin', '2026-04-13 21:25:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2048, '预警阈值配置新增', 2046, 2, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'alert:threshold:add', '#', 'admin', '2026-04-13 21:25:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2049, '预警阈值配置修改', 2046, 3, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'alert:threshold:edit', '#', 'admin', '2026-04-13 21:25:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2050, '预警阈值配置删除', 2046, 4, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'alert:threshold:remove', '#', 'admin', '2026-04-13 21:25:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2051, '预警阈值配置导出', 2046, 5, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'alert:threshold:export', '#', 'admin', '2026-04-13 21:25:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2052, '预警阈值类型', 2045, 1, 'alert-type', 'alert/type/index', NULL, '', 1, 0, 'C', '0', '0', 'alert:type:list', '#', 'admin', '2026-04-13 21:47:23', 'admin', '2026-04-13 23:38:36', '预警阈值类型菜单');
INSERT INTO `sys_menu` VALUES (2053, '预警阈值类型查询', 2052, 1, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'alert:type:query', '#', 'admin', '2026-04-13 21:47:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2054, '预警阈值类型新增', 2052, 2, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'alert:type:add', '#', 'admin', '2026-04-13 21:47:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2055, '预警阈值类型修改', 2052, 3, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'alert:type:edit', '#', 'admin', '2026-04-13 21:47:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2056, '预警阈值类型删除', 2052, 4, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'alert:type:remove', '#', 'admin', '2026-04-13 21:47:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2057, '预警阈值类型导出', 2052, 5, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'alert:type:export', '#', 'admin', '2026-04-13 21:47:23', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2058, '预警历史记录', 2045, 1, 'history', 'alert/history/index', NULL, '', 1, 1, 'C', '0', '0', 'alert:history:list', '#', 'admin', '2026-04-15 01:21:15', 'admin', '2026-04-15 02:20:57', '预警历史记录菜单');
INSERT INTO `sys_menu` VALUES (2059, '预警历史记录查询', 2058, 1, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'alert:history:query', '#', 'admin', '2026-04-15 01:21:15', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2060, '预警历史记录新增', 2058, 2, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'alert:history:add', '#', 'admin', '2026-04-15 01:21:15', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2061, '预警历史记录修改', 2058, 3, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'alert:history:edit', '#', 'admin', '2026-04-15 01:21:15', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2062, '预警历史记录删除', 2058, 4, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'alert:history:remove', '#', 'admin', '2026-04-15 01:21:15', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2063, '预警历史记录导出', 2058, 5, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'alert:history:export', '#', 'admin', '2026-04-15 01:21:15', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2064, '农作物检测', 0, 2, 'detect', NULL, NULL, '', 1, 0, 'M', '0', '0', '', 'search', 'admin', '2026-04-15 15:17:09', 'admin', '2026-04-18 17:20:33', '');
INSERT INTO `sys_menu` VALUES (2065, '在线检测', 2064, 1, 'online-detect', NULL, NULL, '', 1, 0, 'M', '0', '0', '', '#', 'admin', '2026-04-15 15:18:41', 'admin', '2026-04-15 15:23:01', '');
INSERT INTO `sys_menu` VALUES (2066, '检测日志', 2065, 1, 'log', 'model/log/index', NULL, '', 1, 0, 'C', '0', '0', 'model:log:list', '#', 'admin', '2026-04-15 17:27:40', '', NULL, '检测日志菜单');
INSERT INTO `sys_menu` VALUES (2067, '检测日志查询', 2066, 1, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'model:log:query', '#', 'admin', '2026-04-15 17:27:40', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2068, '检测日志新增', 2066, 2, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'model:log:add', '#', 'admin', '2026-04-15 17:27:40', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2069, '检测日志修改', 2066, 3, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'model:log:edit', '#', 'admin', '2026-04-15 17:27:40', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2070, '检测日志删除', 2066, 4, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'model:log:remove', '#', 'admin', '2026-04-15 17:27:40', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2071, '检测日志导出', 2066, 5, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'model:log:export', '#', 'admin', '2026-04-15 17:27:40', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2072, '病虫害检测', 2065, 0, 'disease/detect', 'model/disease/index', NULL, '', 1, 0, 'C', '0', '0', '', '#', 'admin', '2026-04-16 18:10:58', 'admin', '2026-04-16 18:49:31', '');
INSERT INTO `sys_menu` VALUES (2073, '监控检测', 2064, 2, 'monitor-ser', NULL, NULL, '', 1, 0, 'M', '0', '0', '', '#', 'admin', '2026-04-18 18:26:03', 'admin', '2026-06-13 14:31:19', '');
INSERT INTO `sys_menu` VALUES (2074, '监控任务', 2073, 2, 'job', 'monitor-ser/job/index', NULL, '', 1, 0, 'C', '0', '0', 'monitor:job:list', '#', 'admin', '2026-06-13 14:17:09', 'admin', '2026-06-13 14:35:10', '监控任务菜单');
INSERT INTO `sys_menu` VALUES (2075, '监控任务查询', 2074, 1, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'monitor:job:query', '#', 'admin', '2026-06-13 14:17:09', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2076, '监控任务新增', 2074, 2, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'monitor:job:add', '#', 'admin', '2026-06-13 14:17:09', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2077, '监控任务修改', 2074, 3, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'monitor:job:edit', '#', 'admin', '2026-06-13 14:17:09', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2078, '监控任务删除', 2074, 4, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'monitor:job:remove', '#', 'admin', '2026-06-13 14:17:09', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2079, '监控任务导出', 2074, 5, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'monitor:job:export', '#', 'admin', '2026-06-13 14:17:09', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2080, '监控管理', 2073, 1, 'manage', 'monitor-ser/manage/index', NULL, '', 1, 1, 'C', '0', '0', 'monitor:manage:list', '#', 'admin', '2026-06-13 14:17:10', 'admin', '2026-06-13 23:30:02', '监控管理菜单');
INSERT INTO `sys_menu` VALUES (2081, '监控管理查询', 2080, 1, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'monitor:manage:query', '#', 'admin', '2026-06-13 14:17:10', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2082, '监控管理新增', 2080, 2, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'monitor:manage:add', '#', 'admin', '2026-06-13 14:17:10', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2083, '监控管理修改', 2080, 3, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'monitor:manage:edit', '#', 'admin', '2026-06-13 14:17:10', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2084, '监控管理删除', 2080, 4, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'monitor:manage:remove', '#', 'admin', '2026-06-13 14:17:10', '', NULL, '');
INSERT INTO `sys_menu` VALUES (2085, '监控管理导出', 2080, 5, '#', '', NULL, '', 1, 0, 'F', '0', '0', 'monitor:manage:export', '#', 'admin', '2026-06-13 14:17:10', '', NULL, '');

-- ----------------------------
-- Table structure for sys_notice
-- ----------------------------
DROP TABLE IF EXISTS `sys_notice`;
CREATE TABLE `sys_notice`  (
  `notice_id` int NOT NULL AUTO_INCREMENT COMMENT '公告ID',
  `notice_title` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '公告标题',
  `notice_type` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '公告类型（1通知 2公告）',
  `notice_content` longblob NULL COMMENT '公告内容',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '公告状态（0正常 1关闭）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`notice_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '通知公告表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_notice
-- ----------------------------
INSERT INTO `sys_notice` VALUES (1, '温馨提醒：2018-07-01 新版本发布啦', '2', 0xE696B0E78988E69CACE58685E5AEB9, '0', 'admin', '2026-04-08 23:16:40', '', NULL, '管理员');
INSERT INTO `sys_notice` VALUES (2, '维护通知：2018-07-01 系统凌晨维护', '1', 0xE7BBB4E68AA4E58685E5AEB9, '0', 'admin', '2026-04-08 23:16:40', '', NULL, '管理员');

-- ----------------------------
-- Table structure for sys_notice_read
-- ----------------------------
DROP TABLE IF EXISTS `sys_notice_read`;
CREATE TABLE `sys_notice_read`  (
  `read_id` bigint NOT NULL AUTO_INCREMENT COMMENT '已读主键',
  `notice_id` int NOT NULL COMMENT '公告id',
  `user_id` bigint NOT NULL COMMENT '用户id',
  `read_time` datetime NOT NULL COMMENT '阅读时间',
  PRIMARY KEY (`read_id`) USING BTREE,
  UNIQUE INDEX `uk_user_notice`(`user_id` ASC, `notice_id` ASC) USING BTREE COMMENT '同一用户同一公告只记录一次'
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '公告已读记录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_notice_read
-- ----------------------------

-- ----------------------------
-- Table structure for sys_oper_log
-- ----------------------------
DROP TABLE IF EXISTS `sys_oper_log`;
CREATE TABLE `sys_oper_log`  (
  `oper_id` bigint NOT NULL AUTO_INCREMENT COMMENT '日志主键',
  `title` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '模块标题',
  `business_type` int NULL DEFAULT 0 COMMENT '业务类型（0其它 1新增 2修改 3删除）',
  `method` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '方法名称',
  `request_method` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '请求方式',
  `operator_type` int NULL DEFAULT 0 COMMENT '操作类别（0其它 1后台用户 2手机端用户）',
  `oper_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '操作人员',
  `dept_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '部门名称',
  `oper_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '请求URL',
  `oper_ip` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '主机地址',
  `oper_location` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '操作地点',
  `oper_param` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '请求参数',
  `json_result` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '返回参数',
  `status` int NULL DEFAULT 0 COMMENT '操作状态（0正常 1异常）',
  `error_msg` varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '错误消息',
  `oper_time` datetime NULL DEFAULT NULL COMMENT '操作时间',
  `cost_time` bigint NULL DEFAULT 0 COMMENT '消耗时间',
  PRIMARY KEY (`oper_id`) USING BTREE,
  INDEX `idx_sys_oper_log_bt`(`business_type` ASC) USING BTREE,
  INDEX `idx_sys_oper_log_s`(`status` ASC) USING BTREE,
  INDEX `idx_sys_oper_log_ot`(`oper_time` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 668 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '操作日志记录' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for sys_post
-- ----------------------------
DROP TABLE IF EXISTS `sys_post`;
CREATE TABLE `sys_post`  (
  `post_id` bigint NOT NULL AUTO_INCREMENT COMMENT '岗位ID',
  `post_code` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '岗位编码',
  `post_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '岗位名称',
  `post_sort` int NOT NULL COMMENT '显示顺序',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '状态（0正常 1停用）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`post_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '岗位信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_post
-- ----------------------------
INSERT INTO `sys_post` VALUES (1, 'ceo', '董事长', 1, '0', 'admin', '2026-04-08 23:16:38', '', NULL, '');
INSERT INTO `sys_post` VALUES (2, 'se', '项目经理', 2, '0', 'admin', '2026-04-08 23:16:38', '', NULL, '');
INSERT INTO `sys_post` VALUES (3, 'hr', '人力资源', 3, '0', 'admin', '2026-04-08 23:16:38', '', NULL, '');
INSERT INTO `sys_post` VALUES (4, 'user', '普通员工', 4, '0', 'admin', '2026-04-08 23:16:38', '', NULL, '');

-- ----------------------------
-- Table structure for sys_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_role`;
CREATE TABLE `sys_role`  (
  `role_id` bigint NOT NULL AUTO_INCREMENT COMMENT '角色ID',
  `role_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '角色名称',
  `role_key` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '角色权限字符串',
  `role_sort` int NOT NULL COMMENT '显示顺序',
  `data_scope` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '1' COMMENT '数据范围（1：全部数据权限 2：自定数据权限 3：本部门数据权限 4：本部门及以下数据权限）',
  `menu_check_strictly` tinyint(1) NULL DEFAULT 1 COMMENT '菜单树选择项是否关联显示',
  `dept_check_strictly` tinyint(1) NULL DEFAULT 1 COMMENT '部门树选择项是否关联显示',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '角色状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`role_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 101 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '角色信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_role
-- ----------------------------
INSERT INTO `sys_role` VALUES (1, '超级管理员', 'admin', 1, '1', 1, 1, '0', '0', 'admin', '2026-04-08 23:16:38', '', NULL, '超级管理员');
INSERT INTO `sys_role` VALUES (2, '普通角色', 'common', 2, '2', 1, 1, '0', '0', 'admin', '2026-04-08 23:16:38', 'admin', '2026-04-13 20:30:18', '普通角色');
INSERT INTO `sys_role` VALUES (100, '片区管理员', 'plot', 3, '1', 1, 1, '0', '0', 'admin', '2026-04-09 22:28:45', 'admin', '2026-04-09 22:28:52', NULL);

-- ----------------------------
-- Table structure for sys_role_dept
-- ----------------------------
DROP TABLE IF EXISTS `sys_role_dept`;
CREATE TABLE `sys_role_dept`  (
  `role_id` bigint NOT NULL COMMENT '角色ID',
  `dept_id` bigint NOT NULL COMMENT '部门ID',
  PRIMARY KEY (`role_id`, `dept_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '角色和部门关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_role_dept
-- ----------------------------
INSERT INTO `sys_role_dept` VALUES (2, 100);
INSERT INTO `sys_role_dept` VALUES (2, 101);
INSERT INTO `sys_role_dept` VALUES (2, 105);

-- ----------------------------
-- Table structure for sys_role_menu
-- ----------------------------
DROP TABLE IF EXISTS `sys_role_menu`;
CREATE TABLE `sys_role_menu`  (
  `role_id` bigint NOT NULL COMMENT '角色ID',
  `menu_id` bigint NOT NULL COMMENT '菜单ID',
  PRIMARY KEY (`role_id`, `menu_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '角色和菜单关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_role_menu
-- ----------------------------
INSERT INTO `sys_role_menu` VALUES (2, 1);
INSERT INTO `sys_role_menu` VALUES (2, 2);
INSERT INTO `sys_role_menu` VALUES (2, 100);
INSERT INTO `sys_role_menu` VALUES (2, 101);
INSERT INTO `sys_role_menu` VALUES (2, 102);
INSERT INTO `sys_role_menu` VALUES (2, 103);
INSERT INTO `sys_role_menu` VALUES (2, 104);
INSERT INTO `sys_role_menu` VALUES (2, 105);
INSERT INTO `sys_role_menu` VALUES (2, 106);
INSERT INTO `sys_role_menu` VALUES (2, 107);
INSERT INTO `sys_role_menu` VALUES (2, 108);
INSERT INTO `sys_role_menu` VALUES (2, 109);
INSERT INTO `sys_role_menu` VALUES (2, 110);
INSERT INTO `sys_role_menu` VALUES (2, 111);
INSERT INTO `sys_role_menu` VALUES (2, 112);
INSERT INTO `sys_role_menu` VALUES (2, 113);
INSERT INTO `sys_role_menu` VALUES (2, 114);
INSERT INTO `sys_role_menu` VALUES (2, 500);
INSERT INTO `sys_role_menu` VALUES (2, 501);
INSERT INTO `sys_role_menu` VALUES (2, 1000);
INSERT INTO `sys_role_menu` VALUES (2, 1001);
INSERT INTO `sys_role_menu` VALUES (2, 1002);
INSERT INTO `sys_role_menu` VALUES (2, 1003);
INSERT INTO `sys_role_menu` VALUES (2, 1004);
INSERT INTO `sys_role_menu` VALUES (2, 1005);
INSERT INTO `sys_role_menu` VALUES (2, 1006);
INSERT INTO `sys_role_menu` VALUES (2, 1007);
INSERT INTO `sys_role_menu` VALUES (2, 1008);
INSERT INTO `sys_role_menu` VALUES (2, 1009);
INSERT INTO `sys_role_menu` VALUES (2, 1010);
INSERT INTO `sys_role_menu` VALUES (2, 1011);
INSERT INTO `sys_role_menu` VALUES (2, 1012);
INSERT INTO `sys_role_menu` VALUES (2, 1013);
INSERT INTO `sys_role_menu` VALUES (2, 1014);
INSERT INTO `sys_role_menu` VALUES (2, 1015);
INSERT INTO `sys_role_menu` VALUES (2, 1016);
INSERT INTO `sys_role_menu` VALUES (2, 1017);
INSERT INTO `sys_role_menu` VALUES (2, 1018);
INSERT INTO `sys_role_menu` VALUES (2, 1019);
INSERT INTO `sys_role_menu` VALUES (2, 1020);
INSERT INTO `sys_role_menu` VALUES (2, 1021);
INSERT INTO `sys_role_menu` VALUES (2, 1022);
INSERT INTO `sys_role_menu` VALUES (2, 1023);
INSERT INTO `sys_role_menu` VALUES (2, 1024);
INSERT INTO `sys_role_menu` VALUES (2, 1025);
INSERT INTO `sys_role_menu` VALUES (2, 1026);
INSERT INTO `sys_role_menu` VALUES (2, 1027);
INSERT INTO `sys_role_menu` VALUES (2, 1028);
INSERT INTO `sys_role_menu` VALUES (2, 1029);
INSERT INTO `sys_role_menu` VALUES (2, 1030);
INSERT INTO `sys_role_menu` VALUES (2, 1031);
INSERT INTO `sys_role_menu` VALUES (2, 1032);
INSERT INTO `sys_role_menu` VALUES (2, 1033);
INSERT INTO `sys_role_menu` VALUES (2, 1034);
INSERT INTO `sys_role_menu` VALUES (2, 1035);
INSERT INTO `sys_role_menu` VALUES (2, 1036);
INSERT INTO `sys_role_menu` VALUES (2, 1037);
INSERT INTO `sys_role_menu` VALUES (2, 1038);
INSERT INTO `sys_role_menu` VALUES (2, 1039);
INSERT INTO `sys_role_menu` VALUES (2, 1040);
INSERT INTO `sys_role_menu` VALUES (2, 1041);
INSERT INTO `sys_role_menu` VALUES (2, 1042);
INSERT INTO `sys_role_menu` VALUES (2, 1043);
INSERT INTO `sys_role_menu` VALUES (2, 1044);
INSERT INTO `sys_role_menu` VALUES (2, 1045);
INSERT INTO `sys_role_menu` VALUES (2, 1046);
INSERT INTO `sys_role_menu` VALUES (2, 1047);
INSERT INTO `sys_role_menu` VALUES (2, 1048);
INSERT INTO `sys_role_menu` VALUES (2, 1049);
INSERT INTO `sys_role_menu` VALUES (2, 1050);
INSERT INTO `sys_role_menu` VALUES (2, 1051);
INSERT INTO `sys_role_menu` VALUES (2, 1052);
INSERT INTO `sys_role_menu` VALUES (2, 1053);
INSERT INTO `sys_role_menu` VALUES (2, 1054);
INSERT INTO `sys_role_menu` VALUES (2, 2006);
INSERT INTO `sys_role_menu` VALUES (2, 2007);
INSERT INTO `sys_role_menu` VALUES (2, 2008);
INSERT INTO `sys_role_menu` VALUES (2, 2009);
INSERT INTO `sys_role_menu` VALUES (2, 2010);
INSERT INTO `sys_role_menu` VALUES (2, 2011);
INSERT INTO `sys_role_menu` VALUES (2, 2012);
INSERT INTO `sys_role_menu` VALUES (2, 2013);
INSERT INTO `sys_role_menu` VALUES (2, 2014);
INSERT INTO `sys_role_menu` VALUES (2, 2015);
INSERT INTO `sys_role_menu` VALUES (2, 2016);
INSERT INTO `sys_role_menu` VALUES (2, 2017);
INSERT INTO `sys_role_menu` VALUES (2, 2018);
INSERT INTO `sys_role_menu` VALUES (2, 2019);
INSERT INTO `sys_role_menu` VALUES (2, 2020);
INSERT INTO `sys_role_menu` VALUES (2, 2021);
INSERT INTO `sys_role_menu` VALUES (2, 2022);
INSERT INTO `sys_role_menu` VALUES (2, 2023);
INSERT INTO `sys_role_menu` VALUES (2, 2024);
INSERT INTO `sys_role_menu` VALUES (2, 2025);
INSERT INTO `sys_role_menu` VALUES (2, 2026);
INSERT INTO `sys_role_menu` VALUES (2, 2027);
INSERT INTO `sys_role_menu` VALUES (2, 2028);
INSERT INTO `sys_role_menu` VALUES (2, 2029);
INSERT INTO `sys_role_menu` VALUES (2, 2030);
INSERT INTO `sys_role_menu` VALUES (2, 2031);
INSERT INTO `sys_role_menu` VALUES (2, 2032);
INSERT INTO `sys_role_menu` VALUES (2, 2033);
INSERT INTO `sys_role_menu` VALUES (2, 2034);
INSERT INTO `sys_role_menu` VALUES (2, 2035);
INSERT INTO `sys_role_menu` VALUES (2, 2036);
INSERT INTO `sys_role_menu` VALUES (2, 2037);
INSERT INTO `sys_role_menu` VALUES (2, 2038);
INSERT INTO `sys_role_menu` VALUES (2, 2039);
INSERT INTO `sys_role_menu` VALUES (2, 2040);
INSERT INTO `sys_role_menu` VALUES (2, 2041);
INSERT INTO `sys_role_menu` VALUES (2, 2042);
INSERT INTO `sys_role_menu` VALUES (2, 2043);
INSERT INTO `sys_role_menu` VALUES (2, 2044);
INSERT INTO `sys_role_menu` VALUES (100, 3);
INSERT INTO `sys_role_menu` VALUES (100, 115);
INSERT INTO `sys_role_menu` VALUES (100, 116);
INSERT INTO `sys_role_menu` VALUES (100, 117);
INSERT INTO `sys_role_menu` VALUES (100, 1055);
INSERT INTO `sys_role_menu` VALUES (100, 1056);
INSERT INTO `sys_role_menu` VALUES (100, 1057);
INSERT INTO `sys_role_menu` VALUES (100, 1058);
INSERT INTO `sys_role_menu` VALUES (100, 1059);
INSERT INTO `sys_role_menu` VALUES (100, 1060);
INSERT INTO `sys_role_menu` VALUES (100, 2006);
INSERT INTO `sys_role_menu` VALUES (100, 2007);
INSERT INTO `sys_role_menu` VALUES (100, 2008);
INSERT INTO `sys_role_menu` VALUES (100, 2009);
INSERT INTO `sys_role_menu` VALUES (100, 2010);
INSERT INTO `sys_role_menu` VALUES (100, 2011);
INSERT INTO `sys_role_menu` VALUES (100, 2012);
INSERT INTO `sys_role_menu` VALUES (100, 2013);
INSERT INTO `sys_role_menu` VALUES (100, 2014);
INSERT INTO `sys_role_menu` VALUES (100, 2015);
INSERT INTO `sys_role_menu` VALUES (100, 2016);
INSERT INTO `sys_role_menu` VALUES (100, 2017);
INSERT INTO `sys_role_menu` VALUES (100, 2018);
INSERT INTO `sys_role_menu` VALUES (100, 2019);
INSERT INTO `sys_role_menu` VALUES (100, 2020);
INSERT INTO `sys_role_menu` VALUES (100, 2021);
INSERT INTO `sys_role_menu` VALUES (100, 2022);
INSERT INTO `sys_role_menu` VALUES (100, 2023);
INSERT INTO `sys_role_menu` VALUES (100, 2024);
INSERT INTO `sys_role_menu` VALUES (100, 2025);

-- ----------------------------
-- Table structure for sys_user
-- ----------------------------
DROP TABLE IF EXISTS `sys_user`;
CREATE TABLE `sys_user`  (
  `user_id` bigint NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `dept_id` bigint NULL DEFAULT NULL COMMENT '部门ID',
  `user_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '用户账号',
  `nick_name` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '用户昵称',
  `user_type` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '00' COMMENT '用户类型（00系统用户）',
  `email` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '用户邮箱',
  `phonenumber` varchar(11) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '手机号码',
  `sex` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '用户性别（0男 1女 2未知）',
  `avatar` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '头像地址',
  `password` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '密码',
  `status` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '账号状态（0正常 1停用）',
  `del_flag` char(1) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '0' COMMENT '删除标志（0代表存在 2代表删除）',
  `login_ip` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '最后登录IP',
  `login_date` datetime NULL DEFAULT NULL COMMENT '最后登录时间',
  `pwd_update_date` datetime NULL DEFAULT NULL COMMENT '密码最后更新时间',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`user_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 104 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '用户信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_user
-- ----------------------------
INSERT INTO `sys_user` VALUES (1, 103, 'admin', 'yy', '00', 'yy@163.com', '15888888888', '1', '', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', '127.0.0.1', '2026-06-14 17:04:48', '2026-04-08 23:16:38', 'admin', '2026-04-08 23:16:38', '', NULL, '管理员');
INSERT INTO `sys_user` VALUES (2, 105, 'yy', 'yy', '00', 'yy@qq.com', '15666666666', '1', '', '$2a$10$7JB720yubVSZvUI0rEqK/.VqGOZTH.ulu33dHOiBE8ByOhJIrdAu2', '0', '0', '127.0.0.1', '2026-04-08 23:16:38', '2026-04-08 23:16:38', 'admin', '2026-04-08 23:16:38', '', NULL, '测试员');
INSERT INTO `sys_user` VALUES (100, 100, 'ylz', '羊离子', '00', '123@qq.com', '17820902798', '0', '', '$2a$10$698IQq53W6eNEhizEM3FVOgyEcP8sP2NdiFh0otoeIsQyjTfqbsWq', '0', '0', '', NULL, NULL, 'admin', '2026-04-09 22:29:52', 'admin', '2026-04-09 23:00:52', NULL);
INSERT INTO `sys_user` VALUES (101, 100, 'xqq', '小强强', '00', '', '13323235050', '0', '', '$2a$10$WZhID3sNo4uXLo5ahZAaI.SOZtqtIaPlqrXzHv/loVlrL1f0OL8Ou', '0', '0', '', NULL, NULL, 'admin', '2026-04-10 00:30:43', '', NULL, NULL);
INSERT INTO `sys_user` VALUES (102, NULL, 'ylz123', '羊羊', '00', '', '18827982798', '1', '', '$2a$10$dyOz6cGciUP8uRQbRJnPDe.ln/N9eqgTQY/CwpQzkNy.vq9AaNJxO', '0', '0', '', NULL, NULL, 'admin', '2026-04-10 20:23:49', '', NULL, NULL);
INSERT INTO `sys_user` VALUES (103, NULL, 'test123', 'test', '00', '', '', '0', '', '$2a$10$FLslWZY4gI5MR5gtcx1p7.T.zi5gAh75MUrHb8Ecu9NSSlBRNZEyG', '0', '0', '', NULL, NULL, 'admin', '2026-04-13 20:29:46', '', NULL, NULL);

-- ----------------------------
-- Table structure for sys_user_post
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_post`;
CREATE TABLE `sys_user_post`  (
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `post_id` bigint NOT NULL COMMENT '岗位ID',
  PRIMARY KEY (`user_id`, `post_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '用户与岗位关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_user_post
-- ----------------------------
INSERT INTO `sys_user_post` VALUES (1, 1);
INSERT INTO `sys_user_post` VALUES (2, 2);

-- ----------------------------
-- Table structure for sys_user_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_role`;
CREATE TABLE `sys_user_role`  (
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `role_id` bigint NOT NULL COMMENT '角色ID',
  PRIMARY KEY (`user_id`, `role_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '用户和角色关联表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of sys_user_role
-- ----------------------------
INSERT INTO `sys_user_role` VALUES (1, 1);
INSERT INTO `sys_user_role` VALUES (2, 2);
INSERT INTO `sys_user_role` VALUES (100, 100);
INSERT INTO `sys_user_role` VALUES (101, 100);
INSERT INTO `sys_user_role` VALUES (102, 100);
INSERT INTO `sys_user_role` VALUES (103, 2);

-- ----------------------------
-- Table structure for variety
-- ----------------------------
DROP TABLE IF EXISTS `variety`;
CREATE TABLE `variety`  (
  `id` int NOT NULL AUTO_INCREMENT COMMENT '品种ID',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '品种名称',
  `remark` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '备注',
  `create_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '创建者',
  `create_time` datetime NULL DEFAULT NULL COMMENT '创建时间',
  `update_by` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT '' COMMENT '更新者',
  `update_time` datetime NULL DEFAULT NULL COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '农作物品种表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of variety
-- ----------------------------
INSERT INTO `variety` VALUES (1, '豆科', NULL, '', '2026-04-09 17:27:19', '', NULL);
INSERT INTO `variety` VALUES (2, '蔷薇科', NULL, '', '2026-04-10 01:57:01', '', NULL);
INSERT INTO `variety` VALUES (3, '禾本科', NULL, '', '2026-04-10 19:36:16', '', NULL);
INSERT INTO `variety` VALUES (4, '测试类', NULL, '', '2026-04-15 22:28:13', '', NULL);
INSERT INTO `variety` VALUES (5, '蚜虫类', NULL, '', '2026-04-18 17:22:07', '', NULL);
INSERT INTO `variety` VALUES (6, '草螟科', NULL, '', '2026-04-18 17:26:14', '', NULL);
INSERT INTO `variety` VALUES (7, '真足螨科', NULL, '', '2026-04-18 17:32:11', '', NULL);
INSERT INTO `variety` VALUES (8, '菊科', NULL, '', '2026-04-18 17:44:54', '', NULL);

SET FOREIGN_KEY_CHECKS = 1;
