abstract class ChatStates{}

class ChatInitialState extends ChatStates{}

class ChatCurrentIndexState extends ChatStates{}
class ChatRegisterUserState extends ChatStates{}
class ChatLoginUserState extends ChatStates{}
class ChatForgotPasswordState extends ChatStates{}
class ChatSignInWithGoogleLoadingState extends ChatStates{}
class ChatSignInWithGoogleSuccessState extends ChatStates{}
class ChatSignInWithFacebookLoadingState extends ChatStates{}
class ChatSignInWithFacebookSuccessState extends ChatStates{}
class ChatSetSocialAuthDataInFirestoreState extends ChatStates{}
class ChatGetAllUserDataState extends ChatStates{}
class ChatGetAllFriendsDataLoadingState extends ChatStates{}
class ChatGetAllFriendsDataSuccessState extends ChatStates{}
class ChatGetCurrentUserDataState extends ChatStates{}
class ChatPickImageState extends ChatStates{}
class ChatUploadImageState extends ChatStates{}
class ChatUpdateUserDataState extends ChatStates{}
class ChatLogoutUserDataState extends ChatStates{}
class ChatFutureDelayedState extends ChatStates{}
class ChatDisableButtonProfileState extends ChatStates{}
class ChatEnableButtonProfileState extends ChatStates{}
class ChatSendMessageState extends ChatStates{}
class ChatReceiverMessageState extends ChatStates{}
class ChatGetAllUsersWithRefreshState extends ChatStates{}
class ChatgetChatsListUidUsersState extends ChatStates{}
class ChatUserOnlineStatusState extends ChatStates{}
class ChatUserOfflineStatusState extends ChatStates{}
class ChatMessageReadTrueState extends ChatStates{}
class ChatMessageReadFalseState extends ChatStates{}
class ChatUnreadMessageState extends ChatStates{}
class ChatFCMChatMessageState extends ChatStates{}
class ChatOpenMessageFriendsScreenFCMState extends ChatStates{}
