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
  int _currentPage = 1;
  int _totalPages = 1;
  final int _photosPerPage = 10;
  DocumentSnapshot? _lastDocument;
  List <DocumentSnapshot> _photos = [];

  Future <void> _fetchTotalPages() async
  {
    final snapshot = await FirebaseFirestore.instance.collection('photos').get();
    
    if (mounted)
    {
      setState(()
      {
        _totalPages = (snapshot.size / _photosPerPage).ceil();
      });
    }
  }

  Future <void> _fetchPhotos() async
  {
    Query query = FirebaseFirestore.instance.collection('photos').orderBy('uploadDate' , descending: true).limit(_photosPerPage);

    if (_lastDocument != null)
    {
      query = query.startAfterDocument(_lastDocument!);
    }

    final snapshot = await query.get();

    if(mounted)
    {
      setState(()
      {
        if (_currentPage == 1)
        {
          _photos = snapshot.docs;
        } 
        else
        {
          _photos.addAll(snapshot.docs);
        }

        _lastDocument = snapshot.docs.isNotEmpty ? snapshot.docs.last : null;
      });
    }
  }

  void _nextPage()
  {
    if (_currentPage < _totalPages)
    {
      setState(()
      {
        _currentPage++;
      });
      _fetchPhotos();
    }
  }

  void _previousPage()
  {
    if (_currentPage > 1)
    {
      setState(()
      {
        _currentPage--;
        _lastDocument = null; // Reset for previous page
        _photos.clear();

        for (int i = 1 ; i < _currentPage ; i++)
        {
          _fetchPhotos();
        }
      });
      _fetchPhotos();
    }
  }

  @override
  void initState()
  {
    super.initState();
    _fetchTotalPages();
    _fetchPhotos();
  }

  @override
  void dispose()
  {
    super.dispose();
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Uploaded Photos'),
        actions: [
          IconButton(
            icon: Icon(Get.isDarkMode ? Icons.dark_mode : Icons.light_mode),
            onPressed: () {
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
              },
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance.collection('photos').orderBy('uploadDate' , descending: true).snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot)
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

                final paginatedPhotos = photos.skip((_currentPage - 1) * _photosPerPage).take(_photosPerPage).toList();

                return ListView.builder(
                  itemCount: paginatedPhotos.length,
                  itemBuilder: (context , index)
                  {
                    var photo = paginatedPhotos[index];
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
                          docId: photo.id,
                        ));
                      },
                    );
                  },
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: _currentPage > 1 ? _previousPage : null,
                child: const Text('Previous'),
              ),
              Text('Page $_currentPage of $_totalPages'),
              TextButton(
                onPressed: _currentPage < _totalPages ? _nextPage : null,
                child: const Text('Next'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}