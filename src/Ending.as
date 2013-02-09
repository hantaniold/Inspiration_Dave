package {
	import org.flixel.FlxG;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	import org.flixel.plugin.photonstorm.FlxBitmapFont
	import statics.LevelData;
	import entities.WrapSprite;
	import Playtomic.Log;
	public class Ending extends FlxState {
	
		[Embed (source = "res/img/bg/endingBG.png")] private var EndingBG:Class;
		[Embed (source = "res/img/cutscenes/theend.png")] private var TheEnd:Class;

		private var player:FlxSprite = new FlxSprite();
		
		private var bg1:WrapSprite = new WrapSprite(0, 0, 640, -100, true);
		private var bg2:WrapSprite = new WrapSprite(640,0, 640, -100, true);
		
		private var theEnd:FlxSprite = new FlxSprite(120, 60);
		
		private var text:FlxBitmapFont = new FlxBitmapFont(Registry.bigFontWhite, 14, 28, Registry.fontString, 26, 0, 0, 0, 2);
		private var filler:String = "                                        \n";
		private var dialogue:Array;
		private var dialogueIndex:int = 0;
		private var doExit:Boolean = false;
		private var doExit2:Boolean = false;
		private var timer:Number = 0;
		
		private var overlay:FlxSprite = new FlxSprite(0, 0);
		override public function create():void {
		FlxG.bgColor = 0x000000;
		FlxG.playMusic(LevelData.TitleSong, 1.0);
		
		bg1.loadGraphic(EndingBG, false, false, 640, 480);
		bg2.loadGraphic(EndingBG, false, false, 640, 480);
		add(bg1);
		add(bg2);
		
		player.x = 283; player.y = 230;
		player.scale = new FlxPoint(3,3);
		player.loadGraphic(Player.PlayerSprite, true, false, 15, 30);
		player.addAnimation("run", [ 1, 2, 3, 4, 5, 6, 7, 8, 9,10], 10, true);
		player.play("run");
		add(player);
		
		theEnd.loadGraphic(TheEnd, false, false, 400, 100);
		theEnd.alpha = 0;
		add(theEnd);
		           //"                                     "                                    "
				   //"                                        \n";
		text.setText(filler+"And so, Dave's quest for\n inspiration ends here.",true,0, 0, "center", true);
		text.x = 20;
		text.y = 350;
		add(text);
		setDialogue();
		
		overlay.makeGraphic(640, 480, 0xFF000000);
		overlay.alpha = 0;
		add(overlay);
		
		}
		
		override public function update():void {
			if (!doExit) {
				if (FlxG.keys.justPressed("X") || FlxG.keys.justPressed("J")) {
					dialogueIndex++;
					if (dialogueIndex >= dialogue.length) {
						doExit = true;
						bg1.velocity.x = bg2.velocity.x = 0;
						player.velocity.x = 90;
						text.text = " ";
					} else {
						text.text = filler + dialogue[dialogueIndex];
					}
					
				}
			} else {
				theEnd.alpha += 0.01;
				if (theEnd.alpha > 0.9 && (FlxG.keys.justPressed("X") || FlxG.keys.justPressed("J"))) {
					doExit2 = true;
				}
				if (doExit2) {
					timer += FlxG.elapsed;
					overlay.alpha += 0.01;
					if (overlay.alpha > 0.95 && timer > 3) {
						FlxG.switchState(new WorldMap());
					}
				}
			}
			super.update();
		}
		
	  //"                                        \n";
	  private function setDialogue():void {
		 var noteTotal:int;
		 var nrSecrets:int;
		 var nrTimeMedals:int;
		 
		 var notewords:String;
		 var timewords:String;
		 var secretwords:String;
		 var finalmessage:String;
		 
		 var i:int;
		 
		 for (i = 0; i < Registry.noteScores.length; i++) {
			 noteTotal += Registry.noteScores[i];
		 }
		 for (i = 0; i < 7; i++) {
			 if (Registry.boxesOpened[i]) {
				 nrSecrets++;
			 }
		 }
		 
		 for (i = 5; i <= 38; i++) {
			 if (Registry.times[i] == 0 || i == 24) continue;
			 if (Registry.times[i] < Registry.devTimes[i]) nrTimeMedals++;
		 }
		 Log.LevelCounterMetric("Entered Ending", "Ending");
		 Log.CustomMetric("Time Medals At Ending", "Ending Stats", false);
		 Log.CustomMetric("Notes At Ending", "Ending Stats", false);
		 Log.CustomMetric("Secrets At Ending", "Ending Stats", false);
		 Log.LevelAverageMetric("Deaths at end", "Ending", Registry.nrDeaths, false);
		 
		 if (noteTotal < 100) { 
			 notewords = "Wow, almost no notes at all!\nImpressive, actually.";
		 } else if (noteTotal < 400) {
			 notewords = "That's a decent amount...\nbut I'm sure you can do better!";
		 } else if (noteTotal < 600) {
			 notewords = "Great job! \n Go a little further!";
		 } else if (noteTotal < 660) {
			 notewords = "You're really close\nto getting all the notes!\nKeep it up!";
		 } else {
			 notewords = "That's 100%!\nThanks for getting them all!";
		 }
		 if (nrTimeMedals < 1) {
			 timewords = "...which means you're slow.\n:(";
		 } else if (nrTimeMedals < 10) {
			 timewords  = "...which is an okay amount.\nYou could be faster, though!";
		 } else if (nrTimeMedals < 20) {
			 timewords  = "...which means you did a decent job.\nA fast, decent job!";
		 } else if (nrTimeMedals < 30) {
			 timewords = "...you're pretty fast at this!";
		 } else if (nrTimeMedals < 33) {
			 timewords = "...you're real good!\nAlmost to 100%!";
		 } else {
			 timewords = "...wow, you beat the times\non all the stages!\nGreat job!";
		 }
		 if (nrSecrets == 0) {
			 secretwords = "...hm...\nHave you gone to the hut?";
		 } else if (nrSecrets < 3) {
			 secretwords = "Well, you got a few!\nHope you enjoyed them...";
		 } else if (nrSecrets < 7) {
			 secretwords = "That's a nice amount..\nbut not seven!\n";
		 } else {
			 secretwords = "Cool, you got them all!\nHope they were worth your time.";
		 }
			
		 if (noteTotal < 400) {
			 finalmessage = "It wasn't very good.\nIt was called a poor mockup of Davement.\nDave was thrown in jail! :(";
		 } else if (noteTotal < 600) {
			 finalmessage = "It was given an 8.6.\nA decent job, by Ditchpork standards.\nMaybe best new music!";
		 } else if (nrSecrets < 4) {
			 finalmessage = "It scored a 9.2...\nbut that was 0.1 points\nlower than Davement's! :(";
		 } else {
			 finalmessage = "A 10.0! A revolutionary album!\nDave soon became a rock star,\nand grew up happily...or did he?";
		 }
		 
		dialogue = new Array(
		"Well, unless you decide to like, keep\n playing, or something. Which you can !",
		"How well did his quest for inspiration go?\nWell, you should know the answer...",
		"Let's see here...\n",
		"You got " + noteTotal.toString() + " notes...\n...out of a possible 660!",
		notewords,
		"Were you fast? Furious?\nYou got " + nrTimeMedals.toString() + " out of 33 possible time medals...",
		timewords,
		"And out of the seven secrets available...\nyou unlocked "+nrSecrets.toString()+".",
		secretwords,
		"Hmm, okay...let's see.",
		"How did Dave do? \nWhat were the results?",
		"How did Ditchpork, the popular\nand possible evil music tastemaker\nperceive Dave's album?",
		"Well...",
		finalmessage,
		"Anyways, thanks for getting \nDave through this.",
		"...even though he's stuck\nin the '90s!",
		"I hope you had as \nmuch fun playing this,\nas I had making it.",
		"Farewell!",
		"(You should try to get everything!)"
		);
		}
		
	}
	
	
}