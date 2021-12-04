package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup;
import flixel.input.gamepad.FlxGamepad;
import flixel.input.gamepad.mappings.MayflashWiiRemoteMapping;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxSound;
import flixel.system.ui.FlxSoundTray;
import flixel.text.FlxText;
import flixel.tweens.FlxEase.EaseFunction;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
#if newgrounds
import io.newgrounds.NG;
#end
import lime.app.Application;
import openfl.Assets;

using StringTools;

#if sys
import smTools.SMFile;
#end
#if windows
import Discord.DiscordClient;
#end
#if cpp
import sys.thread.Thread;
#end

class TitleState extends MusicBeatState
{
	static var initialized:Bool = false;

	var credGroup:FlxGroup;
	var credTextShit:Alphabet;
	var textGroup:FlxGroup;
	var ngSpr:FlxSprite;
	var code:Int = 0;

	var curWacky:Array<String> = [];

	var wackyImage:FlxSprite;

	override public function create():Void
	{

		#if android
		FlxG.android.preventDefaultKeys = [BACK];
		#end
		FlxG.mouse.visible = false;

		FlxG.worldBounds.set(0, 0);

		@:privateAccess
		{
			trace("Loaded " + openfl.Assets.getLibrary("default").assetsLoaded + " assets (DEFAULT)");
		}

		PlayerSettings.init();

		#if windows
		DiscordClient.initialize();

		Application.current.onExit.add(function(exitCode)
		{
			DiscordClient.shutdown();
		});
		#end

		curWacky = FlxG.random.getObject(getIntroTextShit());

		trace('hello');

		// DEBUG BULLSHIT

		super.create();

		// NGio.noLogin(APIStuff.API);

		#if ng
		var ng:NGio = new NGio(APIStuff.API, APIStuff.EncKey);
		trace('NEWGROUNDS LOL');
		#end

		FlxG.save.bind('funkin', 'ninjamuffin99');

		KadeEngineData.initSave();

		// var file:SMFile = SMFile.loadFile("file.sm");
		// this was testing things

		Highscore.load();

		#if FREEPLAY
		FlxG.switchState(new FreeplayState());
		#elseif CHARTING
		FlxG.switchState(new ChartingState());
		#else
		new FlxTimer().start(0.1, function(tmr:FlxTimer)
		{
			startIntro();
		});
		#end
	}

//	var logoBl:FlxSprite;
	var logoBlBUMP:FlxSprite;
//	var gfDance:FlxSprite;
//	var danceLeft:Bool = false;
	var titleText:FlxSprite;
	var bg:FlxSprite;

