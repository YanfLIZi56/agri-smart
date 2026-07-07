<template>
    <el-dialog v-model="visible" title="农作物详情" width="700px" append-to-body :close-on-click-modal="false"
        @closed="handleClose">
        <div v-loading="loading" style="padding: 10px;">
            <el-descriptions :column="1" border size="small" style="margin-bottom: 15px">
                <el-descriptions-item label="农作物名称">{{ detail.name || '-' }}</el-descriptions-item>
                <el-descriptions-item label="模型标签">{{ detail.alias || '-' }}</el-descriptions-item>
                <el-descriptions-item label="品种">{{ detail.varietyName || '-' }}</el-descriptions-item>
                <el-descriptions-item label="状态">
                    <dict-tag :options="crop_status" :value="detail.status" />
                </el-descriptions-item>
            </el-descriptions>

            <el-descriptions v-if="detail.status === 1 || detail.status === 2" :column="1" border size="small"
                style="margin-bottom: 15px">
                <el-descriptions-item label="症状描述">{{ detail.symptoms || '无' }}</el-descriptions-item>
                <el-descriptions-item label="病因描述">{{ detail.causes || '无' }}</el-descriptions-item>
                <el-descriptions-item label="防治方法">{{ detail.prevention || '无' }}</el-descriptions-item>
            </el-descriptions>

            <div>
                <div>示例图片: </div>
                <div v-if="detail.images" style="text-align: center; margin-top: 10px">
                    <image-preview :src="detail.images" width="70%" height="70%" />
                </div>
            </div>


        </div>

        <template #footer>
            <div class="dialog-footer">
                <el-button @click="visible = false">关闭</el-button>
            </div>
        </template>
    </el-dialog>
</template>

<script setup name="CropDetailDialog">
import { ref, watch, defineProps, defineEmits, getCurrentInstance } from 'vue'
import { getCrop } from '@/api/crop/crop'

const { proxy } = getCurrentInstance()
const { crop_status } = proxy.useDict('crop_status')

const props = defineProps({
    linkedEncyclopedia: [String, Number],
    open: Boolean
})

const emit = defineEmits(['update:open', 'close'])
const visible = ref(false)
const loading = ref(false)
const detail = ref({})

watch(() => props.open, (val) => {
    visible.value = val
    if (val && props.linkedEncyclopedia) {
        loadDetail()
    }
})

watch(visible, (val) => {
    emit('update:open', val)
})

async function loadDetail() {
    if (!props.linkedEncyclopedia) return
    loading.value = true
    detail.value = {}
    try {
        const res = await getCrop(props.linkedEncyclopedia)
        detail.value = res.data || {}
    } finally {
        loading.value = false
    }
}

function handleClose() {
    detail.value = {}
    emit('close')
}
</script>

<style scoped>
:deep(.el-descriptions__label) {
    width: 120px !important;
}
</style>