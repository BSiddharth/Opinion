import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:opinion_frontend/components/addPageTextField.dart';
import 'package:opinion_frontend/components/addPostCustomOptions.dart';
import 'package:opinion_frontend/components/darkDivider.dart';
import 'package:opinion_frontend/components/mainAppBar.dart';
import 'package:opinion_frontend/components/showProfilePicture.dart';
import 'package:opinion_frontend/components/snackbar.dart';
import 'package:opinion_frontend/providers.dart';
import 'package:opinion_frontend/screens/sectionPage.dart';
import 'package:opinion_frontend/services/createPost.dart';
import 'package:opinion_frontend/services/glowRemover.dart';
import 'package:opinion_frontend/services/postPicLinkgenerator.dart';
import 'package:photo_manager/photo_manager.dart';

final imageIndexProvider = StateProvider.autoDispose<int>((ref) => 0);
// final imageProvider = StateProvider.autoDispose<File?>((ref) => null);
// final storagePermissionProvider = StateProvider<bool>((ref) => false);

class AddPostPage extends StatefulWidget {
  static const screenName = '/addpostpage';

  @override
  _AddPostPageState createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddPostPage> {
  final _titleEditingController = TextEditingController();

  final _descriptionEditingController = TextEditingController();

  final _option1EditingController = TextEditingController();

  final _option2EditingController = TextEditingController();

  final _option3EditingController = TextEditingController();

  final _option4EditingController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool imagePermissonPermitted = false;
  bool votingEnabled = true;
  File? imageFile;
  List<AssetEntity> assets = [];

  @override
  void initState() {
    _fetchAssets();
    super.initState();
  }

  @override
  void dispose() {
    _titleEditingController.dispose();
    _descriptionEditingController.dispose();
    _option1EditingController.dispose();
    _option2EditingController.dispose();
    _option3EditingController.dispose();
    _option4EditingController.dispose();
    super.dispose();
  }

  void _fetchAssets() async {
    imagePermissonPermitted = await PhotoManager.requestPermission();
    if (imagePermissonPermitted) {
      // Set onlyAll to true, to fetch only the 'Recent' album
      // which contains all the photos/videos in the storage
      final albums = await PhotoManager.getAssetPathList(
          onlyAll: true, type: RequestType.image);
      final recentAlbum = albums.first;

      // Now that we got the album, fetch all the assets it contains
      final recentAssets = await recentAlbum.getAssetListRange(
        start: 0, // start at index 0
        end: 60, // end at a very big index (to get all the assets)
      );

      // Update the state and notify UI
      setState(() {
        assets = recentAssets;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text("Add Post"),
          actions: [
            Consumer(
              builder: (context, watch, child) {
                return IconButton(
                  splashColor: Colors.transparent,
                  icon: Icon(
                    Icons.check,
                    color: Colors.white,
                  ),
                  onPressed: () async {
                    final String title = _titleEditingController.text.trim();
                    final String description =
                        _descriptionEditingController.text.trim();
                    final String votable = votingEnabled.toString();
                    final String section = context.read(sectionProvider).state;
                    final String option1text =
                        _option1EditingController.text.trim();
                    final String option2text =
                        _option2EditingController.text.trim();
                    final String option3text =
                        _option3EditingController.text.trim();
                    final String option4text =
                        _option4EditingController.text.trim();
                    final String token = context.read(tokenProvider).state!;

                    if (votingEnabled && _formKey.currentState!.validate() ||
                        !votingEnabled) {
                      if (imageFile == null) {
                        snackBarTemplate(
                            context: context,
                            message: 'Choose an image to post!');
                        return;
                      } else {
                        context.read(currentIndexProvider).state = 0;
                        context.read(currentAppBarProvider).state =
                            MainAppBar();

                        Fluttertoast.showToast(
                          msg: "Posting",
                          toastLength: Toast.LENGTH_SHORT,
                          backgroundColor: Colors.redAccent,
                          textColor: Colors.white,
                        );
                        final String? imageLink =
                            await postPicLinkGen(imageFile!);
                        if (imageLink == null) {
                          Fluttertoast.showToast(
                            msg: 'Some problem occurred while posting!',
                            toastLength: Toast.LENGTH_SHORT,
                            backgroundColor: Colors.redAccent,
                            textColor: Colors.white,
                          );
                          return;
                        }

                        final response = await createPost(
                          title: title,
                          description: description,
                          votable: votable,
                          imageUrl: imageLink,
                          section: section,
                          token: token,
                          option1text: option1text,
                          option2text: option2text,
                          option3text: option3text,
                          option4text: option4text,
                        );

                        if (response.statusCode == 200) {
                          Fluttertoast.showToast(
                            msg: "Posted successfully",
                            toastLength: Toast.LENGTH_SHORT,
                            backgroundColor: Colors.redAccent,
                            textColor: Colors.white,
                          );
                        } else {
                          Fluttertoast.showToast(
                            msg: 'Some problem occurred while posting!',
                            toastLength: Toast.LENGTH_SHORT,
                            backgroundColor: Colors.redAccent,
                            textColor: Colors.white,
                          );
                        }
                      }
                    }
                  },
                );
              },
            )
          ],
        ),
        body: GlowRemover(
          child: ListView(
            children: [
              Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                  child: Consumer(builder: (context, ref, child) {
                    final userDetails =
                        context.read(currentUserDetailsProvider).state;
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ShowProfilePicture(
                          url: userDetails.userprofileimagelink,
                          dimension: 40.0,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          userDetails.username,
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: "Baloo",
                            fontSize: 18,
                          ),
                        ),
                      ],
                    );
                  })),
              AddPageTextField(
                minLines: 2,
                hintText: "Title (Optional)",
                maxLength: 150,
                textController: _titleEditingController,
              ),
              AddPageTextField(
                hintText: "Description (Optional)",
                maxLength: 2000,
                minLines: 10,
                textController: _descriptionEditingController,
              ),
              CheckboxListTile(
                activeColor: Colors.redAccent,
                title: const Text(
                  "Enable Voting",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                value: votingEnabled,
                onChanged: (value) {
                  setState(() {
                    votingEnabled = !votingEnabled;
                  });
                },
              ),
              DarkDivider(height: 5),
              Consumer(builder: (context, watch, child) {
                String section = watch(sectionProvider).state;
                String imageString = watch(sectionImageProvider).state;

                return Visibility(
                  visible: votingEnabled,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          Navigator.pushNamed(context, SectionPage.screenName);
                        },
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(18),
                              child: Text("Section",
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    color: Colors.white,
                                  )),
                            ),
                            Spacer(),
                            // section
                            // ? Icon(
                            //     Icons.arrow_forward_ios,
                            //     color: Colors.white,
                            //   )
                            // :
                            Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Image.asset(
                                    imageString,
                                    height: 35,
                                    width: 35,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(section,
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.white,
                                    )),
                              ],
                            ),
                            SizedBox(
                              width: 22,
                            )
                          ],
                        ),
                      ),
                      DarkDivider(height: 5),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(18, 18, 18, 1),
                            child: Text("Optional Custom Voting Options",
                                style: TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.white,
                                )),
                          ),
                          Spacer(),
                        ],
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(18, 0, 18, 23),
                            child: Text("( 130 words limit )",
                                style: TextStyle(
                                  fontSize: 12.0,
                                  color: Colors.white60,
                                )),
                          ),
                          Spacer(),
                        ],
                      ),
                      Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              AddPostCustomOptions(
                                hintText: "Option 1",
                                controller: _option1EditingController,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Option 1 cannot be empty';
                                  }
                                  if (value.length < 4) {
                                    return 'Minimum 4 characters needed';
                                  }
                                  return null;
                                },
                              ),
                              AddPostCustomOptions(
                                hintText: "Option 2",
                                controller: _option2EditingController,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Option 2 cannot be empty';
                                  }
                                  if (value.length < 4) {
                                    return 'Minimum 4 characters needed';
                                  }
                                  return null;
                                },
                              ),
                              AddPostCustomOptions(
                                hintText: "Option 3",
                                controller: _option3EditingController,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Option 3 cannot be empty';
                                  }
                                  if (value.length < 4) {
                                    return 'Minimum 4 characters needed';
                                  }
                                  return null;
                                  // if (value.isEmpty &&
                                  //     _option4EditingController.text != "") {
                                  //   return "Option 3 cannot be empty if option 4 is specified";
                                  // }
                                  // if (!value.isEmpty && value.length < 4) {
                                  //   return 'Minimum 4 characters needed';
                                  // }
                                  // return null;
                                },
                              ),
                              AddPostCustomOptions(
                                hintText: "Option 4",
                                controller: _option4EditingController,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Option 4 cannot be empty';
                                  }
                                  if (value.length < 4) {
                                    return 'Minimum 4 characters needed';
                                  }
                                  return null;
                                  // if (!value.isEmpty && value.length < 4) {
                                  //   return 'Minimum 4 characters needed';
                                  // }
                                  // return null;
                                },
                              ),
                            ],
                          )),
                      SizedBox(
                        height: 5,
                      ),
                      DarkDivider(height: 5),
                    ],
                  ),
                );
              }),
              imagePermissonPermitted
                  ? Column(
                      children: [
                        Consumer(builder: (context, watch, child) {
                          final int imageIndex =
                              watch(imageIndexProvider).state;
                          return Container(
                            height: 300,
                            child: assets.length != 0
                                ? FutureBuilder<File?>(
                                    future: assets[imageIndex].file,
                                    builder: (_, snapshot) {
                                      final file = snapshot.data;
                                      if (file == null) {
                                        return Container();
                                      }
                                      imageFile = file;
                                      return Image.file(
                                        file,
                                        fit: BoxFit.contain,
                                      );
                                    },
                                  )
                                : Container(
                                    height: 300,
                                    color: Colors.white,
                                  ),
                          );
                        }),
                        DarkDivider(height: 5),
                        Container(
                          height: 300,
                          child: GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              // A grid view with 3 items per row
                              crossAxisCount: 3,
                            ),
                            itemCount: assets.length,
                            itemBuilder: (_, index) {
                              return AssetThumbnail(
                                asset: assets[index],
                                index: index,
                              );
                            },
                          ),
                        )
                      ],
                    )
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            padding: EdgeInsets.symmetric(
                                vertical: 15, horizontal: 15),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                side: BorderSide(color: Colors.black)),
                          ),
                          onPressed: null,
                          // () async {
                          //   // imagePermissonPermitted =
                          //   //     await PhotoManager.requestPermission();
                          //   // setState(() {});
                          // },
                          child: Text(
                            "ALLOW STORAGE PERMISSION",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.normal,
                                letterSpacing: 1.0,
                                fontSize: 15),
                          )),
                    ),
            ],
          ),
        ));
  }
}

