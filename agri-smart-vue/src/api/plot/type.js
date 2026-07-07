import request from '@/utils/request'

// 查询片区类型列表
export function listType(query) {
  return request({
    url: '/plot/type/list',
    method: 'get',
    params: query
  })
}

// 查询片区类型详细
export function getType(id) {
  return request({
    url: '/plot/type/' + id,
    method: 'get'
  })
}

// 新增片区类型
export function addType(data) {
  return request({
    url: '/plot/type',
    method: 'post',
    data: data
  })
}

// 修改片区类型
export function updateType(data) {
  return request({
    url: '/plot/type',
    method: 'put',
    data: data
  })
}

// 删除片区类型
export function delType(id) {
  return request({
    url: '/plot/type/' + id,
    method: 'delete'
  })
}

// 查询所有片区类型
export function allPlotType() {
  return request({
    url: '/plot/type/list',
    method: 'get',
    params: { pageNum: 1, pageSize: 100 }
  })
}
