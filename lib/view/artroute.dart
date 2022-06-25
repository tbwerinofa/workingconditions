import 'package:flutter/material.dart';
import 'artutil.dart';

class ArtRoute extends StatelessWidget {
  final String art;
  ArtRoute({@required this.art});
  static int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
                child: Text(
                  'Choose your art',
                  style: TextStyle(fontSize: 24, color: Colors.white),
                ),
                decoration: BoxDecoration(
                    color: Colors.yellow,
                    image: DecorationImage(
                        image: NetworkImage(
                            'https://cdn.pixabay.com/photo/2016/11/29/05/45/astronomy-1867616_1280.jpg'),
                        fit: BoxFit.fill))),
            ListTile(
              title: Text(ArtUtil.CARAVAGIO),
              trailing: Icon(Icons.art_track),
              onTap: () => changeRoute(context, ArtUtil.CARAVAGIO),
            ),
            ListTile(
              title: Text(ArtUtil.MONET),
              trailing: Icon(Icons.art_track),
              onTap: () => changeRoute(context, ArtUtil.MONET),
            ),
            ListTile(
              title: Text(ArtUtil.VANGOGH),
              trailing: Icon(Icons.art_track),
              onTap: () => changeRoute(context, ArtUtil.VANGOGH),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text('Navigating art'),
        actions: <Widget>[
          PopupMenuButton(
            icon: Icon(Icons.image),
            itemBuilder: (BuildContext context) {
              return ArtUtil.menuItems.map((String item) {
                return PopupMenuItem<String>(child: Text(item), value: item);
              }).toList();
            },
            onSelected: (value) => changeRoute(context, value),
          )
        ],
      ),
      body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage(art), fit: BoxFit.cover))),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.lime[900],
        currentIndex: _currentIndex,
        items: [
          //BottomNavigationBarItem(
         //     title: Text(ArtUtil.CARAVAGIO), icon: Icon(Icons.art_track)),
         // BottomNavigationBarItem(
         //     title: Text(ArtUtil.MONET), icon: Icon(Icons.art_track)),
         // BottomNavigationBarItem(
        //      title: Text(ArtUtil.VANGOGH), icon: Icon(Icons.art_track)),
        ],
        onTap: (value) {
          String _artist = ArtUtil.menuItems[value];
          _currentIndex = value;
          changeRoute(context, _artist);
        },
      ),
    );
  }

  void changeRoute(BuildContext context, String menuItem) {
    String image;

    switch (menuItem) {
      case ArtUtil.CARAVAGIO:
        image = ArtUtil.IMG_CARAVAGIO;
        break;
      case ArtUtil.MONET:
        image = ArtUtil.IMG_MONET;
        break;
      case ArtUtil.VANGOGH:
        image = ArtUtil.IMG_VANGOGH;
        break;
    }
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ArtRoute(art: image)));
  }
}
