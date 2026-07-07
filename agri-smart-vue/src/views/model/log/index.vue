<template>
    <div class="app-container">
        <el-form :model="queryParams" ref="queryRef" :inline="true" v-show="showSearch" label-width="68px">
            <el-form-item label="检测类型" prop="logType">
                <el-select v-model="queryParams.logType" placeholder="请选择检测类型" clearable>
                    <el-option v-for="dict in model_type" :key="dict.value" :label="dict.label" :value="dict.value" />
                </el-select>
            </el-form-item>
            <el-form-item label="检测类型" prop="detectType">
                <el-select v-model="queryParams.detectType" placeholder="请选择检测类型" clearable>
                    <el-option v-for="dict in detect_type" :key="dict.value" :label="dict.label" :value="dict.value" />
                </el-select>
            </el-form-item>
            <el-form-item label="操作用户" prop="userId">
                <el-select v-model="queryParams.userId" clearable @keyup.enter="handleQuery" filterable remote
                    reserve-keyword placeholder="请输入操作用户进行搜索" :remote-method="remoteMethod" :loading="userLoading"
                    style="width: 260px">
                    <el-option v-for="item in userOptions" :key="item.value" :label="item.label" :value="item.value" />
                </el-select>
            </el-form-item>
            <el-form-item label="模型" prop="modelConfigId">
                <el-select v-model="queryParams.modelConfigId" clearable @keyup.enter="handleQuery" filterable remote
                    reserve-keyword placeholder="请输入模型进行搜索" :remote-method="remoteMethodModel"
                    :loading="modelConfigLoading" style="width: 260px">
                    <el-option v-for="item in modelConfigOptions" :key="item.value" :label="item.label"
                        :value="item.value" />
                </el-select>
            </el-form-item>
            <el-form-item label="用户反馈" prop="feedbackStatus">
                <el-select v-model="queryParams.feedbackStatus" placeholder="请选择用户反馈" clearable>
                    <el-option v-for="dict in feedback_status" :key="dict.value" :label="dict.label"
                        :value="dict.value" />
                </el-select>
            </el-form-item>
            <el-form-item label="检测时间" style="width: 608px">
                <el-date-picker v-model="daterangeCreateTime" value-format="YYYY-MM-DD HH:mm:ss" type="datetimerange"
                    range-separator="-" start-placeholder="开始时间" end-placeholder="结束时间"></el-date-picker>
            </el-form-item>
            <el-form-item>
                <el-button type="primary" icon="Search" @click="handleQuery">搜索</el-button>
                <el-button icon="Refresh" @click="resetQuery">重置</el-button>
            </el-form-item>
        </el-form>

        <el-row :gutter="10" class="mb8">
            <el-col :span="1.5">
                <el-button type="success" plain icon="Edit" :disabled="single" @click="handleUpdate"
                    v-hasPermi="['model:log:edit']">修改</el-button>
            </el-col>
            <el-col :span="1.5">
                <el-button type="danger" plain icon="Delete" :disabled="multiple" @click="handleDelete"
                    v-hasPermi="['model:log:remove']">删除</el-button>
            </el-col>
            <el-col :span="1.5">
                <el-button type="warning" plain icon="Download" @click="handleExport"
                    v-hasPermi="['model:log:export']">导出</el-button>
            </el-col>
            <right-toolbar v-model:showSearch="showSearch" @queryTable="getList"></right-toolbar>
        </el-row>

        <el-table v-loading="loading" :data="logList" @selection-change="handleSelectionChange">
            <el-table-column type="selection" width="55" align="center" />
            <el-table-column label="ID" align="center" prop="id" />
            <el-table-column label="检测类型" align="center" prop="logType">
                <template #default="scope">
                    <dict-tag :options="model_type" :value="scope.row.logType" />
                </template>
            </el-table-column>
            <el-table-column label="任务类型" align="center" prop="detectType">
                <template #default="scope">
                    <dict-tag :options="detect_type" :value="scope.row.detectType" />
                </template>
            </el-table-column>
            <el-table-column label="操作用户" align="center" prop="userName" />
            <el-table-column label="使用模型" align="center" width="200">
                <template #default="scope">
                    <span>{{ scope.row.modelName }}:{{ scope.row.modelVersion }} {{
                        getModelStatus(scope.row.modelConfigIsActive, scope.row.modelConfigIsDel) }}</span>
                </template>
            </el-table-column>
            <el-table-column label="推理耗时" align="center" prop="durationMs">
                <template #default="scope">
                    <span>{{ scope.row.durationMs }}ms</span>
                </template>
            </el-table-column>
            <el-table-column label="目标总数" align="center" prop="totalTargets" />
            <el-table-column label="反馈状态" align="center" prop="feedbackStatus">
                <template #default="scope">
                    <dict-tag :options="feedback_status" :value="scope.row.feedbackStatus" />
                </template>
            </el-table-column>
            <el-table-column label="检测时间" align="center" prop="detectTime" width="180" />
            <el-table-column label="操作" align="center" class-name="small-padding fixed-width">
                <template #default="scope">
                    <el-button link type="primary" icon="View" @click="handleDetail(scope.row)">查看</el-button>
                    <el-button link type="primary" icon="Edit" @click="handleUpdate(scope.row)"
                        v-hasPermi="['model:log:edit']">修改</el-button>
                    <el-button link type="danger" icon="Delete" @click="handleDelete(scope.row)"
                        v-hasPermi="['model:log:remove']">删除</el-button>
                </template>
            </el-table-column>
        </el-table>

        <pagination v-show="total > 0" :total="total" v-model:page="queryParams.pageNum"
            v-model:limit="queryParams.pageSize" @pagination="getList" />

        <!-- 查看详情 -->
        <el-dialog title="检测日志详情" v-model="detailOpen" width="900px" append-to-body>
            <div v-loading="detailLoading" style="padding:10px">
                <div class="img-pre">
                    <div><label>结果图：</label></div>
                    <el-image :src="resultImagePath" style="width:50%; height:50%;" fit="scale-down"></el-image>
                </div>
                <div style=" margin:15px 0">
                    <label>密度统计：</label>
                    <el-tag v-for="(v, k, i) in densityObj" :key="i" type="primary" style="margin-right:8px">{{ k }}:{{
                        v
                    }}
                    </el-tag>
                </div>
                <el-divider>检测目标详情</el-divider>
                <el-table :data="detailDetailList" border>
                    <el-table-column label="类别" prop="label" width="120" />
                    <el-table-column label="作物名称" prop="cropName" width="120" />
                    <el-table-column label="品种" prop="varietyName" width="120" />
                    <el-table-column label="置信度" prop="conf" />
                    <el-table-column label="病虫害状态" width="100">
                        <template #default="scope">
                            <dict-tag :options="crop_status" :value="scope.row.cropStatus" />
                        </template>
                    </el-table-column>
                    <el-table-column label="坐标" prop="bbox" />
                    <el-table-column label="百科链接" prop="linkedEncyclopedia" width="80">
                        <template #default="scope">
                            <el-button link v-if="scope.row.linkedEncyclopedia" type="primary" icon="View"
                                @click="handleLink(scope.row.linkedEncyclopedia)">查看</el-button>
                        </template>
                    </el-table-column>
                </el-table>
                <el-divider>用户反馈</el-divider>
                <el-col :span="24">
                    <el-form-item label="用户反馈" prop="feedbackStatus">
                        <dict-tag :options="feedback_status" :value="detailForm.feedbackStatus" />
                    </el-form-item>
                </el-col>
                <el-col :span="24">
                    <el-form-item label="反馈说明" prop="feedbackText">
                        {{ detailForm.feedbackText || '-' }}
                    </el-form-item>
                </el-col>
            </div>
        </el-dialog>

        <!-- 添加或修改对话框 -->
        <el-dialog :title="title" v-model="open" width="1200px" append-to-body>
            <el-form ref="logRef" :model="form" :rules="rules" label-width="120px">
                <el-row :gutter="20">
                    <el-col :span="12">
                        <el-form-item label="检测类型" prop="logType">
                            <el-select v-model="form.logType" placeholder="请选择检测类型">
                                <el-option v-for="dict in model_type" :key="dict.value" :label="dict.label"
                                    :value="parseInt(dict.value)" />
                            </el-select>
                        </el-form-item>
                    </el-col>
                    <el-col :span="12">
                        <el-form-item label="任务类型" prop="detectType">
                            <el-select v-model="form.detectType" placeholder="请选择任务类型">
                                <el-option v-for="dict in detect_type" :key="dict.value" :label="dict.label"
                                    :value="parseInt(dict.value)" />
                            </el-select>
                        </el-form-item>
                    </el-col>
                    <el-col :span="12">
                        <el-form-item label="操作用户" prop="userId">
                            <el-select v-model="form.userId" placeholder="请选择用户">
                                <el-option v-for="item in userOptions" :key="item.value" :label="item.label"
                                    :value="item.value" />
                            </el-select>
                        </el-form-item>
                    </el-col>
                    <el-col :span="12">
                        <el-form-item label="模型配置" prop="modelConfigId">
                            <el-select v-model="form.modelConfigId" placeholder="请选择模型">
                                <el-option v-for="item in modelConfigOptions" :key="item.value" :label="item.label"
                                    :value="item.value" />
                            </el-select>
                        </el-form-item>
                    </el-col>
                    <el-col :span="12">
                        <el-form-item label="推理耗时(ms)" prop="durationMs">
                            <el-input v-model="form.durationMs" placeholder="请输入推理耗时" />
                        </el-form-item>
                    </el-col>
                    <el-col :span="12">
                        <el-form-item label="目标总数" prop="totalTargets">
                            <el-input v-model="form.totalTargets" placeholder="检测到的目标总数" />
                        </el-form-item>
                    </el-col>
                    <el-col :span="24">
                        <el-form-item label="结果图路径" prop="resultImagePath">
                            <el-input v-model="form.resultImagePath" placeholder="结果图存储路径" />
                        </el-form-item>
                    </el-col>
                    <el-col :span="24">
                        <el-form-item label="反馈状态" prop="feedbackStatus">
                            <el-select v-model="form.feedbackStatus" placeholder="请选择反馈状态">
                                <el-option v-for="dict in feedback_status" :key="dict.value" :label="dict.label"
                                    :value="parseInt(dict.value)" />
                            </el-select>
                        </el-form-item>
                    </el-col>
                    <el-col :span="24">
                        <el-form-item label="反馈说明" prop="feedbackText">
                            <el-input v-model="form.feedbackText" type="textarea" rows="2" placeholder="反馈说明" />
                        </el-form-item>
                    </el-col>
                </el-row>

                <el-divider content-position="center">检测目标明细</el-divider>
                <el-table :data="detectionLogDetailList" border>
                    <el-table-column label="序号" width="60" align="center">
                        <template #default="{ $index }">{{ $index + 1 }}</template>
                    </el-table-column>
                    <el-table-column label="类别标签" min-width="120" prop="label" />
                    <el-table-column label="置信度" width="100" prop="conf" />
                    <el-table-column label="作物名称" width="120" prop="cropName" />
                    <el-table-column label="品种" width="120" prop="varietyName" />
                    <el-table-column label="病虫害状态" width="100">
                        <template #default="scope">
                            <dict-tag :options="crop_status" :value="scope.row.cropStatus" />
                        </template>
                    </el-table-column>
                    <el-table-column label="百科ID" width="100" prop="linkedEncyclopedia" />
                    <el-table-column label="坐标框" prop="bbox" min-width="200" />
                </el-table>
            </el-form>

            <template #footer>
                <div class="dialog-footer">
                    <el-button type="primary" @click="submitForm">确 定</el-button>
                    <el-button @click="cancel">取 消</el-button>
                </div>
            </template>
        </el-dialog>

        <cropDetail :linkedEncyclopedia="linkedEncyclopedia" :open="cropOpen" @close="cropOpen = false" />
    </div>
