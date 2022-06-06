import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../../main.dart';
import '../../../configs/colors.dart';
import '../../../configs/common.dart';
import '../../../configs/constants.dart';
import '../../../models/subscription_model.dart';

/// Press the floating button to add a new subscription
class AddSubscriptionScreen extends StatefulWidget {
  final SubscriptionModel? subscriptionModel;

  AddSubscriptionScreen({this.subscriptionModel});

  @override
  AddSubscriptionScreenState createState() => AddSubscriptionScreenState();
}

class AddSubscriptionScreenState extends State<AddSubscriptionScreen> {
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
  bool kRecurring = true;
  bool kIsUpdate = false;

  Color? reminderColor;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    kIsUpdate = widget.subscriptionModel != null;
    reminderColor = Colors.white;

    if (kIsUpdate) {
      amountController.text = widget.subscriptionModel!.amount!;
      nameController.text = widget.subscriptionModel!.name!;
      descriptionController.text = widget.subscriptionModel!.description!;
      paymentMethodController.text = widget.subscriptionModel!.paymentMethod!;
      reminderColor = getColorFromHex(widget.subscriptionModel!.color!);

      if (widget.subscriptionModel!.dueDate != null) {
        kRecurring = false;
        expiryDateController.text =
            DateFormat(date_format).format(widget.subscriptionModel!.dueDate!);
      } else {
        kRecurring = true;
        firstPaymentController.text = DateFormat(date_format)
            .format(widget.subscriptionModel!.firstPayDate!);
        durationController.text = widget.subscriptionModel!.duration.toString();
        durationUnit = widget.subscriptionModel!.durationUnit;
      }
      setState(() {});
    }
  }

  /// Calendar
  Future<void> showDateFrom() async {
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(Duration(days: 1)),
      firstDate: DateTime(1990),
      lastDate: DateTime(2222),
      builder: (BuildContext context, Widget? child) {
        return appStore.isDarkMode
            ? Theme(
                data: ThemeData.dark().copyWith(
                  colorScheme: ColorScheme.fromSwatch(
                    brightness: Brightness.dark,
                    primarySwatch: Colors.deepOrange,
                  ),
                  dialogBackgroundColor: Colors.black,
                ),
                child: child!,
              )
            : Theme(
                data: ThemeData.light().copyWith(
                  colorScheme: ColorScheme.fromSwatch(
                    brightness: Brightness.light,
                    primarySwatch: Colors.deepOrange,
                  ),
                  dialogBackgroundColor: Colors.white,
                ),
                child: child!,
              );
      },
    );
    if (date != null) {
      if (kRecurring) {
        // format the date and return as date_format
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
        title: Text(add_new_subscription),
        actions: [
          kIsUpdate
              ? TextButton(
                  onPressed: () async {
                    bool deleted = await showInDialog(
                      context,
                      title: Text(
                        delete_sub,
                        style: TextStyle(
                          color: getBoolAsync(IS_DARK_MODE)
                              ? AppColors.kHabitOrange
                              : AppColors.kTextBlack,
                          fontWeight: TextFontWeight.bold,
                        ),
                      ),
                      child: Text(confirm_to_delete_sub,
                          style: primaryTextStyle()),
                      actions: [
                        TextButton(
                            onPressed: () {
                              finish(context, false);
                            },
                            child: Text(cancel, style: primaryTextStyle())),
                        TextButton(
                          onPressed: () {
                            finish(context, true);
                          },
                          child: Text(
                            delete,
                            style: primaryTextStyle(
                              color: AppColors.kHabitOrange,
                            ),
                          ),
                        ),
                      ],
                    );
                    if (deleted) {
                      subscriptionService
                          .removeDocument(widget.subscriptionModel!.id)
                          .then((value) {
                        finish(context);
                        finish(context);
                        toast('Subscription deleted');
                      }).catchError((error) {
                        toast(error);
                      });
                    }
                  },
                  child: Text(delete2, style: boldTextStyle(color: Colors.red)),
                ).paddingOnly(right: 16)
              : SizedBox(),
        ],
      ),
      body: GestureDetector(
        // Dismiss the keyboard when the tap is outside events
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Stack(
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
                          decoration: BoxDecoration(
                              color: reminderColor,
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius:
                                  BorderRadius.circular(defaultRadius)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              /// Price card
                              AppTextField(
                                maxLength: 10,
                                autoFocus: kIsUpdate ? false : true,
                                textFieldType: TextFieldType.PHONE,
                                focus: amountFocus,
                                nextFocus: nameFocus,
                                cursorColor: AppColors.kHabitOrange,
                                controller: amountController,
                                textStyle: primaryTextStyle(
                                    size: 40,
                                    color: reminderColor!.isDark()
                                        ? Colors.white.withOpacity(0.85)
                                        : Colors.black),
                                textAlign: TextAlign.center,
                                errorThisFieldRequired: errorThisFieldRequired,
                                decoration: InputDecoration(
                                  counterText: '',
                                  hintText: '00.0',
                                  hintStyle: secondaryTextStyle(size: 40),
                                  border: InputBorder.none,
                                ),
                              ).center(),
                              Text(MYR,
                                  style: boldTextStyle(
                                      size: 30,
                                      color: reminderColor!.isDark()
                                          ? Colors.white.withOpacity(0.85)
                                          : Colors.black)),
                            ],
                          ),
                        ),
                        16.height,

                        /// Colour for the card
                        Container(
                          width: context.width(),
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                              color: reminderColor,
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius:
                                  BorderRadius.circular(defaultRadius)),
                          child: Text(select_colour2,
                              style: primaryTextStyle(
                                  color: reminderColor!.isDark()
                                      ? Colors.white.withOpacity(0.85)
                                      : Colors.black),
                              textAlign: TextAlign.center),
                        ).onTap(() {
                          selectColorDialog();
                        }),
                        16.height,

                        /// Name
                        Text(name, style: boldTextStyle()),
                        10.height,
                        AppTextField(
                          focus: nameFocus,
                          nextFocus: descriptionFocus,
                          controller: nameController,
                          textFieldType: TextFieldType.NAME,
                          decoration:
                              subscriptionInputDecoration(name: 'e.g. Spotify'),
                        ).cornerRadiusWithClipRRect(defaultRadius),
                        12.height,

                        /// Description
                        Text(description, style: boldTextStyle()),
                        10.height,
                        AppTextField(
                          focus: descriptionFocus,
                          controller: descriptionController,
                          textFieldType: TextFieldType.NAME,
                          decoration:
                              subscriptionInputDecoration(name: 'e.g. Premium'),
                          isValidationRequired: false,
                        ).cornerRadiusWithClipRRect(defaultRadius),
                      ],
                    ).paddingOnly(left: 16, right: 16, top: 16),
                    16.height,
                    Divider(thickness: 1),

                    /// Recurring and one time tab
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
                                      color: kRecurring
                                          ? appStore.isDarkMode
                                              ? AppColors.kHabitOrange
                                              : AppColors.kHabitDark
                                          : Colors.grey)),
                            ).onTap(() {
                              kRecurring = true;
                              setState(() {});
                            }),
                            Container(
                              padding: EdgeInsets.all(8),
                              child: Text(
                                one_time,
                                style: boldTextStyle(
                                    color: kRecurring
                                        ? Colors.grey
                                        : appStore.isDarkMode
                                            ? AppColors.kHabitOrange
                                            : AppColors.kHabitDark),
                              ),
                            ).onTap(() {
                              kRecurring = false;
                              setState(() {});
                            })
                          ],
                        ),
                        16.height,

                        /// Billing period
                        kRecurring
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(billing_period, style: boldTextStyle()),
                                  10.height,
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Every', style: primaryTextStyle()),
                                      16.width,
                                      AppTextField(
                                        controller: durationController,
                                        cursorColor: AppColors.kHabitOrange,
                                        textStyle: primaryTextStyle(),
                                        textFieldType: TextFieldType.PHONE,
                                        decoration: subscriptionInputDecoration(
                                            name: '1'),
                                      )
                                          .cornerRadiusWithClipRRect(
                                              defaultRadius)
                                          .expand(),
                                      16.width,

                                      /// Drop down selection
                                      Container(
                                        padding:
                                            EdgeInsets.only(left: 8, right: 8),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            color:
                                                Colors.grey.withOpacity(0.2)),
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
                                          items: <String>[
                                            DAY,
                                            WEEK,
                                            MONTH,
                                            YEAR
                                          ].map<DropdownMenuItem<String>>(
                                              (String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value,
                                                  style: primaryTextStyle()),
                                            );
                                          }).toList(),
                                        ),
                                      ).expand(flex: 1)
                                    ],
                                  ),
                                  12.height,

                                  /// First payment
                                  Text(first_payment, style: boldTextStyle()),
                                  10.height,
                                  AppTextField(
                                    onTap: () {
                                      showDateFrom();
                                    },
                                    controller: firstPaymentController,
                                    cursorColor: AppColors.kHabitOrange,
                                    textFieldType: TextFieldType.NAME,
                                    decoration: subscriptionInputDecoration(
                                        name: 'e.g. $date_format'),
                                  ).cornerRadiusWithClipRRect(defaultRadius),
                                ],
                              ).paddingOnly(left: 16, right: 16, bottom: 16)

                            /// Expiry date if choose one time
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(exp_date, style: boldTextStyle()),
                                  10.height,
                                  AppTextField(
                                    onTap: () {
                                      showDateFrom();
                                    },
                                    controller: expiryDateController,
                                    cursorColor: AppColors.kHabitOrange,
                                    textFieldType: TextFieldType.NAME,
                                    decoration: subscriptionInputDecoration(
                                        name: 'e.g. $date_format'),
                                  ).cornerRadiusWithClipRRect(defaultRadius),
                                ],
                              ).paddingOnly(left: 16, right: 16, bottom: 16),
                        Divider(thickness: 1),
                        12.height,

                        /// Enter payment method
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(pay_method, style: boldTextStyle()),
                            10.height,
                            AppTextField(
                              controller: paymentMethodController,
                              cursorColor: AppColors.kHabitOrange,
                              textFieldType: TextFieldType.NAME,
                              decoration: subscriptionInputDecoration(
                                  name: 'e.g. Gift card'),
                              isValidationRequired: false,
                            ).cornerRadiusWithClipRRect(defaultRadius),
                            12.height,

                            /// Save button
                            AppButton(
                              color: AppColors.kHabitOrange,
                              width: context.width(),
                              onTap: () {
                                addSubscriptionReminder().then((value) {
                                  //
                                }).catchError((error) {
                                  appStore.setLoading(false);
                                  toast(error.toString());
                                });
                              },
                              child: Text(kIsUpdate ? update : save,
                                  style: boldTextStyle(
                                      color: appStore.isDarkMode
                                          ? AppColors.kHabitDark
                                          : Colors.white)),
                            ),
                          ],
                        ).paddingOnly(left: 16, right: 16, bottom: 16),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            /// Mobx observer
            Observer(
                builder: (_) => Loader(
                        color: appStore.isDarkMode
                            ? AppColors.kHabitDark
                            : AppColors.kHabitOrange)
                    .center()
                    .visible(appStore.isLoading))
          ],
        ),
      ),
    );
  }

  /// Save to Firebase
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

      if (kRecurring) {
        var firstDate =
            DateTime.parse(firstPaymentController.text.trim().validate());

        model.firstPayDate = firstDate;
        model.duration =
            durationController.text.toInt(defaultValue: 1).validate();
        model.durationUnit = durationUnit.validate();

        if (model.durationUnit == DAY) {
          model.nextPayDate = firstDate.add(Duration(days: model.duration!));
        } else if (model.durationUnit == WEEK) {
          model.nextPayDate =
              firstDate.add(Duration(days: 7 * model.duration!));
        } else if (model.durationUnit == MONTH) {
          model.nextPayDate =
              firstDate.add(Duration(days: 30 * model.duration!));
        } else if (model.durationUnit == YEAR) {
          model.nextPayDate =
              firstDate.add(Duration(days: 365 * model.duration!));
        }
      } else {
        model.dueDate =
            DateTime.parse(expiryDateController.text.trim().validate());
      }

      model.paymentMethod = paymentMethodController.text.validate();
      model.userId = getStringAsync(USER_ID);

      if (kIsUpdate) {
        model.id = widget.subscriptionModel!.id;

        subscriptionService
            .updateDocument(model.toJson(), model.id)
            .then((value) {
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

  /// Colour the card
  selectColorDialog() {
    return showInDialog(
      context,
      title: Text(select_colour),
      contentPadding: EdgeInsets.all(8),
      builder: (_) => new SelectNoteColor(onTap: (color) {
        setState(() {
          reminderColor = color;
          finish(context);
        });
      }).paddingAll(16),
    );
  }
}
