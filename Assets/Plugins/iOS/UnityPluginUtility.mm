// Unity プラグイン向けのユーティリティ類

#import "UnityPluginUtility.h"

// AppController.mm からのインポート
extern UIViewController *UnityGetGLViewController();

@implementation UnityPluginUtility

// Unity のメイン画面のビューコントローラーを取得する。
+ (UIViewController *)rootViewController {
    return UnityGetGLViewController();
}

// Unity 側から渡された文字列を NSString へ変換する。
+ (NSString *)stringWithUnityString:(const char *)string {
    return [NSString stringWithUTF8String:(string ? string : "")];
}

// NSString を Unity 側へ渡すヒープ文字列へ変換する。
+ (char *)heapStringWithString:(NSString *)string {
    if (!string) return NULL;
    const char* utf8 = string.UTF8String;
    char* memory = static_cast<char*>(malloc(strlen(utf8) + 1));
    if (memory) strcpy(memory, utf8);
    return memory;
}

@end