</template>

<script setup name="Log">
import { listLog, getLog, delLog, addLog, updateLog } from "@/api/model/log"
import { listUser } from "@/api/system/user"
import { remoteModelConfigList } from "@/api/model/config"
import cropDetail from "@/views/components/cropDetail.vue"
import { ElDivider } from "element-plus"

const { proxy } = getCurrentInstance()
const { model_type, detect_type, feedback_status, crop_status } = proxy.useDict('model_type', 'detect_type', 'feedback_status', 'crop_status')

const logList = ref([])
const detectionLogDetailList = ref([])
const open = ref(false)
const cropOpen = ref(false)
const loading = ref(true)
const showSearch = ref(true)
const ids = ref([])
const single = ref(true)
const multiple = ref(true)
const total = ref(0)
const title = ref("")
const daterangeCreateTime = ref([])
const linkedEncyclopedia = ref('')
const resultImagePath = ref('')

// 详情
const detailOpen = ref(false)
const detailForm = ref({})
const detailDetailList = ref([])
const detailLoading = ref(false)
const densityObj = ref({})

const data = reactive({
    form: {},
    queryParams: {
        pageNum: 1,
        pageSize: 10,
        logType: null,
        detectType: null,
        userId: null,
        modelConfigId: null,
        feedbackStatus: null,
    },
    rules: {
        logType: [{ required: true, message: "检测类型不能为空", trigger: "change" }],
        detectType: [{ required: true, message: "任务类型不能为空", trigger: "change" }],
        userId: [{ required: true, message: "请选择用户", trigger: "change" }],
        modelConfigId: [{ required: true, message: "请选择模型", trigger: "change" }],
        resultImagePath: [{ required: true, message: "结果图不能为空", trigger: "blur" }],
        totalTargets: [{ required: true, message: "目标总数不能为空", trigger: "blur" }],
        feedbackStatus: [{ required: true, message: "请选择反馈状态", trigger: "change" }],
    }
})

