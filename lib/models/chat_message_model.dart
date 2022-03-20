class ChatMessageModel{
  String? senderId;
  String? receiverId;
  String? time;
  String? text;

  ChatMessageModel({
    this.senderId,
    this.receiverId,
    this.time,
    this.text,


});
  ChatMessageModel.fromJson(Map<String,dynamic> json){
    senderId = json['senderId'];
    receiverId = json['receiverId'];
    time = json['time'];
    text = json['text'];


  }

  Map<String,dynamic> toJson() {
    return {
      'senderId':senderId,
      'receiverId':receiverId,
      'time':time,
      'text':text,

    };
  }

}