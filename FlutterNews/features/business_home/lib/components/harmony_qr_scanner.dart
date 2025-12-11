import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:scan/scan.dart';
import 'package:permission_handler/permission_handler.dart';
import '../commons/constants.dart';

class HarmonyQrScanner extends StatefulWidget {
  const HarmonyQrScanner({super.key});

  @override
  State<HarmonyQrScanner> createState() => _HarmonyQrScannerState();
}

class _HarmonyQrScannerState extends State<HarmonyQrScanner>
    with WidgetsBindingObserver {
  String qrcode = 'Unknown';
  ScanController? controller;
  bool isCameraReady = false;
  bool isPermissionDenied = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      requestCamera();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    if (controller != null) {
      // controller?.resume();
      controller = null;
    }

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      setState(() {
        controller = ScanController();
        isCameraReady = true;
        isPermissionDenied = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final topPadding = mediaQuery.padding.top;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: null,
      body: Listener(
        onPointerDown: (event) {
          if (event.position.dx < Constants.cameraBackButtonWidth &&
              event.position.dy <
                  topPadding + Constants.cameraBackButtonHeight) {
            Navigator.pop(context);
          }
        },
        child: Stack(
          children: [
            Positioned.fill(
              child: _buildCameraView(),
            ),
            Positioned(
              top: topPadding + Constants.spacingM,
              left: Constants.spacingM,
              child: Container(
                width: Constants.cameraBackButtonWidth,
                height: Constants.cameraBackButtonHeight,
                alignment: Alignment.center,
                child: Container(
                  width: Constants.cameraInnerButtonWidth,
                  height: Constants.cameraInnerButtonHeight,
                  decoration: BoxDecoration(
                    color: Constants.cameraOverlayColor,
                    borderRadius: BorderRadius.circular(
                      Constants.borderRadiusCircle,
                    ),
                  ),
                  child: Container(
                    width: Constants.cameraIconButtonWidth,
                    height: Constants.cameraIconButtonHeight,
                    decoration: BoxDecoration(
                      color: Constants.whiteTransparentColor,
                      borderRadius: BorderRadius.circular(
                        Constants.borderRadiusButton,
                      ),
                      border: Border.all(
                        color: Constants.blackTransparentColor,
                        width: Constants.borderWidthThin,
                      ),
                    ),
                    child: IconButton(
                      padding: Constants.iconButtonPadding,
                      icon: SvgPicture.asset(
                        Constants.iconBackPath,
                        width: Constants.backButtonWidth,
                        height: Constants.backButtonHeight,
                        colorFilter: const ColorFilter.mode(
                          Constants.whiteColor,
                          BlendMode.srcIn,
                        ),
                        fit: BoxFit.contain,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
              ),
            ),

            // 3. 标题（保持不变）
            Positioned(
              top:
                  topPadding + Constants.spacingXl * 2 + Constants.spacingM * 2,
              left: Constants.spacingM,
              right: Constants.spacingM,
              child: const Text(
                "扫描二维码/条形码",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: Constants.fontSizeLarge,
                  color: Constants.whiteColor,
                  fontWeight: FontWeight.bold,
                  height: Constants.textLineHeight,
                ),
              ),
            ),

            // 4. 底部相册按钮（保持不变）
            Positioned(
              bottom: Constants.spacingXl,
              left: 0,
              right: 0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: Constants.cameraPadding,
                    child: Column(
                      children: [
                        SvgPicture.asset(
                          Constants.galleryIconPath,
                          width: Constants.galleryIconSize,
                          height: Constants.galleryIconSize,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(height: Constants.spacingS),
                        const Text(
                          "图库",
                          style: TextStyle(
                            fontSize: Constants.fontSizeSmall,
                            color: Constants.whiteColor,
                            fontWeight: FontWeight.bold,
                            height: Constants.textLineHeight,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),

            // 5. 权限提示（保持不变）
            if (isPermissionDenied)
              Positioned.fill(
                child: Container(
                  color: Constants.blackHalfTransparentColor,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "请授予相机权限以使用扫描功能",
                        style: TextStyle(
                            color: Constants.whiteColor,
                            fontSize: Constants.fontSizeMedium),
                      ),
                      const SizedBox(height: Constants.spacingL),
                      ElevatedButton(
                        onPressed: () => openAppSettings(),
                        child: const Text("去设置"),
                      )
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCameraView() {
    if (!isCameraReady) {
      return Container(
        color: Colors.black,
        child: const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(Constants.greenColor),
          ),
        ),
      );
    }

    return ScanView(
      controller: controller!,
      scanAreaScale: Constants.scanAreaScale,
      scanLineColor: Constants.greenColor,
      onCapture: (data) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Scaffold(
              appBar: AppBar(title: const Text('扫描结果')),
              body: Center(child: Text(data)),
            ),
          ),
        ).then((_) {
          controller?.resume();
        });
      },
    );
  }

  Future<void> requestCamera() async {
    final status = await Permission.camera.status;
    if (status.isGranted) {
      _initScanner();
      return;
    }

    final result = await Permission.camera.request();
    if (result.isGranted) {
      _initScanner();
    } else {
      setState(() => isPermissionDenied = true);
    }
  }

  void _initScanner() {
    if (mounted) {
      setState(() {
        controller = ScanController();
        isCameraReady = true;
        isPermissionDenied = false;
      });
    }
  }
}
