import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:module_newsfeed/components/native_navigation_utils.dart';
import '../Screenshot/screen_shot.dart';
import '../buildShare/first_poster_share.dart';
import '../buildShare/poster_share_pop_content.dart';
import '../model/share_model.dart';
import '../utils/event_dispatcher.dart';
import '../utils/pop_view_utils.dart';
import 'package:module_share/constants/constants.dart';

// -------------------------- 核心分享组件 --------------------------、
typedef OnShareButtonClicked = void Function(String buttonName);
final EventBus eventBus = EventBus();

class Share extends StatefulWidget {
  final WidgetBuilder? shareRenderBuilder;
  final ShareOptions qrCodeInfo;
  final VoidCallback onClose;
  final VoidCallback onOpen;
  final ValueChanged<VoidCallback>? onTriggerShare;

  const Share({
    super.key,
    this.shareRenderBuilder,
    required this.qrCodeInfo,
    required this.onClose,
    required this.onOpen,
    this.onTriggerShare,
  });

  static Future<void> show(BuildContext context, ShareOptions options,String subtitle) async {

    final Map<String, String> params = {
      "params":subtitle
    };
    await NativeNavigationUtils.pushToShare(params:  params);
  }

  @override
  State<Share> createState() => _ShareState();
}

class _ShareState extends State<Share> {
  bool _sharePopShow = false;
  Uint8List? _pixmap;
  late final QqShareViewModel _qqShareViewModel;

  @override
  void initState() {
    super.initState();
    _qqShareViewModel = QqShareViewModel.instance;
    _qqShareViewModel.initQqShare();
    widget.onTriggerShare?.call(_triggerShare);

    final currentCallback = ShareEventDispatcher.instance.closeCallback;
    ShareEventDispatcher.instance.closeCallback = () {
      currentCallback?.call();
      widget.onClose();
    };
  }

  @override
  void dispose() {
    ShareEventDispatcher.instance.closeCallback = null;
    super.dispose();
  }

  void _triggerShare() {
    widget.onOpen();
    final ShareSheetParams params = ShareSheetParams(
      onPost: (bool success, Uint8List data) {
        
      },
      qrCodeInfo: widget.qrCodeInfo,
    );
    PopViewUtils.setContext(context);
    PopViewUtils.showSheet(
      contentBuilder: (context) => FirstPosterShare(params: params),
      options: SheetOptions(
        title: '分享到',
        backgroundColor: Colors.white,
        showClose: true,
      ),
    );
  }

  void _onPost(bool isOpen, Uint8List pixmap) {
    setState(() {
      _sharePopShow = isOpen;
      _pixmap = pixmap;
    });
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onTriggerShare?.call(_triggerShare);
    });
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildShareTriggerButton(),
        if (_sharePopShow && _pixmap != null)
          Center(
            child: PosterSharePop(
              sharePopShow: _sharePopShow,
              qrCodeInfo: widget.qrCodeInfo,
              pixmap: _pixmap!,
              onClose: () {
                setState(() => _sharePopShow = false);
                widget.onClose();
              },
              popClose: (bool isClose) =>
                  setState(() => _sharePopShow = isClose),
            ),
          ),
        SizedBox(
          width: Constants.SPACE_0,
          height: Constants.SPACE_0,
          child: Stack(
            children: [
              Positioned(
                left: Constants.SPACE_2000,
                bottom: Constants.SPACE_0,
                child: Visibility(
                  visible: false,
                  maintainAnimation: true,
                  maintainSize: true,
                  maintainState: true,
                  child: Screenshot(
                    qrCodeInfo:
                        ShareOptions(id: "", title: "", articleFrom: ""),
                    onPost: (_, __) {},
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  // 分享触发按钮：固定尺寸，避免布局偏移
  Widget _buildShareTriggerButton() {
    return GestureDetector(
      onTap: _triggerShare,
      child: widget.shareRenderBuilder != null
          ? widget.shareRenderBuilder!(context)
          : Image.asset(
              Constants.shareActiveImage,
              width: Constants.SPACE_24,
              height: Constants.SPACE_24,
              color: Theme.of(context).colorScheme.secondary,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.share, size: Constants.SPACE_24);
              },
            ),
    );
  }
}

class QqShareViewModel {
  static final QqShareViewModel instance = QqShareViewModel();

  void initQqShare() {
    
  }

  void share(ShareOptions options) {
    
  }
}

class WxShareViewModel {
  static final WxShareViewModel instance = WxShareViewModel();

  void newsWebShare(ShareOptions options) {
    
  }
}

class ShareOptionTap {
  final String icon;
  final String name;
  final VoidCallback? onTap; 

  ShareOptionTap({
    required this.icon,
    required this.name,
    this.onTap, 
  });
}