class AssetThumbnail extends StatelessWidget {
  AssetThumbnail({
    required this.asset,
    required this.index,
  });

  final AssetEntity asset;
  final int index;

  @override
  Widget build(BuildContext context) {
    // We're using a FutureBuilder since thumbData is a future
    return FutureBuilder<Uint8List?>(
      future: asset.thumbData,
      builder: (_, snapshot) {
        final bytes = snapshot.data;

        // If we have no data, display a spinner
        if (bytes == null)
          return CircularProgressIndicator(
            color: Colors.redAccent,
          );
        // If there's data, display it as an image
        return Consumer(
          builder: (context, watch, child) {
            return GestureDetector(
                onTap: () {
                  context.read(imageIndexProvider).state = index;
                },
                child: Image.memory(bytes, fit: BoxFit.cover));
          },
        );
      },
    );
  }
}

// import 'dart:async';
// import 'dart:convert';
// import 'dart:io';

// import 'package:flutter/material.dart';

// import 'package:opinion_frontend/components/addPageTextField.dart';
// import 'package:opinion_frontend/components/darkDivider.dart';
// import 'package:opinion_frontend/components/showProfilePicture.dart';
// import 'package:opinion_frontend/screens/sectionPage.dart';
// import 'package:opinion_frontend/services/glowRemover.dart';

