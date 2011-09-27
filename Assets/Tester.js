#pragma strict

var skin : GUISkin;

function Awake() {
	Facebook.Install("114118368695293");
}

function OnGUI() {
	GUI.skin = skin;
	
	var sw = Screen.width;
	var sh = Screen.height;
	
	var rect = Rect(0.1 * sw, 0.1 * sh, 0.8 * sw, 0.8 * sh);
	GUILayout.BeginArea(rect, Facebook.GetUserName(), "Window");

	if (GUILayout.Button("Sign in")) {
		Facebook.SignIn();
	}

	if (GUILayout.Button("Sign out")) {
		Facebook.SignOut();
	}

	if (GUILayout.Button("Post to wall (1)")) {
		Facebook.LaunchDialog({
			"link": "http://github.com/keijiro/unity-ios-facebook-plugin",
			"picture": "http://cloud.github.com/downloads/keijiro/unity-ios-facebook-plugin/fb-picture.png",
			"name": "Facebook plugin for Unity iOS",
			"caption": "Hosted on GitHub.",
			"description": "これはUnity上の文字列です（パターンその１）",
			"message": "Facebook plugin for Unity iOS http://github.com/keijiro/unity-ios-facebook-plugin - これはUnity上の文字列です。"
		});
	}
	
	if (GUILayout.Button("Post to wall (2)")) {
		Facebook.LaunchDialog({
			"link": "http://unity-yb.github.com",
			"picture": "http://unity-yb.github.com/images/book.png",
			"name": "Unity入門",
			"caption": "発売中！",
			"description": "これはUnity上の文字列です（パターンその２）",
			"message": "Unity入門 http://unity-yb.github.com - これはUnity上の文字列です。"
		});
	}
	
	GUILayout.EndArea();
}
