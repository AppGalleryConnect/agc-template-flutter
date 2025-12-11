import '../../constants/constants.dart';
import '../../database/news_type.dart';
import '../../params/response/layout_response.dart';
import '../../params/base/base_model.dart';

/// 模拟帖子数据类
class MockPost {
  /// 我的帖子列表
  static List<BaseNews> mineList = [
    BaseNews(
      id: 'post_mine_1',
      type: NewsEnum.post,
      likeCount: 12,
      commentCount: 15,
      isLiked: false,
      isMarked: false,
      recommends: [
        SimpleNews(newsId: 'article_11', newsType: NewsEnum.article),
        SimpleNews(newsId: 'article_12', newsType: NewsEnum.article),
      ],
      shareCount: 120,
      markCount: 45,
      articleFrom: '',
      title:
          '假期的旅行碎片已加载完毕～。旅行哪里是逃离呀，分明是让你在人山人海里，重新找到自己的位置，原来旅行的意义，真的藏在那些不期而遇里，走在陌生的街道，看当地人慢悠悠地喝茶，突然懂了 "慢下来" 不是浪费时，原来自己比想象中更有韧性呀。',
      richContent: '',
      authorId: '001',
      createTime: 1751076002000,
      postImgList: [
        PostImgList(
          picVideoUrl:
              'https://agc-storage-drcn.platform.dbankcloud.cn/v0/news-hnp2d/news_tra_2.jpg',
          surfaceUrl: '',
        ),
        PostImgList(
          picVideoUrl:
              'https://agc-storage-drcn.platform.dbankcloud.cn/v0/news-hnp2d/news_tra_3.jpg',
          surfaceUrl: '',
        ),
        PostImgList(
          picVideoUrl:
              'https://agc-storage-drcn.platform.dbankcloud.cn/v0/news-hnp2d/news_tra_4.jpg',
          surfaceUrl: '',
        ),
        PostImgList(
          picVideoUrl:
              'https://agc-storage-drcn.platform.dbankcloud.cn/v0/news-hnp2d/news_tra_5.jpg',
          surfaceUrl: '',
        ),
        PostImgList(
          picVideoUrl:
              'https://agc-storage-drcn.platform.dbankcloud.cn/v0/news-hnp2d/news_tra_6.jpg',
          surfaceUrl: '',
        ),
        PostImgList(
          picVideoUrl:
              'https://agc-storage-drcn.platform.dbankcloud.cn/v0/news-hnp2d/news_tra_7.jpg',
          surfaceUrl: '',
        ),
        PostImgList(
          picVideoUrl:
              'https://agc-storage-drcn.platform.dbankcloud.cn/v0/news-hnp2d/news_tra_8.jpg',
          surfaceUrl: '',
        ),
        PostImgList(
          picVideoUrl:
              'https://agc-storage-drcn.platform.dbankcloud.cn/v0/news-hnp2d/news_tra_9.jpg',
          surfaceUrl: '',
        ),
        PostImgList(
          picVideoUrl:
              'https://agc-storage-drcn.platform.dbankcloud.cn/v0/news-hnp2d/news_tra_10.jpg',
          surfaceUrl: '',
        ),
      ],
      navInfo: NavInfo(
        setting:
            '{"type":"view","children":[{"type":"view","children":[{"type":"List","children":[{"type":"native","showType":"FeedDetailsCard","name":"帖子详情"}],"style":{"backgroundColor":"#FFFFFF","padding-bottom":"12","padding-top":"12"}}]}]}',
      ),
    ),
    BaseNews(
      id: 'post_mine_2',
      type: NewsEnum.post,
      likeCount: 36,
      commentCount: 175,
      isMarked: false,
      isLiked: false,
      markCount: 4500,
      articleFrom: '',
      shareCount: 12000,
      title: '#旅行的意义 #在路上',
      recommends: [
        SimpleNews(newsId: 'article_8', newsType: NewsEnum.article),
        SimpleNews(newsId: 'article_13', newsType: NewsEnum.article),
      ],
      richContent: '',
      authorId: '001',
      createTime: 1750557602000,
      postImgList: [
        PostImgList(
          picVideoUrl:
              'https://agc-storage-drcn.platform.dbankcloud.cn/v0/news-hnp2d/news_tra_11.jpg',
          surfaceUrl: '',
        ),
      ],
      navInfo: NavInfo(),
    ),
  ];

