import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:habit_note/models/images_model.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../configs/colors.dart';
import '../../configs/common.dart';
import '../../configs/constants.dart';
import '../../main.dart';
import 'components/add_image_screen.dart';
import 'components/custom_post_card.dart';

/// Failed to get the url update in the cloud firestore
class GalleryScreen extends StatefulWidget {
  const GalleryScreen({Key? key}) : super(key: key);

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppStrings.galleryNotesScreen,
          style: GoogleFonts.fugazOne(),
        ),
      ),

      /// Show the list of created reminder
      body: StreamBuilder<List<ImagesModel>>(
          stream: imagesService.fetchImages(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.length == 0) {
                return noImagesDataWidget(context).center();
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    ImagesModel post = snapshot.data![index];
                    return InkWell(
                      borderRadius: BorderRadius.circular(defaultRadius),
                      onTap: () {
                        // TODO:
                        /// For editing the post
                        // AddImageScreen(
                        //   imagesModel: post,
                        // ).launch(context);
                      },
                      child: Container(
                          margin: EdgeInsets.symmetric(
                              horizontal:
                                  MediaQuery.of(context).size.width * 0.025,
                              vertical: 15),
                          child: PostCard(
                              postId: post.imageId.validate(),
                              uid: post.userId.validate(),
                              title: post.title.validate(),
                              description: post.description.validate(),
                              url: post.url,
                              createdAt: post.createdAt,
                              updatedAt: post.updatedAt)),
                    );
                  });
            } else {
              return snapWidgetHelper(snapshot);
            }
          }),
      floatingActionButton: Observer(
        builder: (_) => FloatingActionButton(
          backgroundColor: AppColors.kHabitOrange,
          child: Icon(Icons.add,
              color: appStore.isDarkMode ? AppColors.kHabitDark : Colors.white),
          onPressed: () {
            AddImageScreen().launch(context);
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
