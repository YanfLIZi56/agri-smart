<template>
    <el-dialog v-model="visible" title="农作物片区详情" width="1020px" append-to-body @close="handleClose">
        <div style="display: flex;gap: 5px;">
            <div class="panel-wrapper" style="flex: 0.7;">
                <!-- 基本信息 -->
                <div class="card">
                    <div class="card-title">基本信息</div>
                    <div class="card-body">
                        <div class="row">
                            <div class="col"><label>片区名称</label>
                                <p>{{ data.name }}</p>
                            </div>
                            <div class="col"><label>地理位置</label>
                                <p>{{ data.location }}</p>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col"><label>面积</label>
                                <p>{{ data.area }} 公顷</p>
                            </div>
                            <div class="col"><label>管理者</label>
                                <p>{{ data.managerName }}</p>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col"><label>片区类型</label>
                                <p>{{ data.plotType }}</p>
                            </div>
                            <div class="col"><label>状态</label><dict-tag :options="plot_status" :value="data.status" />
                            </div>
                        </div>
                    </div>
                </div>

                <!-- 环境数据 + 阈值 + 颜色告警 + 箭头 -->
                <div class="card card-environment">
                    <div class="card-title">实时环境数据</div>
                    <div class="card-body">
                        <div class="env-grid">
                            <div class="env-item" v-for="(value, index) in data.envDtos" :key="index">
                                <div class="env-label">{{ value.alertType }}</div>
                                <div class="env-value" :class="{ danger: isValueOutOfRange(value) }">

                                    <div style="font-size:12px;color:#999;margin-left:4px">
                                        (阈值 {{ value.minValue ? value.minValue : '=' }}-{{ value.maxValue ?
                                            value.maxValue
                                            : '=' }} {{ value.unit }}) </div>

                                    <div
                                        style="display: flex; align-items: center; justify-content: center;margin-top: 8px;">
                                        <div>
                                            <el-icon v-if="isValueAboveMax(value)" color="danger">
                                                <Top />
                                            </el-icon>
                                            <el-icon v-if="isValueBelowMin(value)" color="danger">
                                                <Bottom />
                                            </el-icon>
                                        </div>
                                        {{ value.envValue ? value.envValue : '--' }} {{ value.unit }}
                                    </div>
                                </div>
                                <div class="time-row">
                                    <label>采集时间：</label><span>{{ value.collectTime ? value.collectTime : '--' }}</span>
                                </div>
                            </div>
                        </div>

                    </div>
                </div>
            </div>
            <!-- 种植农作物（多条 + 左右布局） -->
            <div class="card card-crop" style="flex: 0.3;">
                <div class="card-title">片区种植农作物</div>
                <div class="crop-list-wrapper">
                    <div class="crop-card" v-for="(item, index) in data.plotCropList" :key="index">
                        <div class="crop-item">
                            <div class="label">农作物</div>
                            <div class="value">{{ item.cropName }}</div>
                        </div>
                        <div class="crop-item">
                            <div class="label">类型</div>
                            <div class="value">{{ item.cropType }}</div>
                        </div>
                        <div class="crop-item">
                            <div class="label">数量</div>
                            <div class="value">{{ item.nums }} 株</div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <template #footer>
            <div style="text-align:right">
                <el-button @click="handleClose">关闭</el-button>
            </div>
        </template>
    </el-dialog>
</template>

<script setup>
import { getCurrentInstance, defineProps, defineEmits, computed } from 'vue'

const { proxy } = getCurrentInstance()
const { plot_status } = proxy.useDict('plot_status')

const props = defineProps({
    open: { type: Boolean, default: false },
    data: { type: Object, default: () => ({}) }
})
const emit = defineEmits(['update:open', 'close'])

const visible = computed({
    get: () => props.open,
    set: (val) => emit('update:open', val)
})

// 判断值是否超出范围
const isValueOutOfRange = (value) => {
    // 两个都为null，不比较
    if (value.minValue === null && value.maxValue === null) {
        return false
    }
    // minValue为null，只要小于等于maxValue就行
    if (value.minValue === null) {
        return value.envValue > value.maxValue
    }
    // maxValue为null，只要大于等于minValue就行
    if (value.maxValue === null) {
        return value.envValue < value.minValue
    }
    // 两个都不为null，正常比较
    return value.envValue > value.maxValue || value.envValue < value.minValue
}

// 判断值是否高于最大值
const isValueAboveMax = (value) => {
    return value.maxValue !== null && value.envValue > value.maxValue
}

// 判断值是否低于最小值
const isValueBelowMin = (value) => {
    return value.minValue !== null && value.envValue < value.minValue
}

function handleClose() {
    emit('close')
}
</script>

<style scoped>
.panel-wrapper {
    display: flex;
    flex-direction: column;
    gap: 16px;
}

.card {
    background: #fff;
    border-radius: 12px;
    padding: 18px 22px;
    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
    border: 1px solid #f0f0f0;
}

.card-crop {
    background: #fffbf5;
    border: 1px solid #fff0d6;
}

.card-environment {
    background: #f9fbfc;
    border: 1px solid #e4eeff;
}

.card-title {
    font-size: 16px;
    font-weight: 600;
    margin-bottom: 14px;
    color: #333;
}

.row {
    display: flex;
    padding: 10px 0;
    border-bottom: 1px dashed #f0f0f0;
}

.row:last-child {
    border-bottom: none;
}

.col {
    flex: 1;
    display: flex;
    flex-direction: column;
    gap: 4px;
}

.col label {
    font-size: 13px;
    color: #999;
}

.col p {
    margin: 0;
    font-size: 14px;
    color: #333;
    font-weight: 500;
}

.crop-list-wrapper {
    display: flex;
    flex-direction: column;
    gap: 14px;
}

.crop-card {
    width: 100%;
    background: #fff;
    border-radius: 10px;
    padding: 14px 16px;
    border: 1px solid #ffe9c7;
}

.crop-item {
    display: flex;
    flex: 1;
    justify-content: space-between;
    padding: 6px 0;
}

.crop-item .label {
    font-size: 13px;
    color: #999;
}

.crop-item .value {
    font-size: 14px;
    font-weight: 500;
    color: #333;
}

.env-grid {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    gap: 16px;
}

.env-item {
    background: #fff;
    border-radius: 10px;
    padding: 10px;
    text-align: center;
    border: 1px solid #eef5ff;
}

.env-label {
    font-size: 15px;
    color: #888;
}

.env-value {
    font-size: 22px;
    font-weight: bold;
    color: #1989fa;
}

/* 超标变红 */
.env-value.danger {
    color: #f56c6c !important;
}

/* 箭头样式 */
.arrow {
    font-size: 16px;
    margin-right: 4px;
    font-weight: bold;
}

.arrow.up {
    color: #f56c6c;
}

.arrow.down {
    color: #1989fa;
}

.time-row {
    text-align: center;
    font-size: 12px;
    color: #787878;
    margin-top: 10px;
}
</style>