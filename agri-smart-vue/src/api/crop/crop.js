import request from '@/utils/request'

// 查询农作物信息列表
export function listCrop(query) {
  return request({
    url: '/crop/crop/list',
    method: 'get',
    params: query
  })
}

// 查询农作物信息详细
export function getCrop(id) {
  return request({
    url: '/crop/crop/' + id,
    method: 'get'
  })
}

// 新增农作物信息
export function addCrop(data) {
  return request({
    url: '/crop/crop',
    method: 'post',
    data: data
  })
}

// 修改农作物信息
export function updateCrop(data) {
  return request({
    url: '/crop/crop',
    method: 'put',
    data: data
  })
}

// 删除农作物信息
export function delCrop(id) {
  return request({
    url: '/crop/crop/' + id,
    method: 'delete'
  })
}
