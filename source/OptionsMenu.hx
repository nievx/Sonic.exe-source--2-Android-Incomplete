package;

import Options;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.gamepad.FlxGamepad;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

using StringTools;


class OptionsMenu extends MusicBeatState
{
	public static var instance:OptionsMenu;

	var selector:FlxText;
	var curSelected:Int = 0;
	var cheat:Bool = false;
	var canselect:Bool = true;


	var options:Array<OptionCategory> = [
		new OptionCategory("Sonic APK", [
			new JumpscareOption("Liga ou desliga os sustins. Pode desligar, sei que você não tanka..."),
			new Vfx("Ativa alguns efeitos especiais, desligue isso para melhorar a performance."),
			new SplashOption("Sanguinho quando tu acertar uma nota, desligue isso para melhorar a performance."),
			new CamMove("Faz a Camera se mover no sentido da nota que você acertou, desligue isso para melhorar a performance."),
			new LowQuality('Remove partes do cenário para melhorar a performance, ligue isso para melhorar a performance.')
		]),
		new OptionCategory("Gameplay", [
			new DFJKOption(controls),
			new DownscrollOption("Auto-Explicativo eu acho..."),
			new MiddlescrollOption("Remove as setas do oponente e coloca as suas no meio da tela"),
			new GhostTapOption("Basicamente não te pune por apertar uma nota fora de hora."),
			new Judgement("Customize seu tempo de resposta, MEXA NISSO SE TIVER UM TECLADO DIFERENCIADO (Esquerda ou direita)"),
			#if desktop
			new FPSCapOption("Cap your FPS"),
			#end
			new ScrollSpeedOption("Muda a Velocidade das notas (1 = Dependente da chart)"),
			new AccuracyDOption("Muda como a precisão é calculada"),
		//	new ResetButtonOption("Toggle pressing R to gameover."),
			// new OffsetMenu("Get a note offset based off of your inputs!"),
		//	new CustomizeGameplay("Drag'n'Drop Gameplay Modules around to your preference")
		]),
		new OptionCategory("Aparencia", [
			//new DistractionsAndEffectsOption("Toggle stage distractions that can hinder your gameplay."),
			new CamZoomOption("Tira o zoom da camera dentro do jooj."),
			new RainbowFPSOption("Faça seu FPS sair do Armário"),
			new AccuracyOption("Mostra informações da precisão."),
			new NPSDisplayOption("Mostra a quantidade de notas por segundo vindo."),
			new SongPositionOption("Mostra seu tempo na musica (como uma barra)"),
			new CpuStrums("As notas da CPU fazem brilhin."),
		]),
		
		new OptionCategory("Trens", [
			new FPSOption(""),
			//new ReplayOption("View replays"),
			//new FlashingLightsOption("Ative essa opção caso não queira ter problemas com o chuvisco e talz"),
			//new WatermarkOption("Enable and disable all watermarks from the engine."),
			//new ShowInput("Display every single input in the score screen."),
			new Optimization("Ligue isso se teu celular for bem... MAS TIPO BEM RUIM MERMO"),
			new BotPlay("CONFIA POH, EU Já ZOEI CONTIGO ALGUMA VEZ? Não responda ;-;"),
			new RealBot('O MELHOR JOGADOR DO MUNDO, APENAS Só perde pro Silver, CONFIA!!!')
		]) #if mobileC ,

		new OptionCategory("Mobile", [
			new CustomControls("Customize seus controles")
		]) #end
		
	];

	public var acceptInput:Bool = true;

	private var currentDescription:String = "";
	private var grpControls:FlxTypedGroup<Alphabet>;
	public static var versionShit:FlxText;

