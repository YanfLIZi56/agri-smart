<template>
    <div class="pest-detection-container">
        <!-- 左侧操作区 -->
        <div class="left-panel">
            <div class="panel-card">

                <!-- ====================== 上传区域（默认显示，选完图隐藏） ====================== -->
                <el-upload v-if="!previewUrl" class="upload-demo" drag action="#" :auto-upload="false"
                    :on-change="handleFileChange" :file-list="fileList" accept="image/*" :limit="1">
                    <el-icon class="el-icon--upload"><upload-filled /></el-icon>
                    <div class="el-upload__text">拖放图片到此处，或<em>点击上传</em></div>
                    <div class="el-upload__tip" slot="tip">仅支持 jpg/png 格式</div>
                </el-upload>

                <!-- ====================== 预览图 + 更换按钮（选图后显示） ====================== -->
                <div v-else class="preview-wrapper">
                    <div class="preview-container">
                        <img :src="previewUrl" alt="预览图片" class="preview-img" />
                    </div>
                    <el-button type="info" @click="handleChangeImage" style="margin-top: 10px">
                        更换图片
                    </el-button>
                </div>

                <!-- 模型选择 -->
                <div class="form-item">
                    <label class="form-label">选择检测模型：</label>
                    <el-select v-model="form.modelId" clearable filterable remote reserve-keyword
                        placeholder="请输入模型进行搜索" :remote-method="remoteMethodModel" style="width: 260px">
                        <el-option v-for="item in modelList" :key="item.id" :label="item.modelName + ':' + item.version"
                            :value="item.id" />
                    </el-select>
                </div>

                <!-- 检测类型 -->
                <div class="form-item">
                    <label class="form-label">选择检测类型：</label>
                    <el-select v-model="form.detectType" placeholder="请选择检测类型" class="form-select">
                        <el-option v-for="item in detect_type" :key="item.value" :label="item.label"
                            :value="item.value" />
                    </el-select>
                </div>

                <!-- 置信度 -->
                <div class="form-item">
                    <label class="form-label">置信度阈值：{{ form.conf }}</label>
                    <el-slider v-model="form.conf" :min="0.1" :max="1.0" :step="0.01" class="slider-bar" />
                </div>

                <!-- 开始检测 -->
                <el-button type="primary" class="detect-btn" :disabled="!canDetect" @click="handleDetect">
                    开始检测
                </el-button>
            </div>
        </div>

        <!-- 右侧结果区 -->
        <div class="right-panel">
            <div class="result-card" v-if="detectionResult">
                <div class="result-header">
                    <h3>检测结果</h3>
                    <span class="result-time">耗时：{{ detectionResult.durationMs }}ms</span>
                </div>
                <div class="result-info">
                    <div class="basic-info">
                        <p>密度统计:
                            <el-tag v-for="(v, k, i) in densityObj" :key="i" type="primary" style="margin-right:8px">{{
                                k }}:{{
                                    v
                                }}
                            </el-tag>
                        </p>
                        <p>识别目标数：{{ detectionResult.totalTargets }}</p>
                        <p>结果图片：</p>
                        <img :src="resultImagePath" alt="检测结果图" class="result-img" />
                    </div>
                    <div class="detections-list">
                        <h4>识别详情：</h4>
                        <el-table :data="detectionResult.detectionLogDetailList" border size="small">
                            <el-table-column prop="cropName" label="目标类型" align="center" />
                            <el-table-column prop="conf" label="置信度" align="center" :formatter="formatConf" />
                            <el-table-column prop="bbox" label="位置信息" align="center">
                                <template #default="scope">
                                    <div v-for="(item, i) in formatBbox(scope.row)" :key="i">{{ item }}</div>
                                </template>
                            </el-table-column>
                        </el-table>
                    </div>
                </div>
            </div>
            <div class="empty-result" v-else>
                <el-empty description="暂无检测结果，请上传图片并开始检测" />
            </div>
        </div>
    </div>
</template>

<script setup>
import { remoteModelConfigList } from '@/api/model/config'
import { detect } from '@/api/model/detect'


const { proxy } = getCurrentInstance()
const { detect_type } = proxy.useDict('detect_type')

// 模型列表
const modelList = ref([])

// 表单
const form = ref({
    modelId: '',
    detectType: '',
    conf: 0.25,
    file: null,
})

