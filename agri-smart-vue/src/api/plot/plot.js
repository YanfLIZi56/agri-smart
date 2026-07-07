import request from '@/utils/request'

// 查询片区信息列表
export function listPlot(query) {
  return request({
    url: '/plot/plot/list',
    method: 'get',
    params: query
  })
}

// 查询片区信息详细
export function getPlot(id) {
  return request({
    url: '/plot/plot/' + id,
    method: 'get'
  })
}

// 新增片区信息
export function addPlot(data) {
  return request({
    url: '/plot/plot',
    method: 'post',
    data: data
  })
}

// 修改片区信息
export function updatePlot(data) {
  return request({
    url: '/plot/plot',
    method: 'put',
    data: data
  })
}

// 删除片区信息
export function delPlot(id) {
  return request({
    url: '/plot/plot/' + id,
    method: 'delete'
  })
}

// 查询片区信息详细包含环境信息
export function getPlotDetail(id) {
  return request({
    url: '/plot/plot/env/' + id,
    method: 'get'
  })
}

// 远程搜索片区管理员用户列表
export function remoteUserList(query) {
  return request({
    url: '/plot/plot/remote/user',
    method: 'get',
    params: query
  })
}
