// Unity プラグイン向けのユーティリティ類

#import <Foundation/Foundation.h>

@interface UnityPluginUtility : NSObject

// Unity のメイン画面のビューコントローラーを取得する。
+ (UIViewController *)rootViewController;

// Unity 側から渡された文字列を NSString へ変換する。
+ (NSString *)stringWithUnityString:(const char *)string;

// NSString を Unity 側へ渡すヒープ文字列へ変換する。
+ (char *)heapStringWithString:(NSString *)string;

@end


