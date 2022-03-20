class UnreadMessageCountModel{
  int? countUnreadMessage;
  String? isINChatScreen;


  UnreadMessageCountModel({
    this.countUnreadMessage,
    this.isINChatScreen,
});
  UnreadMessageCountModel.fromJson(Map<String,dynamic> json){
    countUnreadMessage = json['count_unread_message'];
    isINChatScreen = json['is_in_chat_screen'];

  }

  Map<String,dynamic> toJson() {
    return {
      'count_unread_message':countUnreadMessage,
      'is_in_chat_screen':isINChatScreen,
    };
  }

}