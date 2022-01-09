import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:habit_note/model/subscription_model.dart';
import 'package:habit_note/utils/colors.dart';
import 'package:habit_note/utils/common.dart';
import 'package:habit_note/utils/string_constant.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../main.dart';
import 'AddSubscriptionReminderScreen.dart';
import 'SubscriptionDetailScreen.dart';

class SubscriptionReminderListScreen extends StatefulWidget {
  @override
  SubscriptionReminderListScreenState createState() => SubscriptionReminderListScreenState();
}

class SubscriptionReminderListScreenState extends State<SubscriptionReminderListScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    setStatusBarColor(appStore.isDarkMode ? AppColors.kHabitDark : Colors.white, statusBarIconBrightness: Brightness.light, delayInMilliSeconds: 100);
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    setStatusBarColor(appStore.isDarkMode ? AppColors.kHabitDark : Colors.white, delayInMilliSeconds: 100);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Text(sub_reminder),
      ),
      floatingActionButton: Observer(
        builder: (_) => FloatingActionButton(
          onPressed: () {
            AddSubscriptionReminderScreen().launch(context);
          },
          backgroundColor: appStore.isDarkMode ? AppColors.kHabitOrange : AppColors.kHabitDark,
          child: Icon(Icons.add, color: appStore.isDarkMode ? AppColors.kHabitDark : Colors.white),
        ),
      ),
      body: StreamBuilder<List<SubscriptionModel>>(
        stream: subscriptionService.subscription(),
        builder: (_, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.length == 0) {
              return noDataWidget(context).center();
            }

            return ListView.builder(
              padding: EdgeInsets.only(top: 8),
              shrinkWrap: true,
              itemCount: snapshot.data!.length,
              itemBuilder: (_, index) {
                SubscriptionModel data = snapshot.data![index];

                checkRecurringSubDate(subModel: data);

                return InkWell(
                  borderRadius: BorderRadius.circular(defaultRadius),
                  onTap: () {
                    SubscriptionDetailScreen(model: snapshot.data![index]).launch(context);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: getColorFromHex(data.color!),
                      border: Border.all(color: AppColors.grayColor.withOpacity(0.3)),
                      borderRadius: BorderRadius.circular(defaultRadius),
                    ),
                    child: Stack(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(data.name.validate(),
                                    style: boldTextStyle(size: 20, color: getColorFromHex(data.color!).isDark() ? Colors.white.withOpacity(0.85) : Colors.black), maxLines: 1, overflow: TextOverflow.ellipsis),
                                16.width,
                                Text(data.description.validate(),
                                    style: primaryTextStyle(color: getColorFromHex(data.color!).isDark() ? Colors.white.withOpacity(0.85) : Colors.black), maxLines: 1, overflow: TextOverflow.ellipsis),
                              ],
                            ).expand(),
                            Text('$ringgit_icon ${data.amount.validate()}',
                                style: boldTextStyle(size: 20, color: getColorFromHex(data.color!).isDark() ? Colors.white.withOpacity(0.85) : Colors.black), maxLines: 1, overflow: TextOverflow.ellipsis),
                          ],
                        ).paddingOnly(left: 16, top: 8, right: 16, bottom: 8),
                        data.firstPayDate == null && data.dueDate!.isBefore(DateTime.now())
                            ? Container(
                                width: context.width(),
                                color: AppColors.kHabitDark.withOpacity(0.7),
                                child: Text(expired, style: boldTextStyle(color: Colors.white)).paddingAll(24).center(),
                              ).cornerRadiusWithClipRRect(defaultRadius).center()
                            : SizedBox(),
                      ],
                    ),
                  ),
                ).paddingOnly(left: 16, top: 8, right: 16, bottom: 8);
              },
            );
          } else {
            return snapWidgetHelper(snapshot);
          }
        },
      ),
    );
  }

  Future<void> checkRecurringSubDate({required SubscriptionModel subModel}) async {
    if (subModel.nextPayDate != null && subModel.nextPayDate!.isBefore(DateTime.now())) {
      if (subModel.durationUnit == DAY) {
        subModel.nextPayDate = subModel.nextPayDate!.add(Duration(days: subModel.duration!));
      } else if (subModel.durationUnit == WEEK) {
        subModel.nextPayDate = subModel.nextPayDate!.add(Duration(days: 7 * subModel.duration!));
      } else if (subModel.durationUnit == MONTH) {
        subModel.nextPayDate = subModel.nextPayDate!.add(Duration(days: 30 * subModel.duration!));
      } else if (subModel.durationUnit == YEAR) {
        subModel.nextPayDate = subModel.nextPayDate!.add(Duration(days: 365 * subModel.duration!));
      }
    }

    await subscriptionService.updateDocument({'nextPayDate': subModel.nextPayDate}, subModel.id).then((value) {
      //
    }).catchError((error) {
      toast(error.toString());
    });
  }
}
