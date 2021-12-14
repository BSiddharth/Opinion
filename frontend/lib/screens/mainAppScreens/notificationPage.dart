import 'package:flutter/material.dart';
import 'package:opinion_frontend/components/showProfilePicture.dart';
import 'package:opinion_frontend/services/glowRemover.dart';

// class NotificationPage extends StatelessWidget {
//   const NotificationPage({Key? key}) : super(key: key);
//   static const screenName = '/notificationpage';

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Text(
//           "Notification Page",
//           style: TextStyle(color: Colors.white),
//         ),
//       ),
//     );
//   }
// }

class NotificationPage extends StatelessWidget {
  const NotificationPage({Key? key}) : super(key: key);
  static const screenName = '/notificationpage';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Notifications"),
      ),
      body: GlowRemover(
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShowProfilePicture(
                      url:
                          "https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
                      dimension: 40),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            style: TextStyle(),
                            children: <TextSpan>[
                              TextSpan(
                                text: 'Johnsmithjohnsmithjohnsmith ',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              TextSpan(
                                text: 'and',
                              ),
                              TextSpan(
                                // recognizer:,
                                text: ' 230 others ',
                                style: TextStyle(
                                    // fontWeight: FontWeight.bold,
                                    ),
                              ),
                              TextSpan(
                                text: 'voted on your post.',
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          "6w",
                          style: TextStyle(
                            color: Colors.white60,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Spacer(),
                  SizedBox(width: 12),

                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      "https://www.livelaw.in/h-upload/2019/12/14/368013-citizenship-amendment-act-and-sc-02.jpg",
                      // cacheHeight: 100,
                      height: 40.0,
                      width: 40.0,
                      fit: BoxFit.cover,
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShowProfilePicture(
                      url:
                          "https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
                      dimension: 40),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            style: TextStyle(),
                            children: <TextSpan>[
                              TextSpan(
                                text: 'Johnsmithjohnsmithjohnsmith ',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              // TextSpan(
                              //   text: 'and',
                              // ),
                              // TextSpan(
                              //   // recognizer:,
                              //   text: ' 230 others ',
                              //   style: TextStyle(
                              //       // fontWeight: FontWeight.bold,
                              //       ),
                              // ),
                              TextSpan(
                                text: 'commented on your post.',
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          "6w",
                          style: TextStyle(
                            color: Colors.white60,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Spacer(),
                  SizedBox(width: 12),

                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      "https://www.livelaw.in/h-upload/2019/12/14/368013-citizenship-amendment-act-and-sc-02.jpg",
                      // cacheHeight: 100,
                      height: 40.0,
                      width: 40.0,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShowProfilePicture(
                      url:
                          "https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
                      dimension: 40),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            style: TextStyle(),
                            children: <TextSpan>[
                              TextSpan(
                                text: 'Johnsmithjohnsmithjohnsmith ',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              // TextSpan(
                              //   text: 'and',
                              // ),
                              // TextSpan(
                              //   // recognizer:,
                              //   text: ' 230 others ',
                              //   style: TextStyle(
                              //       // fontWeight: FontWeight.bold,
                              //       ),
                              // ),
                              TextSpan(
                                text: 'replied to your comment.',
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          "6w",
                          style: TextStyle(
                            color: Colors.white60,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Spacer(),
                  SizedBox(width: 12),

                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      "https://www.livelaw.in/h-upload/2019/12/14/368013-citizenship-amendment-act-and-sc-02.jpg",
                      // cacheHeight: 100,
                      height: 40.0,
                      width: 40.0,
                      fit: BoxFit.cover,
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShowProfilePicture(
                      url:
                          "https://images.pexels.com/photos/220453/pexels-photo-220453.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
                      dimension: 40),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            style: TextStyle(),
                            children: <TextSpan>[
                              TextSpan(
                                text: 'Johnsmithjohnsmithjohnsmith ',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white70),
                              ),
                              // TextSpan(
                              //   text: 'and',
                              // ),
                              // TextSpan(
                              //   // recognizer:,
                              //   text: ' 230 others ',
                              //   style: TextStyle(
                              //       // fontWeight: FontWeight.bold,
                              //       ),
                              // ),
                              TextSpan(
                                text: 'mentioned you in a comment.',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white70),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          "6w",
                          style: TextStyle(
                            color: Colors.white60,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Spacer(),
                  SizedBox(width: 12),

                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      "https://www.livelaw.in/h-upload/2019/12/14/368013-citizenship-amendment-act-and-sc-02.jpg",
                      // cacheHeight: 100,
                      height: 40.0,
                      width: 40.0,
                      fit: BoxFit.cover,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
