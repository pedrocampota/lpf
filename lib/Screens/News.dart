//Libraries
import 'package:flutter/material.dart';
import 'package:webfeed/webfeed.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:iconsax/iconsax.dart';

class News extends StatefulWidget {
  News() : super();

  final String title = 'A acontecer agora';

  @override
  NewsState createState() => NewsState();
}

class NewsState extends State<News> {
  static const String FEED_URL = 'https://www.record.pt/rss';
  RssFeed? _feed;
  String? _title;
  static const String loadingFeedMsg = 'A carregar feed...';
  static const String feedLoadErrorMsg = 'Erro ao carregar o Feed.';
  static const String feedOpenErrorMsg = 'Erro ao abrir o Feed.';
  static const String placeholderImg =
      'media/images/background_placeholder.png';
  GlobalKey<RefreshIndicatorState>? _refreshKey;

  updateTitle(title) {
    setState(() {
      _title = title;
    });
  }

  updateFeed(feed) {
    setState(() {
      _feed = feed;
    });
  }

  Future<void> openFeed(url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: true,
        forceWebView: false,
      );
      return;
    }
    updateTitle(feedOpenErrorMsg);
  }

  load() async {
    updateTitle(loadingFeedMsg);
    loadFeed().then((result) {
      if (null == result || result.toString().isEmpty) {
        updateTitle(feedLoadErrorMsg);
        return;
      }
      updateFeed(result);
      updateTitle(_feed?.title);
    });
  }

  Future<RssFeed?> loadFeed() async {
    try {
      final client = http.Client();
      final response = await client.get(Uri.parse(FEED_URL));
      return RssFeed.parse(response.body);
    } catch (e) {
      //
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    _refreshKey = GlobalKey<RefreshIndicatorState>();
    updateTitle(widget.title);
    load();
  }

  title(title) {
    return Text(
      title,
      style: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.w500,
          color: Color.fromARGB(255, 6, 82, 187)),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  subtitle(subTitle) {
    return Text(
      subTitle,
      style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.w100),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  thumbnail(imageUrl) {
    return Padding(
      padding: EdgeInsets.only(left: 0, right: 0),
      child: CachedNetworkImage(
        placeholder: (context, url) => Image.asset(placeholderImg),
        imageUrl: imageUrl,
        height: 500,
        width: 500,
        alignment: Alignment.center,
        fit: BoxFit.cover,
      ),
    );
  }

  list() {
    return ListView.builder(
      itemCount: _feed?.items?.length,
      itemBuilder: (BuildContext context, int index) {
        final item = _feed?.items?[index];
        var originalDate = item?.pubDate;
        var originalDateString = DateTime.parse(originalDate.toString());
        final formattedDate =
            DateFormat('dd/MM/yyyy').format(originalDateString);

        var originalImageUrl = item?.enclosure?.url;
        var originalImageUrlString = originalImageUrl.toString();
        final imageUrl = originalImageUrlString.replaceAll(
            'https://cdn.record.pt/images/https://cdn.record.pt/images/',
            'https://cdn.record.pt/images/');

        var pubTitle = item?.title;
        final pubTitleToShow = pubTitle.toString().length > 30
            ? pubTitle.toString().substring(0, 30) + '...'
            : pubTitle.toString();
        return GestureDetector(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Card(
                shadowColor: Colors.grey.shade100,
                elevation: 1,
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Container(
                  height: 200,
                  alignment: Alignment.bottomLeft,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        colorFilter: ColorFilter.mode(
                            Colors.black.withOpacity(0.2), BlendMode.srcOver),
                        image: new NetworkImage(imageUrl),
                        fit: BoxFit.cover),
                  ),
                  padding: EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pubTitleToShow,
                        style: TextStyle(
                          color: Color(0xFFFFFFFF),
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 2,
                      ),
                      Text(formattedDate,
                          style: TextStyle(
                              color: Color(0xFFFFFFFF),
                              fontSize: 12,
                              fontWeight: FontWeight.w300))
                    ],
                  ),
                ),
              ),
            ),
            onTap: () => openFeed(item?.link));
      },
    );
  }

  isFeedEmpty() {
    return null == _feed || null == _feed?.items;
  }

  body() {
    return isFeedEmpty()
        ? Center(
            child: CircularProgressIndicator(),
          )
        : RefreshIndicator(
            key: _refreshKey,
            child: list(),
            onRefresh: () => load(),
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 2, 19, 84),
        title: Text(
          'A acontecer agora',
          style: TextStyle(fontWeight: FontWeight.w300, fontSize: 16),
        ),
        leading: IconButton(
            icon: const Icon(Iconsax.backward),
            color: Colors.white,
            onPressed: () {
              Navigator.pop(context);
            }),
        actions: [
          IconButton(
            icon: const Icon(Iconsax.global),
            color: Colors.white,
            onPressed: () async {
              const url = "https://www.record.pt/";
              if (await canLaunchUrl(Uri.parse(url))) {
                await launchUrl(Uri.parse(url));
              }
            },
          )
        ],
      ),
      body: body(),
    );
  }
}
