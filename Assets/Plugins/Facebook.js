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
//
// iOSの場合は次のパラメーターを使うことができる。
// link, picture, name, caption, description
//
// また、他プラットフォームとの互換性を保つために
// message パラメーターも設定することが推奨される。
static function LaunchDialog(params : Hashtable) {
	AddParamIfExists("link", params);
	AddParamIfExists("picture", params);
	AddParamIfExists("name", params);
	AddParamIfExists("caption", params);
	AddParamIfExists("description", params);
	_FacebookLaunchDialog();
}

static private function AddParamIfExists(key : String, params : Hashtable) {
	if (params.ContainsKey(key)) {
		PlayerPrefs.SetString("fbplugin_" + key, params[key]);
	} else {
		PlayerPrefs.DeleteKey("fbplugin_" + key);
	}
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
