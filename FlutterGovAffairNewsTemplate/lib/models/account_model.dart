// 账号模型: 用于构建政务号、部门号
class AccountModel {
  final String id;
  final String name;
  final String avatar;
  final bool isFollowed;

  AccountModel({
    required this.id,
    required this.name,
    required this.avatar,
    this.isFollowed = false,
  });
}