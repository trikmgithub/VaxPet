import 'package:flutter/material.dart';

class TabBarBasic extends StatelessWidget {
  final String tabTitle1;
  final String tabTitle2;
  final String tabTitle3;

  // Thêm các tham số mới để truyền vào nội dung cho từng tab
  final Widget tabContent1;
  final Widget tabContent2;
  final Widget tabContent3;

  // Cập nhật constructor để yêu cầu các tham số nội dung mới
  const TabBarBasic({
    super.key,
    required this.tabTitle1,
    required this.tabTitle2,
    required this.tabTitle3,
    required this.tabContent1,
    required this.tabContent2,
    required this.tabContent3,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TabBar(
            tabs: [
              Tab(text: tabTitle1),
              Tab(text: tabTitle2),
              Tab(text: tabTitle3),
            ],
          ),
          SizedBox(
            height: 100,
            child: TabBarView(
              children: [
                // Sử dụng nội dung tùy chỉnh từ tham số thay vì text cố định
                Center(child: tabContent1),
                Center(child: tabContent2),
                Center(child: tabContent3),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