// class AddPostPage extends StatefulWidget {
//   @override
//   _AddPostPageState createState() => _AddPostPageState();
// }

// class _AddPostPageState extends State<AddPostPage> {
//   List<FileModel> files = [];
//   FileModel? selectedModel;
//   String? image;
//   String? section;
//   late String sectionImage;

//   final _formKey = GlobalKey<FormState>();

//   bool? _isVotingEnabled = true;
//   TextEditingController? _titleEditingController;
//   TextEditingController? _descriptionEditingController;
//   TextEditingController? _option1EditingController;
//   TextEditingController? _option2EditingController;
//   TextEditingController? _option3EditingController;
//   TextEditingController? _option4EditingController;

//   @override
//   void initState() {
//     super.initState();
//     _titleEditingController = TextEditingController();
//     _descriptionEditingController = TextEditingController();
//     _option1EditingController = TextEditingController();
//     _option2EditingController = TextEditingController();
//     _option3EditingController = TextEditingController();
//     _option4EditingController = TextEditingController();
//     getImagesPath();
//   }

//   @override
//   void dispose() {
//     _titleEditingController!.dispose();
//     _descriptionEditingController!.dispose();
//     _option1EditingController!.dispose();
//     _option2EditingController!.dispose();
//     _option3EditingController!.dispose();
//     _option4EditingController!.dispose();
//     super.dispose();
//   }

