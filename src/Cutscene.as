package {
	import org.flixel.FlxBasic;
	import org.flixel.FlxGroup;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	import org.flixel.FlxG;
	import statics.LevelData;
	import Playtomic.Log;
	import org.flixel.plugin.photonstorm.FlxBitmapFont;
	
	/*Cutscene logic. Tracks how often people finish watching them. */
	public class Cutscene extends FlxState {
		[Embed (source = "res/img/cutscenes/backdrop.png")] public var Backdrop:Class;
		/* A grid of 32 * 64 sprites */
		[Embed (source = "res/img/cutscenes/cutscenesprites.png")] public var Sprites:Class;
		
		private var backdrop:FlxSprite = new FlxSprite(0, 0);
		private var floorVal:int = 282; //The "floor" - loaded sprites get "stuck" here
		
		private var player:FlxSprite = new FlxSprite(0, 0);
		private var pill:FlxSprite = new FlxSprite(0, 0);
		private var note:FlxSprite = new FlxSprite(0, 0);
		private var record:FlxSprite = new FlxSprite(0, 0);
		private var timeMachine:FlxSprite = new FlxSprite(0, 0);
		private var sprites:FlxGroup = new FlxGroup();
		
		private var plainsBG:FlxSprite = new FlxSprite(-50, -360);
		private var forestBG:FlxSprite = new FlxSprite(-50, -360);
		private var caveBG:FlxSprite = new FlxSprite(-100, -360);
		private var nightcityBG:FlxSprite = new FlxSprite(130, -360);
		
		private var text:FlxBitmapFont = new FlxBitmapFont(Registry.bigFontWhite, 14, 28, Registry.fontString, 26, 0, 0, 0, 2);
		private var filler:String = "                                    \n";
		private var dialogueIndex:int = 0; 
		private var dialogueLength:int = 0;
		override public function create():void {
			FlxG.volume = 0.8;
			FlxG.playMusic(LevelData.BossaSong,1.0);
			FlxG.bgColor = 0;
			backdrop.loadGraphic(Backdrop, false, false, 640, 480);
			add(backdrop);
			
			player.loadGraphic(Player.PlayerSprite, false, false, 15, 30);
			player.frame = 0; 
			player.scale = new FlxPoint(2, 2);
			sprites.add(player);
			
			note.loadGraphic(Note.NoteSprites, false, false, 16, 16);
			note.frame = 1; 
			note.scale = new FlxPoint(2, 2);
			sprites.add(note);
			
			pill.loadGraphic(Pill.PillSprites, false, false, 16, 16);
			pill.frame = 1; 
			pill.scale = new FlxPoint(2, 2);
			sprites.add(pill);
			
			record.loadGraphic(Sprites, false, false, 32, 64);
			record.frame = 0; 
			record.offset.y = 32;
			sprites.add(record);
			
			timeMachine.loadGraphic(Sprites, false, false, 32, 64);
			timeMachine.frame = 1; 
			timeMachine.offset.y = 32;
			sprites.add(timeMachine);
			
			var quarterSize:FlxPoint = new FlxPoint(0.25, 0.25);
			plainsBG.loadGraphic(LevelData.HouseBG, false, false, 640, 480); plainsBG.scale = quarterSize;
			forestBG.loadGraphic(LevelData.forestBG, false, false, 640, 480); forestBG.scale = quarterSize;
			caveBG.loadGraphic(LevelData.CaveBG, false, false, 640, 480); caveBG.scale = quarterSize;
			nightcityBG.loadGraphic(LevelData.NightCityBG, false, false, 640, 480); nightcityBG.scale = quarterSize;
			sprites.add(plainsBG); sprites.add(forestBG); sprites.add(caveBG); sprites.add(nightcityBG);
			
			add(sprites);
			sprites.setAll("visible", false);
			
			text.setText(filler, true, 0, 0, "center", true);
			text.x = 42; text.y = 310;
			add(text);
			
			
			switch (Registry.cutscene) {
				case 0: 
					dialogueLength = introText.length;
					text.text = filler + introText[dialogueIndex] + "\n (Press X/J. Or ENTER to skip)";
					break;
				case 1:
					dialogueLength = c2Text.length;
					text.text = filler + c2Text[dialogueIndex] + "\n (Press X/J. Or ENTER to skip)";

					break;
				case 2:
					dialogueLength = c3Text.length;
					text.text = filler + c3Text[dialogueIndex] + "\n (Press X/J. Or ENTER to skip)";

					break;
				case 3:
					dialogueLength = c4Text.length;			
					text.text = filler + c4Text[dialogueIndex] + "\n (Press X/J. Or ENTER to skip)";

					break;
			}
			dialogueIndex = 0;
		}
		
		override public function update():void {
			for (var i:int = 0; i < sprites.length; i++) {
				if (Registry.cutscene > 0) {
					if (sprites.members[i].y > floorVal - 300) {
						sprites.members[i].y = floorVal - 301;
						sprites.members[i].velocity.y = sprites.members[i].acceleration.y = 0;
					}
				} else {
					if (sprites.members[i].y > floorVal - 20) {
						sprites.members[i].y = floorVal - 20;
						sprites.members[i].velocity.y = sprites.members[i].acceleration.y = 0;
					}
				}	
			}
			
			if (Registry.cutscene == 0) {
				introCutscene();
			} else if (Registry.cutscene == 1) {
				c2();
			} else if (Registry.cutscene == 2) {
				
				c3();
			} else if (Registry.cutscene == 3) {
				c4();
			}
			
				
			
		}
		
		private function pressedKey():Boolean {
			var keys:Array = new Array("X", "C", "Z", "J", "K", "SPACE");
			var retVal:int = 0;
			for (var i:int = 0; i < keys.length; i++) {
				retVal += FlxG.keys.justPressed(keys[i]);
			}
			return Boolean(retVal);
		}
		private function introCutscene():void {
			if (pressedKey()) {
				FlxG.play(LevelData.Bloop);
				dialogueIndex ++;
				switch (dialogueIndex) {
					case 1:
						player.visible = true; player.x = 164; player.acceleration.y = 150; player.velocity.y = 200; break;
					case 2:
						record.visible = true; record.x = 204; record.acceleration.y = 150; record.velocity.y = 200; break;
					case 3:
						timeMachine.visible = true; timeMachine.x = 260; timeMachine.acceleration.y = 150; timeMachine.velocity.y = 200; break;
					case 7:
						note.visible = true; note.x = 340; note.acceleration.y = 150; note.velocity.y = 200; break;
					case 9:
						pill.visible = true; pill.x = 380; pill.acceleration.y = 150; pill.velocity.y = 200; break;
					case 10:
						Log.CustomMetric("WatchedIntro", "Cutscenes");
				}
				text.text = filler + introText[dialogueIndex] + "\n (Press X/J. Or ENTER to skip)";
			}
			
			if (FlxG.keys.justPressed("ENTER")) {
				dialogueIndex = introText.length;
				Log.CustomMetric("SkippedIntro", "Cutscenes");
			}
			if (dialogueIndex >= introText.length) {
				Registry.cutscenesWatched[0] = true;
				FlxG.switchState(new WorldMap());
			}
		
			super.update();
		}
		
		private var introText:Array = new Array( 
		"This is Dave. He's a super-fan of\n the hit '90s band, Davement.\n",
		"He has all of their records and\n vinyls, and will make sure you know.\n",
		"He badly wants to be Davement.\nBecause his name is in it.",
		"It's such a big problem, that he\n built a time machine.\n",
		"The time machine took him back to\n 1990, around when Davement\n recorded their first demo.",
		"His plan? Walk the world.\nFor musical inspiration.\nAnd release a better album.",
		"That will make him better than Davement.\n Or something. \n Via inspiration from Davement.",
		"So it's up to you to help him.\nHelp him to be creative.\nOr plagiarize.",
		"Dave also has an anxiety disorder.\nSo keep popping pills.\nOr he might explode.",
		"Collect lots of notes.\n\n",
		"Because notes are the currency...\n...of musical creativity.\n",
		"Well, not really.\nBut they unlock things. (Yay!)\n",
		"Now, on to the game!\n\n");
		
		private function c2():void {
			if (pressedKey()) {
				FlxG.play(LevelData.Bloop);
				dialogueIndex ++;
				switch (dialogueIndex) {
					case 1:
						plainsBG.visible = true; plainsBG.velocity.y = 200; break;
					case c2Text.length:
						Log.CustomMetric("WatchedC2", "Cutscenes"); break;
				}
				text.text = filler + c2Text[dialogueIndex] + "\n (Press X/J. Or ENTER to skip)";
			}
			
			if (FlxG.keys.justPressed("ENTER")) { 
				dialogueIndex = c2Text.length;
				Log.CustomMetric("SkippedC2", "Cutscenes"); 
			}
			if (dialogueIndex >= c2Text.length) {
				Registry.cutscenesWatched[1] = true;
				FlxG.switchState(new WorldMap());
			}
		
			super.update();
		}
		
		
		private var c2Text:Array = new Array( 
		"Having made it through\nthe not-so-perilous plains,\n",
		"Dave finds himself at a\nmysterious, abandoned hut.\n",
		"The path also leads\nto a dark forest valley.\n",
		"The hut must be full\nof secrets!\nMaybe literally!",
		"He should go visit the hut.\nAnd look at stuff.\n",
		"The forest must hold inspiration.\nSo, Dave heads out...\n"
		);
		
		private function c3():void {
			if (pressedKey()) {
				FlxG.play(LevelData.Bloop);
				dialogueIndex ++;
				switch (dialogueIndex) {
					case 1: 
						forestBG.visible = true; forestBG.velocity.y = 200;
					case c3Text.length:
						Log.CustomMetric("WatchedC3", "Cutscenes"); break;
				}
				text.text = filler + c3Text[dialogueIndex] + "\n (Press X/J. Or ENTER to skip)";
			}
			
			if (FlxG.keys.justPressed("ENTER")) { 
				dialogueIndex = c3Text.length;
				Log.CustomMetric("SkippedC3", "Cutscenes"); 
			}
			if (dialogueIndex >= c3Text.length) {
				Registry.cutscenesWatched[2] = true;
				FlxG.switchState(new WorldMap());
			}
		
			super.update();
		}
		
		private var c3Text:Array = new Array (
		"Ugh!\n\n",
		"Damn spikes!\n\n",
		"That's what Dave is thinking.\nBut now, the forest is done!\n",
		"Dave has some great song ideas.\nOr so he thinks.\n",
		"He'll make a song like\nDavement's hit single,\nCut Her Fair.\n",
		"Or that one off of\ntheir last album,\nPounded.",
		"What a dirty sounding song name!\n\n",
		"This made Dave giggle.\n\n",
		"Well, it would have,\nIf Dave had a face...\n",
		"Details aside, Dave noticed\na few houses in the distance.\n",
		"And a mountain range.\nSurely full of caves!\n",
		"There must be more inspiration there.\nHe hopes.\n",
		"As Dave leaves, he remembers\nthat he should visit\nthe hut regularly.\n"
		);
		
		private function c4():void {
			if (pressedKey()) {
				FlxG.play(LevelData.Bloop);
				dialogueIndex ++;
				switch (dialogueIndex) {
					case 1:
						caveBG.visible = nightcityBG.visible = true;
						caveBG.velocity.y = nightcityBG.velocity.y = 200;
					case c4Text.length:
						Log.CustomMetric("WatchedC4", "Cutscenes"); break;
				}
				text.text = filler + c4Text[dialogueIndex] + "\n (Press X/J. Or ENTER to skip)";
			}
			
			if (FlxG.keys.justPressed("ENTER")) { 
				dialogueIndex = c4Text.length;
				Log.CustomMetric("SkippedC4", "Cutscenes"); 
			}
			if (dialogueIndex >= c4Text.length) {
				Registry.cutscenesWatched[3] = true;
				FlxG.switchState(new Ending());
			}
			super.update();
		}
		
		
		private var c4Text:Array = new Array(
		"Groovy!\n\n",
		"Dave made it through\nthose trials and tribulations.\n",
		"He wonders what those last\nfive stages are, though.\n",
		"He supposes he must need\nto get more time medals\nand notes to find out!",
		"Because maybe he'll\nsee a different ending.\n",
		"I mean, if he knew\nwhat an ending was,\nof course.",
		"Onwards! To the ending!\nOr more adventuring...\n"
		);
		
		
	}
}