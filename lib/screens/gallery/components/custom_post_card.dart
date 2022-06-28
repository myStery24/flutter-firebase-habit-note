import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../configs/colors.dart';
import '../../../configs/constants.dart';
import '../../../main.dart';

class PostCard extends StatefulWidget {
  const PostCard({
    Key? key,
    required this.postId,
    required this.uid,
    required this.title,
    required this.description,
    required this.url,
    required this.createdAt,
    required this.updatedAt,
  }) : super(key: key);

  final String postId;
  final String uid;
  final String? title;
  final String description;
  final url;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.all(8.0),
      decoration: boxDecorationWithShadow(
        borderRadius: BorderRadius.circular(defaultRadius),
        backgroundColor: appStore.isDarkMode
            ? AppColors.kPrimaryVariantColorDark
            : AppColors.kPrimaryVariantColor,
        spreadRadius: 0.0,
        blurRadius: 0.0,
        border: Border.all(
            color: appStore.isDarkMode
                ? AppColors.kPrimaryVariantColorDark
                : Colors.grey.shade400),
        boxShadow: [
          /// Top shadow
          BoxShadow(
              blurRadius: 5,
              offset: const Offset(-1, -2), // x, y
              color: appStore.isDarkMode
                  ? AppColors.kHabitOrange.withOpacity(0.3)
                  : AppColors.kHabitDark.withOpacity(0.3)),

          /// Bottom shadow
          BoxShadow(
              blurRadius: 5,
              offset: const Offset(1, 3),
              color: appStore.isDarkMode
                  ? AppColors.kHabitOrange.withOpacity(0.3)
                  : AppColors.kHabitDark.withOpacity(0.3)),
        ],
      ),
      child: Column(
        children: [
          /// HEADER SECTION OF THE POST
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: 4,
            ).copyWith(right: 0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // Text(widget.title['title'].toString(),
                      Text(widget.title!,
                          style: primaryTextStyle(
                              weight: TextFontWeight.bold,
                              size: 18,
                              color: appStore.isDarkMode
                                  ? AppColors.kTextWhite
                                  : AppColors.kTextBlack),
                          maxLines: 10,
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),

                /// Let user delete the post if the id match with their uid
                widget.uid == getStringAsync(USER_ID)
                    ? IconButton(
                        onPressed: () {
                          showDialog(
                            useRootNavigator: false,
                            context: context,
                            builder: (context) {
                              return Dialog(
                                child: ListView(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16),
                                    shrinkWrap: true,
                                    children: [delete]
                                        .map(
                                          (e) => InkWell(
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 12,
                                                        horizontal: 16),
                                                child: Row(
                                                  children: [
                                                    Icon(Icons
                                                        .delete_forever_outlined),
                                                    8.width,
                                                    Text(e,
                                                        style:
                                                            primaryTextStyle()),
                                                  ],
                                                ),
                                              ),

                                              /// A confirmation dialogue
                                              onTap: () async {
                                                bool? res = await showInDialog(
                                                  context,
                                                  title: Text(
                                                    delete_note,
                                                    style: TextStyle(
                                                      color: getBoolAsync(
                                                              IS_DARK_MODE)
                                                          ? AppColors
                                                              .kHabitOrange
                                                          : AppColors
                                                              .kTextBlack,
                                                      fontWeight:
                                                          TextFontWeight.bold,
                                                    ),
                                                  ),
                                                  builder: (_) => new Text(
                                                      confirm_to_delete_note,
                                                      style:
                                                          primaryTextStyle()),
                                                  actions: [
                                                    TextButton(
                                                        onPressed: () {
                                                          finish(
                                                              context, false);
                                                        },
                                                        child: Text(cancel,
                                                            style:
                                                                primaryTextStyle())),
                                                    TextButton(
                                                      onPressed: () {
                                                        finish(context, true);
                                                      },
                                                      child: Text(
                                                        delete,
                                                        style: primaryTextStyle(
                                                          color: AppColors
                                                              .kHabitOrange,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                );
                                                if (res ?? false) {
                                                  deletePost(widget.postId);
                                                  // remove the dialog box
                                                  Navigator.of(context).pop();
                                                }
                                              }),
                                        )
                                        .toList()),
                              );
                            },
                          );
                        },
                        icon: const Icon(Icons.more_vert),
                      )
                    : Container(),
              ],
            ),
          ),

          /// IMAGE SECTION OF THE POST
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: size.height * 0.3,
                width: double.infinity,
                child: Image.network(
                  widget.url, // widget.url['url'].toString(),
                  fit: BoxFit.scaleDown,
                ),
              ),
            ],
          ),

          8.height,

          /// DESCRIPTION SECTION
          Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    vertical: 4,
                  ).copyWith(right: 0),
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(
                          fontSize: 16,
                          color: appStore.isDarkMode
                              ? AppColors.kTextWhite
                              : AppColors.kTextBlack),
                      children: [
                        TextSpan(
                          text: '${widget.description}',
                        ),
                      ],
                    ),
                  ),
                ),

                /// Date
                widget.createdAt.toString() == widget.updatedAt.toString()
                    ? Container(
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: Text(
                            "Created at " +
                                DateFormat.yMMMd()
                                    .format(widget.createdAt!)
                                    .toString()
                                    .validate() +
                                DateFormat("\nhh:mm:ss a")
                                    .format(widget.updatedAt!)
                                    .toString()
                                    .validate(),
                            style: TextStyle(
                                color: appStore.isDarkMode
                                    ? AppColors.kTextWhite
                                    : AppColors.kTextBlack),
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 4),
                      )
                    : Container(
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: Text(
                            "Updated at " +
                                DateFormat.yMMMd()
                                    .format(widget.updatedAt!)
                                    .toString()
                                    .validate() +
                                DateFormat("\nhh:mm:ss a")
                                    .format(widget.updatedAt!)
                                    .toString()
                                    .validate(),
                            style: TextStyle(
                                color: appStore.isDarkMode
                                    ? AppColors.kTextWhite
                                    : AppColors.kTextBlack),
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 4),
                      ),
              ],
            ),
          )
        ],
      ),
    );
  }

  /// Delete the posted image
  deletePost(String postId) async {
    try {
      await imagesService.removeDocument(postId).then((value) {
        toast('Note deleted forever');
      });
    } catch (err) {
      toast(err.toString());
    }
  }
}
