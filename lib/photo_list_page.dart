import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'photo_display_page.dart';

class PhotoListPage extends StatefulWidget
{
  const PhotoListPage({super.key});

  @override
  PhotoListPageState createState() => PhotoListPageState();
}

class PhotoListPageState extends State <PhotoListPage>
{
  String _searchQuery = '';

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Uploaded Photos'),
        actions: [
          IconButton(
            icon: Icon(Get.isDarkMode ? Icons.dark_mode : Icons.light_mode),
            onPressed: ()
            {
              Get.changeThemeMode(Get.isDarkMode ? ThemeMode.light : ThemeMode.dark);
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search by file name',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value)
              {
                setState(()
                {
                  _searchQuery = value.toLowerCase();
                });
              }
          )
        )
      )
    ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('photos').snapshots(),
        builder: (context , AsyncSnapshot <QuerySnapshot> snapshot)
        {
          if (snapshot.connectionState == ConnectionState.waiting)
          {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError)
          {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData)
          {
            return const Center(child: CircularProgressIndicator());
          }

          final photos = snapshot.data!.docs.where((doc)
          {
            var fileName = doc['fileName'].toString().toLowerCase();
            return fileName.contains(_searchQuery);
          }).toList();

          if (photos.isEmpty)
          {
            return const Center(child: Text('No photos found.',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w400
                  )
                )
              );
          }

          return ListView.builder(
            itemCount: photos.length,
            itemBuilder: (context , index)
            {
              var photo = photos[index];
              return ListTile(
                leading: Image.network(photo['url']),
                title: Text('File Name: ${photo['fileName']}'),
                subtitle: Text('Uploaded on: ${photo['uploadDate'].toDate()}'),
                onTap: ()
                {
                  Get.to(() => PhotoDisplayPage(
                    imageUrl: photo['url'],
                    fileName: photo['fileName'],
                    uploadDate: photo['uploadDate'].toDate(),
                  ));
                },
              );
            },
          );
        },
      ),
    );
  }
}