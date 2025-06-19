import 'package:flutter/material.dart';

class TabBarBasic extends StatelessWidget {
  final String tabTitle1;
  final String tabTitle2;
  final String tabTitle3;
  const TabBarBasic({super.key, required this.tabTitle1, required this.tabTitle2, required this.tabTitle3});

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
                Center(
                  child: Text(
                    'Tab 1 Content',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                Center(
                  child: Text(
                    'Tab 2 Content',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                Center(
                  child: Text(
                    'Tab 3 Content',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
