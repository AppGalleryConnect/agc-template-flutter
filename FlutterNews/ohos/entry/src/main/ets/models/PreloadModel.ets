 interface FunctionResultRet {
  code: number
  desc: string
}


export interface CloudRecommendListResult<T> {
  hmSystem: FunctionResultRet,
  recommendList: T
}