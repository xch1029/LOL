![](http://qiniu.tbmao.com/lollolapp.jpg)

要说我最喜欢的游戏，那必须是英雄联盟。太多太多的回忆！今天我们一起使用`Flutter`来开发一款英雄资料卡。上图是APP的部分截图，APP的整体设计看上去还是很清爽的。首页使用Tab展示英雄的六大分类，点击英雄的条目会跳转到英雄的详情页面。

### 目录结构
```
- lib
    - models
    - utils
    - views
    - widgets
    - main.dart
```
我们先从项目的目录结构讲起吧，对APP来个整体上的把握。本APP我们采用的目录结构是很常见的，不仅仅是Flutter开发，现在的前端开发模式也基本相似:
- `models`来定义数据模型
- `utils`里放一些公用的函数、接口、路由、常量等
- `views`里放的是页面级别的组件
- `widgets`里放的是页面中需要使用的小组件
- `main.dart` 是APP的启动文件 

### 开始之处
APP必定从`main.dart`开始，一些模板化的代码就不提了，有一点需要注意的是，APP状态栏的背景是透明的，这个配置在`main()`函数中：
``` dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
  if (Platform.isAndroid) {
    SystemUiOverlayStyle systemUiOverlayStyle =
        SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
}
```

### 首页
APP进入首页后开始拉取后端接口的数据，进而展示英雄列表。`TabBar`组件来定义页面上部的Tab切换，`TabBarView`来展示页面下部的列表。本来打算使用拳头开放的接口数据，但是没有提供中文翻译。就去腾讯找了下，腾讯更加封闭，居然没有开发者接口。无赖之举，自己用node写了个接口来提供实时的英雄数据，数据100%来自官网哦。另外本人服务器配置不是很高也不稳定，所以接口只供学习使用哦
``` dart
import 'package:flutter/material.dart';
import 'package:lol/views/homeList.dart';
import 'package:lol/utils/api.dart' as api;
import 'package:lol/utils/constant.dart';
import 'package:lol/utils/utils.dart';

class HomeView extends StatefulWidget {
  HomeView({Key key}) : super(key: key);

  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with SingleTickerProviderStateMixin {
  TabController _tabController;
  List<dynamic> heroList = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, initialIndex: 0, length: 6);
    init();
  }

  init() async {
    Map res = await api.getHeroList();
    setState(() {
     heroList = res.values.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TabBar(
          controller: _tabController,
          tabs: <Widget>[
            Tab(text: '战士'),
            Tab(text: '坦克'),
            Tab(text: '法师'),
            Tab(text: '刺客'),
            Tab(text: '辅助'),
            Tab(text: '射手'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          HomeList(data: Utils.filterHeroByTag(heroList, Tags.Fighter)),
          HomeList(data: Utils.filterHeroByTag(heroList, Tags.Tank)),
          HomeList(data: Utils.filterHeroByTag(heroList, Tags.Mage)),
          HomeList(data: Utils.filterHeroByTag(heroList, Tags.Assassin)),
          HomeList(data: Utils.filterHeroByTag(heroList, Tags.Support)),
          HomeList(data: Utils.filterHeroByTag(heroList, Tags.Marksman)),
        ],
      ),
    );
  }
}
```

### 首页列表
首页的六个列表都是一样的，只是数据不同，所以公用一个组件`homeList.dart`即可，切换`Tab`的时候为了不销毁之前的页面需要让组件继承`AutomaticKeepAliveClientMixin`类：
``` dart
import 'package:flutter/material.dart';
import 'package:lol/widgets/home/heroItem.dart';
import 'package:lol/models/heroSimple.dart';

class HomeList extends StatefulWidget {
  final List data;
  HomeList({Key key, this.data}) : super(key: key);

  _HomeListState createState() => _HomeListState();
}

class _HomeListState extends State<HomeList>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: ListView.builder(
        itemCount: widget.data.length,
        itemBuilder: (BuildContext context, int index) {
          return HeroItem(data: HeroSimple.fromJson(widget.data[index]));
        },
      ),
    );
  }
}
```
### 英雄详情
点击英雄条目，路由跳转到详情页面`heroDetail.dart`，这个页面中包含了很多小组件，其中的皮肤预览功能使用的是第三方的图片查看库`extended_image`,这个库很强大，而且还是位中国开发者，必须支持。
``` dart
import 'package:flutter/material.dart';
import 'package:lol/utils/api.dart' as api;
import 'package:lol/models/heroSimple.dart';
import 'package:lol/models/heroDetail.dart';
import 'package:lol/utils/utils.dart';
import 'package:lol/widgets/detail/detailItem.dart';
import 'package:lol/widgets/detail/skin.dart';
import 'package:lol/widgets/detail/info.dart';

class HeroDetail extends StatefulWidget {
  final HeroSimple heroSimple;
  HeroDetail({Key key, this.heroSimple}) : super(key: key);

  _HeroDetailState createState() => _HeroDetailState();
}

class _HeroDetailState extends State<HeroDetail> {
  HeroDetailModel _heroData; // hero数据
  bool _loading = false; // 加载状态
  String _version = ''; // 国服版本
  String _updated = ''; // 文档更新时间

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    setState(() {
      _loading = true;
    });
    Map res = await api.getHeroDetail(widget.heroSimple.id);
    var data = res['data'];
    String version = res['version'];
    String updated = res['updated'];
    print(version);
    setState(() {
      _heroData = HeroDetailModel.fromJson(data);
      _version = version;
      _updated = updated;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.heroSimple.name), elevation: 0),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  DetailItem(
                    title: '皮肤',
                    child: Skins(imgList: _heroData.skins),
                  ),
                  DetailItem(
                    title: '类型',
                    child: Row(
                        children: _heroData.tags
                            .map((tag) => Container(
                                  margin: EdgeInsets.only(right: 10),
                                  child: CircleAvatar(
                                    child: Text(
                                      Utils.heroTagsMap(tag),
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ))
                            .toList()),
                  ),
                  DetailItem(
                    title: '属性',
                    child: HeroInfo(data: _heroData.info),
                  ),
                  DetailItem(
                    title: '使用技巧',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: _heroData.allytips
                          .map((tip) => Column(
                                children: <Widget>[
                                  Text(tip),
                                  SizedBox(height: 5)
                                ],
                              ))
                          .toList(),
                    ),
                  ),
                  DetailItem(
                    title: '对抗技巧',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: _heroData.enemytips
                          .map((tip) => Column(
                                children: <Widget>[
                                  Text(tip),
                                  SizedBox(height: 5)
                                ],
                              ))
                          .toList(),
                    ),
                  ),
                  DetailItem(
                    title: '背景故事',
                    child: Text(_heroData.lore),
                  ),
                  DetailItem(
                    title: '国服版本',
                    child: Text(_version),
                  ),
                  DetailItem(
                    title: '更新时间',
                    child: Text(_updated),
                  )
                ],
              ),
            ),
    );
  }
}
```

### 打包APK
打包APK通常需要三个步骤：
Step1: 生成签名
Step2: 对项目进行签名配置
Step3: 打包

#### Step1: 生成签名
在打包APK之前需要生成一个签名文件，签名文件是APP的唯一标识：
```
keytool -genkey -v -keystore c:/Users/15897/Desktop/key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias key
```
- `c:/Users/15897/Desktop/key.jks`表示文件的生成位置，我直接设置的桌面
- `-validity 10000`设置的签名的有效时间
- `-alias key`为签名文件起个别名，我直接设置成key

执行这条命令行后，会有一个交互式的问答：
```
输入密钥库口令:
再次输入新口令:
您的名字与姓氏是什么?
  [Unknown]:  hua
您的组织单位名称是什么?
  [Unknown]:  xxx
您的组织名称是什么?
  [Unknown]:  xxx
您所在的城市或区域名称是什么?
  [Unknown]:  xxx
您所在的省/市/自治区名称是什么?
  [Unknown]:  xxx
该单位的双字母国家/地区代码是什么?
  [Unknown]:  xxx
CN=hua, OU=xxx, O=xxx, L=xxx, ST=xxx, C=xxx是否正确?
  [否]:  y

正在为以下对象生成 2,048 位RSA密钥对和自签名证书 (SHA256withRSA) (有效期为 10,000 天):
         CN=hua, OU=xxx, O=xxx, L=xxx, ST=xxx, C=xxx
输入 <key> 的密钥口令
        (如果和密钥库口令相同, 按回车):
[正在存储c:/Users/15897/Desktop/key.jks]
```
#### Step2: 对项目进行签名配置
在项目中新建文件`<app dir>/android/key.properties`,文件中定义了四个变量，留着给`<app dir>/android/app/build.gradle`调用。

前三个都是上一步用到的几个字段，第四个`storeFile`是签名文件的位置，文件位置是相对于`<app dir>/android/app/build.gradle`来说，所以需要将上一步生成了的`key.jks`复制到`<app dir>/android/app/`下。

警告：文件涉及到密码啥的，所以最好不要上传到版本管理。
```
#  Note: Keep the key.properties file private; do not check it into public source control.
storePassword=123456
keyPassword=123456
keyAlias=key
storeFile=key.jks
```
再修改`<app dir>/android/app/build.gradle`（`这里才是正在的配置`）：
```
def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}

android {

```

```
signingConfigs {
    release {
        keyAlias keystoreProperties['keyAlias']
        keyPassword keystoreProperties['keyPassword']
        storeFile file(keystoreProperties['storeFile'])
        storePassword keystoreProperties['storePassword']
    }
}
buildTypes {
    release {
        signingConfig signingConfigs.release
    }
}
```

#### Step3: 打包
执行打包命令：
```
flutter build apk
```
```
You are building a fat APK that includes binaries for android-arm, android-arm64.
If you are deploying the app to the Play Store, it's recommended to use app bundles or split the APK to reduce the APK size.
    To generate an app bundle, run:
        flutter build appbundle --target-platform android-arm,android-arm64
        Learn more on: https://developer.android.com/guide/app-bundle
    To split the APKs per ABI, run:
        flutter build apk --target-platform android-arm,android-arm64 --split-per-abi
        Learn more on:  https://developer.android.com/studio/build/configure-apk-splits#configure-abi-split
Initializing gradle...                                              3.6s
Resolving dependencies...                                          26.8s
Calling mockable JAR artifact transform to create file: C:\Users\15897\.gradle\caches\transforms-1\files-1.1\android.jar\e122fbb402658e4e43e8b85a067823c3\android.jar with input C:\Users\15897\AppData\Local\Android\Sdk\platforms\android-28\android.jar
Running Gradle task 'assembleRelease'...
Running Gradle task 'assembleRelease'... Done                      84.7s
Built build\app\outputs\apk\release\app-release.apk (11.2MB).
```
打包完成后，apk文件就在这里`build\app\outputs\apk\release\app-release.apk`

#### 打包方面相关链接
- [Flutter官网APK打包教程](https://flutter.dev/docs/deployment/android)
- [本项目打包配置代码`对比`](https://github.com/xch1029/LOL/commit/d2094e2f4182da22f9b3f767295b134fee578bf2)
- [本项目APK下载](http://qiniu.tbmao.com/blogapp-release.apk)



### 更多链接
- [源码](https://github.com/xch1029/LOL)
- [博客](http://jser.tech/2019/07/28/lol)
- [掘金](https://juejin.im/post/5d3d733c6fb9a07ecf726d3a)
