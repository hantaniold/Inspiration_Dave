package 
{
	import org.flixel.FlxGroup;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSound;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	import org.flixel.FlxText;
	import org.flixel.FlxTilemap;
	import org.flixel.FlxG;
	import org.flixel.plugin.photonstorm.FlxBitmapFont;
	import statics.LevelData;
	import Playtomic.Link;
	import Playtomic.Log;
    import com.newgrounds.*;
	
	public class HutState extends FlxState {
		
		[Embed (source = "res/img/sprites/treasure.png")] public var Treasure:Class;
		[Embed (source = "res/img/sprites/jukebox.png")] public var Jukebox:Class;
		[Embed (source = "res/img/sprites/secretlist.png")] public var SecretsList:Class;
		[Embed (source = "res/img/sprites/signbg.png")] public var SignBG:Class;
		[Embed (source = "../pic.png")] public var Pic:Class;

		
		private var map:FlxTilemap = new FlxTilemap();
		private var mapBG:FlxTilemap = new FlxTilemap();
		private var BG:FlxSprite = new FlxSprite();
		private var player:Player = new Player();
		private var exit:FlxSprite = new FlxSprite();
		
		/** Objects for the jukebox feature **/
		private var jukebox:FlxSprite = new FlxSprite(32 * 16, 25 * 16 + 4);
		private var jukeboxBG:FlxSprite = new FlxSprite(120, 100);
		private var songNames:Array = new Array("Titleitle", "Some Things Start Here",
		"World Map Bossa", "Here's To Learning", "Nonthreatening Lands", "Forestpeggio",
		"Whose House", "Treading Sharply", "Caves Are Deep");
		private var songIndex:int = 0;
		private var songText:FlxBitmapFont = new FlxBitmapFont(Registry.bigFontWhite, 14, 28, Registry.fontString, 26, 0, 0, 0, 2);
		
		/** Objects for the secrets List feature. */
		private var secretsList:FlxSprite = new FlxSprite(28 * 16, 25 * 16);
		private var secretsListBG:FlxSprite = new FlxSprite(120, 100);
		private var secretsListText:FlxBitmapFont = new FlxBitmapFont(Registry.bigFontWhite, 14, 28, Registry.fontString, 26, 0, 0, 0, 2);
		private var secretNames:Array = new Array("GROOVETASTIC", "I'VE GOT A HEADACHE", "A LONESOME, LAGGY TRAIL", "ARTSY OR LAZY?", "THIS COULD'VE BEEN YOU", "OK, JOKE'S OVER", "LE FREAK, C'EST CHIC");
		private var secretDescriptions:Array = new Array("That jukebox works now.\n Awesome!",
		 "Spin, spin, spin!",
		 "For those who want to see \nour trails for a long time.",
		 "You'd be well-advised \nnot to enter a level now.",
		 "A gruesome look into \nDave's spritesheet past.",
		 "For the completionists \nout there...",
		 "AWWW YEAH! \nTURN THAT DISCO UP!");
		private var secretIndex:int = 0;
		private var justEnteredSecretState:Boolean = false;
		
		/* Objects for the treasure box feature. */
		private var treasures:FlxGroup = new FlxGroup();
		private var treasureMessage:FlxBitmapFont = new FlxBitmapFont(Registry.bigFontWhite, 14, 28, Registry.fontString, 26, 0, 0, 0, 2);
		private var treasureMessageBG:FlxSprite = new FlxSprite();
		private var noteMedal:FlxSprite = new FlxSprite();
		private var timeMedal:FlxSprite = new FlxSprite();
		
		/* Some state for conditions on opening treasure. */
		private var timeReqs:Array = new Array(5, 10, 15, 20, 25, 31, 33);
		private var noteReqs:Array = new Array(150, 260, 360, 460, 560, 620, 660);
		private var nrNotes:int = 0;
		private var nrTimeMedals:int = 0;
		
		/* State for the update loop.*/
		private var S_NORMAL:int = 0;
		private var S_JUKEBOX:int = 1;
		private var S_SECRETS:int = 2;
		private var S_TWITTER:int = 3;
		private var state:int = S_NORMAL;
		
		/*Shameless plugging */
		private var shamelessPlug:FlxSprite = new FlxSprite(22 * 16, 21 * 16 + 4);
		private var credBG1:FlxSprite = new FlxSprite(100, 10);
		private var credBG2:FlxSprite = new FlxSprite(108, 18);
		private var credText:FlxBitmapFont = new FlxBitmapFont(Registry.font, 7, 14, Registry.fontString, 26, 0, 0, 0, 1);
		
		private var DOWN_P:Boolean = false;
		private var ADV_P:Boolean = false;
		private var noScrollPoint:FlxPoint = new FlxPoint(0, 0);
		override public function create():void {
			map.loadMap(LevelData.HUT, LevelData.HouseTiles, 16, 16);
			mapBG.loadMap(LevelData.HUTBG, LevelData.HouseTiles, 16, 16);
			BG.loadGraphic(LevelData.NightCityBG, false, false, 640, 480);
			BG.scrollFactor = noScrollPoint;
			add(BG);
			add(mapBG);
			
			/* Fill in how many medals we have given global state...*/
			calculateMedals();
			
			
			exit.loadGraphic(PlayState.Door, false, false, 16, 32);
			exit.x = 12 * 16; exit.y = 26 * 16;
			exit.solid = false;			
			add(exit);

			
			player.x = 14*16; player.y = 26*16;
			FlxG.camera.follow(player);		
			FlxG.camera.setBounds(0, 0, map.width, map.height, true);
			var i:int;
			for (i = 0; i < player.playerTrailSprites.length; i++) {
				add(player.playerTrailSprites[i]);
			}
			
			// GFX for secrets list/jukebox, as well as displayed notes/medals...
			var medal1:FlxSprite = new FlxSprite(28 * 16 + 116, 24 * 16- 17); medal1.scale = new FlxPoint(2, 2);
			medal1.loadGraphic(WorldMap.NoteMedal, false, false, 9, 14);
			add(medal1);
			var medal2:FlxSprite = new FlxSprite(28 * 16 + 116, 25 * 16 - 6); medal2.scale = new FlxPoint(2, 2);
			medal2.loadGraphic(WorldMap.TimeMedal, false, false, 9, 14);
			add(medal2);
			var medalsText:FlxBitmapFont = new FlxBitmapFont(Registry.bigFontBlack, 14, 28, Registry.fontString, 26, 0, 0, 0, 2);
			medalsText.setText(nrNotes.toString() + "\n" + nrTimeMedals.toString(),true,0,0,"left",true);
			medalsText.x = 28 * 16 + 137; medalsText.y = 24 * 16 - 20;
			add(medalsText);
			secretsList.loadGraphic(SecretsList, false, false, 32, 32);
			secretsList.solid = false;
			add(secretsList);

			jukebox.loadGraphic(Jukebox, true, false, 32, 32);
			jukebox.addAnimation("a", [0, 1, 2], 4, true); jukebox.play("a");
			jukebox.solid = false;
	
			
			// Add treasures, give them IDs. 
			var treasureXs:Array = new Array(40,44,48,53,57,61,68)
			var treasureYs:Array = new Array(25,25,18,18,15,15,18)
			for (i = 0; i < 7; i++) {
				var treasure:FlxSprite = new FlxSprite(treasureXs[i]*16,treasureYs[i]*16);
				treasure.loadGraphic(Treasure, false, false, 32, 32);
				if (Registry.boxesOpened[i]) {
					treasure.frame = 1;
				} else {
					treasure.frame = 0;
				}
				treasure.ID = i;
				treasures.add(treasure);
			}
			add(treasures);
			treasureMessageBG.alpha = 0;
			treasureMessageBG.makeGraphic(40, 72, 0xff0066ff);
		
			//Make the text associated with opening things
			treasureMessage.setText(" ", true, 0, 0, "left", true);
			treasureMessage.alpha = 0;
			noteMedal.loadGraphic(WorldMap.NoteMedal, false, false, 9, 14); 
			timeMedal.loadGraphic(WorldMap.TimeMedal, false, false, 9, 14);
			noteMedal.alpha = 0; timeMedal.alpha = 0;
			noteMedal.scale = timeMedal.scale = new FlxPoint(2, 2);
			
			//twitter thing
			shamelessPlug.loadGraphic(Pic, false, false, 100, 100);
			shamelessPlug.scale = new FlxPoint(0.5, 0.5);
			add(shamelessPlug);
			credBG1.makeGraphic(440, 400, 0xff0000df);
			credBG2.makeGraphic(440 - 16, 400 - 16, 0xff00aafd);
			credBG1.visible = credBG2.visible = credText.visible =  false;
			credText.setText("CREDITS!!!\nThanks to friends for their encouragement and advice - \nOH, MP, EH, GC, CK,\n\
			SP, CB, TC, MZ, DC, RY, RT\n\n\n\
			I made this game in Flixel,\n and used GIMP for graphics\n\
			and PxTone for the sound effects and music.\n\n\nIf you like this game, rate it a 5,\n share with friends,\n\
			and follow me on Twitter\n for future game updates !\n (Press T!)\n...or Z/J to exit this screen.)\n\n\
			This game made by Sean -seagaia- Hogan, 2012.",
			true, 0, 0, "center", true);
			credText.x = 32 + 90; credText.y = 30 + 20;
			credText.scrollFactor = credBG1.scrollFactor = credBG2.scrollFactor = noScrollPoint;
	
			
			//Draw in correct order
			add(jukebox);
			add(player);
			add(map);
			secretsListBG.loadGraphic(SignBG, false, false, 400, 200);
			secretsListBG.visible = secretsListText.visible = false;
			add(secretsListBG);
			secretsListText.setText("                          \n" + secretNames[0], true, 0, 0, "center", true);
			add(secretsListText);
			secretsListText.x = 140; secretsListText.y = 115;
			add(secretsListText); secretsListText.scrollFactor = secretsListBG.scrollFactor = noScrollPoint;
			
			//Load various other assets with the jukebox logic, etc...
			jukeboxBG.loadGraphic(SignBG, false, false, 400, 200);
			jukeboxBG.visible = false;
			
			add(jukeboxBG); jukeboxBG.scrollFactor = noScrollPoint;
			songText.setText("                         \n"+songNames[0], true, 0, 0, "center", true);
			songText.visible = false;
			songText.x = 140; songText.y = 115;
			add(songText); songText.scrollFactor = noScrollPoint;
			
			add(treasureMessageBG);
			add(treasureMessage); add(noteMedal); add(timeMedal);
			
			add(credBG1); add(credBG2); add(credText);
            
            var logo:FlxSprite = new FlxSprite(0, 340);
            logo.loadGraphic(Registry.SPONSOR_LOGO, false, false, 142, 136);
            add(logo);
            
            var miniInfo:FlxBitmapFont =  new FlxBitmapFont(Registry.font, 7, 14, Registry.fontString, 26, 0, 0, 0, 1);
            miniInfo.setText("Press '5' to play more games!", true, 0, 0, "left", true);
            miniInfo.x = 150;
            miniInfo.y = 465;
		
            var miniInfoBG:FlxSprite = new FlxSprite(miniInfo.x - 8, miniInfo.y - 5);
            var miniInfoBG2:FlxSprite = new FlxSprite(miniInfo.x - 4, miniInfo.y - 2);
            miniInfoBG.makeGraphic(298+34,18,0xFF0022EE);
            miniInfoBG2.makeGraphic(292 + 33, 16, 0xFF11FFFF);
            add(miniInfoBG); add(miniInfoBG2); add(miniInfo);  
            
            miniInfoBG.scrollFactor = miniInfoBG2.scrollFactor = miniInfo.scrollFactor = logo.scrollFactor = new FlxPoint(0, 0);
            
		}
		
		override public function update():void {
			
			DOWN_P = FlxG.keys.justPressed("DOWN") || FlxG.keys.justPressed("S");
			ADV_P = FlxG.keys.justPressed("X") || FlxG.keys.justPressed("J") || FlxG.keys.justPressed("UP") || FlxG.keys.justPressed("ENTER") || FlxG.keys.justPressed("SPACE");
			
		
        if (FlxG.keys.justPressed("FIVE")) {
            Log.LevelCounterMetric("Visited Sponsor In Game", "Links", true);
            Link.Open(Registry.SPONSOR_GAME, "sponsor site game", "sponsor links");
        }
			if (state == S_JUKEBOX) {
				updateJukebox();
				return;
			}
			if (state == S_SECRETS) {
				updateSecrets();
				return;
			}
			if (state == S_TWITTER) {
				updateCredits();
				return;
			}
			FlxG.collide(player, map);
			if (player.overlaps(shamelessPlug) && DOWN_P) {
                Log.LevelCounterMetric("Looked at hut credits", "Hut", true);
				FlxG.play(LevelData.Bloop);
				credText.visible = credBG1.visible = credBG2.visible = true;
				state = S_TWITTER;
				return;
			}
			if (player.overlaps(exit) && DOWN_P) {
				FlxG.play(LevelData.HitDoor);
				FlxG.switchState(new WorldMap());
			}
			if (player.overlaps(jukebox) && DOWN_P) {
				if (Registry.boxesOpened[0]) {
                    Log.LevelCounterMetric("Opened jukebox", "Hut", true);
					state = S_JUKEBOX;
					jukeboxBG.visible = true;
					songText.visible = true;
					songText.text = "                         \n--"+songNames[songIndex]+"--\nX/J = Play\nMore Music (Link): S"
				} else {
					treasureMessage.x = player.x - 20; treasureMessage.y = player.y - 55;
					FlxG.play(LevelData.Bloop);
					treasureMessage.alpha = 1;
					treasureMessage.text = "Out of order...";
				}
				return;
			}
			
			if (player.overlaps(secretsList) && DOWN_P) {
				state = S_SECRETS;
                
				secretsListBG.visible = true;
				secretsListText.visible = true;
				justEnteredSecretState = true;
				return;
			}
			
			if (treasureMessage.alpha > 0) {
				treasureMessage.alpha -= 0.012;
				treasureMessageBG.alpha -= 0.012;
				noteMedal.alpha -= 0.012;
				timeMedal.alpha -= 0.012;
			}
			if (DOWN_P) {	
				FlxG.overlap(treasures, player, openTreasure);
			}
			super.update();
		}
		
		public function updateCredits():void {
			if (FlxG.keys.justPressed("Z") || FlxG.keys.justPressed("K")) {
				state = S_NORMAL;
				credText.visible = credBG1.visible = credBG2.visible = false;

				
			}
			if (FlxG.keys.justPressed("T")) {
                API.unlockMedal("Shameless plug");
                Log.LevelCounterMetric("Went to twitter (hut)", "Links", false);
				Link.Open("http://twitter.com/seagaia2", "Twitter (hut)", "Links");
			}
			return;
		}
		/** Logic for opening a treasure - different messages based on whether, it's open, closed and don't meet
		 * the reqs, closed and meet the reqs.**/
		public function openTreasure(treasure:FlxSprite, player:Object):void {
			treasureMessage.x = player.x - 20; treasureMessage.y = player.y - 55;
			if (!Registry.boxesOpened[treasure.ID] && nrNotes >= noteReqs[treasure.ID] && nrTimeMedals >= timeReqs[treasure.ID]) {
				treasureMessage.alpha = 1;
				treasureMessage.text = "You got a secret!\nCheck the list.";
				FlxG.play(Note.fx1);
				Registry.boxesOpened[treasure.ID] = true;
				treasure.frame = 1;
				Log.CustomMetric("Got secret " + treasure.ID.toString(), "Secrets", false);
				return;
			} else if (!Registry.boxesOpened[treasure.ID]) { //must not satisfy reqs, give message
				FlxG.play(Player.DeathSound);
				treasureMessageBG.alpha = 1; noteMedal.alpha = 1;
				timeMedal.alpha = 1; treasureMessage.alpha = 1;
				noteMedal.x = treasureMessage.x; noteMedal.y = treasureMessage.y;
				timeMedal.x = treasureMessage.x; timeMedal.y = treasureMessage.y + 28;
				treasureMessage.text = " "+noteReqs[treasure.ID].toString() +"\n "+timeReqs[treasure.ID].toString();
				return;
			} 
			
		}
		public function updateJukebox():void {
			if (FlxG.keys.justPressed("Z") || FlxG.keys.justPressed("K")) {
				state = S_NORMAL;
				jukeboxBG.visible = false;
				songText.visible = false;
			}
			if (ADV_P) {
			
				playSong(songIndex);
			}
			if ((FlxG.keys.justPressed("LEFT") || FlxG.keys.justPressed("A")) && songIndex > 0) {
				songIndex--;
				songText.text = "                         \n--"+songNames[songIndex]+"--\nX/J = Play\nMore Music (Link): S";
			} 
			if ((FlxG.keys.justPressed("RIGHT") || FlxG.keys.justPressed("D")) && songIndex < songNames.length - 1) {
				songIndex++;
				songText.text = "                         \n--"+songNames[songIndex]+"--\nX/J = Play\nMore Music (Link): S";
			}
			
			if (FlxG.keys.justPressed("S")) {
                API.unlockMedal("Thanks for listening!");
                Log.LevelCounterMetric("Went to soundcloud", "Links", true);
				Link.Open("http://soundcloud.com/seagaia", "soundcloud", "personal links");
			}
		}
		
		public function updateSecrets():void {
			if (FlxG.keys.justPressed("Z") || FlxG.keys.justPressed("K")) {
				state = S_NORMAL;
				secretsListText.visible = secretsListBG.visible = false;
			}
			
			if (ADV_P && Registry.boxesOpened[secretIndex]) {
				// If the secret's unlocked, toggle it
				Registry.secretsState[secretIndex] = !Registry.secretsState[secretIndex]; 
				//Toggle the long trail if necessary
				var j:int;
				var playerGFX:Class = Player.PlayerSprite;
				
				/* If the different sprite cheat is on, load that graphic. */
				if (Registry.secretsState[4]) {
					playerGFX = Player.OldPlayer;
				}
				
				player.loadGraphic(playerGFX, true, false, 15, 30);

				if (secretIndex == 2) {
					if (Registry.secretsState[secretIndex]) {
						player.extendTrail();
						for (j = 0; j < player.playerTrailSprites.length; j++) {
							if (j > 4) add(player.playerTrailSprites[j]);
							player.playerTrailSprites[j].loadGraphic(playerGFX, true, false, 15, 30);
						}
					} else {
						for (j = 0; player.playerTrailSprites.length > 5; j++) {
							player.playerTrailSprites.pop();
						}
					}
				}
			}
			if ((FlxG.keys.justPressed("LEFT") || FlxG.keys.justPressed("A")) && secretIndex > 0) {
				secretIndex--;
			}
			if ((FlxG.keys.justPressed("RIGHT") || FlxG.keys.justPressed("D")) && secretIndex < 6) {
				secretIndex++;
			}
			if (ADV_P || FlxG.keys.justPressed("LEFT") || FlxG.keys.justPressed("A") || FlxG.keys.justPressed("RIGHT") || FlxG.keys.justPressed("D") || justEnteredSecretState) {	
				justEnteredSecretState = false;
				if (!Registry.boxesOpened[secretIndex]) {
						secretsListText.text = "                          \n" + "????? (It's a secret!)";
					} else {
						secretsListText.text = "                          \n" + secretNames[secretIndex] + "\n" +
						secretDescriptions[secretIndex];
					}
				
				var secretNr:int = secretIndex + 1;
				secretsListText.text += "\n(" + secretNr.toString() + "/7)";
			
				if (secretIndex != 0 && secretIndex != 5 && Registry.boxesOpened[secretIndex]) {
					secretsListText.text += "\n(" + (Registry.secretsState[secretIndex] ? "ON" : "OFF") + ")";
				}
			}
		}
		
		private function playSong(songIndex:int):void {
			
			switch (songIndex) {
				case 0: FlxG.playMusic(LevelData.TitleSong, 1); break;
				case 1: FlxG.playMusic(LevelData.MenuSong,1); break;
				case 2: FlxG.playMusic(LevelData.BossaSong,1); break;
				case 3: FlxG.playMusic(LevelData.TutorialSong,1); break;
				case 4: FlxG.playMusic(LevelData.PlainsSong,1); break;
				case 5: FlxG.playMusic(LevelData.ForestSong,1); break;
				case 6: FlxG.playMusic(LevelData.HouseSong, 1); break;
				case 7: FlxG.playMusic(LevelData.CaveSong, 1); break;
				case 8: FlxG.playMusic(LevelData.SpecialSong, 1); break;
			}
			return;
		}
		
		private function calculateMedals():void {
			var i:int;
			for (i = 5; i < Registry.noteScores.length; i++) {
				nrNotes += Registry.noteScores[i];
			}
			for (i = 5; i < Registry.times.length; i++) {
				if (i == 24) continue;
				if (Registry.times[i] == 0) continue;
				
				if (Registry.times[i] < Registry.devTimes[i]) {
					nrTimeMedals++;
				}
			}
		}
	}
}