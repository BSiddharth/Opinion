import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:opinion_frontend/providers.dart';

class SectionPage extends ConsumerWidget {
  const SectionPage({Key? key}) : super(key: key);
  static const screenName = "/addpostpage/sectionpage";

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: Text("Choose Section"),
          actions: [
            IconButton(
              icon: Icon(Icons.check),
              onPressed: () {
                Navigator.pop(context);
              },
              splashColor: Colors.transparent,
            )
          ],
        ),
        body: ListView(
          children: [
            ChooseSectionRadioTile(
              titleString: "Trending",
              assetString: "assets/images/trending.png",
            ),
            ChooseSectionRadioTile(
              titleString: "General",
              assetString: "assets/images/general.jpg",
            ),
            ChooseSectionRadioTile(
              titleString: "Laws and Policies",
              assetString: "assets/images/policies.jpg",
            ),
            ChooseSectionRadioTile(
              titleString: "Government",
              assetString: "assets/images/government.jpg",
            ),
            ChooseSectionRadioTile(
              titleString: "Movies",
              assetString: "assets/images/movies.jpg",
            ),
            ChooseSectionRadioTile(
              titleString: "Random",
              assetString: "assets/images/random.jpg",
            ),
          ],
        ),
      ),
    );
  }
}

// class SectionPage extends StatefulWidget {
//   @override
//   _SectionPageState createState() => _SectionPageState();
// }

// class _SectionPageState extends State<SectionPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Choose Section"),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.check),
//             onPressed: () {
//               Navigator.pop(context, [choosenSection, choosenSectionImage]);
//             },
//             splashColor: Colors.transparent,
//           )
//         ],
//       ),
//       body: ListView(
//         children: [
//           ChooseSectionRadioTile(
//             titleString: "Trending",
//             assetString: "assets/trending.png",
//             choosenSection: choosenSection,
//             onTapFunction: (String value, String imageString) {
//               setState(() {
//                 choosenSection = value;
//                 choosenSectionImage = imageString;
//               });
//             },
//           ),
//           ChooseSectionRadioTile(
//             titleString: "General",
//             assetString: "assets/general.jpg",
//             choosenSection: choosenSection,
//             onTapFunction: (String value, String imageString) {
//               setState(() {
//                 choosenSection = value;
//                 choosenSectionImage = imageString;
//               });
//             },
//           ),
//           ChooseSectionRadioTile(
//             titleString: "Laws and Policies",
//             assetString: "assets/policies.jpg",
//             choosenSection: choosenSection,
//             onTapFunction: (String value, String imageString) {
//               setState(() {
//                 choosenSection = value;
//                 choosenSectionImage = imageString;
//               });
//             },
//           ),
//           ChooseSectionRadioTile(
//             titleString: "Government",
//             assetString: "assets/government.jpg",
//             choosenSection: choosenSection,
//             onTapFunction: (String value, String imageString) {
//               setState(() {
//                 choosenSection = value;
//                 choosenSectionImage = imageString;
//               });
//             },
//           ),
//           ChooseSectionRadioTile(
//             titleString: "Movies",
//             assetString: "assets/movies.jpg",
//             choosenSection: choosenSection,
//             onTapFunction: (String value, String imageString) {
//               setState(() {
//                 choosenSection = value;
//                 choosenSectionImage = imageString;
//               });
//             },
//           ),
//           // ChooseSectionRadioTile(
//           //   titleString: "Random",
//           //   assetString: "assets/random.jpg",
//           //   choosenSection: choosenSection,
//           //   onTapFunction: (String value, String imageString) {
//           //     setState(() {
//           //       choosenSection = value;
//           //       choosenSectionImage = imageString;
//           //     });
//           //   },
//           // ),
//         ],
//       ),
//     );
//   }
// }

class ChooseSectionRadioTile extends ConsumerWidget {
  const ChooseSectionRadioTile({
    required this.assetString,
    required this.titleString,
  });

  final String assetString;
  final String titleString;

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        context.read(sectionProvider).state = titleString;
        context.read(sectionImageProvider).state = assetString;
      },
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 10,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.asset(
                assetString,
                height: 40,
                width: 40,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Text(
            titleString,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          ),
          Spacer(),
          AbsorbPointer(
            child: Radio(
                value: titleString,
                groupValue: watch(sectionProvider).state,
                onChanged: (String? value) {
                  // onTapFunction(value);
                }),
          )
        ],
      ),
    );
  }
}
