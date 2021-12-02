package;

import flixel.text.FlxText;
import flixel.FlxState;
import flixel.FlxG;
import flixel.FlxSubState;

import extension.webview.WebView;

using StringTools;

class VideoState extends MusicBeatState
{
	public var nextState:FlxState;

	#if android
	public static var androidPath:String = 'file:///android_asset/';



	var text:FlxText;

	public function new(source:String, toTrans:FlxState)
	{
		super();

		text = new FlxText(0, 0, 0, "toque para continuar", 48);
		text.screenCenter();
		text.alpha = 0;
		add(text);

		nextState = toTrans;

		//FlxG.autoPause = false;

		WebView.onClose=onClose;
		WebView.onURLChanging=onURLChanging;

		WebView.open(androidPath + source + '.html', false, null, ['http://exitme(.*)']);
	}

	public override function update(dt:Float) {
		//for (touch in FlxG.touches.list)
		//	if (touch.justReleased)
				onClose(); //Maybe this will make cutscenes work smoother than before

		super.update(dt);	
	}

	function onClose(){// not working
		text.alpha = 0;
		//FlxG.autoPause = true;
		trace('close!');
		trace(nextState);
		FlxG.switchState(nextState);
	}

	function onURLChanging(url:String) {
		text.alpha = 1;
		if (url == 'http://exitme(.*)') onClose(); // drity hack lol
		trace("WebView is about to open: "+url);
	}
	#else
	public function new(source:String, toTrans:FlxState)
		{
			super();
			nextState = toTrans;
			FlxG.switchState(nextState);
			//Windows offset adjustment purposes
		}
	#end
}