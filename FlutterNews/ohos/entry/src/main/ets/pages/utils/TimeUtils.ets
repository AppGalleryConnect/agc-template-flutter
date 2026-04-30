export class TimeUtils {
  /**
   * 时间戳转自定义格式时间
   * @param {number} timestamp - 时间戳（秒级/毫秒级）
   * @param {string} format - 目标格式，如 'YYYY-MM-DD HH:mm:ss'
   * @returns {string} 格式化后的时间
   */
  public static formatTimestamp(timestamp: number, format = 'YYYY-MM-DD HH:mm:ss') {

    const date = new Date(timestamp.toString().length === 10 ? timestamp * 1000 : timestamp);

    const padZero = (num: number) => num.toString().padStart(2, '0');

    const year = date.getFullYear().toString();
    const month = padZero(date.getMonth() + 1);
    const day = padZero(date.getDate());
    const hour = padZero(date.getHours());
    const minute = padZero(date.getMinutes());
    const second = padZero(date.getSeconds());

    return format
      .replace('YYYY', year)
      .replace('MM', month)
      .replace('DD', day)
      .replace('HH', hour)
      .replace('mm', minute)
      .replace('ss', second);
  }
}