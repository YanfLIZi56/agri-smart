import request from '@/utils/request'

// 查询片区环境实时数据列表
export function listRealtime(query) {
  return request({
    url: '/plot/realtime/list',
    method: 'get',
    params: query
  })
}

// 查询片区环境实时数据详细
export function getRealtime(id) {
  return request({
    url: '/plot/realtime/' + id,
    method: 'get'
  })
}

// 新增片区环境实时数据
export function addRealtime(data) {
  return request({
    url: '/plot/realtime',
    method: 'post',
    data: data
  })
}

// 修改片区环境实时数据
export function updateRealtime(data) {
  return request({
    url: '/plot/realtime',
    method: 'put',
    data: data
  })
}

// 删除片区环境实时数据
export function delRealtime(id) {
  return request({
    url: '/plot/realtime/' + id,
    method: 'delete'
  })
}