  /// 帖子列表（包含我的帖子列表的所有内容）
  static List<BaseNews> list = [
    ...mineList,
    BaseNews(
      id: 'post_1',
      type: NewsEnum.post,
      likeCount: 36,
      commentCount: 175,
      shareCount: 12000,
      isLiked: true,
      isMarked: true,
      markCount: 4500,
      articleFrom: '',
      recommends: [
        SimpleNews(newsId: 'article_11', newsType: NewsEnum.article),
        SimpleNews(newsId: 'article_12', newsType: NewsEnum.article),
      ],
      title:
          '假期的旅行碎片已加载完毕～。旅行哪里是逃离呀，分明是让你在人山人海里，重新找到自己的位置，原来旅行的意义，真的藏在那些不期而遇里，走在陌生的街道，看当地人慢悠悠地喝茶，突然懂了 "慢下来" 不是浪费时，原来自己比想象中更有韧性呀。',
      richContent: '',
      authorId: 'author_6',
      createTime: 1751089800000,
      postImgList: [
        PostImgList(
          picVideoUrl:
              'https://agc-storage-drcn.platform.dbankcloud.cn/v0/news-hnp2d/news_tra_2.jpg',
          surfaceUrl: '',
        ),
        PostImgList(
          picVideoUrl:
              'https://agc-storage-drcn.platform.dbankcloud.cn/v0/news-hnp2d/news_tra_8.jpg',
          surfaceUrl: '',
        ),
        PostImgList(
          picVideoUrl:
              'https://agc-storage-drcn.platform.dbankcloud.cn/v0/news-hnp2d/news_tra_3.jpg',
          surfaceUrl: '',
        ),
        PostImgList(
          picVideoUrl:
              'https://agc-storage-drcn.platform.dbankcloud.cn/v0/news-hnp2d/news_tra_5.jpg',
          surfaceUrl: '',
        ),
        PostImgList(
          picVideoUrl:
              'https://agc-storage-drcn.platform.dbankcloud.cn/v0/news-hnp2d/news_tra_4.jpg',
          surfaceUrl: '',
        ),
        PostImgList(
          picVideoUrl:
              'https://agc-storage-drcn.platform.dbankcloud.cn/v0/news-hnp2d/news_tra_6.jpg',
          surfaceUrl: '',
        ),
        PostImgList(
          picVideoUrl:
              'https://agc-storage-drcn.platform.dbankcloud.cn/v0/news-hnp2d/news_tra_10.jpg',
          surfaceUrl: '',
        ),
        PostImgList(
          picVideoUrl:
              'https://agc-storage-drcn.platform.dbankcloud.cn/v0/news-hnp2d/news_tra_7.jpg',
          surfaceUrl: '',
        ),
        PostImgList(
          picVideoUrl:
              'https://agc-storage-drcn.platform.dbankcloud.cn/v0/news-hnp2d/news_tra_9.jpg',
          surfaceUrl: '',
        ),
      ],
      navInfo: NavInfo(
        setting:
            '{"type":"view","children":[{"type":"view","children":[{"type":"List","children":[{"type":"native","showType":"FeedDetailsCard","name":"帖子详情"}],"style":{"backgroundColor":"#FFFFFF","padding-bottom":"12","padding-top":"12"}}]}]}',
      ),
    ),
    BaseNews(
      id: 'post_2',
      type: NewsEnum.post,
      likeCount: 36,
      commentCount: 175,
      shareCount: 12000,
      isLiked: false,
      isMarked: false,
      markCount: 4500,
      articleFrom: '',
      recommends: [
        SimpleNews(newsId: 'article_8', newsType: NewsEnum.article),
        SimpleNews(newsId: 'article_13', newsType: NewsEnum.article),
      ],
      title: '#旅行的意义 #在路上',
      richContent: '',
      authorId: 'author_6',
      createTime: 1751089800000,
      postImgList: [
        PostImgList(
          picVideoUrl:
              'https://agc-storage-drcn.platform.dbankcloud.cn/v0/news-hnp2d/news_tra_11.jpg',
          surfaceUrl: '',
        ),
      ],
      navInfo: NavInfo(),
    ),
    BaseNews(
      id: 'post_3',
      type: NewsEnum.post,
      likeCount: 36,
      commentCount: 175,
      shareCount: 12000,
      isLiked: false,
      isMarked: false,
      markCount: 4500,
      articleFrom: '',
      recommends: [
        SimpleNews(newsId: 'article_8', newsType: NewsEnum.article),
        SimpleNews(newsId: 'article_13', newsType: NewsEnum.article),
      ],
      title: '#好好学习、天天向上# 学而时习之',
      richContent: '',
      authorId: 'author_6',
      createTime: 1751089800000,
      postImgList: [
        PostImgList(
          picVideoUrl:
              'https://agc-storage-drcn.platform.dbankcloud.cn/v0/news-hnp2d/news_tra_2.jpg',
          surfaceUrl: '',
        ),
        PostImgList(
          picVideoUrl:
              'https://agc-storage-drcn.platform.dbankcloud.cn/v0/news-hnp2d/news_tra_3.jpg',
          surfaceUrl: '',
        ),
        PostImgList(
          picVideoUrl:
              'https://agc-storage-drcn.platform.dbankcloud.cn/v0/news-hnp2d/news_tra_4.jpg',
          surfaceUrl: '',
        ),
        PostImgList(
          picVideoUrl:
              'https://agc-storage-drcn.platform.dbankcloud.cn/v0/news-hnp2d/news_tra_5.jpg',
          surfaceUrl: '',
        ),
      ],
      navInfo: NavInfo(),
    ),
    BaseNews(
      id: 'post_4',
      type: NewsEnum.post,
      likeCount: 36,
      commentCount: 175,
      shareCount: 12000,
      isLiked: false,
      isMarked: false,
      markCount: 4500,
      articleFrom: '',
      recommends: [
        SimpleNews(newsId: 'article_8', newsType: NewsEnum.article),
        SimpleNews(newsId: 'article_13', newsType: NewsEnum.article),
      ],
      title:
          '清晨的阳光总是带着点懒意，悄悄爬上窗帘缝隙时，先别急着掀开被子。听会儿窗外的鸟鸣，是麻雀在树枝上跳来跳去的碎语，还是鸽子带着哨音从楼顶掠过？',
      richContent: '',
      authorId: 'author_5',
      createTime: 1751089800000,
      postImgList: [
        PostImgList(
          picVideoUrl:
              'https://www-file.huawei.com/admin/asset/v1/pro/view/ca03b4509af94cadbdde656fd9cd23ef.jpg',
          surfaceUrl: '',
        ),
      ],
      navInfo: NavInfo(
        setting:
            '{"type":"view","children":[{"type":"view","children":[{"type":"List","children":[{"type":"native","showType":"FeedDetailsCard","name":"帖子详情"}],"style":{"backgroundColor":"#FFFFFF","padding-bottom":"12","padding-top":"12"}}]}]}',
      ),
    ),
    BaseNews(
      id: 'post_5',
      type: NewsEnum.post,
      likeCount: 36,
      commentCount: 175,
      shareCount: 12000,
      isLiked: false,
      isMarked: false,
      markCount: 4500,
      articleFrom: '',
      recommends: [
        SimpleNews(newsId: 'article_8', newsType: NewsEnum.article),
        SimpleNews(newsId: 'article_13', newsType: NewsEnum.article),
      ],
      title: '雨后黄山现 "佛光" 奇观，云海之上光晕环绕宛如仙境，梯田云雾缭绕如 "天梯"，农人耕作身影勾勒出秋日农耕画卷',
      richContent: '',
      authorId: 'author_2',
      createTime: 1751089800000,
      postImgList: [
        PostImgList(
          picVideoUrl:
              'https://www-file.huawei.com/admin/asset/v1/pro/view/ca03b4509af94cadbdde656fd9cd23ef.jpg',
          surfaceUrl: '',
        ),
        PostImgList(
          picVideoUrl:
              'https://agc-storage-drcn.platform.dbankcloud.cn/v0/news-hnp2d/new%2F4_2514153291_huge.jpg',
          surfaceUrl: '',
        ),
        PostImgList(
          picVideoUrl:
              'https://agc-storage-drcn.platform.dbankcloud.cn/v0/news-hnp2d/new%2F94_2103664649_huge%E5%B0%8F.jpg',
          surfaceUrl: '',
        ),
        PostImgList(
          picVideoUrl:
              'https://agc-storage-drcn.platform.dbankcloud.cn/v0/news-hnp2d/new%2F38_hellorf_hi2241563890%E5%B0%8F.jpg',
          surfaceUrl: '',
        ),
      ],
      navInfo: NavInfo(
        setting:
            '{"type":"view","children":[{"type":"view","children":[{"type":"List","children":[{"type":"native","showType":"FeedDetailsCard","name":"帖子详情"}],"style":{"backgroundColor":"#FFFFFF","padding-bottom":"12","padding-top":"12"}}]}]}',
      ),
    ),
    BaseNews(
      id: 'post_6',
      type: NewsEnum.post,
      likeCount: 36,
      commentCount: 175,
      shareCount: 12000,
      isLiked: false,
      isMarked: false,
      markCount: 4500,
      articleFrom: '',
      recommends: [
        SimpleNews(newsId: 'article_8', newsType: NewsEnum.article),
        SimpleNews(newsId: 'article_13', newsType: NewsEnum.article),
      ],
      title: '江南古镇入梅：雨打芭蕉润青瓦，水墨画里藏初夏',
      richContent: '',
      authorId: 'author_5',
      createTime: 1751089800000,
      postImgList: [
        PostImgList(
          picVideoUrl:
              'https://www-file.huawei.com/admin/asset/v1/pro/view/ca03b4509af94cadbdde656fd9cd23ef.jpg',
          surfaceUrl: '',
        ),
      ],
      navInfo: NavInfo(
        setting:
            '{"type":"view","children":[{"type":"view","children":[{"type":"List","children":[{"type":"native","showType":"FeedDetailsCard","name":"帖子详情"}],"style":{"backgroundColor":"#FFFFFF","padding-bottom":"12","padding-top":"12"}}]}]}',
      ),
    ),
    BaseNews(
      id: 'post_7',
      type: NewsEnum.post,
      likeCount: 36,
      commentCount: 175,
      shareCount: 12000,
      isLiked: false,
      isMarked: false,
      markCount: 4500,
      articleFrom: '',
      recommends: [
        SimpleNews(newsId: 'article_8', newsType: NewsEnum.article),
        SimpleNews(newsId: 'article_13', newsType: NewsEnum.article),
      ],
      title: '塞北草原秋意浓，千亩胡杨林披 "金衣"，每日吸引超千名摄影爱好者，东北雪乡迎来今冬初雪，雪蘑菇、雪蛋糕造型憨态可掬成网红打卡点',
      richContent: '',
      authorId: 'author_9',
      createTime: 1751089800000,
      postImgList: [
        PostImgList(
          picVideoUrl:
              'https://agc-storage-drcn.platform.dbankcloud.cn/v0/news-hnp2d/new%2F18_2549393977_huge%E5%B0%8F.jpg',
          surfaceUrl: '',
        ),
        PostImgList(
          picVideoUrl:
              'https://agc-storage-drcn.platform.dbankcloud.cn/v0/news-hnp2d/new%2F20_hellorf_2239003531.jpg',
          surfaceUrl: '',
        ),
      ],
      navInfo: NavInfo(
        setting:
            '{"type":"view","children":[{"type":"view","children":[{"type":"List","children":[{"type":"native","showType":"FeedDetailsCard","name":"帖子详情"}],"style":{"backgroundColor":"#FFFFFF","padding-bottom":"12","padding-top":"12"}}]}]}',
      ),
    ),
    BaseNews(
      id: 'post_8',
      type: NewsEnum.post,
      likeCount: 36,
      commentCount: 175,
      shareCount: 12000,
      isLiked: false,
      isMarked: false,
      markCount: 4500,
      articleFrom: '',
      recommends: [
        SimpleNews(newsId: 'article_6', newsType: NewsEnum.article),
        SimpleNews(newsId: 'article_14', newsType: NewsEnum.article),
      ],
      title:
          '春色与红韵交织，独好园焕新颜。春风拂过会昌山麓，风景独好园内红梅竞放，与青砖黛瓦的毛泽东旧居与粤赣省委旧址群相映成趣。这里是毛泽东盛赞 "风景这边独好" 的地方，更是红色历史的鲜活见证。春日里，游客漫步园区，既可在古树下赏花拍照，又能在革命旧址中触摸历史的温度。一树红梅，一墙标语，皆是革命精神与自然生机的共舞',
      richContent: '',
      authorId: 'author_8',
      createTime: 1751089800000,
      postImgList: [
        PostImgList(
          picVideoUrl:
              'https://agc-storage-drcn.platform.dbankcloud.cn/v0/news-hnp2d/new%2F38_hellorf_hi2241563890%E5%B0%8F.jpg?token=4a1b3c5f-ae0d-4115-bd1a-67315fa59910',
          surfaceUrl: '',
        ),
        PostImgList(
          picVideoUrl:
              'https://agc-storage-drcn.platform.dbankcloud.cn/v0/news-hnp2d/new%2F94_2103664649_huge%E5%B0%8F.jpg?token=46fd270e-1c53-4a1b-8bb2-fabba4fa70d3',
          surfaceUrl: '',
        ),
      ],
      navInfo: NavInfo(
        setting:
            '{"type":"view","children":[{"type":"view","children":[{"type":"List","children":[{"type":"native","showType":"FeedDetailsCard","name":"帖子详情"}],"style":{"backgroundColor":"#FFFFFF","padding-bottom":"12","padding-top":"12"}}]}]}',
      ),
    ),
    BaseNews(
      id: 'post_9',
      type: NewsEnum.post,
      likeCount: 36,
      commentCount: 175,
      shareCount: 12000,
      isLiked: false,
      isMarked: false,
      markCount: 4500,
      articleFrom: '',
      recommends: [
        SimpleNews(newsId: 'article_6', newsType: NewsEnum.article),
        SimpleNews(newsId: 'article_14', newsType: NewsEnum.article),
      ],
      title:
          '夏日的福建安溪金谷村溪流清澈、绿树成荫、游人如织。近年来，当地持续推进生态治理，让曾经环境脏乱的小村庄，水变清了、岸也更绿了。走进金谷村，清澈的金谷溪穿村而过，两岸绿树成荫，风格艺术感满满的设施错落有致地分布。游客们有的在溪边戏水，有的在岸边喝茶聊天、休憩纳凉，享受惬意的午后时光',
      richContent: '',
      authorId: 'author_8',
      createTime: 1751089800000,
      postImgList: [
        PostImgList(
          picVideoUrl:
              'https://agc-storage-drcn.platform.dbankcloud.cn/v0/news-hnp2d/new%2F29_2590322759_huge.jpg',
          surfaceUrl: '',
        ),
        PostImgList(
          picVideoUrl:
              'https://agc-storage-drcn.platform.dbankcloud.cn/v0/news-hnp2d/new%2F97_hellorf_hi2244493932.jpg',
          surfaceUrl: '',
        ),
        PostImgList(
          picVideoUrl:
              'https://agc-storage-drcn.platform.dbankcloud.cn/v0/news-hnp2d/new%2Fhellorf_hi2239368115%E5%B0%8F.jpg',
          surfaceUrl: '',
        ),
        PostImgList(
          picVideoUrl:
              'https://agc-storage-drcn.platform.dbankcloud.cn/v0/news-hnp2d/new%2F41_1734189599_huge%E5%B0%8F.jpg',
          surfaceUrl: '',
        ),
        PostImgList(
          picVideoUrl:
              'https://agc-storage-drcn.platform.dbankcloud.cn/v0/news-hnp2d/new%2F20_hellorf_2239003531.jpg',
          surfaceUrl: '',
        ),
        PostImgList(
          picVideoUrl:
              'https://agc-storage-drcn.platform.dbankcloud.cn/v0/news-hnp2d/new%2F2387811837_huge%E5%B0%8F.jpg',
          surfaceUrl: '',
        ),
        PostImgList(
          picVideoUrl:
              'https://agc-storage-drcn.platform.dbankcloud.cn/v0/news-hnp2d/new%2F2_2302601201_huge.jpg',
          surfaceUrl: '',
        ),
        PostImgList(
          picVideoUrl:
              'https://agc-storage-drcn.platform.dbankcloud.cn/v0/news-hnp2d/new%2F97_hellorf_hi2244493932.jpg',
          surfaceUrl: '',
        ),
        PostImgList(
          picVideoUrl:
              'https://agc-storage-drcn.platform.dbankcloud.cn/v0/news-hnp2d/new%2F97_hellorf_hi2244493932.jpg',
          surfaceUrl: '',
        ),
      ],
      navInfo: NavInfo(
        setting:
            '{"type":"view","children":[{"type":"view","children":[{"type":"List","children":[{"type":"native","showType":"FeedDetailsCard","name":"帖子详情"}],"style":{"backgroundColor":"#FFFFFF","padding-bottom":"12","padding-top":"12"}}]}]}',
      ),
    ),
  ];

  /// 默认请求列表数据（将default改为defaultModel避免关键字冲突）
  static RequestListData defaultModel =
      RequestListData(articles: [], navInfo: NavInfo(), extraInfo: {});
}
