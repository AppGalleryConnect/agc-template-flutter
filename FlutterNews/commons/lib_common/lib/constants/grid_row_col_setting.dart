/// 断点名称
library;

enum BreakpointName {
  sm,
  md,
  lg,
  xl,
}

/// 断点取值
class BreakpointValue {
  static const String sm = '600';
  static const String md = '840';
  static const String lg = '1440';
}

/// 栅格通用设置
class GridRowColSetting {
  /// 栅格布局-断点数列
  static const List<String> breakPointValue = [
    '0',
    BreakpointValue.sm,
    BreakpointValue.md,
    BreakpointValue.lg,
  ];

  /// 栅格布局-列数
  static const Map<BreakpointName, int> gridRowOptionsColumns = {
    BreakpointName.sm: 4,
    BreakpointName.md: 8,
    BreakpointName.lg: 12,
    BreakpointName.xl: 12,
  };

  /// 栅格布局-x间距
  static const Map<BreakpointName, double> gridRowOptionsGutterX = {
    BreakpointName.sm: 8.0,
    BreakpointName.md: 12.0,
    BreakpointName.lg: 16.0,
    BreakpointName.xl: 20.0,
  };

  /// 栅格布局-margin
  static const Map<BreakpointName, double> gridRowOptionsMargin = {
    BreakpointName.sm: 16.0,
    BreakpointName.md: 24.0,
    BreakpointName.lg: 32.0,
    BreakpointName.xl: 32.0,
  };

  /// 栅格行布局容器-默认参数
  static GridRowOptions get defaultGridRowOptions => const GridRowOptions(
        gutter: GridRowGutter(
          x: gridRowOptionsGutterX,
        ),
        columns: gridRowOptionsColumns,
        breakpoints: GridRowBreakpoints(
          value: breakPointValue,
          reference: BreakpointsReference.windowSize,
        ),
        direction: GridRowDirection.row,
      );

  /// 弹窗最大宽度
  static const double dialogMaxWidth = 400.0;
}

/// 栅格行选项
class GridRowOptions {
  final GridRowGutter gutter;
  final Map<BreakpointName, int> columns;
  final GridRowBreakpoints breakpoints;
  final GridRowDirection direction;

  const GridRowOptions({
    required this.gutter,
    required this.columns,
    required this.breakpoints,
    required this.direction,
  });
}

/// 栅格间距
class GridRowGutter {
  final Map<BreakpointName, double> x;

  const GridRowGutter({
    required this.x,
  });
}

/// 栅格断点
class GridRowBreakpoints {
  final List<String> value;
  final BreakpointsReference reference;

  const GridRowBreakpoints({
    required this.value,
    required this.reference,
  });
}

/// 断点参考
enum BreakpointsReference {
  windowSize,
  componentSize,
}

/// 栅格方向
enum GridRowDirection {
  row,
  column,
}