	function startIntro()
	{
		if (!initialized)
		{
			/*var diamond:FlxGraphic = FlxGraphic.fromClass(GraphicTransTileDiamond);
			diamond.persist = true;
			diamond.destroyOnNoUse = false;
			FlxTransitionableState.defaultTransIn = new TransitionData(FADE, FlxColor.BLACK, 1, new FlxPoint(0, -1), {asset: diamond, width: 32, height: 32},
				new FlxRect(-300, -300, FlxG.width * 1.8, FlxG.height * 1.8));
			FlxTransitionableState.defaultTransOut = new TransitionData(FADE, FlxColor.BLACK, 0.7, new FlxPoint(0, 1),
				{asset: diamond, width: 32, height: 32}, new FlxRect(-300, -300, FlxG.width * 1.8, FlxG.height * 1.8));
				
			transIn = FlxTransitionableState.defaultTransIn;
			transOut = FlxTransitionableState.defaultTransOut;*/

			// HAD TO MODIFY SOME BACKEND SHIT
			// IF THIS PR IS HERE IF ITS ACCEPTED UR GOOD TO GO
			// https://github.com/HaxeFlixel/flixel-addons/pull/348

			// var music:FlxSound = new FlxSound();
			// music.loadStream(Paths.music('freakyMenu'));
			// FlxG.sound.list.add(music);
			// music.play();

			if(FlxG.sound.music == null) {
				FlxG.sound.playMusic(Paths.music('freakyMenu'), 0);

				FlxG.sound.music.fadeIn(4, 0, 0.7);
			}
		}

		Conductor.changeBPM(102);
		persistentUpdate = true;

		bg = new FlxSprite(0, 0);
		bg.frames = Paths.getSparrowAtlas('NewTitleMenuBG', 'exe');
		bg.animation.addByPrefix('idle', "TitleMenuSSBG instance 1", 24);
		bg.animation.play('idle');
		bg.alpha = .75;
		bg.scale.x = 3;
		bg.scale.y = 3;
		bg.antialiasing = true;
		bg.updateHitbox();
		bg.screenCenter();
		add(bg);

		logoBlBUMP = new FlxSprite(0, 0);
		logoBlBUMP.loadGraphic(Paths.image('Logo', 'exe'));
		logoBlBUMP.antialiasing = true;

		logoBlBUMP.scale.x = .5;
		logoBlBUMP.scale.y = .5;

		logoBlBUMP.screenCenter();

		add(logoBlBUMP);

		FlxTween.tween(logoBlBUMP, {y: logoBlBUMP.y + 25}, 4, {ease: FlxEase.quadInOut, type: PINGPONG});

	/*	gfDance = new FlxSprite(FlxG.width * 0.4, FlxG.height * 0.07);
		gfDance.frames = Paths.getSparrowAtlas('gfDanceTitle');
		gfDance.animation.addByIndices('danceLeft', 'gfDance', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
		gfDance.animation.addByIndices('danceRight', 'gfDance', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
		gfDance.antialiasing = true;
		add(gfDance);
		add(logoBl);*/

		titleText = new FlxSprite(0, 0);
		titleText.frames = Paths.getSparrowAtlas('titleEnterNEW');
		titleText.animation.addByPrefix('idle', "Press Enter to Begin instance 1", 24);
		titleText.animation.addByPrefix('press', "ENTER PRESSED instance 1", 24, false);
		titleText.antialiasing = true;
		titleText.animation.play('idle');
		titleText.updateHitbox();
		titleText.screenCenter();
		// titleText.screenCenter(X);
		add(titleText);
		

	//	var logo:FlxSprite = new FlxSprite().loadGraphic(Paths.image('logo'));
	//	logo.screenCenter();
	//	logo.antialiasing = true;
		// add(logo);

		// FlxTween.tween(logoBl, {y: logoBl.y + 50}, 0.6, {ease: FlxEase.quadInOut, type: PINGPONG});
		// FlxTween.tween(logo, {y: logoBl.y + 50}, 0.6, {ease: FlxEase.quadInOut, type: PINGPONG, startDelay: 0.1});

		credGroup = new FlxGroup();
		add(credGroup);
		textGroup = new FlxGroup();

		credTextShit = new Alphabet(0, 0, "ninjamuffin99\nPhantomArcade\nkawaisprite\nevilsk8er", true);
		credTextShit.screenCenter();

		// credTextShit.alignment = CENTER;

		credTextShit.visible = false;

	/*ngSpr = new FlxSprite(0, FlxG.height * 0.52).loadGraphic(Paths.image('newgrounds_logo'));
		add(ngSpr);
		ngSpr.visible = false;
		ngSpr.setGraphicSize(Std.int(ngSpr.width * 0.8));
		ngSpr.updateHitbox();
		ngSpr.screenCenter(X);
		ngSpr.antialiasing = true; */

		FlxTween.tween(credTextShit, {y: credTextShit.y + 20}, 2.9, {ease: FlxEase.quadInOut, type: PINGPONG});

		FlxG.mouse.visible = false;

		// credGroup.add(credTextShit);

		FlxG.sound.play(Paths.sound('TitleLaugh'), 1, false, null, false, function()
		{
			skipIntro();
		});
	}

	function getIntroTextShit():Array<Array<String>>
	{
		var fullText:String = Assets.getText(Paths.txt('introText'));

		var firstArray:Array<String> = fullText.split('\n');
		var swagGoodArray:Array<Array<String>> = [];

		for (i in firstArray)
		{
			swagGoodArray.push(i.split('--'));
		}

		return swagGoodArray;
	}

