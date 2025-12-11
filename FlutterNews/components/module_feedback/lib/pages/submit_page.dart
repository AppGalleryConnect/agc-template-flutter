import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../common/constants.dart';
import 'package:module_setfontsize/utils/font_scale_utils.dart';
import '../components/nav_header_bar.dart';
import '../viewmodels/submit_vm.dart';
import 'dart:io';

class SubmitPage extends StatefulWidget {
  const SubmitPage({super.key});

  @override
  SubmitPageState createState() => SubmitPageState();
}

class SubmitPageState extends State<SubmitPage> {
  late SubmitVM viewModel;
  late TextEditingController _problemController;
  late TextEditingController _contactController;

  @override
  void initState() {
    super.initState();
    viewModel = SubmitVM();
    _problemController = TextEditingController();
    _contactController = TextEditingController();
  }

  @override
  void dispose() {
    _problemController.dispose();
    _contactController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ChangeNotifierProvider.value(
        value: viewModel,
        child: Consumer<SubmitVM>(
          builder: (context, vm, child) {
            return Column(
              children: [
                const NavHeaderBar(
                  title: '反馈问题',
                ),
                Container(
                  height: Constants.SPACE_8,
                  color: Colors.grey.shade100,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.zero,
                    child: Column(
                      children: [
                        // 问题描述区域
                        _textInfo(vm),
                        // 图片上传区域
                        _imageInfo(vm),
                        // 分割线
                        Container(
                          height: Constants.SPACE_8,
                          color: Colors.grey.shade100,
                        ),
                        // 联系方式区域
                        _contactInfo(vm),
                        // 底部间距，确保内容不被按钮遮挡
                        const SizedBox(height: Constants.SPACE_16),
                      ],
                    ),
                  ),
                ),
                // 提交按钮
                _btnInfo(vm),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _textInfo(SubmitVM vm) {
    return Padding(
      padding: const EdgeInsets.all(Constants.SPACE_10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
              controller: _problemController,
              onChanged: vm.updateBody,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: '请详细描述您的问题（必填）',
                hintStyle: TextStyle(
                  color: Colors.grey.shade400,
                  fontSize: Constants.FONT_16 * FontScaleUtils.fontSizeRatio,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
              style: TextStyle(
                fontSize: Constants.FONT_16 * FontScaleUtils.fontSizeRatio,
              )),
          // 字数统计，右对齐
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              '${vm.body.length}/100',
              style: TextStyle(
                fontSize: Constants.FONT_12 * FontScaleUtils.fontSizeRatio,
                color: Colors.grey.shade400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 修改_imageInfo方法中的图片显示逻辑
  Widget _imageInfo(SubmitVM vm) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Constants.SPACE_10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: Constants.SPACE_8,
              mainAxisSpacing: Constants.SPACE_8,
            ),
            itemCount: vm.imgArr.length < Constants.MAX_IMG_COUNT
                ? vm.imgArr.length + 1
                : Constants.MAX_IMG_COUNT,
            itemBuilder: (context, index) {
              if (index == 0 && vm.imgArr.length < Constants.MAX_IMG_COUNT) {
                return _uploadBox(vm);
              } else {
                final imgIndex = vm.imgArr.length < Constants.MAX_IMG_COUNT
                    ? index - 1
                    : index;
                return _imageBox(vm.imgArr[imgIndex], imgIndex, vm);
              }
            },
          ),
          // 图片数量统计
          Padding(
            padding: const EdgeInsets.only(top: Constants.SPACE_8),
            child: Text(
              '${vm.imgArr.length}/${Constants.MAX_IMG_COUNT}',
              style: TextStyle(
                fontSize: Constants.FONT_12 * FontScaleUtils.fontSizeRatio,
                color: Colors.grey.shade400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _contactInfo(SubmitVM vm) {
    return Padding(
      padding: const EdgeInsets.all(Constants.SPACE_10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '联系方式（选填）',
            style: TextStyle(
              fontSize: Constants.FONT_14 * FontScaleUtils.fontSizeRatio,
              color: Colors.black,
            ),
          ),
          TextField(
            controller: _contactController,
            onChanged: vm.updateContactPhone,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              hintText: '请填写联系手机',
              hintStyle: TextStyle(
                color: Colors.grey.shade400,
                fontSize: Constants.FONT_13 * FontScaleUtils.fontSizeRatio,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.only(top: Constants.SPACE_8),
              suffixIcon: vm.contactPhone.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () {
                        _contactController.clear();
                        vm.updateContactPhone('');
                      },
                      iconSize: Constants.FONT_16 * FontScaleUtils.fontSizeRatio,
                    )
                  : null,
            ),
            style: TextStyle(
              fontSize: Constants.FONT_16 * FontScaleUtils.fontSizeRatio,
            ),
          ),
        ],
      ),
    );
  }

  Widget _btnInfo(SubmitVM vm) {
    return Padding(
      padding: const EdgeInsets.all(Constants.SPACE_10),
      child: ElevatedButton(
        onPressed: vm.loading ? null : () => vm.submit(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: Constants.BACKGROUND_COLOR,
          minimumSize: const Size(double.infinity, Constants.SPACE_48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Constants.SPACE_24),
          ),
        ),
        child: vm.loading
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: Constants.SPACE_2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                  const SizedBox(width: Constants.SPACE_8),
                  Text(
                    '正在提交反馈...',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: Constants.FONT_16 * FontScaleUtils.fontSizeRatio,
                    ),
                  ),
                ],
              )
            : Text(
                '提交反馈',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: Constants.FONT_16 * FontScaleUtils.fontSizeRatio,
                  fontWeight: FontWeight.w500,
                ),
              ),
      ),
    );
  }

  Widget _uploadBox(SubmitVM vm) {
    return GestureDetector(
      onTap: () => vm.selectPhoto(),
      child: Container(
        width: double.infinity,
        height: (MediaQuery.of(context).size.width -
                Constants.SPACE_10 * 2 -
                Constants.SPACE_16) /
            3,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Constants.SPACE_12),
          color: Constants.UPLOAD_COLOR,
        ),
        child: Center(
          child: Icon(
            Icons.add,
            color: Colors.grey,
            size: Constants.FONT_24 * FontScaleUtils.fontSizeRatio,
          ),
        ),
      ),
    );
  }

  Widget _imageBox(String path, int index, SubmitVM vm) {
    return GestureDetector(
      onTap: () {
        
      },
      child: AspectRatio(
        aspectRatio: 1,
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Constants.SPACE_8),
                image: DecorationImage(
                  image: FileImage(File(path)),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              top: Constants.SPACE_4,
              right: Constants.SPACE_4,
              child: GestureDetector(
                onTap: () {
                  vm.removeImage(index);
                },
                behavior: HitTestBehavior.opaque,
                child: Container(
                  width: Constants.SPACE_20,
                  height: Constants.SPACE_20,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Constants.SPACE_10),
                    color: Colors.black.withOpacity(0.5),
                  ),
                  child: Icon(
                    Icons.close,
                    color: Colors.white,
                    size: Constants.FONT_12 * FontScaleUtils.fontSizeRatio,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
