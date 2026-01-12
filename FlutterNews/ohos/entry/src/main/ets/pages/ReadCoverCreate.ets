import { image } from '@kit.ImageKit';
import fs from '@ohos.file.fs';
import axios, { AxiosError, AxiosResponse } from '@ohos/axios'
import { common } from '@kit.AbilityKit';

export class ReadUtils {
  static async readCoverCreate(cover: string, context: Context,
    uiContext: common.UIAbilityContext): Promise<PixelMap | undefined> {
    return new Promise((resolve) => {
      const handler = cover.split('/')
      const imageName = handler[handler.length-1]
      let filePath = context.cacheDir + '/' + imageName
      try {
        fs.accessSync(filePath);
        fs.unlinkSync(filePath);
      } catch (err) {
        console.error('error:' + JSON.stringify(err));
      }
      axios({
        url: cover,
        method: 'get',
        filePath: filePath,
      }).then((res: AxiosResponse<string>) => {
        let pixelMap = ReadUtils.transcodePixelMap(context, imageName, uiContext)
        resolve(pixelMap)
        console.info('result: ' + JSON.stringify(res.data));
      }).catch((error: AxiosError) => {
        let pixelMap = ReadUtils.transcodePixelMap(context, imageName, uiContext)
        resolve(pixelMap)
        console.error('error:' + JSON.stringify(error));
      })
    })

  }

  static transcodePixelMap(context: Context, imageName: string,
    uiContext: common.UIAbilityContext): PixelMap | undefined {
    let filePath = uiContext.cacheDir + '/' + imageName
    let imageSource = image.createImageSource(filePath);
    let decodingOptions: image.DecodingOptions = {
      sampleSize: 1,
      desiredSize: { width: 400, height: 400 },
      desiredPixelFormat: image.PixelMapFormat.RGBA_8888,
      index: 0,
    };
    let pixelmap = imageSource.createPixelMapSync(decodingOptions);
    return pixelmap
  }
}