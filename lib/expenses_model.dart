// To parse this JSON data, do
//
//     final expensesResponse = expensesResponseFromJson(jsonString);

import 'dart:convert';

List<ExpensesResponse> expensesResponseFromJson(String str) =>
    List<ExpensesResponse>.from(
        json.decode(str).map((x) => ExpensesResponse.fromJson(x)));

String expensesResponseToJson(List<ExpensesResponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ExpensesResponse {
  ExpensesResponse({
    required this.id,
    required this.groupId,
    required this.friendshipId,
    required this.expenseBundleId,
    required this.description,
    required this.repeats,
    required this.repeatInterval,
    required this.emailReminder,
    required this.emailReminderInAdvance,
    required this.nextRepeat,
    required this.details,
    required this.commentsCount,
    required this.payment,
    required this.creationMethod,
    required this.transactionMethod,
    required this.transactionConfirmed,
    required this.transactionId,
    required this.transactionStatus,
    required this.cost,
    required this.currencyCode,
    required this.repayments,
    required this.date,
    required this.createdAt,
    required this.createdBy,
    required this.updatedAt,
    required this.updatedBy,
    required this.deletedAt,
    required this.deletedBy,
    required this.category,
    required this.receipt,
    required this.users,
  });

  int? id;
  int? groupId;
  int? friendshipId;
  dynamic expenseBundleId;
  String? description;
  bool? repeats;
  dynamic repeatInterval;
  bool? emailReminder;
  int? emailReminderInAdvance;
  dynamic nextRepeat;
  dynamic details;
  int? commentsCount;
  bool? payment;
  String? creationMethod;
  String? transactionMethod;
  bool? transactionConfirmed;
  dynamic transactionId;
  dynamic transactionStatus;
  String? cost;
  String? currencyCode;
  List<Repayment> repayments;
  String date;
  String createdAt;
  CreatedBy? createdBy;
  String updatedAt;
  CreatedBy? updatedBy;
  dynamic deletedAt;
  dynamic deletedBy;
  Category category;
  Receipt receipt;
  List<User> users;

  factory ExpensesResponse.fromJson(Map<String, dynamic> json) =>
      ExpensesResponse(
        id: json["id"],
        groupId: json["group_id"],
        friendshipId: json["friendship_id"],
        expenseBundleId: json["expense_bundle_id"],
        description: json["description"],
        repeats: json["repeats"],
        repeatInterval: json["repeat_interval"],
        emailReminder: json["email_reminder"],
        emailReminderInAdvance: json["email_reminder_in_advance"],
        nextRepeat: json["next_repeat"],
        details: json["details"],
        commentsCount: json["comments_count"],
        payment: json["payment"],
        creationMethod: json["creation_method"],
        transactionMethod: json["transaction_method"],
        transactionConfirmed: json["transaction_confirmed"],
        transactionId: json["transaction_id"],
        transactionStatus: json["transaction_status"],
        cost: json["cost"],
        currencyCode: json["currency_code"],
        repayments: List<Repayment>.from(
            json["repayments"].map((x) => Repayment.fromJson(x))),
        date: json["date"],
        createdAt: json["created_at"],
        createdBy: CreatedBy.fromJson(json["created_by"] ?? {}),
        updatedAt: json['updated_at'],
        updatedBy: CreatedBy.fromJson(json["updated_by"] ?? {}),
        deletedAt: json["deleted_at"],
        deletedBy: json["deleted_by"],
        category: Category.fromJson(json["category"]),
        receipt: Receipt.fromJson(json["receipt"]),
        users: List<User>.from(json["users"].map((x) => User.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "group_id": groupId,
        "friendship_id": friendshipId,
        "expense_bundle_id": expenseBundleId,
        "description": description,
        "repeats": repeats,
        "repeat_interval": repeatInterval,
        "email_reminder": emailReminder,
        "email_reminder_in_advance": emailReminderInAdvance,
        "next_repeat": nextRepeat,
        "details": details,
        "comments_count": commentsCount,
        "payment": payment,
        "creation_method": creationMethod,
        "transaction_method": transactionMethod,
        "transaction_confirmed": transactionConfirmed,
        "transaction_id": transactionId,
        "transaction_status": transactionStatus,
        "cost": cost,
        "currency_code": currencyCode,
        "repayments": List<dynamic>.from(repayments.map((x) => x.toJson())),
        "date": date,
        "created_at": createdAt,
        "created_by": createdBy!.toJson(),
        "updated_at": updatedAt,
        "updated_by": updatedBy!.toJson(),
        "deleted_at": deletedAt,
        "deleted_by": deletedBy,
        "category": category.toJson(),
        "receipt": receipt.toJson(),
        "users": List<dynamic>.from(users.map((x) => x.toJson())),
      };
}

class Category {
  Category({
    required this.id,
    required this.name,
  });

  int id;
  String name;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}

class CreatedBy {
  CreatedBy({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.picture,
    required this.customPicture,
  });

  int id;
  String firstName;
  String lastName;
  Picture picture;
  bool customPicture;

  factory CreatedBy.fromJson(Map<String, dynamic> json) => CreatedBy(
        id: json["id"] ?? 0,
        firstName: json["first_name"] ?? "",
        lastName: json["last_name"] ?? '',
        picture: Picture.fromJson(json["picture"] ?? {}),
        customPicture: json["custom_picture"] ?? false,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "first_name": firstName,
        "last_name": lastName,
        "picture": picture.toJson(),
        "custom_picture": customPicture,
      };
}

class Picture {
  Picture({
    required this.medium,
  });

  String medium;

  factory Picture.fromJson(Map<String, dynamic> json) => Picture(
        medium: json["medium"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "medium": medium,
      };
}

class Receipt {
  Receipt({
    required this.large,
    required this.original,
  });

  dynamic large;
  dynamic original;

  factory Receipt.fromJson(Map<String, dynamic> json) => Receipt(
        large: json["large"],
        original: json["original"],
      );

  Map<String, dynamic> toJson() => {
        "large": large,
        "original": original,
      };
}

class Repayment {
  Repayment({
    required this.from,
    required this.to,
    required this.amount,
  });

  int from;
  int to;
  String amount;

  factory Repayment.fromJson(Map<String, dynamic> json) => Repayment(
        from: json["from"],
        to: json["to"],
        amount: json["amount"],
      );

  Map<String, dynamic> toJson() => {
        "from": from,
        "to": to,
        "amount": amount,
      };
}

class User {
  User({
    required this.user,
    required this.userId,
    required this.paidShare,
    required this.owedShare,
    required this.netBalance,
  });

  CreatedBy user;
  int userId;
  String paidShare;
  String owedShare;
  String netBalance;

  factory User.fromJson(Map<String, dynamic> json) => User(
        user: CreatedBy.fromJson(json["user"]),
        userId: json["user_id"],
        paidShare: json["paid_share"],
        owedShare: json["owed_share"],
        netBalance: json["net_balance"],
      );

  Map<String, dynamic> toJson() => {
        "user": user.toJson(),
        "user_id": userId,
        "paid_share": paidShare,
        "owed_share": owedShare,
        "net_balance": netBalance,
      };
}
