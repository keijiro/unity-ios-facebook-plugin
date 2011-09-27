// Facebook for Unity プラグインのエントリ部分。

#import <Foundation/Foundation.h>
#import "FacebookDriver.h"
#import "UnityPluginUtility.h"

static NSString *s_appID;
static FacebookDriver *s_driver;

#pragma mark - Plug-in installation and uninstallation

// インストール
extern "C" void _FacebookInstall(const char *appID) {
    if (s_driver == nil) {
        s_appID = [[UnityPluginUtility stringWithUnityString:appID] retain];
        s_driver = [[FacebookDriver alloc] initWithAppID:s_appID];
    }
}

// アンインストール
extern "C" void _FacebookUninstall() {
    if (s_appID != nil) {
        [s_appID release];
        s_appID = nil;
    }
    if (s_driver != nil) {
        [s_driver release];
        s_driver = nil;
    }
}

#pragma mark - Facebook API operations

// ダイアログの表示状態の取得
extern "C" BOOL _FacebookIsDialogActive() {
    return s_driver.visible;
}

// ユーザー名の取得
extern "C" char *_FacebookGetUserName() {
    return [UnityPluginUtility heapStringWithString:s_driver.userName];
}

// サインイン
extern "C" void _FacebookSignIn() {
    [s_driver signIn];
}

// サインアウト
extern "C" void _FacebookSignOut() {
    [s_driver signOut];
}

// ダイアログの起動
extern "C" void _FacebookLaunchDialog() {
    // 取り扱うパラメーター群。
    NSArray *keys = [NSArray arrayWithObjects:@"link", @"picture", @"name", @"caption", @"description", nil];

    // User defaults (PlayerPrefs) に格納されたパラメーター群を取り出す。
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObject:s_appID forKey:@"app_id"];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    for (NSString *key in keys) {
        NSString *value = [defaults stringForKey:[@"fbplugin_" stringByAppendingString:key]];
        if (value) [params setObject:value forKey:key];
    }
    
    [s_driver launchDialog:params];
}

#pragma mark - URL scheme handler

// URLスキームのトランポリン処理用ハンドラ
extern "C" BOOL FacebookPluginHandleOpenURL(NSURL *url) {
    return [s_driver.facebook handleOpenURL:url];
}