	var currentSelectedCat:OptionCategory;
	var blackBorder:FlxSprite;
	override function create()
	{
		instance = this;
		var menuBG:FlxSprite = new FlxSprite().loadGraphic(Paths.image("BackGROUND2"));

		menuBG.setGraphicSize(1280, 720);
		menuBG.updateHitbox();
		menuBG.screenCenter();
		menuBG.antialiasing = true;
		add(menuBG);

		grpControls = new FlxTypedGroup<Alphabet>();
		add(grpControls);

		for (i in 0...options.length)
		{
			var controlLabel:Alphabet = new Alphabet(0, (70 * i) + 30, options[i].getName(), true, false, true);
			controlLabel.isMenuItem = true;
			controlLabel.targetY = i;
			grpControls.add(controlLabel);
			// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
		}

		currentDescription = "none";

		versionShit = new FlxText(5, FlxG.height + 40, 0, "Offset (Left, Right, Shift for slow): " + HelperFunctions.truncateFloat(FlxG.save.data.offset,2) + " - Description - " + currentDescription, 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		
		blackBorder = new FlxSprite(-30,FlxG.height + 40).makeGraphic((Std.int(versionShit.width + 900)),Std.int(versionShit.height + 600),FlxColor.BLACK);
		blackBorder.alpha = 0.5;

		add(blackBorder);

		add(versionShit);

		FlxTween.tween(versionShit,{y: FlxG.height - 18},2,{ease: FlxEase.elasticInOut});
		FlxTween.tween(blackBorder,{y: FlxG.height - 18},2, {ease: FlxEase.elasticInOut});

		#if mobileC
		addVirtualPad(FULL, A_B);
		#end

		super.create();
	}

	var isCat:Bool = false;
	

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (acceptInput)
		{
			if (controls.BACK && !isCat)
				{
				MusicBeatState.switchState(new MainMenuState());
				trace("back to da menu");
				}
			else if (controls.BACK)
			{
				isCat = false;
				grpControls.clear();
				for (i in 0...options.length)
				{
					var controlLabel:Alphabet = new Alphabet(0, (70 * i) + 30, options[i].getName(), true, false);
					controlLabel.isMenuItem = true;
					controlLabel.targetY = i;
					grpControls.add(controlLabel);
					// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
				}
				
				curSelected = 0;
				
				changeSelection(curSelected);
			}

			var gamepad:FlxGamepad = FlxG.gamepads.lastActive;
			if (canselect)
			{
				if (gamepad != null)
				{
					if (gamepad.justPressed.DPAD_UP)
					{
						FlxG.sound.play(Paths.sound('scrollMenu'));
						changeSelection(-1);
					}
					if (gamepad.justPressed.DPAD_DOWN)
					{
						FlxG.sound.play(Paths.sound('scrollMenu'));
						changeSelection(1);
					}
				}
				
				if (controls.UP_P)
					changeSelection(-1);
				if (controls.DOWN_P)
					changeSelection(1);
			}
			
			if (isCat)
			{
				if (currentSelectedCat.getOptions()[curSelected].getAccept())
				{
					if (FlxG.keys.pressed.SHIFT)
						{
							if (FlxG.keys.pressed.RIGHT)
								currentSelectedCat.getOptions()[curSelected].right();
							if (FlxG.keys.pressed.LEFT)
								currentSelectedCat.getOptions()[curSelected].left();
						}
					else
					{
						if (controls.RIGHT)
							currentSelectedCat.getOptions()[curSelected].right();
						if (controls.LEFT)
							currentSelectedCat.getOptions()[curSelected].left();
					}
				}
				else
				{
					if (FlxG.keys.pressed.SHIFT)
					{
						if (controls.RIGHT_P)
							FlxG.save.data.offset += 0.1;
						else if (controls.LEFT_P)
							FlxG.save.data.offset -= 0.1;
					}
					else if (FlxG.keys.pressed.RIGHT)
						FlxG.save.data.offset += 0.1;
					else if (FlxG.keys.pressed.LEFT)
						FlxG.save.data.offset -= 0.1;
					
					versionShit.text = "Offset (Left, Right, Shift for slow): " + HelperFunctions.truncateFloat(FlxG.save.data.offset,2) + " - Description - " + currentDescription;
				}
				if (currentSelectedCat.getOptions()[curSelected].getAccept())
					versionShit.text =  currentSelectedCat.getOptions()[curSelected].getValue() + " - Description - " + currentDescription;
				else
					versionShit.text = "Offset (Left, Right, Shift for slow): " + HelperFunctions.truncateFloat(FlxG.save.data.offset,2) + " - Description - " + currentDescription;
			}
			else
			{
				if (FlxG.keys.pressed.SHIFT)
				{
					if (controls.RIGHT_P)
						FlxG.save.data.offset += 0.1;
					else if (controls.LEFT_P)
						FlxG.save.data.offset -= 0.1;
				}
				else if (controls.RIGHT_P)
					FlxG.save.data.offset += 0.1;
				else if (controls.LEFT_P)
					FlxG.save.data.offset -= 0.1;
				
				versionShit.text = "Offset (Left, Right, Shift for slow): " + HelperFunctions.truncateFloat(FlxG.save.data.offset,2) + " - Description - " + currentDescription;
			}
		

			if (controls.RESET)
					FlxG.save.data.offset = 0;

			if (controls.ACCEPT && canselect)
			{
				if (isCat)
				{
					if (currentSelectedCat.getOptions()[curSelected].press()) {
						grpControls.members[curSelected].reType(currentSelectedCat.getOptions()[curSelected].getDisplay());
						trace(currentSelectedCat.getOptions()[curSelected].getDisplay());
						if (currentSelectedCat.getOptions()[curSelected].getDisplay().startsWith('BotPlay'))
						{
							var camera:FlxCamera;
							camera = new FlxCamera();
							FlxG.cameras.add(camera);
							canselect = false;
							FlxG.sound.music.stop();
							var nocheat:FlxSprite = new FlxSprite().loadGraphic(Paths.image('nocheating', 'exe'));
							nocheat.alpha = 0;
							nocheat.cameras = [camera];
							add(nocheat);
							new FlxTimer().start(2, function(ok:FlxTimer)
							{
								FlxTween.tween(nocheat, {alpha:1}, 1, {onComplete: function(ok:FlxTween)
								{
									cheat = true;
									FlxG.save.data.fakebotplay = false;
								}});
							});
						}
					}
				}
				else
				{
					currentSelectedCat = options[curSelected];
					isCat = true;
					grpControls.clear();
					for (i in 0...currentSelectedCat.getOptions().length)
						{
							var controlLabel:Alphabet = new Alphabet(0, (70 * i) + 30, currentSelectedCat.getOptions()[i].getDisplay(), true, false);
							controlLabel.isMenuItem = true;
							controlLabel.targetY = i;
							grpControls.add(controlLabel);
							// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
						}
					curSelected = 0;
				}
				
				changeSelection();
			}
			else if (!canselect && cheat && controls.ACCEPT)
			{
				FlxG.sound.music.play();
				MusicBeatState.switchState(new OptionsMenu());
			}
		}
		FlxG.save.flush();
	}

