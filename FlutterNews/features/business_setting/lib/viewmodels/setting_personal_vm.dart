import 'dart:io';
import 'dart:math';
import 'package:get/get.dart';
import 'package:lib_common/constants/pop_view_utils.dart';
import 'package:lib_common/lib_common.dart';
import 'package:lib_account/services/account_api.dart';
import 'package:lib_news_api/lib_news_api.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

const String TAG = '[SettingPersonalVM]';

class SettingPersonalVM extends GetxController {
  late final UserInfoModel userInfoModel;
  final WindowModel windowModel = StorageUtils.connect(
    create: () => WindowModel(),
    type: StorageType.appStorage,
  );
  final ImagePicker _picker = ImagePicker();
  late final RxString nickName;
  late final RxString contactPhone;
  late final RxString personalDesc;
  final avatarPath = 'assets/icon_default.png'.obs;
  final showNickNameSheet = false.obs;
  final showPersonDescSheet = false.obs;
  final showPhoneSheet = false.obs;
  final hasModify = false.obs;
  final keyHeight = 0.0.obs;
  final double defaultSheetH = 0.9;

  @override
  void onInit() {
    super.onInit();
    userInfoModel = AccountApi.getInstance().userInfoModel;
    nickName = userInfoModel.authorNickName.obs;
    contactPhone = userInfoModel.authorPhone.obs;
    personalDesc = userInfoModel.authorDesc.obs;
    updateAvatarPath(userInfoModel.authorIcon);
    userInfoModel.addListener(_onUserInfoChanged);
  }

  void updateAvatarPath(String iconPath) {
    if (iconPath.isNotEmpty) {
      avatarPath.value = iconPath;
    } else {
      avatarPath.value = 'assets/icon_default.png';
    }
  }

  void _onUserInfoChanged() {
    nickName.value = userInfoModel.authorNickName;
    contactPhone.value = userInfoModel.authorPhone;
    personalDesc.value = userInfoModel.authorDesc;
    updateAvatarPath(userInfoModel.authorIcon);
  }

  @override
  void onClose() {
    userInfoModel.removeListener(_onUserInfoChanged);
    super.onClose();
  }

  bool modifyNickName() {
    if (nickName.value.isEmpty) {
      toast('昵称不能为空');
      return false;
    }
    MineServiceApi.modifyPersonalInfo(ModifyPersonalInfoRequest(
      authorNickName: nickName.value,
    ));
    userInfoModel.authorNickName = nickName.value;
    showNickNameSheet.value = false;
    hasModify.value = true;
    toast('昵称修改成功');
    return true;
  }

  bool modifyContactPhone() {
    if (contactPhone.value.isEmpty) {
      toast('手机号码不能为空');
      return false;
    }

    if (!_isPhoneNumberValid(contactPhone.value)) {
      toast('请输入正确的手机号码');
      return false;
    }
    MineServiceApi.modifyPersonalInfo(ModifyPersonalInfoRequest(
      authorPhone: contactPhone.value,
    ));

    userInfoModel.authorPhone = _encryptPhone(contactPhone.value);
    showPhoneSheet.value = false;
    hasModify.value = true;
    toast('手机号码修改成功');
    return true;
  }

  bool _isPhoneNumberValid(String phone) {
    final phoneRegex = RegExp(r'^1[3-9]\d{9}$');
    return phoneRegex.hasMatch(phone);
  }

  String _encryptPhone(String phone) {
    if (phone.length != 11) return phone;
    return '${phone.substring(0, 3)}****${phone.substring(7)}';
  }

  bool modifyPersonalDesc() {
    MineServiceApi.modifyPersonalInfo(ModifyPersonalInfoRequest(
      authorDesc: personalDesc.value,
    ));
    userInfoModel.authorDesc = personalDesc.value;
    showPersonDescSheet.value = false;
    hasModify.value = true;
    toast('个人简介修改成功');
    return true;
  }

  String _generateRandomUUID() {
    final random = Random();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final randomPart = random.nextInt(999999);
    return '${timestamp}_$randomPart';
  }

  Future<String> _handleUri(String uri) async {
    if (uri.isEmpty) {
      return '';
    }

    try {
      final appDocDir = await getApplicationDocumentsDirectory();
      final fileName = '${_generateRandomUUID()}.png';
      final newPath = path.join(appDocDir.path, fileName);
      String sourcePath = uri;
      if (sourcePath.startsWith('file://')) {
        sourcePath = sourcePath.substring(7);
      }
      final sourceFile = File(sourcePath);
      if (await sourceFile.exists()) {
        await sourceFile.copy(newPath);
        return newPath;
      } else {
        return '';
      }
    } catch (e) {
      return '';
    }
  }

  Future<void> saveUserIcon(String uri) async {
    if (uri.isEmpty) {
      return;
    }
    final avatarUrl = await _handleUri(uri);
    if (avatarUrl.isEmpty) {
      toast('头像保存失败');
      return;
    }

    MineServiceApi.modifyPersonalInfo(ModifyPersonalInfoRequest(
      authorIcon: avatarUrl,
    ));

    userInfoModel.authorIcon = avatarUrl;
    updateAvatarPath(avatarUrl);
    hasModify.value = true;
    toast('头像修改成功');
  }

  void customBack() {
    Get.back(result: hasModify.value ? 'modify-flag' : null);
  }

  void registerKeyboard() {}

  void unRegisterKeyboard() {}

  /// 用户名
  String get username => nickName.value;

  /// 编辑用户名
  void editUsername() {
    nickName.value = userInfoModel.authorNickName;
    showNickNameSheet.value = true;
  }

  /// 手机号码
  String get phoneNumber => contactPhone.value;

  /// 编辑手机号码
  void editPhone() {
    contactPhone.value = userInfoModel.authorPhone;
    showPhoneSheet.value = true;
  }

  /// 个人简介
  String get personalBio => personalDesc.value;

  /// 编辑个人简介
  void editBio() {
    personalDesc.value = userInfoModel.authorDesc;
    showPersonDescSheet.value = true;
  }

  /// 选择头像
  Future<void> pickAvatar() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        await saveUserIcon(image.path);
      }
    } catch (e) {
      toast('选择头像失败，请重试');
    }
  }
}
