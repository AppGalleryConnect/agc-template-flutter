import { http } from '@kit.NetworkKit';
import { fileUri, fileIo as fs } from '@kit.CoreFileKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { UtilLog } from '@hw-agconnect/util-log';
import { GlobalContext } from '@pura/harmony-utils';
import { application, common, contextConstant } from '@kit.AbilityKit';


const TAG = '[FileUtils]';

/**
 * 文件处理类
 */
export class FileUtils {
  /**
   * 下载图片
   * @param url
   * @returns
   */
  static downloadImage(url: string): Promise<ArrayBuffer> {
    return new Promise((resolve, reject) => {
      http.createHttp()
        .request(url, { method: http.RequestMethod.GET })
        .then((data: http.HttpResponse) => {
          if (http.ResponseCode.OK === data.responseCode) {
            const buffer: ArrayBuffer = data.result as ArrayBuffer;
            resolve(buffer);
          } else {
            UtilLog.error(TAG, `downloadImage fail, url: ${url}, responseCode: ${data.responseCode}`);
            reject();
          }
        })
        .catch((err: BusinessError) => {
          UtilLog.error(TAG, `downloadImage fail, url: ${url}, err: ${JSON.stringify(err)}`);
          reject();
        })
    })
  }

  /**
   * 写入buffer到沙箱地址
   * @param buffer
   * @returns
   */
  static saveBufferToSandbox(context: UIContext, buffer: ArrayBuffer): string {
    let file: fs.File | null = null;
    try {
      const savePath = `${context.getHostContext()?.cacheDir}/${new Date().getTime()}.png`;
      file = fs.openSync(savePath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
      fs.writeSync(file.fd, buffer);
      return fileUri.getUriFromPath(savePath);
    } catch (e) {
      return '';
    } finally {
      try {
        if (file) {
          fs.closeSync(file);
        }
      } catch (e) {
        UtilLog.error(TAG, 'fs.closeSync error: ' + JSON.stringify(e));
      }
    }
  }
  /**
   * 获取所有缓存路径
   * @param context
   * @returns
   */
  static async getPaths(context: Context): Promise<string[]> {
    let paths: string[] = [];
    try {
      let moduleContext: common.Context;
      moduleContext = await application.createModuleContext(context, 'entry');
      // 缓存路径 /data/storage/el2/base/cache
      UtilLog.info(TAG, `moduleContext + el2: ${moduleContext.cacheDir}`);
      // 缓存路径 /data/storage/el2/base/haps/entry/cache
      UtilLog.info(TAG, `UIAbilityContext + el2: ${context.cacheDir}`);
      paths.push(moduleContext.cacheDir);
      paths.push(context.cacheDir);

      // 缓存路径 /data/storage/el1/base/cache
      moduleContext.area = contextConstant.AreaMode.EL1;
      UtilLog.info(TAG, `moduleContext + el1: ${moduleContext.cacheDir}`);
      // 缓存路径 /data/storage/el1/base/haps/entry/cache
      context.area = contextConstant.AreaMode.EL1;
      UtilLog.info(TAG, `UIAbilityContext + el1: ${context.cacheDir}`);
      paths.push(moduleContext.cacheDir);
      paths.push(context.cacheDir);

      // 恢复默认的安全级别
      context.area = contextConstant.AreaMode.EL2;
      return paths;
    } catch (e) {
      UtilLog.error(TAG, `getPaths fail. Code: ${e.code}, message: ${e.message}`);
      return paths;
    }
  }
  /**
   * 删除某个缓存目录下的文件
   * @param cacheDir
   */
  static deleteFile(cacheDir: string) {
    fs.listFile(cacheDir).then((filenames) => {
      for (let i = 0; i < filenames.length; i++) {
        let dirPath = cacheDir + '/' + filenames[i];
        UtilLog.info(TAG, 'dir path:' + dirPath);
        let isDirectory: boolean = false;
        try {
          isDirectory = fs.statSync(dirPath).isDirectory();
        } catch (e) {
          UtilLog.error(TAG, 'statSync error:' + JSON.stringify(e));
        }

        if (isDirectory) {
          try {
            fs.rmdirSync(dirPath);
          } catch (e) {
            UtilLog.error(TAG, 'rmdirSync fail, error: ' + JSON.stringify(e));
          }
        } else {
          fs.unlink(dirPath).then(() => {
            UtilLog.info(TAG, 'remove file succeed');
          }).catch((err: Error) => {
            UtilLog.error(TAG, 'remove file failed with error message: ' + err.message);
          });
        }
      }
    }).catch((e: BusinessError) => {
      UtilLog.error(TAG, 'listFile fail, error: ' + JSON.stringify(e));
    })
  }
}