import request from '@/utils/request'

// 查询农作物品种列表
export function listVariety(query) {
  return request({
    url: '/crop/variety/list',
    method: 'get',
    params: query
  })
}

// 查询所有农作物品种列表
export function allVariety() {
  return request({
    url: '/crop/variety/list',
    method: 'get',
    params: { pageNum: 1, pageSize: 1000 }
  })
}

// 查询农作物品种详细
export function getVariety(id) {
  return request({
    url: '/crop/variety/' + id,
    method: 'get'
  })
}

// 新增农作物品种
export function addVariety(data) {
  return request({
    url: '/crop/variety',
    method: 'post',
    data: data
  })
}

// 修改农作物品种
export function updateVariety(data) {
  return request({
    url: '/crop/variety',
    method: 'put',
    data: data
  })
}

// 删除农作物品种
export function delVariety(id) {
  return request({
    url: '/crop/variety/' + id,
    method: 'delete'
  })
}
