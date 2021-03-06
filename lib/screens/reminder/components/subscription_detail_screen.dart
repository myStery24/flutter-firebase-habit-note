import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../configs/constants.dart';
import '../../../models/subscription_model.dart';
import 'add_subscription_screen.dart';
import 'add_subscription_reminder_screen.dart';

// ignore: must_be_immutable
class SubscriptionDetailScreen extends StatefulWidget {
  SubscriptionModel? model;

  SubscriptionDetailScreen({this.model});

  @override
  SubscriptionDetailScreenState createState() =>
      SubscriptionDetailScreenState();
}

class SubscriptionDetailScreenState extends State<SubscriptionDetailScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {}

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
        title: Text(subscription_detail),
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
                            /// Close the current screen
                            IconButton(
                                icon: Icon(Icons.close),
                                color: getColorFromHex(widget.model!.color!)
                                        .isDark()
                                    ? Colors.white.withOpacity(0.85)
                                    : Colors.black,
                                onPressed: () {
                                  finish(context);
                                }),
                            PopupMenuButton(
                              onSelected: (dynamic value) async {
                                if (value == 1) {
                                  SubscriptionModel? res =
                                      await AddSubscriptionScreen(
                                              subscriptionModel: widget.model)
                                          .launch(context,
                                              pageRouteAnimation:
                                                  PageRouteAnimation
                                                      .SlideBottomTop,
                                              duration: 500.microseconds);
                                  setState(() {
                                    widget.model = res ?? widget.model;
                                  });
                                } else if (value == 2) {
                                  if (widget.model!.firstPayDate == null &&
                                      widget.model!.dueDate!
                                          .isBefore(DateTime.now())) {
                                    toastLong(subscription_exp);
                                  } else {
                                    AddSubscriptionReminderScreen(
                                            subscriptionModel: widget.model)
                                        .launch(context,
                                            pageRouteAnimation:
                                                PageRouteAnimation
                                                    .SlideBottomTop,
                                            duration: 500.microseconds);
                                  }
                                }
                              },

                              /// Show edit and add reminder options
                              icon: Icon(Icons.more_vert_rounded,
                                  color: getColorFromHex(widget.model!.color!)
                                          .isDark()
                                      ? Colors.white.withOpacity(0.85)
                                      : Colors.black),
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
                                      Text(reminder, style: primaryTextStyle()),
                                    ],
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                        8.height,

                        /// Subscription detail
                        /// Name
                        Text(
                          widget.model!.name.validate(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: primaryTextStyle(
                            size: 24,
                            color:
                                getColorFromHex(widget.model!.color!).isDark()
                                    ? Colors.white.withOpacity(0.85)
                                    : Colors.black,
                          ),
                        ),
                        4.height,

                        /// Description
                        widget.model!.description!.isNotEmpty
                            ? Text(
                                widget.model!.description.validate(),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: primaryTextStyle(
                                  size: 16,
                                  color: getColorFromHex(widget.model!.color!)
                                          .isDark()
                                      ? Colors.white.withOpacity(0.85)
                                      : Colors.black,
                                ),
                              )
                            : SizedBox(),
                        4.height,

                        /// Price
                        Text(
                          '$ringgit_icon ${widget.model!.amount.validate()}',
                          style: boldTextStyle(
                            size: 32,
                            color:
                                getColorFromHex(widget.model!.color!).isDark()
                                    ? Colors.white.withOpacity(0.85)
                                    : Colors.black,
                          ),
                        ),
                      ],
                    ).paddingBottom(32),
                  ).cornerRadiusWithClipRRect(defaultRadius),
                  16.height,

                  /// Billing period
                  widget.model!.duration != null
                      ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(billing_period, style: primaryTextStyle()),
                            8.height,
                            Text(
                                'Every ${widget.model!.duration.validate()}  ${widget.model!.durationUnit.validate()}',
                                style: secondaryTextStyle()),
                          ],
                        )
                      : SizedBox(),

                  /// Every ...
                  widget.model!.duration != null
                      ? Divider(thickness: 1)
                      : SizedBox(),
                  2.height,

                  /// Next payment
                  widget.model!.firstPayDate != null
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(next_payment, style: primaryTextStyle()),
                            8.height,
                            Text(
                                DateFormat(date_format)
                                    .format(widget.model!.nextPayDate!)
                                    .toString()
                                    .validate(),
                                style: secondaryTextStyle()),
                            Divider(thickness: 1),
                          ],
                        )
                      : SizedBox(),
                  2.height,

                  /// First payment
                  Text(
                      widget.model!.firstPayDate != null
                          ? first_payment
                          : exp_date,
                      style: primaryTextStyle()),
                  8.height,
                  widget.model!.firstPayDate != null
                      ? Text(
                          DateFormat(date_format)
                              .format(widget.model!.firstPayDate!)
                              .toString()
                              .validate(),
                          style: secondaryTextStyle())
                      : Text(
                          DateFormat(date_format)
                              .format(widget.model!.dueDate!)
                              .toString()
                              .validate(),
                          style: secondaryTextStyle()),
                  Divider(thickness: 1),
                  2.height,

                  /// Payment method
                  Text(pay_method, style: primaryTextStyle()),
                  8.height,
                  widget.model!.paymentMethod!.isNotEmpty
                      ? Text(widget.model!.paymentMethod.validate(),
                          style: secondaryTextStyle())
                      : Text('No $pay_method', style: secondaryTextStyle()),
                  Divider(thickness: 1),
                  2.height,

                  /// Reminder
                  Text(reminder, style: primaryTextStyle()),
                  8.height,
                  widget.model!.notificationId != null
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                                '${DateFormat(datetime_format).format(widget.model!.notificationDate!)}',
                                style: secondaryTextStyle()),
                            Text('$ringgit_icon ${widget.model!.amount}',
                                style: secondaryTextStyle()),
                          ],
                        )
                      : Text('No $reminder', style: secondaryTextStyle()),
                  2.height,
                ],
              ).paddingOnly(left: 16, right: 16, top: 16),
            ),
          ],
        ),
      ),
    );
  }
}
