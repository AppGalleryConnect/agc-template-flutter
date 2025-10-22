import 'package:flutter/material.dart';

class SectionIndicator extends StatefulWidget {
  final String activeSection;
  final ValueChanged<String> onSectionChanged;

  const SectionIndicator({
    super.key,
    required this.activeSection,
    required this.onSectionChanged,
  });

  @override
  SectionIndicatorState createState() => SectionIndicatorState();
}

class SectionIndicatorState extends State<SectionIndicator> {
  @override
  Widget build(BuildContext context) {
    final sections = ['热门新闻', '科技新闻', '体育新闻', '娱乐新闻'];

    return ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: sections.length,
      separatorBuilder: (_, __) => const SizedBox(width: 15),
      itemBuilder: (context, index) {
        final isActive = sections[index] == widget.activeSection;

        return GestureDetector(
          onTap: () => widget.onSectionChanged(sections[index]),
          child: Container(
            // 添加垂直方向的padding，增加指示器和下边界的距离
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: isActive
                    ? const Border(
                        bottom: BorderSide(color: Colors.blue, width: 3),
                      )
                    : null,
              ),
              child: Text(
                sections[index],
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isActive ? Colors.blue : Colors.grey,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