const fileList = ref([])
const previewUrl = ref('')
const detectionResult = ref(null)
const densityObj = ref({})
const resultImagePath = ref('')

// 是否可检测
const canDetect = computed(() => {
    return !!(form.value.modelId && form.value.detectType && form.value.file)
})

// 选择图片
function handleFileChange(file) {
    if (file.raw) {
        form.value.file = file.raw
        previewUrl.value = URL.createObjectURL(file.raw)
        fileList.value = [file] // 只保留一张
    }
}

// 更换图片
function handleChangeImage() {
    // 释放临时URL，避免内存泄漏
    if (previewUrl.value) URL.revokeObjectURL(previewUrl.value)

    // 清空
    previewUrl.value = ''
    form.value.file = null
    fileList.value = []
}

// 格式化置信度
function formatConf(row) {
    return (row.conf).toFixed(2)
}

// 格式化坐标
function formatBbox(row) {
    const bbox = JSON.parse(row.bbox)
    let result = [`左上角坐标: (${bbox.x1.toFixed(2)}, ${bbox.y1.toFixed(2)})`, `右下角坐标: (${bbox.x2.toFixed(2)}, ${bbox.y2.toFixed(2)})`]
    return result
}

function getImageUrl(path) {
    if (!path) return ''
    const result = `${import.meta.env.VITE_APP_BASE_API}/yolo/result?fileName=${path}`
    return result
}

// 开始检测
async function handleDetect() {
    const formData = new FormData()
    formData.append('file', form.value.file)
    formData.append('conf', form.value.conf)
    formData.append('modelId', form.value.modelId)
    formData.append('detectType', form.value.detectType)
    detect(formData).then((res) => {
        detectionResult.value = res.data
        densityObj.value = JSON.parse(res.data.densityJson || '{}')
        resultImagePath.value = getImageUrl(res.data.resultImagePath)
    })

}

// 远程搜索模型
function remoteMethodModel(query) {
    remoteModelConfigList({
        pageNum: 1,
        pageSize: 20,
        modelName: query,
        isActive: 1,
        isDelete: 0,
    }).then((res) => {
        modelList.value = res.rows
    })
}

onMounted(() => {
    remoteMethodModel('')
})
</script>

<style scoped>
.pest-detection-container {
    display: flex;
    width: 100%;
    height: 100vh;
    padding: 20px;
    box-sizing: border-box;
    gap: 20px;
}

.left-panel {
    width: 40%;
    height: 100%;
}

.panel-card {
    background: #fff;
    padding: 24px;
    border-radius: 8px;
    box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);
    height: 100%;
    display: flex;
    flex-direction: column;
    gap: 20px;
}

/* 预览图容器 */
.preview-wrapper {
    display: flex;
    flex-direction: column;
    align-items: center;
}

.preview-container {
    width: 100%;
    display: flex;
    justify-content: center;
}

.preview-img {
    max-width: 100%;
    max-height: 220px;
    border-radius: 6px;
    object-fit: contain;
    border: 1px solid #eee;
}

.form-item {
    display: flex;
    flex-direction: column;
    gap: 8px;
}

.form-label {
    font-size: 14px;
    color: #333;
    font-weight: 500;
}

.form-select {
    width: 100%;
}

.slider-bar {
    width: 100%;
}

.detect-btn {
    width: 100%;
    height: 40px;
    font-size: 16px;
    margin-top: auto;
}

/* 右侧结果 */
.right-panel {
    width: 60%;
    height: 100%;
    overflow-y: auto;
}

.result-card {
    background: #fff;
    padding: 24px;
    border-radius: 8px;
    box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);
}

.result-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    border-bottom: 1px solid #eee;
    padding-bottom: 12px;
    margin-bottom: 16px;
}

.result-time {
    color: #666;
    font-size: 14px;
}

.result-info {
    display: flex;
    flex-direction: column;
    gap: 20px;
}

.result-img {
    max-width: 320px;
    max-height: 240px;
    border-radius: 4px;
    margin-top: 8px;
    object-fit: contain;
}

.empty-result {
    width: 100%;
    height: 100%;
    display: flex;
    align-items: center;
    justify-content: center;
    background: #fff;
    border-radius: 8px;
    box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);
}
</style>