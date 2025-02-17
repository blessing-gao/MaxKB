import { Result } from '@/request/Result'
import { get, post, del, put } from '@/request/index'
import type { pageRequest } from '@/api/type/common'
import type { functionLibData } from '@/api/type/function-lib'
import { type Ref } from 'vue'

const prefix = '/function_lib'

/**
 * 获取插件列表
 * param {
          "name": "string",
        }
 */
const getAllFunctionLib: (param?: any, loading?: Ref<boolean>) => Promise<Result<any>> = (
  param,
  loading
) => {
  return get(`${prefix}`, param || {}, loading)
}

/**
 * 获取分页插件列表
 * page {
          "current_page": "string",
          "page_size": "string",
        }
 * param {
          "name": "string",
        }
 */
const getFunctionLib: (
  page: pageRequest,
  param: any,
  loading?: Ref<boolean>
) => Promise<Result<any>> = (page, param, loading) => {
  return get(`${prefix}/${page.current_page}/${page.page_size}`, param, loading)
}

/**
 * 创建插件
 * @param 参数
 */
const postFunctionLib: (data: functionLibData, loading?: Ref<boolean>) => Promise<Result<any>> = (
  data,
  loading
) => {
  return post(`${prefix}`, data, undefined, loading)
}

/**
 * 修改插件
 * @param 参数 

 */
const putFunctionLib: (
  function_lib_id: string,
  data: functionLibData,
  loading?: Ref<boolean>
) => Promise<Result<any>> = (function_lib_id, data, loading) => {
  return put(`${prefix}/${function_lib_id}`, data, undefined, loading)
}

/**
 * 调试插件
 * @param 参数 

 */
const postFunctionLibDebug: (data: any, loading?: Ref<boolean>) => Promise<Result<any>> = (
  data: any,
  loading
) => {
  return post(`${prefix}/debug`, data, undefined, loading)
}

/**
 * 删除插件
 * @param 参数 function_lib_id
 */
const delFunctionLib: (
  function_lib_id: String,
  loading?: Ref<boolean>
) => Promise<Result<boolean>> = (function_lib_id, loading) => {
  return del(`${prefix}/${function_lib_id}`, undefined, {}, loading)
}
/**
 * 获取插件详情
 * @param function_lib_id 插件id
 * @param loading 加载器
 * @returns 插件详情
 */
const getFunctionLibById: (
  function_lib_id: String,
  loading?: Ref<boolean>
) => Promise<Result<any>> = (function_lib_id, loading) => {
  return get(`${prefix}/${function_lib_id}`, undefined, loading)
}
const pylint: (code: string, loading?: Ref<boolean>) => Promise<Result<any>> = (code, loading) => {
  return post(`${prefix}/pylint`, { code }, {}, loading)
}

export default {
  getFunctionLib,
  postFunctionLib,
  putFunctionLib,
  postFunctionLibDebug,
  getAllFunctionLib,
  delFunctionLib,
  getFunctionLibById,
  pylint
}