	var transitioning:Bool = false;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music != null)
			Conductor.songPosition = FlxG.sound.music.time;
		// FlxG.watch.addQuick('amp', FlxG.sound.music.amplitude);

		if (FlxG.keys.justPressed.F)
		{
			FlxG.fullscreen = !FlxG.fullscreen;
		}

		var pressedEnter:Bool = controls.ACCEPT;


		#if mobile
	//	addVirtualPad(FULL, A);
		if (controls.ACCEPT)
		{
			pressedEnter = true;
		}
	#end

		if (FlxG.keys.justPressed.UP || controls.UP_P)
			if (code == 0)
				code = 1;
			else
				code == 0;

		if (FlxG.keys.justPressed.DOWN || controls.DOWN_P)
			if (code == 1)
				code = 2;
			else
				code == 0;

		if (FlxG.keys.justPressed.LEFT || controls.LEFT_P)
			if (code == 2)
				code = 3;
			else
				code == 0;

		if (FlxG.keys.justPressed.RIGHT || controls.RIGHT_P)
			if (code == 3)
				code = 4;
			else
				code == 0;

		if (pressedEnter && !transitioning && skippedIntro && code != 4)
		{
			#if (!switch && newgrounds)
			NGio.unlockMedal(60960);

			// If it's Friday according to da clock
			if (Date.now().getDay() == 5)
				NGio.unlockMedal(61034);
			#end

			if (FlxG.save.data.flashing)
				titleText.animation.play('press');

			FlxG.camera.flash(FlxColor.RED, 0.2);
			FlxG.sound.play(Paths.sound('menumomentclick', 'exe'));
			FlxG.sound.play(Paths.sound('menulaugh', 'exe'));

			transitioning = true;
			// FlxG.sound.music.stop();

			MainMenuState.firstStart = true;

			new FlxTimer().start(1, function(tmr:FlxTimer)
			{
				FlxG.camera.fade(FlxColor.BLACK, 1, false, function(){
						LoadingState.loadAndSwitchState(new VideoState('assets/videos/bothCreditsAndIntro', new MainMenuState()));
				});
			});
			// FlxG.sound.play(Paths.music('titleShoot'), 0.7);
		}
		else if (pressedEnter && !transitioning && skippedIntro && code == 4)
		{
			transitioning = true;

			PlayStateChangeables.nocheese = false;
			PlayState.SONG = Song.loadFromJson('milk', 'milk');
			PlayState.isStoryMode = false;
			PlayState.storyDifficulty = 1;
			PlayState.storyWeek = 1;
			FlxG.camera.fade(FlxColor.WHITE, 0.5, false);
			FlxG.sound.play(Paths.sound('confirmMenu'));
			FlxTransitionableState.skipNextTransIn = true;
			FlxTransitionableState.skipNextTransOut = true;
			if (!FlxG.save.data.songArray.contains('milk') && !FlxG.save.data.botplay)
				FlxG.save.data.songArray.push('milk');
			new FlxTimer().start(1.5, function(tmr:FlxTimer)
			{
				LoadingState.loadAndSwitchState(new PlayState());
			});
		}

		super.update(elapsed);
	}

	function createCoolText(textArray:Array<String>)
	{
		for (i in 0...textArray.length)
		{
			var money:Alphabet = new Alphabet(0, 0, textArray[i], true, false);
			money.screenCenter(X);
			money.y += (i * 60) + 200;
			credGroup.add(money);
			textGroup.add(money);
		}
	}

	function addMoreText(text:String)
	{
		var coolText:Alphabet = new Alphabet(0, 0, text, true, false);
		coolText.screenCenter(X);
		coolText.y += (textGroup.length * 60) + 200;
		credGroup.add(coolText);
		textGroup.add(coolText);
	}

	function deleteCoolText()
	{
		while (textGroup.members.length > 0)
		{
			credGroup.remove(textGroup.members[0], true);
			textGroup.remove(textGroup.members[0], true);
		}
	}

	function playBoop1()
		{
			if (!skippedIntro)
				{
					FlxG.sound.play(Paths.sound('boop1', 'shared'));
				}
		}

	function playBoop2()
		{
			if (!skippedIntro)
				{
					FlxG.sound.play(Paths.sound('boop2', 'shared'));
				}
		}

	function playShow()
		{
			if (!skippedIntro)
				{
					FlxG.sound.play(Paths.sound('showMoment', 'shared'), .4);
				}
		}
	
	override function beatHit()
	{
		super.beatHit();
	}

	var skippedIntro:Bool = false;

	function skipIntro():Void
	{
		if (!skippedIntro)
		{
		//	remove(ngSpr);
		//add(bg); //Mobile controls and a cool way to do this stuff btw
		//O que que eu to falando? Eu literalmente só fiz isso porque estava bugando...
		//Convenhamos, a ideia é legal kek
		//add(logoBlBUMP);
		//add(titleText); 
			#if mobile
			addVirtualPad(FULL, A);
			#end

			FlxG.sound.play(Paths.sound('showMoment', 'shared'), .4);

			FlxG.camera.flash(FlxColor.RED, 2);
			remove(credGroup);
			skippedIntro = true;
		}
	}
}