	var isSettingControl:Bool = false;

	function changeSelection(change:Int = 0)
	{
		#if !switch
		// NGio.logEvent("Fresh");
		#end
		
		FlxG.sound.play(Paths.sound("scrollMenu"), 0.4);

		curSelected += change;

		if (curSelected < 0)
			curSelected = grpControls.length - 1;
		if (curSelected >= grpControls.length)
			curSelected = 0;

		if (isCat)
			currentDescription = currentSelectedCat.getOptions()[curSelected].getDescription();
		else
			currentDescription = "Please select a category";
		if (isCat)
		{
			if (currentSelectedCat.getOptions()[curSelected].getAccept())
				versionShit.text =  currentSelectedCat.getOptions()[curSelected].getValue() + " - Description - " + currentDescription;
			else
				versionShit.text = "Offset (Left, Right, Shift for slow): " + HelperFunctions.truncateFloat(FlxG.save.data.offset,2) + " - Description - " + currentDescription;
		}
		else
			versionShit.text = "Offset (Left, Right, Shift for slow): " + HelperFunctions.truncateFloat(FlxG.save.data.offset,2) + " - Description - " + currentDescription;
		// selector.y = (70 * curSelected) + 30;

		var bullShit:Int = 0;

		for (item in grpControls.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			// item.setGraphicSize(Std.int(item.width * 0.8));

			if (item.targetY == 0)
			{
				item.alpha = 1;
				// item.setGraphicSize(Std.int(item.width));
			}
		}
	}
}
