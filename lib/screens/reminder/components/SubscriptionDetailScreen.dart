import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../configs/constants.dart';
import '../../../models/subscription_model.dart';
import 'AddSubscriptionReminderScreen.dart';
import 'NotificationScreen.dart';

// ignore: must_be_immutable
class SubscriptionDetailScreen extends StatefulWidget {
  SubscriptionModel? model;

  SubscriptionDetailScreen({this.model});

  @override
  SubscriptionDetailScreenState createState() => SubscriptionDetailScreenState();
}

class SubscriptionDetailScreenState extends State<SubscriptionDetailScreen> {

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Text(subscription_detail, style: boldTextStyle()),
      ),
      body: Container(
        height: context.height(),
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: context.width(),
                    color: getColorFromHex(widget.model!.color!),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                                icon: Icon(Icons.close),
                                color: getColorFromHex(widget.model!.color!).isDark() ? Colors.white.withOpacity(0.85) : Colors.black,
                                onPressed: () {
                                  finish(context);
                                }),
                            PopupMenuButton(
                              onSelected: (dynamic value) async {
                                if (value == 1) {
                                  SubscriptionModel? res = await AddSubscriptionReminderScreen(subscriptionModel: widget.model)
                                      .launch(context, pageRouteAnimation: PageRouteAnimation.SlideBottomTop, duration: 500.microseconds);
                                  setState(() {
                                    widget.model = res ?? widget.model;
                                  });
                                } else if (value == 2) {
                                  if (widget.model!.firstPayDate == null && widget.model!.dueDate!.isBefore(DateTime.now())) {
                                    toastLong(subscription_exp);
                                  } else {
                                    NotificationScreen(subscriptionModel: widget.model).launch(context, pageRouteAnimation: PageRouteAnimation.SlideBottomTop, duration: 500.microseconds);
                                  }
                                }
                              },
                              icon: Icon(Icons.more_vert_rounded, color: getColorFromHex(widget.model!.color!).isDark() ? Colors.white.withOpacity(0.85) : Colors.black),
                              itemBuilder: (context) => [
                                PopupMenuItem(
                                  value: 1,
                                  child: Row(
                                    children: [
                                      Icon(Icons.edit),
                                      8.width,
                                      Text(edit, style: primaryTextStyle()),
                                    ],
                                  ),
                                ),
                                PopupMenuItem(
                                  value: 2,
                                  child: Row(
                                    children: [
                                      Icon(Icons.notifications_active_outlined),
                                      8.width,
                                      Text(notification, style: primaryTextStyle()),
                                    ],
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                        8.height,
                        Text(
                          widget.model!.name.validate(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: primaryTextStyle(
                            size: 24,
                            color: getColorFromHex(widget.model!.color!).isDark() ? Colors.white.withOpacity(0.85) : Colors.black,
                          ),
                        ),
                        4.height,
                        widget.model!.description!.isNotEmpty
                            ? Text(
                          widget.model!.description.validate(),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: primaryTextStyle(
                            size: 16,
                            color: getColorFromHex(widget.model!.color!).isDark() ? Colors.white.withOpacity(0.85) : Colors.black,
                          ),
                        )
                            : SizedBox(),
                        4.height,
                        Text(
                          '$ringgit_icon ${widget.model!.amount.validate()}',
                          style: boldTextStyle(
                            size: 32,
                            color: getColorFromHex(widget.model!.color!).isDark() ? Colors.white.withOpacity(0.85) : Colors.black,
                          ),
                        ),
                      ],
                    ).paddingBottom(32),
                  ).cornerRadiusWithClipRRect(defaultRadius),
                  16.height,
                  widget.model!.duration != null
                      ? Column(
                    children: [
                      Text(billing_period, style: primaryTextStyle()),
                      2.height,
                      Text('every ${widget.model!.duration.validate()}  ${widget.model!.durationUnit.validate()}', style: secondaryTextStyle()),
                    ],
                  )
                      : SizedBox(),
                  widget.model!.duration != null ? Divider(thickness: 1) : SizedBox(),
                  8.height,
                  widget.model!.firstPayDate != null
                      ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(next_payment, style: primaryTextStyle()),
                      2.height,
                      Text(DateFormat(date_format).format(widget.model!.nextPayDate!).toString().validate(), style: secondaryTextStyle()),
                      Divider(thickness: 1),
                    ],
                  )
                      : SizedBox(),
                  8.height,
                  Text(widget.model!.firstPayDate != null ? first_payment : exp_date, style: primaryTextStyle()),
                  2.height,
                  widget.model!.firstPayDate != null
                      ? Text(DateFormat(date_format).format(widget.model!.firstPayDate!).toString().validate(), style: secondaryTextStyle())
                      : Text(DateFormat(date_format).format(widget.model!.dueDate!).toString().validate(), style: secondaryTextStyle()),
                  Divider(thickness: 1),
                  8.height,
                  Text(pay_method, style: primaryTextStyle()),
                  2.height,
                  widget.model!.paymentMethod!.isNotEmpty ? Text(widget.model!.paymentMethod.validate(), style: secondaryTextStyle()) : Text('No $pay_method', style: secondaryTextStyle()),
                  Divider(thickness: 1),
                  Text(notification, style: primaryTextStyle()),
                  widget.model!.notificationId != null
                      ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${DateFormat(datetime_format).format(widget.model!.notificationDate!)}', style: secondaryTextStyle()),
                      Text('$ringgit_icon ${widget.model!.amount}', style: secondaryTextStyle()),
                    ],
                  )
                      : Text('No $notification', style: secondaryTextStyle()),
                ],
              ).paddingOnly(left: 16, right: 16, top: 16),
            ),
          ],
        ),
      ),
    );
  }
}
