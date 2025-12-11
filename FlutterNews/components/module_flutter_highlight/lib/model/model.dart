class Chunk {
  /// 起始位置
  final int start;

  /// 结束位置
  late final int end;

  /// 是否高亮
  final bool highlight;

  Chunk({
    required this.start,
    required this.end,
    this.highlight = false,
  })  : assert(start >= 0, '起始位置不能为负数'),
        assert(end >= start, '结束位置不能小于起始位置');

  factory Chunk.fromMap(Map<String, dynamic> map) {
    return Chunk(
      start: map['start'] as int? ?? 0,
      end: map['end'] as int? ?? 0,
      highlight: map['highlight'] as bool? ?? false,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Chunk &&
              runtimeType == other.runtimeType &&
              start == other.start &&
              end == other.end &&
              highlight == other.highlight;

  @override
  int get hashCode => start.hashCode ^ end.hashCode ^ highlight.hashCode;

  @override
  String toString() {
    return 'Chunk(start: $start, end: $end, highlight: $highlight)';
  }
}

typedef Chunks = List<Chunk>;