const { queryParams, form, rules } = toRefs(data)
const userOptions = ref([])
const modelConfigOptions = ref([])
const userLoading = ref(false)
const modelConfigLoading = ref(false)

/** 查询列表 */
function getList() {
    loading.value = true
    queryParams.value.params = {}
    if (daterangeCreateTime.value?.length === 2) {
        queryParams.value.params.beginCreateTime = daterangeCreateTime.value[0]
        queryParams.value.params.endCreateTime = daterangeCreateTime.value[1]
    }
    listLog(queryParams.value).then(res => {
        logList.value = res.rows
        total.value = res.total
    }).finally(() => loading.value = false)
}

/** 查看详情 */
function handleDetail(row) {
    detailLoading.value = true
    detailOpen.value = true
    getLog(row.id).then(res => {
        detailForm.value = res.data
        detailDetailList.value = res.data.detectionLogDetailList || []
        resultImagePath.value = getImageUrl(detailForm.value.resultImagePath)
        densityObj.value = JSON.parse(res.data.densityJson || '{}')
    }).finally(() => detailLoading.value = false)
}

/** 修改 */
function handleUpdate(row) {
    reset()
    const id = row.id || ids.value[0]
    getLog(id).then(res => {
        form.value = res.data
        detectionLogDetailList.value = res.data.detectionLogDetailList || []
        if (form.value.userId) {
            userOptions.value = [{ value: form.value.userId, label: form.value.userName }]
        }
        if (form.value.modelConfigId) {
            modelConfigOptions.value = [{
                value: form.value.modelConfigId,
                label: `${form.value.modelName}:${form.value.modelVersion}${getModelStatus(form.value.modelConfigIsActive, form.value.modelConfigIsDel)}`
            }]
        }
        open.value = true
        title.value = "修改检测日志"
    })
}

