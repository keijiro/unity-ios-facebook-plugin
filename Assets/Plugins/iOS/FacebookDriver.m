// Facebook SDK へのアクセスを簡略化するドライバー

#import "FacebookDriver.h"

// Defaults への保存時に使うキー
static NSString* kAccessTokenStore = @"FacebookAccessToken";
static NSString* kExpirationDayStore = @"FacebookExpirationDay";

// プライベート定義
@interface FacebookDriver ()

-(void)retrieveUserName; // ユーザー名の取得開始
-(void)showShareDialog:(NSMutableDictionary *)params; // 共有ダイアログの起動

@property (nonatomic, copy) NSString *userNameInternal;
@property (nonatomic, retain) NSMutableDictionary *shareAfterLogin;

@end

#pragma mark -

@implementation FacebookDriver

#pragma mark Property

@synthesize facebook = facebook_;                   // readonly
@synthesize visible = visible_;                     // readonly
@synthesize userNameInternal = userNameInternal_;   // copy
@synthesize shareAfterLogin = shareAfterLogin_;     // copy

- (NSString*)userName {
    return userNameInternal_;
}

#pragma mark - Object lifecycle

- (id)initWithAppID:(NSString *)appID {
    if ((self = [super init])) {
        facebook_ = [[Facebook alloc] initWithAppId:appID andDelegate:self];
        visible_ = NO;
        // Defaultからアクセス情報を復帰させる。
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        facebook_.accessToken = [defaults objectForKey:kAccessTokenStore];
        facebook_.expirationDate = [defaults objectForKey:kExpirationDayStore];
        // アクセス情報が不正ならば破棄する。
        if (![facebook_ isSessionValid]) {
            [defaults removeObjectForKey:kAccessTokenStore];
            [defaults removeObjectForKey:kExpirationDayStore];
        } else {
            // ユーザー情報の取得をリクエストしておく。
            [self retrieveUserName];
        }
    }
    return self;
}

- (void)dealloc {
    [facebook_ release];
    [userNameInternal_ release];
    [shareAfterLogin_ release];
    [super dealloc];
}

#pragma mark - Private method

- (void)retrieveUserName {
    // 仮の名前を設定しておく。
    self.userNameInternal = @"(retrieving username...)";
    // リクエストの発行。
    [facebook_ requestWithGraphPath:@"me" andDelegate:self];
}

- (void)showShareDialog:(NSMutableDictionary *)params {
    [facebook_ dialog:@"feed" andParams:params andDelegate:self];
}

#pragma mark - Public method

- (void)signOut {
    [facebook_ logout:self];
}

- (void)signIn {
    visible_ = YES;
    self.shareAfterLogin = nil;
    [facebook_ authorize:nil];
}

- (void)launchDialog:(NSMutableDictionary *)params {
    visible_ = YES;
    if (![facebook_ isSessionValid]) {
        self.shareAfterLogin = params;
	    [facebook_ authorize:nil];
    } else {
        [self showShareDialog:params];
    }
}

#pragma mark - FBSessionDelegate

- (void)fbDidLogin {
    // サインイン情報の保存。
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:facebook_.accessToken forKey:kAccessTokenStore];
    [defaults setObject:facebook_.expirationDate forKey:kExpirationDayStore];
    [defaults synchronize];
    // ユーザー情報の取得をリクエストしておく。
    [self retrieveUserName];
    // 終了、あるいはシェア画面への移行。
    if (self.shareAfterLogin) {
        [self showShareDialog:self.shareAfterLogin];
        self.shareAfterLogin = nil;
    } else {
        visible_ = NO;
    }
}

- (void)fbDidNotLogin:(BOOL)cancelled {
    self.shareAfterLogin = nil;
    visible_ = NO;
}

- (void)fbDidLogout {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:kAccessTokenStore];
    [defaults removeObjectForKey:kExpirationDayStore];
    [defaults synchronize];
    self.userNameInternal = nil;
}

#pragma mark - FBDialogDelegate

- (void)dialogDidComplete:(FBDialog *)dialog {
    visible_ = NO;
}

- (void)dialogDidNotComplete:(FBDialog *)dialog {
    visible_ = NO;
}

- (void)dialog:(FBDialog*)dialog didFailWithError:(NSError *)error {
    NSLog(@"FBDialog error - %@", error);
    visible_ = NO;
}

#pragma mark - FBRequestDelegate

- (void)request:(FBRequest *)request didReceiveResponse:(NSURLResponse *)response {
}

- (void)request:(FBRequest *)request didLoad:(id)result {
    // このDelegateはユーザー名の取得にのみ使うと前提している。
    self.userNameInternal = [result objectForKey:@"name"];
}

- (void)request:(FBRequest *)request didFailWithError:(NSError *)error {
    NSLog(@"FBRequest error - %@", error);
}

@end
