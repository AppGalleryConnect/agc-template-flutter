import '../models/account_model.dart';
import '../models/post_model.dart';
import '../models/task_model.dart';

class MockData {
  static List<AccountModel> accountItems = [
    AccountModel(
      id: '1',
      name: 'XX市人力资源和社会保障局',
      avatar: 'assets/images/account.png',
    ),
    AccountModel(
      id: '2',
      name: 'XX市医疗保障局',
      avatar: 'assets/images/account.png',
    ),
    AccountModel(
      id: '3',
      name: 'XX市市场监督管理局',
      avatar: 'assets/images/account.png',
    ),
    AccountModel(
      id: '4',
      name: 'XX市交通运输委员会',
      avatar: 'assets/images/account.png',
    ),
    AccountModel(
      id: '5',
      name: 'XX市卫生健康委员会',
      avatar: 'assets/images/account.png',
    ),
  ];

  static List<AccountModel> accountItems2 = [
    AccountModel(
      id: '6',
      name: '县委办',
      avatar: 'assets/images/account.png',
    ),
    AccountModel(
      id: '7',
      name: '政府办',
      avatar: 'assets/images/account.png',
    ),
    AccountModel(
      id: '8',
      name: '人大办',
      avatar: 'assets/images/account.png',
    ),
    AccountModel(
      id: '9',
      name: '政协办',
      avatar: 'assets/images/account.png',
    ),
    AccountModel(
      id: '10',
      name: '县委办',
      avatar: 'assets/images/account.png',
    ),
  ];

  static List<PostModel> postItems = [
    PostModel(
      id: '101',
      account: accountItems[0],
      category: '政策解读',
      title: '关于2025年社保新规的说明',
      content: '近日发布的社保新规将影响企业和个人缴费比例...',
      publishTime: DateTime(2025, 5, 19),
      replyText: '感谢您的关注，具体实施细则将在下月公布',
      replyTime: DateTime(2025, 5, 20),
      isReplied: true,
    ),
    PostModel(
      id: '102',
      account: accountItems[1],
      category: '通知公告',
      title: '医保电子凭证使用指南',
      content: '即日起全市推广使用医保电子凭证，可通过小程序激活...',
      publishTime: DateTime(2025, 5, 17),
      replyText: '目前系统运行稳定，已覆盖全市85%的医疗机构',
      replyTime: DateTime(2025, 5, 18),
      isReplied: false,
      image: 'assets/images/information.jpg',
    ),
    PostModel(
      id: '103',
      account: accountItems[3],
      category: '交通出行',
      title: '2025年地铁新线路规划公示',
      content: '我市计划在2025年开通三条新地铁线路，覆盖主要城区和郊区',
      publishTime: DateTime(2025, 5, 21),
      replyText: '具体规划图可在交通局官网下载查看',
      replyTime: DateTime(2025, 5, 22),
      isReplied: false,
    ),
    PostModel(
      id: '104',
      account: accountItems[4],
      category: '医疗服务',
      title: '医保报销政策调整通知',
      content: '自2025年6月1日起，部分药品报销比例将提高',
      publishTime: DateTime(2025, 5, 18),
      replyText: '详细药品目录已发布在卫健委官网',
      replyTime: DateTime(2025, 5, 19),
      isReplied: true,
      image: 'assets/images/information.jpg',
    ),
    PostModel(
      id: '105',
      account: accountItems[0],
      category: '就业政策',
      title: '高校毕业生就业补贴政策',
      content: '2025届高校毕业生可申请就业补贴，最高5000元',
      publishTime: DateTime(2025, 5, 16),
      replyText: '申请系统将于6月1日开放，请关注人社局官网',
      replyTime: DateTime(2025, 5, 17),
      isReplied: false,
    ),
  ];

  static List<TaskModel> assistantItems() {
    return [
      TaskModel(
        id: '1',
        title: '老旧小区加装电梯民意征询工作推进',
        content: '组织社区走访，发放调查问卷，召开居民协商会，汇总意见形成可行性报告，报街道办审批备案。',
        publishTime: DateTime.now().subtract(const Duration(days: 7)),
        isCompleted: true,
      ),
      TaskModel(
        id: '2',
        title: '“一老一小”关爱服务项目落地实施',
        content: '对接养老院与托育机构资源，制定服务清单，开展首期公益讲座，并建立需求登记台账，持续跟踪反馈。',
        publishTime: DateTime.now().subtract(const Duration(days: 15)),
        isCompleted: false,
      ),
      TaskModel(
        id: '3',
        title: '困难群众临时救助申请审核与发放',
        content: '核对申请人材料真实性，实地走访核实情况，完成审批流程，确保救助金在3个工作日内到账。',
        publishTime: DateTime.now().subtract(const Duration(hours: 12)),
        isCompleted: true,
      ),
      TaskModel(
        id: '4',
        title: '社区便民服务驿站功能优化方案制定',
        content: '调研居民使用频次与痛点，调整服务时间，新增快递代收、政策咨询等高频服务模块，提交方案公示征求意见。',
        publishTime: DateTime.now().subtract(const Duration(days: 10)),
        isCompleted: false,
      ),
      TaskModel(
        id: '5',
        title: '农村饮水安全问题排查整改行动',
        content: '联合水务公司对5个行政村开展水质检测，建立问题台账，限期修复管道老化段，及时向村民通报进展。',
        publishTime: DateTime.now().subtract(const Duration(days: 22)),
        isCompleted: true,
      ),
      TaskModel(
        id: '6',
        title: '“家门口就业”招聘会筹备与宣传',
        content: '征集本地企业岗位信息，制作招聘海报，通过微信群、社区公告栏多渠道发布，安排现场引导与政策解读。',
        publishTime: DateTime.now().subtract(const Duration(days: 30)),
        isCompleted: false,
      ),
    ];
  }
}
