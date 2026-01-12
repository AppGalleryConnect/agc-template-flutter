// 鸿蒙原生代码（ArkTS）
@Entry
@Component
struct MyUIAbility {
  build() {
    // Center() {
    //   Button("扫码") {
    //     onClick(() => {
    //       // 扫码
    //       scanBarcode.startScanForResult(getContext(this)).then((result: scanBarcode.ScanResult) => {
    //         // 扫码成功
    //         console.log("扫码成功：" + result.text);
    //       }).catch((error: scanBarcode.ScanError) => {
    //         // 扫码失败
    //         console.log()
    //       })
    //     })
    //   }
    // }
    // 定义扫码参数options
    let options: scanBarcode.ScanOptions = {
      scanTypes: [scanCore.ScanType.ALL],
      enableMultiMode: true,
      enableAlbum: true,
    };
    try {
      // 可调用getContext接口获取当前页面关联的UIAbilityContext
      scanBarcode.startScanForResult(getContext(this), options).then((result: scanBarcode.ScanResult) => {
        // 解析码值结果跳转应用服务页
        let resultParams: Record<string, string | NewsEnum> = JSON.parse(result.originalValue)
        if (!resultParams?.articleId) {
          promptAction.showToast({ message: '扫码错误，仅支持模板内文章海报生成的二维码' })
          return
        }
        // let routerParams = {
        //   'id': resultParams?.articleId,
        // } as Record<string, string>
        // RouterToNews.routerToNewsById(routerParams.id)
      }).catch((error: BusinessError) => {
        let message: string = ''
        if (error.code === 1000500002) {
          // 用户取消扫码
          message = '取消扫码'
        } else {
          message = '扫码错误'
        }
        promptAction.showToast({ message: message })
        Logger.error(NewsScan.TAG, '[Scan CPSample]',
          `Failed to get ScanResult by promise with options. Code:${error.code}, message: ${error.message}`);
      });
    } catch (error) {
      promptAction.showToast({ message: '扫码错误' })
      Logger.error(NewsScan.TAG, '[Scan CPSample]',
        `Failed to start the scanning service. Code:${error.code}, message: ${error.message}`);
    }
  }
}