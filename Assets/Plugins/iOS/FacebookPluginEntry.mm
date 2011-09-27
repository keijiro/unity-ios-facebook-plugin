// Facebook for Unity プラグインのエントリ部分。

#import <Foundation/Foundation.h>
#import "FacebookDriver.h"
#import "UnityPluginUtility.h"

static FacebookDriver *driver;

#pragma mark - Plug-in installation and uninstallation

// インストール
extern "C" void _FacebookInstall(const char *appID) {
    if (driver == nil) {
        driver = [[FacebookDriver alloc] initWithAppID:[UnityPluginUtility stringWithUnityString:appID]];
    }
}

// アンインストール
extern "C" void _FacebookUninstall() {
    if (driver != nil) {
        [driver release];
        driver = nil;
    }
}

#pragma mark - Facebook API operations

// ダイアログの表示状態の取得
extern "C" BOOL _FacebookIsDialogActive() {
    return driver.visible;
}

// ユーザー名の取得
extern "C" char *_FacebookGetUserName() {
    return [UnityPluginUtility heapStringWithString:driver.userName];
}

// サインイン
extern "C" void _FacebookSignIn() {
    [driver signIn];
}

// サインアウト
extern "C" void _FacebookSignOut() {
    [driver signOut];
}

// ダイアログの起動
extern "C" void _FacebookLaunchDialog(const char *text) {
    NSLog(@"%@", [UnityPluginUtility stringWithUnityString:text]);
    [driver launchDialog:[UnityPluginUtility stringWithUnityString:text]];
}

#pragma mark - URL scheme handler

// URLスキームのトランポリン処理用ハンドラ
extern "C" BOOL FacebookPluginHandleOpenURL(NSURL *url) {
    return [driver.facebook handleOpenURL:url];
}
