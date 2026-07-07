<template>
    <el-dialog title="选择监控" v-model="visible" width="800px" append-to-body @close="handleClose">
        <el-form :model="queryParams" ref="queryRef" :inline="true" label-width="80px">
            <el-form-item label="监控名称" prop="name">
                <el-input v-model="queryParams.name" placeholder="请输入监控名称" clearable @keyup.enter="handleQuery" />
            </el-form-item>
            <el-form-item>
                <el-button type="primary" icon="Search" @click="handleQuery">搜索</el-button>
                <el-button icon="Refresh" @click="resetQuery">重置</el-button>
            </el-form-item>
        </el-form>

        <el-table v-loading="loading" :data="monitorList">
            <el-table-column label="ID" align="center" prop="id" />
            <el-table-column label="监控名称" align="center" prop="name" />
            <el-table-column label="rtsp流地址" align="center" prop="rtspUrl" />
            <el-table-column label="型号" align="center" prop="monitorType" />
            <el-table-column label="创建时间" align="center" prop="createTime" width="180">
                <template #default="scope">
                    <span>{{ parseTime(scope.row.createTime, '{y}-{m}-{d}') }}</span>
                </template>
            </el-table-column>
            <el-table-column label="操作" align="center" width="100">
                <template #default="scope">
                    <el-button link type="primary" icon="Check" @click="handleSelectRow(scope.row)">
                        选择
                    </el-button>
                </template>
            </el-table-column>
        </el-table>

        <pagination v-show="total > 0" :total="total" v-model:page="queryParams.pageNum"
            v-model:limit="queryParams.pageSize" @pagination="getList" />

    </el-dialog>
</template>

<script setup name="MonitorSelect">
import { ref, computed, reactive, defineProps, defineEmits } from 'vue'
import { listManage } from "@/api/monitor-ser/manage"

const { proxy } = getCurrentInstance()

const props = defineProps({
    open: {
        type: Boolean,
        default: false
    }
})

const emit = defineEmits(['close', 'select'])

const visible = computed({
    get() { return props.open },
    set(val) { emit('close') }
})

const monitorList = ref([])
const loading = ref(true)
const total = ref(0)
const selectedRow = ref(null)

const queryParams = reactive({
    pageNum: 1,
    pageSize: 10,
    name: null,
    status: 0
})

function getList() {
    loading.value = true
    queryParams.status = 0
    listManage(queryParams).then(response => {
        monitorList.value = response.rows
        total.value = response.total
        loading.value = false
    })
}

function handleQuery() {
    queryParams.pageNum = 1
    getList()
}

function resetQuery() {
    queryParams.name = null
    handleQuery()
}

function handleSelectRow(row) {
    selectedRow.value = row
    handleConfirmSelect()
}

function handleConfirmSelect() {
    if (!selectedRow.value) {
        proxy.$modal.msgWarning("请选择一条数据")
        return
    }
    emit('select', selectedRow.value)
    handleClose()
}

function handleClose() {
    selectedRow.value = null
    emit('close')
}

getList()
</script>