//   getImagesPath() async {
//     // var imagePath = await StoragePath.imagesPath;
//     // var images = jsonDecode(imagePath) as List;
//     // files = images.map<FileModel>((e) => FileModel.fromJson(e)).toList();
//     // if (files.length > 0)
//     //   setState(() {
//     //     selectedModel = files[0];
//     //     image = files[0].files![0];
//     //   });
//   }

//   List<DropdownMenuItem> getItems() {
//     return files
//             .map((e) => DropdownMenuItem(
//                   child: Text(
//                     e.folder!,
//                     style: TextStyle(
//                       color: Colors.white,
//                     ),
//                   ),
//                   value: e,
//                 ))
//             .toList() ??
//         [];
//   }

//   void chooseSection(BuildContext context) async {
//     List<String> data = await (Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => SectionPage(),
//       ),
//     ) as FutureOr<List<String>>);
//     section = data[0];
//     sectionImage = data[1];
//     setState(() {});
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         backgroundColor: Colors.black,
//         appBar: AppBar(
//           backgroundColor: Colors.black,
//           title: Text("Add Post"),
//           actions: [
//             IconButton(
//               splashColor: Colors.transparent,
//               icon: Icon(
//                 Icons.check,
//                 color: Colors.white,
//               ),
//               onPressed: () async {
//                 // DocumentReference docRef;
//                 // final FirebaseAuth auth = FirebaseAuth.instance;
//                 // final CollectionReference posts = FirebaseFirestore.instance
//                 //     .collection('posts')
//                 //     .doc(auth.currentUser!.uid)
//                 //     .collection("UsersPosts");

//                 // File imageFile;
//                 // String? downloadUrl;
//                 // String? username;
//                 // String? profilePicUrl;

//                 // await FirebaseFirestore.instance
//                 //     .collection('users')
//                 //     .doc(auth.currentUser!.uid)
//                 //     .get()
//                 //     .then(
//                 //   (DocumentSnapshot documentSnapshot) {
//                 //     if (documentSnapshot.exists) {
//                 //       profilePicUrl = documentSnapshot.data()!["profilePicUrl"];
//                 //       username = documentSnapshot.data()!["username"];
//                 //       // setState(() {});
//                 //     }
//                 //   },
//                 // );
//                 // if (_isVotingEnabled! &&
//                 //     section != null &&
//                 //     File(image!) != null) {
//                 //   if (_formKey.currentState!.validate()) {
//                 //     docRef = await posts.add({
//                 //       'title': _titleEditingController!.text,
//                 //       'description': _descriptionEditingController!.text,
//                 //       'votable': _isVotingEnabled,
//                 //       'section': section,
//                 //       'posterId': auth.currentUser!.uid,
//                 //       'time': DateTime.now().toUtc(),
//                 //       'options': [
//                 //         _option1EditingController!.text,
//                 //         _option2EditingController!.text,
//                 //         _option3EditingController!.text,
//                 //         _option4EditingController!.text,
//                 //       ],
//                 //       "profilePicUrl": profilePicUrl,
//                 //       'username': username,
//                 //     });

//                 //     if (File(image!).lengthSync() <= 300000) {
//                 //       print(File(image!).lengthSync());
//                 //       imageFile = File(image!);
//                 //     } else {
//                 //       ImageProperties properties =
//                 //           await FlutterNativeImage.getImageProperties(image!);

