import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:softprodigy_task/bloc/home_bloc.dart';
import 'package:softprodigy_task/bloc/home_event.dart';
import 'package:softprodigy_task/bloc/home_state.dart';
import 'package:softprodigy_task/main.dart';

class HomePage extends StatefulWidget {

  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  HomeBloc homeBloc;

  @override
  void initState() {
    super.initState();

    ///api call
    homeBloc = BlocProvider.of<HomeBloc>(context);
    homeBloc.add(FetchHomeEvent());

    ///notification received
    notificationReceived();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Builder(
        builder: (context) {
          return Material(
            child: Scaffold(
              appBar: AppBar(
                title: Text("Home"),
              ),
              body: BlocListener<HomeBloc, HomeState>(
                listener: (context, state) {
                  if (state is HomeErrorState) {
                    Scaffold.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.message),
                      ),
                    );
                  }
                },
                child: BlocBuilder<HomeBloc, HomeState>(
                  builder: (context, state) {
                    if (state is HomeInitialState) {
                      return buildLoading();
                    } else if (state is HomeLoadingState) {
                      return buildLoading();
                    } else if (state is HomeLoadedState) {
                      return buildImageView(state.home);
                    } else if (state is HomeErrorState) {
                      return buildErrorUi(state.message);
                    }
                    return Container();
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget buildLoading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  ///ERROR UI
  Widget buildErrorUi(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          message,
          style: TextStyle(color: Colors.red),
        ),
      ),
    );
  }

  ///MAIN UI
  Widget buildImageView(List<dynamic> imageList) {
     final orientation = MediaQuery.of(context).orientation;
    return Column(
      children: [
        Container(
            margin: const EdgeInsets.only(top: 20,bottom: 20),
            width: MediaQuery.of(context).size.width,
            height: 200,
            child: CarouselSlider(
              options: CarouselOptions(),
              items: imageList.take(5)
                  .map((item) => Container(
                margin: const EdgeInsets.only(left: 10,right: 10),
                child: Container(
                  margin: const EdgeInsets.all(2.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.rectangle,
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 2.0,
                        spreadRadius: 0.0,
                        offset: Offset(
                            2.0, 2.0), // shadow direction: bottom right
                      )
                    ],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.all(8.0),
                  child: CachedNetworkImage(
                    fit: BoxFit.cover,
                    width: MediaQuery.of(context).size.width,
                    placeholder: (context, url) => Card(
                        child: Icon(Icons.image,size: 60,)),
                    imageUrl: item,
                  ),
                ),
              )).toList(),
            )),
        Expanded(
          child: GridView.builder(
            shrinkWrap: true,
            itemCount: imageList.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: (orientation == Orientation.portrait) ? 2 : 3),
            itemBuilder: (BuildContext context, int pos) {
              return Container(
                margin: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.rectangle,
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 5.0,
                        spreadRadius: 0.0,
                        offset: Offset(
                            2.0, 2.0), // shadow direction: bottom right
                      )
                    ],
                    borderRadius: BorderRadius.circular(10),
                  ),
                padding: const EdgeInsets.all(8.0),
                child: CachedNetworkImage(
                  placeholder: (context, url) => const Icon(Icons.image,size: 60,),
                  imageUrl: imageList[pos],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void notificationReceived() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification androidNotification = message.notification?.android;
      if (notification != null && androidNotification != null) {
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
                android: AndroidNotificationDetails(
                    channel.id, channel.name, channel.description,
                    color: Colors.blue,
                    playSound: true,
                    icon: "@mipmap/ic_launcher")));
        homeBloc = BlocProvider.of<HomeBloc>(context);
        homeBloc.add(FetchHomeEvent());
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {

      RemoteNotification notification = message.notification;
      AndroidNotification androidNotification = message.notification?.android;
      if (notification != null && androidNotification != null) {

      }
    });
  }

}
