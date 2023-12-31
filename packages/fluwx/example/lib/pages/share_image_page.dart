import 'package:flutter/material.dart';
import 'package:fluwx/fluwx.dart';

class ShareImagePage extends StatefulWidget {
  const ShareImagePage({Key? key}) : super(key: key);

  @override
  State<ShareImagePage> createState() => _ShareImagePageState();
}

class _ShareImagePageState extends State<ShareImagePage> {
  WeChatScene scene = WeChatScene.session;
  String _response = '';

  WeChatImage? source;
  WeChatImage? thumbnail;
  Fluwx fluwx = Fluwx();

  @override
  void initState() {
    super.initState();
    fluwx.subscribeResponse((res) {
      if (res is WeChatShareResponse) {
        setState(() {
          _response = 'state :${res.isSuccessful}';
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('shareImage'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.share, color: Colors.white),
            onPressed: _shareImage,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            TextField(
              decoration: const InputDecoration(labelText: '图片地址(仅限网络)'),
              controller: TextEditingController(
                text: 'https://timgsa.baidu.com/timg'
                    '?image'
                    '&quality=80'
                    '&size=b9999_10000'
                    '&sec=1534614311230'
                    '&di=b17a892b366b5d002f52abcce7c4eea0'
                    '&imgtype=0'
                    '&src=http%3A%2F%2Fimg.mp.sohu.com%2Fupload%2F20170516%2F51296b2673704ae2992d0a28c244274c_th.png',
              ),
              onChanged: (value) {
                source = WeChatImage.network(value);
              },
              keyboardType: TextInputType.multiline,
            ),
            TextField(
              decoration: InputDecoration(labelText: '缩略地址'),
              controller: TextEditingController(text: '//images/logo.png'),
              onChanged: (value) {
                thumbnail = WeChatImage.asset(value);
              },
            ),
            Row(
              children: <Widget>[
                const Text('分享至'),
                Row(
                  children: <Widget>[
                    Radio<WeChatScene>(
                      value: WeChatScene.session,
                      groupValue: scene,
                      onChanged: (v) {
                        if (v != null) handleRadioValueChanged(v);
                      },
                    ),
                    const Text('会话')
                  ],
                ),
                Row(
                  children: <Widget>[
                    Radio<WeChatScene>(
                      value: WeChatScene.timeline,
                      groupValue: scene,
                      onChanged: (v) {
                        if (v != null) handleRadioValueChanged(v);
                      },
                    ),
                    const Text('朋友圈')
                  ],
                ),
                Row(
                  children: <Widget>[
                    Radio<WeChatScene>(
                      value: WeChatScene.favorite,
                      groupValue: scene,
                      onChanged: (v) {
                        if (v != null) handleRadioValueChanged(v);
                      },
                    ),
                    const Text('收藏')
                  ],
                )
              ],
            ),
            Text(_response)
          ],
        ),
      ),
    );
  }

  void _shareImage() {
    fluwx.share(WeChatShareImageModel(source!, thumbnail: thumbnail));
  }

  void handleRadioValueChanged(WeChatScene scene) {
    setState(() {
      this.scene = scene;
    });
  }
}
