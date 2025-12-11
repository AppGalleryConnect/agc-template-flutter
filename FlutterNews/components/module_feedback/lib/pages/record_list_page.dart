import '../common/constants.dart';
import '../viewmodels/record_list_VM.dart';
import '../components/record_card.dart';
import '../components/empty.dart';
import '../components/nav_header_bar.dart';
import 'package:module_setfontsize/utils/font_scale_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Widget recordListPageBuilder() {
  return ChangeNotifierProvider(
    create: (context) => RecordListVM(),
    child: const RecordListPage(),
  );
}

class RecordListPage extends StatefulWidget {
  const RecordListPage({super.key});

  @override
  State<RecordListPage> createState() => _RecordListPageState();
}

class _RecordListPageState extends State<RecordListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Consumer<RecordListVM>(
        builder: (context, viewModel, child) {
          return SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Column(
              children: [
                const NavHeaderBar(
                  title: '反馈记录',
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(
                      left: Constants.SPACE_10,
                      right: Constants.SPACE_10,
                      top: Constants.SPACE_16,
                      bottom:Constants.SPACE_28,
                    ),
                    scrollDirection: Axis.vertical,
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: viewModel.loading
                        ? Container(
                            height: MediaQuery.of(context).size.height * 0.8,
                            alignment: Alignment.center,
                            child: const CircularProgressIndicator(),
                          )
                        : viewModel.list.isNotEmpty
                            ? Column(
                                children: [
                                  for (var index = 0;
                                      index < viewModel.list.length;
                                      index++)
                                    Column(
                                      children: [
                                        if (index > 0)
                                          const SizedBox(
                                              height: Constants.SPACE_12), 
                                        RecordCard(
                                          record: viewModel.list[index],
                                          fontSizeRatio:
                                              FontScaleUtils.fontSizeRatio,
                                        ),
                                      ],
                                    ),
                                ],
                              )
                            : Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.8,
                                alignment: Alignment.center,
                                child: Empty(
                                  fontSizeRatio: FontScaleUtils.fontSizeRatio,
                                ),
                              ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