/** 重置 */
function reset() {
    form.value = {
        id: null, logType: null, detectType: null, userId: null, modelConfigId: null,
        resultImagePath: null, durationMs: null, totalTargets: null, feedbackStatus: 1,
        feedbackText: null, feedbackTime: null, densityJson: null
    }
    detectionLogDetailList.value = []
    proxy.resetForm("logRef")
}

/** 取消 */
function cancel() {
    open.value = false
    reset()
}

/** 提交 */
function submitForm() {
    proxy.$refs.logRef.validate(valid => {
        if (!valid) return
        form.value.detectionLogDetailList = detectionLogDetailList.value
        const action = form.value.id ? updateLog : addLog
        action(form.value).then(() => {
            proxy.$modal.msgSuccess("操作成功")
            open.value = false
            getList()
        })
    })
}

/** 删除 */
function handleDelete(row) {
    const ids = row.id || ids.value
    proxy.$modal.confirm('确认删除？').then(() => {
        return delLog(ids)
    }).then(() => {
        getList()
        proxy.$modal.msgSuccess("删除成功")
    })
}

/** 搜索 */
function handleQuery() {
    queryParams.value.pageNum = 1
    getList()
}

/** 重置查询 */
function resetQuery() {
    daterangeCreateTime.value = []
    proxy.resetForm("queryRef")
    handleQuery()
}

/** 多选 */
function handleSelectionChange(selection) {
    ids.value = selection.map(i => i.id)
    single.value = selection.length !== 1
    multiple.value = !selection.length
}

/** 模型状态 */
function getModelStatus(active, del) {
    if (!active) return " [停用]"
    if (del) return " [删除]"
    return ""
}

/** 用户远程搜索 */
function remoteMethod(query) {
    if (!query) { userOptions.value = []; return }
    userLoading.value = true
    listUser({ pageNum: 1, pageSize: 20, userName: query }).then(res => {
        userOptions.value = res.rows.map(u => ({ value: u.userId, label: u.userName }))
    }).finally(() => userLoading.value = false)
}

/** 模型远程搜索 */
function remoteMethodModel(query) {
    if (!query) { modelConfigOptions.value = []; return }
    modelConfigLoading.value = true
    remoteModelConfigList({ pageNum: 1, pageSize: 20, modelName: query }).then(res => {
        modelConfigOptions.value = res.rows.map(m => ({
            value: m.id,
            label: `${m.modelName}:${m.version}${getModelStatus(m.isActive, m.isDelete)}`
        }))
    }).finally(() => modelConfigLoading.value = false)
}

/** 导出 */
function handleExport() {
    proxy.download('model/log/export', { ...queryParams.value }, `检测日志_${proxy.dateFormat(new Date())}.xlsx`)
}

function handleLink(url) {
    cropOpen.value = true
    linkedEncyclopedia.value = url
}

function getImageUrl(path) {
    if (!path) return ''
    const result = `${import.meta.env.VITE_APP_BASE_API}/yolo/result?fileName=${path}`
    console.log(result);

    return result
}

getList()
</script>