<template>
    <el-dialog :title="title" v-model="visible" width="500px" append-to-body @closed="handleClose">
        <el-form ref="jobRef" :model="form" :rules="rules" label-width="100px">
            <el-row>
                <el-col :span="24">
                    <el-form-item label="监控ID" prop="monitorId">
                        <el-input v-model="form.monitorId" placeholder="监控ID" disabled />
                    </el-form-item>
                </el-col>
                <el-col :span="24">
                    <el-form-item label="模型" prop="modelConfigId">
                        <el-select v-model="form.modelConfigId" clearable filterable remote reserve-keyword
                            placeholder="请输入模型进行搜索" :remote-method="remoteMethodModel" style="width: 260px">
                            <el-option v-for="item in modelList" :key="item.id"
                                :label="item.modelName + ':' + item.version" :value="item.id" />
                        </el-select>
                    </el-form-item>
                </el-col>
                <el-col :span="24">
                    <el-form-item label="持续时间" prop="duration">
                        <el-input v-model="form.duration" placeholder="请输入持续时间" />
                    </el-form-item>
                </el-col>
                <el-col :span="24">
                    <el-form-item label="备注" prop="remark">
                        <el-input v-model="form.remark" type="textarea" placeholder="请输入内容" />
                    </el-form-item>
                </el-col>
            </el-row>
        </el-form>
        <template #footer>
            <div class="dialog-footer">
                <el-button type="primary" @click="submitForm">确 定</el-button>
                <el-button @click="cancel">取 消</el-button>
            </div>
        </template>
    </el-dialog>
</template>

<script setup name="MonitorJobDialog">
import { ref, watch, defineProps, defineEmits } from 'vue'
import { remoteModelConfigList } from '@/api/model/config'
import { addJob } from '@/api/monitor-ser/job'
import { ElMessage } from 'element-plus'

const props = defineProps({
    title: {
        type: String,
        default: '监控任务'
    },
    modelValue: {
        type: Boolean,
        default: false
    },
    monitorId: {
        type: [String, Number],
        default: ''
    }
})

const emit = defineEmits(['update:modelValue', 'close'])

const visible = ref(false)
const jobRef = ref(null)
const loading = ref(false)

// 模型列表
const modelList = ref([])
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

const form = ref({
    monitorId: '',
    modelConfigId: '',
    duration: '',
    remark: ''
})

const rules = ref({
    modelConfigId: [
        { required: true, message: '请输入模型ID', trigger: 'blur' }
    ],
    duration: [
        { required: true, message: '请输入持续时间', trigger: 'blur' }
    ]
})

watch(() => props.modelValue, (val) => {
    visible.value = val
    if (val) {
        initForm()
    }
})

watch(visible, (val) => {
    emit('update:modelValue', val)
})

watch(() => props.monitorId, (val) => {
    if (visible.value) {
        form.value.monitorId = val
    }
}, { immediate: true })

function initForm() {
    form.value = {
        monitorId: props.monitorId,
        modelConfigId: '',
        duration: '',
        remark: ''
    }
}

async function submitForm() {
    if (!jobRef.value) return
    const valid = await jobRef.value.validate()
    if (valid) {
        loading.value = true
        // console.log(form.value)
        try {
            await addJob(form.value)
            ElMessage.success('新增成功')
            visible.value = false
        } catch (error) {
            ElMessage.error('新增失败')
        } finally {
            loading.value = false
        }
    }
}

function cancel() {
    visible.value = false
}

function handleClose() {
    if (jobRef.value) {
        jobRef.value.resetFields()
    }
    emit('close')
}
</script>