import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';
import 'package:mighty_notes/main.dart';
import 'package:mighty_notes/model/subscription_model.dart';
import 'package:mighty_notes/utils/Colors.dart';
import 'package:mighty_notes/utils/Common.dart';
import 'package:mighty_notes/utils/Constants.dart';
import 'package:mighty_notes/utils/StringConstant.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../utils/Common.dart';

class AddSubscriptionReminderScreen extends StatefulWidget {
  final SubscriptionModel? subscriptionModel;

  AddSubscriptionReminderScreen({this.subscriptionModel});

  @override
  AddSubscriptionReminderScreenState createState() => AddSubscriptionReminderScreenState();
}

class AddSubscriptionReminderScreenState extends State<AddSubscriptionReminderScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController amountController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController durationController = TextEditingController();
  TextEditingController firstPaymentController = TextEditingController();
  TextEditingController paymentMethodController = TextEditingController();
  TextEditingController expiryDateController = TextEditingController();

  FocusNode amountFocus = FocusNode();
  FocusNode nameFocus = FocusNode();
  FocusNode descriptionFocus = FocusNode();

  String? durationUnit = DAY;
  bool mRecurring = true;
  bool mIsUpdate = false;

  Color? reminderColor;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    mIsUpdate = widget.subscriptionModel != null;
    reminderColor = Colors.white;

    if (mIsUpdate) {
      amountController.text = widget.subscriptionModel!.amount!;
      nameController.text = widget.subscriptionModel!.name!;
      descriptionController.text = widget.subscriptionModel!.description!;
      paymentMethodController.text = widget.subscriptionModel!.paymentMethod!;
      reminderColor = getColorFromHex(widget.subscriptionModel!.color!);

      if (widget.subscriptionModel!.dueDate != null) {
        mRecurring = false;
        expiryDateController.text = DateFormat(date_format).format(widget.subscriptionModel!.dueDate!);
      } else {
        mRecurring = true;
        firstPaymentController.text = DateFormat(date_format).format(widget.subscriptionModel!.firstPayDate!);
        durationController.text = widget.subscriptionModel!.duration.toString();
        durationUnit = widget.subscriptionModel!.durationUnit;
      }
      setState(() {});
    }
  }

  Future<void> showDateFrom() async {
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(Duration(days: 1)),
      firstDate: DateTime(2019),
      lastDate: DateTime(2222),
      builder: (BuildContext context, Widget? child) {
        return appStore.isDarkMode
            ? Theme(
                data: ThemeData.dark().copyWith(
                  colorScheme: ColorScheme.fromSwatch(
                    primarySwatch: Colors.amber,
                  ),
                  dialogBackgroundColor: Colors.white,
                ),
                child: child!,
              )
            : Theme(
                data: ThemeData.light().copyWith(
                  colorScheme: ColorScheme.fromSwatch(
                    primarySwatch: Colors.teal,
                  ),
                  dialogBackgroundColor: Colors.white,
                ),
                child: child!,
              );
      },
    );
    if (date != null) {
      if (mRecurring) {
        firstPaymentController.text = DateFormat(date_format).format(date);
      } else {
        expiryDateController.text = DateFormat(date_format).format(date);
      }

      setState(() {});
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Text(add_subscription),
        actions: [
          mIsUpdate
              ? TextButton(
                  onPressed: () {
                    subscriptionService.removeDocument(widget.subscriptionModel!.id).then((value) {
                      finish(context);
                      finish(context);
                    }).catchError((error) {
                      toast(error);
                    });
                  },
                  child: Text(delete, style: boldTextStyle()),
                ).paddingOnly(right: 16)
              : SizedBox(),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 180,
                        width: context.width(),
                        decoration: BoxDecoration(color: reminderColor, border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(defaultRadius)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AppTextField(
                              maxLength: 10,
                              autoFocus: mIsUpdate ? false : true,
                              textFieldType: TextFieldType.PHONE,
                              focus: amountFocus,
                              nextFocus: nameFocus,
                              cursorColor: Colors.blueAccent,
                              controller: amountController,
                              textStyle: primaryTextStyle(size: 40, color: reminderColor!.isDark() ? Colors.white.withOpacity(0.85) : Colors.black),
                              textAlign: TextAlign.center,
                              errorThisFieldRequired: errorThisFieldRequired,
                              decoration: InputDecoration(
                                counterText: '',
                                hintText: '00.0',
                                hintStyle: secondaryTextStyle(size: 40),
                                border: InputBorder.none,
                              ),
                            ).center(),
                            Text(INR, style: boldTextStyle(size: 30, color: reminderColor!.isDark() ? Colors.white.withOpacity(0.85) : Colors.black)),
                          ],
                        ),
                      ),
                      16.height,
                      Text(name, style: boldTextStyle()),
                      8.height,
                      AppTextField(
                        focus: nameFocus,
                        nextFocus: descriptionFocus,
                        controller: nameController,
                        cursorColor: Colors.blueAccent,
                        textFieldType: TextFieldType.NAME,
                        decoration: subscriptionInputDecoration(name: 'e.g. Netflix'),
                      ).cornerRadiusWithClipRRect(defaultRadius),
                      8.height,
                      Text(description, style: boldTextStyle()),
                      8.height,
                      AppTextField(
                        focus: descriptionFocus,
                        controller: descriptionController,
                        cursorColor: Colors.blueAccent,
                        textFieldType: TextFieldType.NAME,
                        decoration: subscriptionInputDecoration(name: 'e.g. Premium plan'),
                        isValidationRequired: false,
                      ).cornerRadiusWithClipRRect(defaultRadius),
                    ],
                  ).paddingOnly(left: 16, right: 16, top: 16),
                  16.height,
                  Divider(thickness: 1),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            padding: EdgeInsets.all(8),
                            child: Text(recurring,
                                style: boldTextStyle(
                                    color: mRecurring
                                        ? appStore.isDarkMode
                                            ? AppColors.kHabitOrange
                                            : AppColors.kHabitDark
                                        : Colors.grey)),
                          ).onTap(() {
                            mRecurring = true;
                            setState(() {});
                          }),
                          Container(
                            padding: EdgeInsets.all(8),
                            child: Text(
                              one_time,
                              style: boldTextStyle(
                                  color: mRecurring
                                      ? Colors.grey
                                      : appStore.isDarkMode
                                          ? AppColors.kHabitOrange
                                          : AppColors.kHabitDark),
                            ),
                          ).onTap(() {
                            mRecurring = false;
                            setState(() {});
                          })
                        ],
                      ),
                      16.height,
                      mRecurring
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(billing_period, style: boldTextStyle()),
                                8.height,
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Every', style: primaryTextStyle()),
                                    16.width,
                                    AppTextField(
                                      controller: durationController,
                                      cursorColor: blueButtonColor,
                                      textStyle: primaryTextStyle(),
                                      textFieldType: TextFieldType.PHONE,
                                      decoration: subscriptionInputDecoration(name: '1'),
                                    ).cornerRadiusWithClipRRect(defaultRadius).expand(),
                                    16.width,
                                    Container(
                                      padding: EdgeInsets.only(left: 8, right: 8),
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Colors.grey.withOpacity(0.2)),
                                      child: DropdownButton<String>(
                                        value: durationUnit,
                                        isExpanded: true,
                                        underline: SizedBox(),
                                        icon: Icon(Icons.arrow_drop_down),
                                        iconSize: 24,
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            durationUnit = newValue;
                                          });
                                        },
                                        items: <String>[DAY, WEEK, MONTH, YEAR].map<DropdownMenuItem<String>>((String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value, style: primaryTextStyle()),
                                          );
                                        }).toList(),
                                      ),
                                    ).expand(flex: 2)
                                  ],
                                ),
                                8.height,
                                Text(first_payment, style: boldTextStyle()),
                                8.height,
                                AppTextField(
                                  onTap: () {
                                    showDateFrom();
                                  },
                                  controller: firstPaymentController,
                                  cursorColor: blueButtonColor,
                                  textFieldType: TextFieldType.NAME,
                                  decoration: subscriptionInputDecoration(name: 'e.g. $date_format'),
                                ).cornerRadiusWithClipRRect(defaultRadius),
                              ],
                            ).paddingOnly(left: 16, right: 16, bottom: 16)
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(exp_date, style: boldTextStyle()),
                                8.height,
                                AppTextField(
                                  onTap: () {
                                    showDateFrom();
                                  },
                                  controller: expiryDateController,
                                  cursorColor: blueButtonColor,
                                  textFieldType: TextFieldType.NAME,
                                  decoration: subscriptionInputDecoration(name: 'e.g. $date_format'),
                                ).cornerRadiusWithClipRRect(defaultRadius),
                              ],
                            ).paddingOnly(left: 16, right: 16, bottom: 16),
                      Divider(thickness: 1),
                      8.height,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(pay_method, style: boldTextStyle()),
                          8.height,
                          AppTextField(
                            controller: paymentMethodController,
                            cursorColor: blueButtonColor,
                            textFieldType: TextFieldType.NAME,
                            decoration: subscriptionInputDecoration(name: 'e.g. Credit Card'),
                            isValidationRequired: false,
                          ).cornerRadiusWithClipRRect(defaultRadius),
                          16.height,
                          4.height,
                          Container(
                            width: context.width(),
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(color: reminderColor, border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(defaultRadius)),
                            child: Text(select_color, style: primaryTextStyle(color: reminderColor!.isDark() ? Colors.white.withOpacity(0.85) : Colors.black), textAlign: TextAlign.center),
                          ).onTap(() {
                            selectColorDialog();
                          }),
                          16.height,
                          AppButton(
                            color: appStore.isDarkMode ? AppColors.kHabitOrange : AppColors.kHabitDark,
                            width: context.width(),
                            onTap: () {
                              addSubscriptionReminder().then((value) {
                                //
                              }).catchError((error) {
                                appStore.setLoading(false);
                                toast(error.toString());
                              });
                            },
                            child: Text(mIsUpdate ? update : save, style: boldTextStyle(color: appStore.isDarkMode ? AppColors.kHabitDark : Colors.white)),
                          ),
                        ],
                      ).paddingOnly(left: 16, right: 16, bottom: 16),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Observer(builder: (_) => Loader(color: appStore.isDarkMode ? AppColors.kHabitDark : AppColors.kHabitOrange).center().visible(appStore.isLoading))
        ],
      ),
    );
  }

  Future<void> addSubscriptionReminder() async {
    if (_formKey.currentState!.validate()) {
      appStore.setLoading(true);

      SubscriptionModel model = SubscriptionModel();
      model.amount = amountController.text.validate();
      model.name = nameController.text.validate();
      model.description = descriptionController.text.validate();

      if (reminderColor != null) {
        model.color = reminderColor!.toHex().toString();
      } else {
        model.color = Colors.white.toHex();
      }

      if (mRecurring) {
        var firstDate = DateTime.parse(firstPaymentController.text.trim().validate());

        model.firstPayDate = firstDate;
        model.duration = durationController.text.toInt(defaultValue: 1).validate();
        model.durationUnit = durationUnit.validate();

        if (model.durationUnit == DAY) {
          model.nextPayDate = firstDate.add(Duration(days: model.duration!));
        } else if (model.durationUnit == WEEK) {
          model.nextPayDate = firstDate.add(Duration(days: 7 * model.duration!));
        } else if (model.durationUnit == MONTH) {
          model.nextPayDate = firstDate.add(Duration(days: 30 * model.duration!));
        } else if (model.durationUnit == YEAR) {
          model.nextPayDate = firstDate.add(Duration(days: 365 * model.duration!));
        }
      } else {
        model.dueDate = DateTime.parse(expiryDateController.text.trim().validate());
      }

      model.paymentMethod = paymentMethodController.text.validate();
      model.userId = getStringAsync(USER_ID);

      if (mIsUpdate) {
        model.id = widget.subscriptionModel!.id;

        subscriptionService.updateDocument(model.toJson(), model.id).then((value) {
          finish(context, model);

          appStore.setLoading(false);
        }).catchError((error) {
          appStore.setLoading(false);

          toast(error.toString());
        });
      } else {
        subscriptionService.addDocument(model.toJson()).then((value) {
          finish(context);

          appStore.setLoading(false);
        }).catchError((error) {
          appStore.setLoading(false);

          toast(error.toString());
        });
      }
    }
  }

  selectColorDialog() {
    return showInDialog(
      context,
      title: Text(select_color),
      contentPadding: EdgeInsets.zero,
      child: SelectNoteColor(onTap: (color) {
        setState(() {
          reminderColor = color;
          finish(context);
        });
      }).paddingAll(16),
    );
  }
}
