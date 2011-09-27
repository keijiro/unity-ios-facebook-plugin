// Facebook SDK へのアクセスを簡略化するドライバー

#import "FBConnect.h"

@interface FacebookDriver : NSObject<FBDialogDelegate, FBSessionDelegate, FBRequestDelegate> {
@private
    Facebook *facebook_;
    NSString *userNameInternal_;
    NSMutableDictionary *shareAfterLogin_;
    BOOL visible_;
}

// Facebookオブジェクトへの直接アクセス
@property (readonly) Facebook *facebook;

// ユーザー名：サインアウト時はnilを返す。
@property (readonly) NSString *userName;

// ダイアログの表示状態
@property (readonly) BOOL visible;

// App ID 指定のイニシャライザ
- (id)initWithAppID:(NSString *)appID;

// サインアウトする。
- (void)signOut;

// サインインする。
- (void)signIn;

// ダイアログを起動する。
- (void)launchDialog:(NSMutableDictionary *)params;

@end
