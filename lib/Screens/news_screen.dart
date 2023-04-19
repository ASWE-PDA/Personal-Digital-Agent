import "package:flutter/material.dart";
import "package:luna/UseCases/news/news_use_case.dart";
import "package:url_launcher/url_launcher.dart";


class MyNewsCardsWidget extends StatefulWidget {


  MyNewsCardsWidget();

  @override
  _MyNewsCardsWidgetState createState() => _MyNewsCardsWidgetState();
}

class _MyNewsCardsWidgetState extends State<MyNewsCardsWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My News"),
        actions: [],
      ),
      body: ListView.builder(
        itemCount: NewsUseCase.instance.cardArticles.length > 5 ? 5 : NewsUseCase.instance.cardArticles.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            elevation: 4.0,
            margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: InkWell(
              onTap: () => _launchInBrowser(Uri.parse(NewsUseCase.instance.cardArticles[index].link)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      NewsUseCase.instance.cardArticles[index].title,
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ),
                  Divider(
                    color: Colors.grey[500],
                    height: 1.0,
                    thickness: 1.0,
                    indent: 16.0,
                    endIndent: 16.0,
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 16.0),
                    child: Text(
                      NewsUseCase.instance.cardArticles[index].summary,
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }


  Future<void> _launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception("Could not launch $url");
    }
  }
}