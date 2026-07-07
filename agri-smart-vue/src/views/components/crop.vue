<template>
    <!-- 农作物选择弹窗 -->
    <el-dialog title="选择农作物" v-model="visible" width="800px" append-to-body @close="handleClose">
        <!-- 搜索表单 -->
        <el-form :model="queryParams" ref="queryRef" :inline="true" label-width="80px">
            <el-form-item label="农作物" prop="name">
                <el-input v-model="queryParams.name" placeholder="请输入农作物名称" clearable @keyup.enter="handleQuery" />
            </el-form-item>
            <el-form-item label="标签名" prop="alias">
                <el-input v-model="queryParams.alias" placeholder="请输入标签名" clearable @keyup.enter="handleQuery" />
            </el-form-item>
            <el-form-item label="品种" prop="varietyId">
                <el-select v-model="queryParams.varietyId" placeholder="请选择品种" clearable @keyup.enter="handleQuery">
                    <el-option v-for="item in varietyList" :key="item.id" :label="item.name" :value="item.id" />
                </el-select>
            </el-form-item>
            <el-form-item>
                <el-button type="primary" icon="Search" @click="handleQuery">搜索</el-button>
                <el-button icon="Refresh" @click="resetQuery">重置</el-button>
            </el-form-item>
        </el-form>

        <!-- 表格 -->
        <el-table v-loading="loading" :data="cropList">
            <el-table-column label="主键" align="center" prop="id" />
            <el-table-column label="农作物名称" align="center" prop="name" />
            <el-table-column label="标签名" align="center" prop="alias" />
            <el-table-column label="品种" align="center" prop="varietyName" />
            <el-table-column label="创建时间" align="center" prop="createTime" width="180">
                <template #default="scope">
                    <span>{{ parseTime(scope.row.createTime, '{y}-{m}-{d}') }}</span>
                </template>
            </el-table-column>
            <!-- 选择按钮列 -->
            <el-table-column label="操作" align="center" width="100">
                <template #default="scope">
                    <el-button link type="primary" icon="Check" @click="handleSelectRow(scope.row)">
                        选择
                    </el-button>
                </template>
            </el-table-column>
        </el-table>

        <!-- 分页 -->
        <pagination v-show="total > 0" :total="total" v-model:page="queryParams.pageNum"
            v-model:limit="queryParams.pageSize" @pagination="getList" />

    </el-dialog>
</template>

<script setup name="CropSelect">
import { listCrop } from "@/api/crop/crop"
import { allVariety } from "@/api/crop/variety"

const { proxy } = getCurrentInstance()

// 父组件控制显示隐藏
const props = defineProps({
    open: {
        type: Boolean,
        default: false
    },
    cropStatus: {
        type: Number,
        default: -1
    }
})

// 定义事件
const emit = defineEmits(['close', 'select'])

// 内部状态
const visible = computed({
    get() { return props.open },
    set(val) { emit('close') }
})

const cropList = ref([])
const varietyList = ref([])
const loading = ref(true)
const total = ref(0)
const selectedRow = ref(null) // 当前选中行

// 查询参数
const queryParams = reactive({
    pageNum: 1,
    pageSize: 10,
    name: null,
    alias: null,
    varietyId: null,
    status: null
})

/** 查询列表 */
function getList() {
    loading.value = true
    if (props.cropStatus != -1) {
        queryParams.status = props.cropStatus
    }
    listCrop(queryParams).then(response => {
        cropList.value = response.rows
        total.value = response.total
        loading.value = false
    })
    // 获取品种
    allVariety().then(response => {
        varietyList.value = response.rows
    })
}

/** 搜索 */
function handleQuery() {
    queryParams.pageNum = 1
    getList()
}

/** 重置 */
function resetQuery() {
    queryParams.name = null
    queryParams.alias = null
    queryParams.varietyId = null
    handleQuery()
}

/** 点击行的【选择】按钮 */
function handleSelectRow(row) {
    console.log(row);

    selectedRow.value = row
    handleConfirmSelect() // 直接选择并关闭
}

/** 确认选择 */
function handleConfirmSelect() {
    if (!selectedRow.value) {
        proxy.$modal.msgWarning("请选择一条数据")
        return
    }
    // 向外抛出选择事件
    emit('select', selectedRow.value)
    // 关闭弹窗
    handleClose()
}

/** 关闭弹窗 */
function handleClose() {
    selectedRow.value = null
    emit('close')
}

queryParams.name = null
queryParams.alias = null
queryParams.varietyId = null
getList()
</script>