//                 //       imageFile = await FlutterNativeImage.compressImage(
//                 //         image!,
//                 //         quality: 70,
//                 //         percentage: 70,
//                 //         targetWidth: 1080,
//                 //         targetHeight:
//                 //             (properties.height * 1080 / properties.width).round(),
//                 //       );
//                 //     }
//                 //     UploadTask task = FirebaseStorage.instance
//                 //         .ref("PostPictures/${docRef.id}")
//                 //         .putFile(imageFile);
//                 //     task.then((TaskSnapshot snapshot) async {
//                 //       print('Upload complete!');
//                 //       downloadUrl = await snapshot.ref.getDownloadURL();
//                 //     }).catchError((Object e) {
//                 //       print(e); // FirebaseException
//                 //     });
//                 //     // if (snapshot.error == null) {
//                 //     //   downloadUrl = await snapshot.ref.getDownloadURL();
//                 //     // }

//                 //     await posts.doc(docRef.id).update({"imageUrl": downloadUrl});
//                 //     Navigator.push(
//                 //       context,
//                 //       MaterialPageRoute(
//                 //         builder: (context) => VoteDetailedPage(),
//                 //       ),
//                 //     );
//                 //   }
//                 // } else if (_isVotingEnabled! &&
//                 //     section == null &&
//                 //     File(image!) != null) {
//                 //   var dialog = CustomAlertDialog(
//                 //     message: "You need to choose a section for your post!",
//                 //     negativeBtnText: 'Ok',
//                 //   );
//                 //   showDialog(
//                 //       context: context,
//                 //       builder: (BuildContext context) => dialog);
//                 // } else if (!_isVotingEnabled! && File(image!) != null) {
//                 //   docRef = await posts.add({
//                 //     'title': _titleEditingController!.text,
//                 //     'description': _descriptionEditingController!.text,
//                 //     'votable': _isVotingEnabled,
//                 //     'posterId': auth.currentUser!.uid,
//                 //     'time': DateTime.now().toUtc(),
//                 //     "profilePicUrl": profilePicUrl,
//                 //     'username': username,
//                 //   });

//                 //   if (File(image!).lengthSync() <= 300000) {
//                 //     print(File(image!).lengthSync());
//                 //     imageFile = File(image!);
//                 //   } else {
//                 //     ImageProperties properties =
//                 //         await FlutterNativeImage.getImageProperties(image!);

//                 //     imageFile = await FlutterNativeImage.compressImage(
//                 //       image!,
//                 //       quality: 70,
//                 //       percentage: 70,
//                 //       targetWidth: 1080,
//                 //       targetHeight:
//                 //           (properties.height * 1080 / properties.width).round(),
//                 //     );
//                 //   }
//                 //   UploadTask task = FirebaseStorage.instance
//                 //       .ref("PostPictures/${docRef.id}")
//                 //       .putFile(imageFile);
//                 //   task.then((TaskSnapshot snapshot) async {
//                 //     print('Upload complete!');
//                 //     downloadUrl = await snapshot.ref.getDownloadURL();
//                 //   }).catchError((Object e) {
//                 //     print(e); // FirebaseException
//                 //   });
//                 //   // if (snapshot.error == null) {
//                 //   //   downloadUrl = await snapshot.ref.getDownloadURL();
//                 //   // }

