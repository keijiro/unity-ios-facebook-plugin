// Facebook プラグイン

import System.Runtime.InteropServices;

// プラグインのインストール。
static function Install(appID : String) {
	_FacebookInstall(appID);
}

// プラグインのアンインストール。
static function Uninstall() {
	_FacebookUninstall();
}

// ダイアログの表示状態の取得。
static function IsDialogActive() : boolean {
	return _FacebookIsDialogActive();
}

// ユーザー名の取得。
static function GetUserName() : String {
	return _FacebookGetUserName();
}

// サインイン（Facebook アプリへ処理を飛ばす）。
static function SignIn() {
	_FacebookSignIn();
}

// サインアウト。
static function SignOut() {
	_FacebookSignOut();
}

// 「ウォールへ投稿」ダイアログの起動。
static function LaunchDialog(text : String) {
	PlayerPrefs.SetString("fbplugin_link", "https://github.com/keijiro/unity-ios-facebook-plugin");
	PlayerPrefs.SetString("fbplugin_picture", "http://cloud.github.com/downloads/keijiro/unity-ios-facebook-plugin/fb-picture.png");
	PlayerPrefs.SetString("fbplugin_name", "Facebook plugin for Unity iOS");
	PlayerPrefs.SetString("fbplugin_caption", "Hosted on GitHub.");
	PlayerPrefs.SetString("fbplugin_description", text);
	/*
	PlayerPrefs.DeleteKey("fbplugin_link");
	PlayerPrefs.DeleteKey("fbplugin_picture");
	PlayerPrefs.DeleteKey("fbplugin_name");
	PlayerPrefs.DeleteKey("fbplugin_caption");
	PlayerPrefs.DeleteKey("fbplugin_description");
	*/
	_FacebookLaunchDialog();
}

#if UNITY_IPHONE && !UNITY_EDITOR

// iOS用インポート宣言
@DllImportAttribute("__Internal") static private function _FacebookInstall(appID : String) {}
@DllImportAttribute("__Internal") static private function _FacebookUninstall() {}
@DllImportAttribute("__Internal") static private function _FacebookIsDialogActive() : boolean {}
@DllImportAttribute("__Internal") static private function _FacebookGetUserName() : String {}
@DllImportAttribute("__Internal") static private function _FacebookSignIn() {}
@DllImportAttribute("__Internal") static private function _FacebookSignOut() {}
@DllImportAttribute("__Internal") static private function _FacebookLaunchDialog() {}

#else

// ダミードライバ実装
static private function _FacebookInstall(appID : String) {}
static private function _FacebookUninstall() {}
static private function _FacebookIsDialogActive() : boolean { return false; }
static private function _FacebookGetUserName() : String { return "(none)"; }
static private function _FacebookSignIn() {}
static private function _FacebookSignOut() {}
static private function _FacebookLaunchDialog() {}

#endif
