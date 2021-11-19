import 'package:flutter/material.dart';
import 'package:flutter_gridview_demo/image_detail.dart';
import 'package:flutter_gridview_demo/providers/pixabay_photos.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: PixabayPhotos(),
      child: MaterialApp(
        title: 'GridView Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<PixabayPhotoItem> photos = [];
  int page = 1;
  bool _isFirst = true;

  // @override
  // void didChangeDependencies() {
  //   if (_isFirst) {
  //     final pixbayProvider = Provider.of<PixabayPhotos>(context, listen: false);
  //     pixbayProvider.getPixabayPhotos(page, 20).then((_) {
  //       photos = pixbayProvider.photos;
  //     });
  //   }
  //   _isFirst = false;
  //   super.didChangeDependencies();
  // }

  @override
  void initState() {
    Future.delayed(Duration.zero).then((_) async {
      final pixbayProvider = Provider.of<PixabayPhotos>(context, listen: false);
      await pixbayProvider.getPixabayPhotos(page, 20);
      photos = pixbayProvider.photos;
      setState(() {});
    }).catchError((error) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Error'),
              content: const Text('Fail to fetch images from paxabay'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                )
              ],
            );
          });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SafeArea(
        child: GridView.builder(
            itemCount: photos.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: (orientation == Orientation.portrait) ? 2 : 3,
              childAspectRatio: 3 / 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                    return ImageDetail(photo: photos[index]);
                  }));
                },
                child: GridTile(
                  child: FadeInImage(
                    placeholder:
                        const AssetImage("assets/images/placeholder.png"),
                    image: NetworkImage(photos[index].webformatURL),
                    fit: BoxFit.cover,
                  ),
                  footer: GridTileBar(
                    backgroundColor: Colors.black54,
                    title: Text(photos[index].user),
                    subtitle: Text(
                        'views: ${photos[index].views}, favs: ${photos[index].likes}'),
                  ),
                ),
              );
            }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          page++;
          final pixbayProvider =
              Provider.of<PixabayPhotos>(context, listen: false);
          await pixbayProvider.getPixabayPhotos(page, 20);
          photos = pixbayProvider.photos;
          setState(() {});
          print("floating");
        },
        tooltip: 'Get More Images',
        child: const Icon(Icons.add),
      ),
    );
  }
}
