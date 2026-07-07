import request from '@/utils/request'

// 查询监控管理列表
export function listManage(query) {
  return request({
    url: '/monitor/manage/list',
    method: 'get',
    params: query
  })
}

// 查询监控管理详细
export function getManage(id) {
  return request({
    url: '/monitor/manage/' + id,
    method: 'get'
  })
}

// 新增监控管理
export function addManage(data) {
  return request({
    url: '/monitor/manage',
    method: 'post',
    data: data
  })
}

// 修改监控管理
export function updateManage(data) {
  return request({
    url: '/monitor/manage',
    method: 'put',
    data: data
  })
}

// 删除监控管理
export function delManage(id) {
  return request({
    url: '/monitor/manage/' + id,
    method: 'delete'
  })
}

// 获取监控管理视频地址
export function getManageVideoUrl(id) {
  return request({
    url: '/monitor/manage/rtc/' + id,
    method: 'get'
  })
}