//                 //   await posts.doc(docRef.id).update({"imageUrl": downloadUrl});
//                 //   Navigator.push(
//                 //     context,
//                 //     MaterialPageRoute(
//                 //       builder: (context) => VoteDetailedPage(),
//                 //     ),
//                 //   );
//                 // }
//               },
//             )
//           ],
//         ),
//         body: GlowRemover(
//           child: ListView(
//             children: [
//               Padding(
//                 padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
//                 child: Row(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     ShowProfilePicture(
//                       url:
//                           "https://media1.popsugar-assets.com/files/thumbor/HZkfZCqKtP4x3ToYEMMlTzciW-0/11x217:2750x2956/fit-in/500x500/filters:format_auto-!!-:strip_icc-!!-/2020/01/06/998/n/1922398/6f9cc58e5e13bb70429950.61367099_/i/Chris-Evans.jpg",
//                       dimension: 40.0,
//                     ),
//                     SizedBox(
//                       width: 10,
//                     ),
//                     Text(
//                       "Dabakdo",
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontFamily: "Baloo",
//                         fontSize: 18,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               AddPageTextField(
//                 minLines: 2,
//                 hintText: "Title (Optional)",
//                 maxLength: 150,
//                 textController: _titleEditingController,
//               ),
//               AddPageTextField(
//                 hintText: "Description (Optional)",
//                 maxLength: 2000,
//                 minLines: 10,
//                 textController: _descriptionEditingController,
//               ),
//               CheckboxListTile(
//                 activeColor: Colors.redAccent,
//                 title: const Text(
//                   "Enable Voting",
//                   style: TextStyle(
//                     fontSize: 18,
//                     color: Colors.white,
//                   ),
//                 ),
//                 value: _isVotingEnabled,
//                 onChanged: (value) {
//                   setState(() {
//                     _isVotingEnabled = value;
//                   });
//                 },
//               ),
//               DarkDivider(height: 5),
//               // Container(
//               //   height: 5,
//               //   color: Color(0xffF2F2F2),
//               // ),
//               Visibility(
//                 visible: _isVotingEnabled!,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     GestureDetector(
//                       behavior: HitTestBehavior.translucent,
//                       onTap: () {
//                         chooseSection(context);
//                       },
//                       child: Row(
//                         children: [
//                           Padding(
//                             padding: const EdgeInsets.all(18),
//                             child: Text("Section",
//                                 style: TextStyle(
//                                   fontSize: 18.0,
//                                   color: Colors.white,
//                                 )),
//                           ),
//                           Expanded(child: SizedBox()),
//                           section == null
//                               ? Icon(
//                                   Icons.arrow_forward_ios,
//                                   color: Colors.white,
//                                 )
//                               : Row(
//                                   children: [
//                                     ClipRRect(
//                                       borderRadius: BorderRadius.circular(8.0),
//                                       child: Image.asset(
//                                         sectionImage,
//                                         height: 35,
//                                         width: 35,
//                                         fit: BoxFit.cover,
//                                       ),
//                                     ),
//                                     SizedBox(
//                                       width: 10,
//                                     ),
//                                     Text(section!,
//                                         style: TextStyle(
//                                           fontSize: 16.0,
//                                           color: Colors.white,
//                                         )),
//                                   ],
//                                 ),
//                           SizedBox(
//                             width: 22,
//                           )
//                         ],
//                       ),
//                     ),
//                     DarkDivider(height: 5),
//                     Padding(
//                       padding: const EdgeInsets.fromLTRB(18, 18, 18, 1),
//                       child: Text("Custom Voting Options",
//                           style: TextStyle(
//                             fontSize: 18.0,
//                             color: Colors.white,
//                           )),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.fromLTRB(18, 0, 18, 23),
//                       child: Text(
//                           "( Atleast 2 options required , 130 words limit )",
//                           style: TextStyle(
//                             fontSize: 12.0,
//                             color: Colors.white60,
//                           )),
//                     ),
//                     Form(
//                         key: _formKey,
//                         child: Column(
//                           children: [
//                             AddPostCustomOptions(
//                               hintText: "Option 1*",
//                               controller: _option1EditingController,
//                               validator: (value) {
//                                 if (value.isEmpty) {
//                                   return 'Option 1 cannot be empty';
//                                 }
//                                 if (value.length < 4) {
//                                   return 'Minimum 4 characters needed';
//                                 }
//                                 return null;
//                               },
//                             ),
//                             AddPostCustomOptions(
//                               hintText: "Option 2*",
//                               controller: _option2EditingController,
//                               validator: (value) {
//                                 if (value.isEmpty) {
//                                   return 'Option 2 cannot be empty';
//                                 }
//                                 if (value.length < 4) {
//                                   return 'Minimum 4 characters needed';
//                                 }
//                                 return null;
//                               },
//                             ),
//                             AddPostCustomOptions(
//                               hintText: "Option 3",
//                               controller: _option3EditingController,
//                               validator: (value) {
//                                 if (value.isEmpty &&
//                                     _option4EditingController!.text != "") {
//                                   return "Option 3 cannot be empty if option 4 is specified";
//                                 }
//                                 if (!value.isEmpty && value.length < 4) {
//                                   return 'Minimum 4 characters needed';
//                                 }
//                                 return null;
//                               },
//                             ),
//                             AddPostCustomOptions(
//                               hintText: "Option 4",
//                               controller: _option4EditingController,
//                               validator: (value) {
//                                 if (!value.isEmpty && value.length < 4) {
//                                   return 'Minimum 4 characters needed';
//                                 }
//                                 return null;
//                               },
//                             ),
//                           ],
//                         )),
//                     SizedBox(
//                       height: 5,
//                     ),
//                     DarkDivider(height: 5),
//                   ],
//                 ),
//               ),

