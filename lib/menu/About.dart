import 'package:flutter/material.dart';

class AboutPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AboutState();
}

class _AboutState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            floating: false,
            pinned: true,
            snap: false,
            expandedHeight: 300.0,
            flexibleSpace: const FlexibleSpaceBar(
              title: Text('关于'),
              background: Text(
                '关于',
                style: TextStyle(fontSize: 150, color: Color(0x33000000)),
              ),
            ),
          ),
          SliverList(delegate: SliverChildListDelegate(<Widget>[
            Card(child: Text('test')),
          ])),
        ],
      ),
    );
  }
}
