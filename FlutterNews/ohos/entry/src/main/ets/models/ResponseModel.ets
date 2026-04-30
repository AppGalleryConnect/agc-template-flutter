
/**
 * 新闻类型
 */
export enum NewsEnum {
  /**
   * 文章
   */
  Article = 0,
  /**
   * 视频
   */
  Video,
  /**
   * 动态
   */
  Post,
  /**
   * 广播
   */
  Broadcast,
  /**
   * 电视
   */
  Television
}

/**
 * 视频类型
 */
export enum VideoEnum {
  /**
   * 竖屏
   */
  Portrait = 0,
  /**
   * 横屏
   */
  Landscape,
}

/**
 * 动态图片/视频
 */
export interface PostImgList {
  picVideoUrl: string
  movingVideoUrl?: string
  id?: string
  surfaceUrl: string
  type?: number
  essayId?: string
}

/**
 * 评论-云侧接口响应模型
 */
export interface CommentResponse {
  // 评论id
  commentId: string
  // 父评论ID
  parentCommentId?: string
  // 父评论详情
  parentComment?: CommentResponse
  // 从属新闻id
  newsId: string
  // 评论的作者
  author: AuthorResponse
  // 评论的内容
  commentBody: string
  // 评论被点赞数量
  commentLikeNum: number
  // 评论时间
  createTime: number
  // 是否被我点赞
  isLiked: boolean
  // 被回复的评论列表
  replyComments: CommentResponse[]
}

/**
 * 新闻内容-云侧接口响应模型
 */
export interface NewsResponse {
  // 内容id
  id: string
  // 新闻类型
  type: NewsEnum
  // 标题
  title: string
  // 作者
  author: AuthorResponse
  // 创建时间
  createTime: number
  // 相对时间
  relativeTime?: string
  // 评论列表
  comments: CommentResponse[]
  // 评论数
  commentCount: number
  // 收藏数量
  markCount: number
  // 点赞数量
  likeCount: number
  // 分享数量
  shareCount: number
  // 是否被点赞
  isLiked: boolean
  // 是否被收藏
  isMarked: boolean
  // 富文本
  richContent?: string
  // 相关推荐
  recommends?: NewsResponse[]
  // 视频url
  videoUrl?: string
  // 封面图
  coverUrl?: string
  // 视频类型
  videoType?: VideoEnum
  // 视频时长(单位: 毫秒)
  videoDuration?: number
  // 正文
  postBody?: string
  // 图片链接
  postImgList?: PostImgList[]
  // 动态布局参数
  navInfo?: NavInfo
  // 额外信息
  extraInfo?: Record<string, string | boolean | Record<string, string | boolean>[]>
  // 来源
  articleFrom?: string
  // 播放次数
  playCount?: string
  // 总数
  totalCount?: number
  // 关联文章id
  relationId?: string
}

/**
 * 作者-云侧接口响应模型
 */
export interface AuthorResponse {
  // 作者id
  authorId: string
  //作者昵称
  authorNickName: string
  // 作者icon
  authorIcon: string
  //作者简介
  authorDesc: string
  // 作者ip
  authorIp: string
  // 关注的人数
  watchersCount: number
  // 粉丝数量
  followersCount: number
  // 获赞数量
  likeNum: number
  // 关注的人id集合
  watchers?: string[]
  // 粉丝id集合
  followers?: string[]
  // 订阅号
  subscribe?: string[]
  // 手机号
  authorPhone?: string
}

/***
 * 动态布局信息
 */
export class NavInfo {
  setting: string = ''
}

export class AuthorInfo implements AuthorResponse {
  // 作者id
  authorId: string = ''
  //作者昵称
  authorNickName: string = ''
  // 作者icon
  authorIcon: string = ''
  //作者简介
  authorDesc: string = ''
  // 作者ip
  authorIp: string = ''
  // 关注的人数
  watchersCount: number = 0
  // 粉丝数量
  followersCount: number = 0
  // 获赞数量
  likeNum: number = 0
}

export interface FlexLayoutModel {
  navInfo: NavInfo
  articles: string[]
  extraInfo: Record<string, string | boolean | Record<string, string | boolean>[]>
}

@ObservedV2
export class RequestListData<T = NewsResponse> {
  navInfo: NavInfo = new NavInfo()
  @Trace articles: T[] = []
  extraInfo: Record<string, string | boolean | Record<string, string | boolean>[]> = {}
}