//               Row(
//                 children: [
//                   // Padding(
//                   //   padding: const EdgeInsets.fromLTRB(18, 18, 0, 5),
//                   //   child: Text(
//                   //     "Post",
//                   //     style: TextStyle(fontSize: 18.0, color: Colors.white),
//                   //   ),
//                   // ),
//                   // Spacer(),
//                   // Icon(Icons.arrow_forward_ios, color: Colors.white),
//                   SizedBox(
//                     width: 100,
//                   )
//                 ],
//               ),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 18.0),
//                 child: DropdownButtonHideUnderline(
//                     child: DropdownButton<FileModel>(
//                   dropdownColor: Colors.black,
//                   items: getItems() as List<DropdownMenuItem<FileModel>>?,
//                   onChanged: (FileModel? d) {
//                     assert(d!.files!.length > 0);
//                     image = d!.files![0];
//                     setState(() {
//                       selectedModel = d;
//                     });
//                   },
//                   value: selectedModel,
//                 )),
//               ),
//               Container(
//                 height: 300,
//                 child: image != null
//                     ? Image.file(
//                         File(image!),
//                         fit: BoxFit.contain,
//                         // height: MediaQuery.of(context).size.height * 0.45,
//                         // width: MediaQuery.of(context).size.width,
//                       )
//                     : Container(
//                         height: 300,
//                       ),
//               ),
//               DarkDivider(height: 5),
//               selectedModel != null && selectedModel!.files!.length >= 1
//                   ? Container(
//                       height: 300,
//                       child: GridView.builder(
//                         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                           crossAxisCount: 4,
//                           crossAxisSpacing: 0,
//                           mainAxisSpacing: 0,
//                         ),
//                         itemBuilder: (_, i) {
//                           var file = selectedModel!.files![i];

//                           return GestureDetector(
//                             child: Image.file(
//                               File(file),
//                               fit: BoxFit.cover,
//                               cacheHeight: 200,
//                             ),
//                             onTap: () {
//                               setState(() {
//                                 image = file;
//                               });
//                             },
//                           );
//                         },
//                         // itemCount: selectedModel.files.length,
//                         itemCount: selectedModel!.files!.length <= 40
//                             ? selectedModel!.files!.length
//                             : 40,
//                       ),
//                     )
//                   : Container(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class FileModel {
//   List<String>? files;
//   String? folder;

//   FileModel({this.files, this.folder});

//   FileModel.fromJson(Map<String, dynamic> json) {
//     files = json['files'].cast<String>();
//     folder = json['folderName'];
//   }
// }

// class AddPostCustomOptions extends StatelessWidget {
//   const AddPostCustomOptions({
//     required this.hintText,
//     required this.controller,
//     required this.validator,
//   });
//   final String hintText;
//   final TextEditingController? controller;
//   final Function validator;
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 5),
//       child: TextFormField(
//         validator: validator as String? Function(String?)?,
//         minLines: 1,
//         maxLines: 3,
//         maxLength: 130,
//         maxLengthEnforced: true,
//         controller: controller,
//         cursorColor: Colors.black,
//         cursorWidth: 1.5,
//         decoration: InputDecoration(
//           contentPadding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
//           enabledBorder: const OutlineInputBorder(
//             borderSide: const BorderSide(color: Colors.black54, width: 1.0),
//             borderRadius: const BorderRadius.all(
//               const Radius.circular(10.0),
//             ),
//           ),
//           focusedBorder: const OutlineInputBorder(
//             borderSide: const BorderSide(color: Colors.black54, width: 1.0),
//             borderRadius: const BorderRadius.all(
//               const Radius.circular(10.0),
//             ),
//           ),
//           filled: true,
//           hintStyle: new TextStyle(color: Colors.grey[800]),
//           hintText: hintText,
//           fillColor: Colors.white70,
//           counterText: "",
//         ),
//       ),
//     );
//   }
// }
