import 'business_interaction_platform_interface.dart';

// 导出页面
export 'pages/interaction_page.dart';
export 'pages/publish_post_page.dart';

// 导出组件
export 'components/top_bar.dart';
export 'components/inter_action_tab_content.dart';
export 'components/interaction_feed_card.dart';
export 'components/no_watcher.dart';

// 导出视图模型
export 'viewmodels/interaction_view_model.dart';
export 'viewmodels/publish_post_vm.dart';

// 导出常量
export 'constants/constants.dart';

class BusinessInteraction {
  Future<String?> getPlatformVersion() {
    return BusinessInteractionPlatform.instance.getPlatformVersion();
  }
}
