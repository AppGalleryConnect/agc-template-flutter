
import 'package:flutter/material.dart';
import '../model/share_model.dart';
import 'package:module_share/constants/constants.dart';

class PopViewUtils {
  static BuildContext? _context;

  static void setContext(BuildContext context) => _context = context;

  static void showSheet({
    required WidgetBuilder contentBuilder,
    required SheetOptions options,
  }) {
    if (_context == null) return;

    showModalBottomSheet(
      context: _context!,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(Constants.SPACE_16)),
      ),
      isScrollControlled: false,
      backgroundColor: options.backgroundColor,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min, 
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Constants.SPACE_16, vertical: Constants.SPACE_12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "分享到",
                  style: TextStyle(
                    fontSize: Constants.FONT_10,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                if (options.showClose)
                  IconButton(
                    icon: const Icon(Icons.close,
                        size: Constants.SPACE_20, color: Colors.black87),
                    onPressed: () => Navigator.pop(context), 
                    padding: EdgeInsets.zero, 
                    iconSize: Constants.SPACE_20,
                  ),
              ],
            ),
          ),
          contentBuilder(context),
        ],
      ),
    );
  }
}
