package {
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.FlxG;
	import org.flixel.FlxState;
	import org.flixel.FlxGroup;
	import org.flixel.FlxEmitter;
	import org.flixel.FlxParticle;
	import Playtomic.Log;
	import Playtomic.Link;
    import com.newgrounds.*;
	
	import org.flixel.plugin.photonstorm.FlxBitmapFont;
	import statics.LevelData;
public class WorldMap extends FlxState {

	// This sound triggers when we enter from the main menu.
	[Embed(source = "res/img/worldmap/worldmap.png")] public var Map:Class;
	[Embed(source="res/mp3/notefx1.mp3")] public var fx1:Class;
	[Embed(source = "res/img/worldmap/map-small.png")] public var SmallMapMarker:Class;
	[Embed(source = "res/img/worldmap/map-big.png")] public var BigMapMarker:Class;
	[Embed(source = "res/img/sprites/player2.png")] public static var PlayerGFX:Class;
	[Embed(source = "res/img/worldmap/star.png")] public static var StarGFX:Class;
	[Embed(source = "res/img/worldmap/worldmaparrows.png")] public static var Arrows:Class; //up right down left

	[Embed(source = "res/img/sprites/noteMedal.png")] public static var NoteMedal:Class;
	[Embed(source = "res/img/sprites/timeMedal.png")] public static var TimeMedal:Class;
	public var mapPoints:Array = new Array(new FlxPoint());
	public var stageNames:Array = new Array("", " ", 
	" ", " ", 
	" ", "BELIEVE IN YOURSELF", "FIRST STEPS", "WHOSE HILL", "INDENTATION",
	"STUMBLE DOWN", "FALL LIKE A TEENAGER", "NOT SUPPOSED TO FLOAT", "APPLE CRUMBLE", "BETCHA'LL RESTART", "OH GOD CHOICES",
	"THE BIG EASY", "PORTABELLO", "DEFINITELY A GAME", "FLOATING WOOD", "GET HABITUATED", 
	"AWKWARD", "32-BIT PRECISION", "AIR CONTROL", "STUPENDOUS WORK",
	"THE GROOVE HUT",
	"WHAT IDIOT PUTS SPIKES IN THEIR HOME", "APPARENTLY MORE THAN ONE", "IT'S EXPERIMENTAL", "AN IMPRACTICAL ARCHITECT", 
	"SPASTIC", "LIKE A SQUID BUT NOT", "SUGGESTIVE", "PULLS MY HEART STRINGS", "VALIDATION",
	"BEEF JERKY", "ALYSSA, MY LOVE","BUILDS CHARACTER","HITBOXES","lowercase");
	public var stageNicks:Array = 
		new Array("", " ", " ", " ", " ", "T",
					"1-1", "1-2", "1-3", "1-4", "1-5", "1-6", "1-7", "1-8", "1-9",
					"2-1", "2-2", "2-3", "2-4", "2-5", "2-6", "2-7", "2-8", "2-9",
					 " ",
					 "3-1", "3-2", "3-3", "3-4", "3-5", "3-6", "3-7", "3-8", "3-9",
					 "S-1", "S-2", "S-3", "X-1", "X-2");
								
	public var player:FlxSprite = new FlxSprite(0, 0);
	private var arrows:Array = new Array(new FlxSprite(0, 0), new FlxSprite(0, 0), new FlxSprite(0, 0), new FlxSprite(0, 0));
	private var doFadeIn:Boolean = true;
	private var fadeOut:FlxSprite = new FlxSprite(0, 0);
	public var level:int = 5;
	public var oldLevel:int;	
	
	public var levelName:FlxBitmapFont = new FlxBitmapFont(Registry.font, 7, 14, Registry.fontString, 26, 0, 0, 0, 1);
	public var noteText:FlxBitmapFont = new FlxBitmapFont(Registry.font, 7, 14, Registry.fontString, 26, 0, 0, 0, 1);
	public var timeText:FlxBitmapFont = new FlxBitmapFont(Registry.font, 7, 14, Registry.fontString, 26, 0, 0, 0, 1);
	public var widthFiller:String = "                                                     \n";
	
	public var liu:Array = Registry.levelIsUnlocked;
	
	public var wju:Array = Registry.wasJustUnlocked;
	public var pathQueue:Array = new Array();
	public var queueTimer:Number = 0;
	public var emitters:FlxGroup;
	public var doNewMarkers:Boolean = true;
	public var dANM:Boolean = false; //Done adding new markers?
	public var isMoving:Boolean = false;
	
	private var doEnterLevel:Boolean = false;
    
    private var sponsorLogo:FlxSprite = new FlxSprite();
    private var sponsorLogoText:FlxBitmapFont = new FlxBitmapFont(Registry.font, 7, 14, Registry.fontString, 26, 0, 0, 0, 1);
    
	/** stats screen stuff **/
	private var doStats:Boolean = false;
	private var statsString:FlxBitmapFont = new FlxBitmapFont(Registry.font, 7, 14, Registry.fontString, 26, 0, 0, 0, 1);
	private var statsStrings:Array = new Array("", "", "", "", "");
	private var statsBG1:FlxSprite = new FlxSprite(16, 16); 
	private var statsBG2:FlxSprite = new FlxSprite(20, 20);
	private var page:int = 0; //What page of stats to show.
	private var timeMedals:Array = new Array();
	private var noteMedals:Array = new Array();
    private var sponsorStatsLogo:FlxSprite = new FlxSprite();
    private var sponsorStatsLogoText:FlxBitmapFont = new FlxBitmapFont(Registry.font, 7, 14, Registry.fontString, 26, 0, 0, 0, 1);
	private var openedMenu:Boolean = false;
	/***/
	
	private var starEffectDone:Boolean = false; /*The star effect for jumpin' into a stage */
	private var enterLevelTimer:Number = 1.5;
	private var soundTimer:Number = 0.5;
	
	private var saveGraphic:FlxSprite = new FlxSprite(240, 400);	
	private var saveGraphic2:FlxSprite = new FlxSprite(236, 396);

	private var saveText:FlxBitmapFont = new FlxBitmapFont(Registry.font, 7, 14, Registry.fontString, 26, 0, 0, 0, 1);

	private var canMoveTimer:Number = 0;
	
	private var UP_P:Boolean = (FlxG.keys.UP || FlxG.keys.W);
	private var DOWN_P:Boolean = (FlxG.keys.DOWN || FlxG.keys.S);
	private var LEFT_P:Boolean = (FlxG.keys.LEFT || FlxG.keys.A);
	private var RIGHT_P:Boolean = (FlxG.keys.RIGHT || FlxG.keys.D);
	private var ADV_P:Boolean = (FlxG.keys.X || FlxG.keys.K);
	private var BACK_P:Boolean = (FlxG.keys.Z || FlxG.keys.J);
	
	
	override public function create():void {

	        //Call achievements etc
        Achievements.unlock(); 
		var map:FlxSprite = new FlxSprite(0, 0);
		map.loadGraphic(Map);
		add(map);
		oldLevel = level;
		level = Registry.level;
		saveGame();
		/**stats logic**/
		statsString.setText(" ", true, 0, 0, "left", true);
		statsString.x = 24; statsString.y = 24;
		statsBG1.makeGraphic(640 - 32, 280 - 32, 0xff00ffff);
		statsBG2.makeGraphic(640 - 40, 280 - 40, 0xff00cccc);
		statsString.visible = false;
		statsBG1.visible = false; statsBG2.visible = false;
		initStats();
		
		// Shortened the name for my sanity of typing/readability...
		if (Registry.secretsState[4]) {
			player.loadGraphic(Player.OldPlayer, true, false, 15, 30);
		} else {
			player.loadGraphic(PlayerGFX, true, false, 15, 30);
		}
		player.addAnimation("Walk", [1,2], 4, true);
		player.addAnimation("Still", [0]);
		player.play("Walk");
		isMoving = true;
		
		FlxG.camera.follow(player);
		FlxG.camera.setBounds(0, 0, 640, 480, true);
			
		emitters = new FlxGroup();
		add(emitters);
		
		saveGraphic.makeGraphic(280, 74, 0xff00DDFF);
		saveGraphic2.makeGraphic(288, 82, 0xff000000);
		add(saveGraphic2);		
		add(saveGraphic);

		var first:String = "Press X/J to enter a level. M to mute.\n";	
		if (Registry.cutscenesWatched[3]) {
			first = "Press E to go to the ending again!\n";
		}
		saveText.setText(first+"Arrow keys/WASD move. I to view stats.\nThis game autosaves!\nPress '5' to play more games!", true, 0, 0, "left", true);
	
		saveText.x = 245; saveText.y = 410;
		add(saveText);
		
        sponsorLogo.loadGraphic(Registry.SPONSOR_LOGO, false, false, 142, 136);
        sponsorLogo.x = 10; sponsorLogo.y = 335;
        add(sponsorLogo);
        sponsorLogoText.setText("Press '5' to play more games! \n (Do it!)", true, 0, 0, "left", true);
        sponsorLogoText.x = 10; sponsorLogoText.y = sponsorLogo.y + 110;
      //  add(sponsorLogoText);
		
        
		
		fadeOut.makeGraphic(640, 480, 0xFF000000);
		fadeOut.alpha = 1;
		
		update();
		add(player);
		player.x = mapPoints[level].x;
		player.y = mapPoints[level].y;
		for (var ar:int = 0; ar < 4; ar++) {
			add(arrows[ar]);
			arrows[ar].visible = false;
			arrows[ar].loadGraphic(Arrows, true, false, 9, 9);
			arrows[ar].addAnimation("a", [2 * ar, 2 * ar + 1], 2, true);
			arrows[ar].play("a");
		}
		
		add(fadeOut);
	
		levelName.setText(widthFiller+"What's going on? 123/592.", true, 0, 0, "center", true);
		levelName.x = 150; levelName.y = -4; //levelName.al
		add(levelName);
		
		noteText.setText(widthFiller+"Blah balah balh", true, 0, 0, "center", true);
		noteText.x = 150; noteText.y = 7;
		add(noteText);
		
		timeText.setText(widthFiller+"Blah balah balh", true, 0, 0, "center", true);
		timeText.x = 150; timeText.y = 17;
		add(timeText);
		
        
		add(statsBG1);
		add(statsBG2);
        sponsorStatsLogo.loadGraphic(Registry.SPONSOR_LOGO, false, false, 142, 136);
        sponsorStatsLogo.x = 470; sponsorStatsLogo.y = 90;
        add(sponsorStatsLogo);
        sponsorStatsLogo.visible = sponsorStatsLogoText.visible = false;
        sponsorStatsLogoText.setText("Press '5' to play more games!", true, 0, 0, "left", true);
        sponsorStatsLogoText.x = 410; sponsorStatsLogoText.y = sponsorStatsLogo.y + 150;
        add(sponsorStatsLogoText);
		add(statsString);
		var ix:int = 24;
		var iy:int = 24 + 14*3;
		for (var i:int = 0; i < 9; i++) {
			var noteMedal:FlxSprite = new FlxSprite(ix, iy + 14 * i);
			noteMedal.loadGraphic(NoteMedal, false, false, 9, 14);
			noteMedal.visible = false;
			add(noteMedal);
			noteMedals.push(noteMedal);
			
			var timeMedal:FlxSprite = new FlxSprite(ix + 16, iy + 14 * i);
			timeMedal.loadGraphic(TimeMedal, false, false, 9, 14);
			timeMedal.visible = false;
			add(timeMedal);
			timeMedals.push(timeMedal);
		}
	}
	override public function update():void {
		UP_P = (FlxG.keys.justPressed("UP") || FlxG.keys.justPressed("W"));
		DOWN_P = (FlxG.keys.justPressed("DOWN") || FlxG.keys.justPressed("S"));
		LEFT_P = (FlxG.keys.justPressed("LEFT") || FlxG.keys.justPressed("A"));
		RIGHT_P = (FlxG.keys.justPressed("RIGHT") || FlxG.keys.justPressed("D"));
		ADV_P = (FlxG.keys.justPressed("X") || FlxG.keys.justPressed("J") || FlxG.keys.justPressed("ENTER") || FlxG.keys.justPressed("SPACE"));
		BACK_P = (FlxG.keys.justPressed("Z") || FlxG.keys.justPressed("K"));
		
        if (FlxG.keys.justPressed("FIVE")) {
            Log.LevelCounterMetric("Visited Sponsor In World Map", "Links", true);
            Link.Open(Registry.SPONSOR_WORLDMAP, "sponsor site world map", "sponsor links");
        }
		
		if (doStats) {
			showStats();
			return;
		} else if (FlxG.keys.justPressed("I")) {
			openedMenu = true;
			doStats = true;
		}

		
		if (doFadeIn && fadeOut.alpha > 0) {
			fadeOut.alpha -= 0.01;
		} else {
			doFadeIn = false;
		}
		if (soundTimer > 0) {
			soundTimer -= FlxG.elapsed;
			if (soundTimer < 0.1) {
				FlxG.volume = 0;
				if (!Registry.globalMute) {
					FlxG.playMusic(LevelData.BossaSong, 1.0);
				} else {
					FlxG.volume = 0;
				}
				soundTimer = 0;
			}
		} else {
			if (FlxG.volume <= 1 && !Registry.globalMute)
				FlxG.volume += 0.01;
		}
		
		if (doNewMarkers) {
			liu[5] = true;
			
			/* Boilerplate for determining if the "extra" world stages are open*/
			var sum:int = 0;
			var i:int;
			for (i = 6; i <= 14; i++) {
				sum += Registry.noteScores[i];
				if (sum == 180) {
					if (!Registry.levelIsUnlocked[34]) {
						Registry.levelIsUnlocked[34] = true;
					}
				} else {
					Registry.levelIsUnlocked[34] = liu[34] = false;
				}
			} 
			sum  = 0;
			for (i = 15; i <= 23; i++) {
				sum += Registry.noteScores[i];
				if (sum == 180) {
					if (!Registry.levelIsUnlocked[35]) {
						Registry.levelIsUnlocked[35] = true;
					}
				} else {
					Registry.levelIsUnlocked[35] = liu[35] = false;
				}
			}
			sum = 0;
			for (i = 25; i <= 33; i++) {
				sum += Registry.noteScores[i];
				if (sum == 180) {
					if (!Registry.levelIsUnlocked[36]) {
						Registry.levelIsUnlocked[36] = liu[36] = true;
					}
				} else {
					Registry.levelIsUnlocked[36] = liu[36] = false;
				}
			}
			
			if (Registry.boxesOpened[5]) {
				if (!liu[37]) {
					wju[37] = Registry.levelIsUnlocked[37] = liu[37] = true;
				}
			}
			//if sponsor press S
			if (Registry.sponsorOn || Registry.SPONSORRR) {
				
				Registry.sponsorOn = true;
				for (var kaa:int = 5; kaa <= 38; kaa++) {
					Registry.levelIsUnlocked[kaa] = liu[kaa] = true;
				}
			}
			
			// Determine what markers appear. I regret doing it this way, but have learned from doing so..
			
			if (liu[5]) {
				mapPoints.length = 5;
				addMarker(true, 49, 93, Registry.noteScores[5], wju[5],5);
			}
			if (liu[6]) {
				addMarker(false, 49, 113, 0, wju[6],6);
				addMarker(false, 48, 126, 0, wju[6],6);
				addMarker(true, 37, 137, Registry.noteScores[6], wju[6],6);
			} 
			if (liu[7]) {
				addMarker(false, 59, 140, 0, wju[7],7);
				addMarker(true, 73, 135, Registry.noteScores[7], wju[7],7);
			} 
			if (liu[8]) {
				addMarker(false, 93, 136, 0, wju[8],8);
				addMarker(true, 107, 129, Registry.noteScores[8], wju[8],8);
			}
			if (liu[9]) {
				addMarker(false, 95, 162, 0, wju[8],8);
				addMarker(false, 109, 151, 0, wju[8],8);
				addMarker(true, 77, 165, Registry.noteScores[9], wju[9],9);
			}
			if (liu[10]) {
				addMarker(false, 65, 170, 0, wju[10],10);
				addMarker(true, 45, 169, Registry.noteScores[10], wju[10],10);
			}
			if (liu[11]) {
				addMarker(false, 56, 194, 0, wju[11],11);
				addMarker(false, 69, 212, 0, wju[11],11);
				addMarker(false, 85, 224, 0, wju[11], 11);
				addMarker(true, 102, 219, Registry.noteScores[11], wju[11],11);
			} 
			if (liu[12]) {
				addMarker(false, 127, 207, 0, wju[12],12);
				addMarker(false, 144, 191, 0, wju[12], 12);
				addMarker(true, 152, 169, Registry.noteScores[12], wju[12],12);
			}
			if (liu[13]) {	
				addMarker(false, 176, 160, 0, wju[13],13);
				addMarker(false, 190, 149, 0, wju[13], 13);
				addMarker(true, 197, 127, Registry.noteScores[13], wju[13],13);		
			}
			if (liu[14]) {
				addMarker(false, 216, 118, 0, wju[14], 14);
				addMarker(false, 226, 106, 0, wju[14], 14);
				addMarker(true, 232, 88, Registry.noteScores[14], wju[14], 14);		
			}//hut is open
			if (liu[15]) {
				addMarker(true, 317, 165, Registry.noteScores[15], wju[15],15);		
				addMarker(false, 259, 105, 0, wju[15], 15);
				addMarker(false, 285, 124, 0, wju[15], 15);	
				addMarker(false, 319, 149, 0, wju[15], 15);
				if (!liu[24]) {Registry.levelIsUnlocked[24] = true; liu[24] = true; wju[24] = true; }
			}
			if (liu[16]) {
				addMarker(true, 261, 173, Registry.noteScores[16], wju[16],16);		
				addMarker(false, 295, 175, 0, wju[16], 16);	
				
			}
			if (liu[17]) {
				addMarker(true, 246, 208, Registry.noteScores[17], wju[17],17);									
				addMarker(false, 253, 193, 0, wju[17], 17);
			}
			if (liu[18]) {
				addMarker(true, 191, 235, Registry.noteScores[18], wju[18],18);		
				addMarker(false, 227, 227, 0, wju[18], 18);
			}
			if (liu[19]) {
				addMarker(true, 126, 262, Registry.noteScores[19], wju[19], 19);		
				addMarker(false, 162, 254, 0, wju[19], 19);
			}
			if (liu[20]) {
				addMarker(true, 54, 264, Registry.noteScores[20], wju[20], 20);		
				addMarker(false, 93, 270, 0, wju[20], 20);
			}
			if (liu[21]) {
				addMarker(true, 90, 311, Registry.noteScores[21], wju[21], 21);		
				addMarker(false, 71, 295, 0, wju[21], 21);
			}
			if (liu[22]) {
				addMarker(true, 190, 288, Registry.noteScores[22], wju[22], 22);		
				addMarker(false, 131, 312, 0, wju[22], 22);
				addMarker(false, 167, 302, 0, wju[22], 22);
			}
			if (liu[23]) {
				addMarker(true, 297, 249, Registry.noteScores[23], wju[23], 23);		
				addMarker(false, 225, 278, 0, wju[23], 23);
				addMarker(false, 265, 266, 0, wju[23], 23); 
			}
			if (liu[24]) {
				if (mapPoints.length < 25) mapPoints.length = 24;
				addMarker(true, 316, 127, Registry.noteScores[24], wju[24], 24);
				addMarker(false, 316, 213, 0, wju[24], 24);
			}
			if (liu[25]) {
				addMarker(true, 461,102, Registry.noteScores[25],wju[25], 25);
				addMarker(false, 361, 128, 0, wju[25], 25);
				addMarker(false, 394, 120, 0, wju[25], 25);
				addMarker(false, 426, 112, 0, wju[25], 25);
			}
			if (liu[26]) {
				addMarker(true, 504,100, Registry.noteScores[26],wju[26], 26);
				addMarker(false, 487,106, 0, wju[26], 26);
			}
			if (liu[27]) {
				addMarker(true, 542,91, Registry.noteScores[27],wju[27], 27);
				addMarker(false, 529,100, 0, wju[27], 27);
			}
			if (liu[28]) {
				addMarker(true, 574,92, Registry.noteScores[28],wju[28], 28);
				addMarker(false, 561, 96, 0, wju[28], 28);
			}
			if (liu[29]) {
				addMarker(true, 598,145, Registry.noteScores[29],wju[29], 29);
				addMarker(false, 594,121, 0, wju[29], 29);
			}
			if (liu[30]) {
				addMarker(true, 590,184, Registry.noteScores[30],wju[30], 30);
				addMarker(false, 600, 170, 0, wju[30], 30);
			}
			if (liu[31]) {
				addMarker(true, 547,159, Registry.noteScores[31],wju[31], 31);
				addMarker(false, 573, 177, 0, wju[31], 31);
			}
			if (liu[32]) {
				addMarker(true, 508,184, Registry.noteScores[32],wju[32], 32);
				addMarker(false, 534,176, 0, wju[32], 32);
			}
			if (liu[33]) {
				addMarker(true, 474,160, Registry.noteScores[33],wju[33], 33);
				addMarker(false, 495, 176, 0, wju[33], 33);
				addMarker(false, 472, 136, 0, wju[33], 33);
			}
			if (liu[34]) {
				if (mapPoints.length < 35) mapPoints.length = 34;
				addMarker(true, 176, 75, Registry.noteScores[34], wju[34], 34);
				addMarker(false, 208, 88, 0, wju[34], 34);
			} 
			if (liu[35]) {
				if (mapPoints.length < 36) mapPoints.length = 35;
				addMarker(true, 284, 308, Registry.noteScores[35], wju[35], 35);
				addMarker(false, 299, 277, 0, wju[35], 35);
			}
			if (liu[36]) {
				addMarker(false, 475, 188, 0, wju[36], 36);
				addMarker(true, 471, 208, Registry.noteScores[36], wju[36], 36);
			}
			if (liu[37]) {
				addMarker(true, 303, 76, Registry.noteScores[37], wju[37], 37);
			}
			if (liu[38]) {
				addMarker(true, 351, 58, Registry.noteScores[38], wju[38], 38);
				
			}
			doNewMarkers = false;
			pathQueue.reverse();
			
			for (var idd:int = 0; idd < wju.length; idd++) {
				Registry.wasJustUnlocked[idd] = false;
				
			}
		} else {
			updateMap();
		}
	}
	public function updateMap():void {
		canMoveTimer += FlxG.elapsed;
		if (FlxG.keys.justPressed("E") && Registry.cutscenesWatched[3]) {
			FlxG.switchState(new Ending());
		}
		queueTimer += FlxG.elapsed;
		if (queueTimer > 0.25 && pathQueue.length > 0) {
			queueTimer = 0;
			FlxG.play(LevelData.Bloop);
			var marker:FlxSprite = pathQueue.pop();
			var markerEmitter:FlxEmitter = new FlxEmitter(0,0,50);
			markerEmitter.particleDrag = new FlxPoint(0,0);
			markerEmitter.gravity = 350;
			for (var i:int = 0; i < 50; i++) {
				var particle:FlxParticle = new FlxParticle();
				particle.makeGraphic(3,3,0x8800FF00);
				particle.lifespan = 4.4;
				particle.exists = false;
				markerEmitter.add(particle);
			}
			emitters.add(markerEmitter);
			markerEmitter.at(marker);
			markerEmitter.start(true, 4.4);
			marker.visible = true;
		} else if (pathQueue.length == 0) {
			dANM = true; //done Adding NEw Markers
		}
		
		/* Logic for determining where a player can move. Ew. 
		 * Terrible way of doing it, BUT IT WORKRKSSKKS */
		if ((UP_P || RIGHT_P ||
		    DOWN_P || LEFT_P ) &&
			dANM && !isMoving && (canMoveTimer > 1) && (pathQueue.length == 0)) {
			
			oldLevel = level;
			player.scale.x = 1;
			if (RIGHT_P) {
				switch (level) {
				case 6: if (liu[7]) level = 7; break;
				case 7: if (liu[8]) level = 8; break;
				case 9: level = 8; break;
				case 10: level = 9; break;
				case 11: if (liu[12]) level = 12; break;
				case 12: if (liu[13]) level = 13; break;
				case 13: if (liu[14]) level = 14; break;
				case 14: if (liu[24]) level = 24; break; //Hut
				case 16: level = 15; break;
				case 18: level = 17; break;
				case 19: level = 18; break;
				case 20: level = 19; break;
				case 21: if (liu[22]) level = 22; break;
				case 22: if (liu[23]) level = 23; break;
				case 24: if (liu[25]) level = 25; break;
				case 25: if (liu[26]) level = 26; break;
				case 26: if (liu[27]) level = 27; break;
				case 27: if (liu[28]) level = 28; break;
				
				case 31: level = 30; break;
				case 32: level = 31; break;
				case 33: level = 32; break;
				case 34: level = 14; break;
				case 37: if (liu[38]) level = 38; break;
				}
			} else if (LEFT_P) {
				player.scale.x = -1;
				switch(level) {
				case 7: level = 6; break;
				case 8: level = 7; break;
				case 9: if (liu[10]) level = 10;  break;
				case 11: level = 10; break;
				case 12: level = 11; break;
				case 13: level = 12; break;
				case 14: if (liu[34]) level = 34; break;
				case 15: if (liu[16]) level = 16; break;
				case 17: if (liu[18]) level = 18; break;
				case 18: if (liu[19]) level = 19; break;
				case 19: if (liu[20]) level = 20; break;
				case 21: level = 20; break;
			    case 22: level = 21; break;
				case 23: level = 22; break;
				case 24: level = 14; break; //hut
				case 25: level = 24; break;
				case 26: level = 25; break;
				case 27: level = 26; break;
				case 28: level = 27; break;
				case 30: if (liu[31]) level = 31; break;
				case 31: if (liu[32]) level = 32; break;
				case 32: if (liu[33]) level = 33; break;
				case 38: level = 37; break;
				}
			} else if (DOWN_P) {
				switch(level) {
				case 5: if (liu[6]) level = 6; break;
				case 8: if (liu[9]) level = 9; break;
				case 10: if (liu[11]) level = 11; break;
				case 14: level = 13; break;
				case 15: if (liu[23]) level = 23; break;
				case 16: if (liu[17]) level = 17; break;
				case 20: if (liu[21]) level = 21; break;
				case 23: if (liu[35]) level = 35; break;
				case 24: level = 15; break;
				case 25: if (liu[33]) level = 33; break;
				case 28: if (liu[29]) level = 29; break;
				case 29: if (liu[30]) level = 30; break;
				case 33: if (liu[36]) level = 36; break;
				case 37: level = 24; break;
				
				
				}
			} else if (UP_P) {
				switch(level) {
				case 6: level = 5; break;
				case 15: level = 24; break; //go to hut
				case 17: level = 16; break;
				case 23: level = 15; break;
				case 24: if (liu[37]) level = 37; break;
				case 29: level = 28; break;
				case 30: level = 29; break;
				case 33: level = 25; break;
				case 36: level = 33; break;
				case 35: level = 23; break;
				}
			}
			player.play("Walk");
			isMoving = true;
			
		}
			
		
		/*set velocity towards new marker */
		if ((pathQueue.length == 0) && (canMoveTimer > 1.5) && (oldLevel != level) && (RIGHT_P || LEFT_P || UP_P || DOWN_P)) {
			var newX:Number = mapPoints[level].x - player.x; 
			var newY:Number = mapPoints[level].y - player.y;
			var norm:Number = Math.sqrt(newX * newX + newY * newY);
			newX /= norm;				newY /= norm;
			newX *= 140;				newY *= 140
			player.velocity.x = newX; 	player.velocity.y = newY;
			arrows[0].visible = arrows[1].visible = arrows[2].visible = arrows[3].visible = false;
		}
		
		/* Determine what arrows appear, again, regrettable implementation*/
		if (Math.abs(player.x - (mapPoints[level].x)) < 4 && Math.abs(player.y - (mapPoints[level].y)) < 8 && isMoving)  {
			FlxG.play(LevelData.Bloop);
			isMoving = false;
			player.x = mapPoints[level].x;
			player.y = mapPoints[level].y;
			player.velocity.x = player.velocity.y = 0;
			for (var ars:int = 0; ars < 4; ars++) {
				switch (ars) {
					case 0: arrows[ars].x = player.x + 3; arrows[ars].y = player.y - 12; break;
					case 1: arrows[ars].x = player.x + 18; arrows[ars].y = player.y + 3; break;
					case 2: arrows[ars].x = player.x + 3; arrows[ars].y = player.y + 14; break;
					case 3: arrows[ars].x = player.x - 15; arrows[ars].y = player.y + 3; break;
				}
			}
			switch (level) { /* up = 0, r = 1, d = 2, l = 3 */
			case 5: if (liu[6]) arrows[2].visible = true; break;
			case 6: arrows[0].visible = true; if (liu[7]) arrows[1].visible = true; break;
			case 7: arrows[3].visible = true; if (liu[8]) arrows[1].visible = true; break;
			case 8: arrows[3].visible = true; if (liu[9]) arrows[2].visible = true; break;
			case 9: arrows[1].visible = true; if (liu[10]) arrows[3].visible = true; break;
			case 10: arrows[1].visible = true; if (liu[11]) arrows[2].visible = true;  break;
			case 11: arrows[3].visible = true; if (liu[12]) arrows[1].visible = true; break;
			case 12: arrows[3].visible = true; if (liu[13]) arrows[1].visible = true; break;
			case 13: arrows[3].visible = true; if (liu[14]) arrows[1].visible = true; break;
			case 14: arrows[2].visible = true; if (liu[15]) arrows[1].visible = true; if (liu[34]) arrows[3].visible = true; break;
			case 15: arrows[0].visible = true; if (liu[16]) arrows[3].visible = true; if (liu[23]) arrows[2].visible = true; break;
			case 16: arrows[1].visible = true; if (liu[17]) arrows[2].visible = true; break;
			case 17: arrows[0].visible = true; if (liu[18]) arrows[3].visible = true; break;
			case 18: arrows[1].visible = true; if (liu[19]) arrows[3].visible = true; break;
			case 19: arrows[1].visible = true; if (liu[20]) arrows[3].visible = true; break;
			case 20: arrows[1].visible = true; if (liu[21]) arrows[2].visible = true; break;
			case 21: arrows[3].visible = true; if (liu[22]) arrows[1].visible = true; break;
			case 22: arrows[3].visible = true; if (liu[23]) arrows[1].visible = true; break;
			case 23: arrows[3].visible = true; if (liu[24]) arrows[0].visible = true; if (liu[35]) arrows[2].visible = true;  break;
			case 24: arrows[3].visible = true; arrows[2].visible = true; if (liu[37]) arrows[0].visible = true; if (liu[25]) arrows[1].visible = true;  break;
			case 25: arrows[3].visible = true; if (liu[26]) arrows[1].visible = true; if (liu[33]) arrows[2].visible = true; break;
			case 26: arrows[3].visible = true; if (liu[27]) arrows[1].visible = true; break;
			case 27: arrows[3].visible = true; if (liu[28]) arrows[1].visible = true; break;
			case 28: arrows[3].visible = true; if (liu[29]) arrows[2].visible = true; break;
			case 29: arrows[0].visible = true; if (liu[30]) arrows[2].visible = true; break;
			case 30: arrows[0].visible = true; if (liu[31]) arrows[3].visible = true; break;
			case 31: arrows[1].visible = true; if (liu[32]) arrows[3].visible = true; break;
			case 32: arrows[1].visible = true; if (liu[32]) arrows[3].visible = true; break;
			case 33: arrows[1].visible = true; if (liu[32]) arrows[0].visible = true; if (liu[36]) arrows[2].visible = true; break;
			case 34: arrows[1].visible = true; break;
			case 35: arrows[0].visible = true; break;
			case 36: arrows[0].visible = true; break;
			case 37: arrows[2].visible = true; if (liu[38]) arrows[1].visible = true; break;
			case 38: arrows[3].visible = true; break;
			}
			player.play("Still");
		}
		if (Math.abs(player.velocity.x ) < 10) {
			levelName.text = widthFiller + stageNames[level] + " ("+stageNicks[level]+")";
			Registry.levelName = stageNames[level];
			Registry.levelNick = stageNicks[level];
			if (Registry.times[level] != 0) { 
				timeText.text = widthFiller + "Goal 100% time: " + Registry.devTimes[level].toFixed(2).toString() + " Best 100% time: " + Registry.times[level].toFixed(2) + "s";
				if (Registry.devTimes[level] > Registry.times[level]) timeText.text += "!";
			} else {
				timeText.text = widthFiller+"Best 100% time: N/A";
			}
			
			
			noteText.text = widthFiller+"Best Note Score: " + Registry.noteScores[level].toString() + "/20";
			if (Registry.noteScores[level] == 20) noteText.text += "!";
			
			if (level == 24) { /* Hut "level" should not display times */
				timeText.text = " ";
				noteText.text = " ";
			}
		}
		
		
		if (ADV_P && !isMoving && pathQueue.length == 0) {
			Registry.level = level;
			doEnterLevel = true;
			if (!starEffectDone) {
				FlxG.play(LevelData.EnterLevel);
				doStarEffect(new FlxPoint(player.x,player.y + (player.height/2)),40,16,16);
				starEffectDone = true;
			}
		}
		
		if (FlxG.keys.justPressed("M")) {
			API.unlockMedal("MUTED");
			Log.CustomMetric("Pressed Mute",null, true);
			Registry.globalMute = !Registry.globalMute;
			if (Registry.globalMute) FlxG.volume = 0;
		}
		
		if (doEnterLevel) {
			doFadeIn = false; 
			enterLevelTimer -= FlxG.elapsed;
			fadeOut.alpha += 0.01;
			if (enterLevelTimer < 0.0) {
				if (level == 24) {
					Log.LevelCounterMetric("Entrances", "Hut");
					FlxG.switchState(new HutState());
				} else {
					Log.LevelCounterMetric("Entrances", Registry.levelNick);
					if (Registry.level != 24) {
						FlxG.switchState(new PlayState());
					}
				}
			}
		}
		super.update();
	}
	/** Add a marker to the map for an unlocked level. Flash rainbowish if got all notes. **/
	public function addMarker(isLarge:Boolean, x:int, y:int, score:int, wju:Boolean, whatLevel:int):void {
		var marker:FlxSprite = new FlxSprite(x, y);
		var counter:Number = 0;
		if (isLarge) {
			mapPoints.push(new FlxPoint(x , y-24));
			marker.loadGraphic(BigMapMarker, true, false, 16, 16);
			if (score == 20) {
				marker.addAnimation("Flash", [2, 3, 4, 5], 5);
			} else {
				marker.addAnimation("Flash", [0, 1], 5);
			}
			marker.play("Flash");
		} else {
			marker.loadGraphic(SmallMapMarker);		
		}
	
		if (wju) {
			marker.visible = false;
			add(marker);
			pathQueue.push(marker);
		} else {
			add(marker);
		}
	}
	
	/**Generate four stars around the player that animate once.
	 * @param from The point you want this to center around (usually center of a sprite)
	 * @param speed How fast the stars spread from the from point 
	 * @param sprite The spritesheet to use. 13 frames 20 fps atm*/
	public function doStarEffect(from:FlxPoint,speed:int,width:int,height:int):void {
		var signArray:Array = new Array(1, 1, -1, -1, 1, -1, 1, -1);
		
		for (var i:int = 0; i < 4; i++) {
			var star:FlxSprite = new FlxSprite(from.x, from.y);
			star.loadGraphic(StarGFX, true, false, width, height);
			star.addAnimation("f", [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], 20, false);
			star.velocity.x = speed * signArray[i];
			star.velocity.y = speed * signArray[i + 4];
			star.play("f");
			add(star);
			star.angularVelocity = 40 * signArray[i+4];
		}
		return;
	}
	
	public function showStats():void {
		statsBG1.visible = statsBG2.visible = statsString.visible = sponsorStatsLogo.visible = sponsorStatsLogoText.visible =  true;
		if (LEFT_P && page > 0) {
			page--; FlxG.play(LevelData.Bloop);
		} else if (RIGHT_P && page < 4) {
			page++; FlxG.play(LevelData.Bloop);
		}
		if (LEFT_P || RIGHT_P || openedMenu) {
			
			var i:int = 0;
			var offset:int;
			
			for (i = 0; i < 9; i++) {
				noteMedals[i].visible = false;
				timeMedals[i].visible = false;
			}
			openedMenu = false;
			
			switch (page) {
				case 0: offset = 5; break;
				case 1: offset = 6; break;
				case 2: offset = 15; break;
				case 3: offset = 25; break;
				case 4: offset = 34; break;
			}
			if (offset == 5) {
				if (Registry.noteScores[5] == 20) noteMedals[0].visible = true;
				if (Registry.times[5] != 0 && Registry.times[5] < Registry.devTimes[5]) {
					timeMedals[0].visible = true;
				}
				
			} else if (offset < 34) {
				for (i = 0; i < 9; i++) {
					if (Registry.noteScores[offset + i] == 20) noteMedals[i].visible = true;
					if (Registry.times[offset + i] != 0 && Registry.times[offset + i] < Registry.devTimes[offset + i]) timeMedals[i].visible = true;
				}
			} else {
				for (i = 0; i < 5; i++) {
					if (Registry.noteScores[offset + i] == 20) noteMedals[i].visible = true;
					if (Registry.times[offset + i] != 0 && Registry.times[offset + i] < Registry.devTimes[offset + i]) timeMedals[i].visible = true;
				}
			}
			
		}
			statsString.text = "Stats!!! Press left and right to change pages, I to close.\n";
			statsString.text += "Legend: Level ID, best 100% time, goal 100% time, best score, level name\n";
			statsString.text += "Page " + (page + 1).toString() + " of 5\n" + statsStrings[page];
		if (FlxG.keys.justPressed("I")) { 
			FlxG.play(LevelData.Bloop);
			doStats = false;
			statsString.visible = statsBG1.visible = statsBG2.visible = sponsorStatsLogo.visible = sponsorStatsLogoText.visible = false;
			for (i = 0; i < 9; i++) {
				noteMedals[i].visible = false;
				timeMedals[i].visible = false;
			}
		}
		return;
	}

	
	public function initStats():void { 
		var i:int;
		var time:String = "---";
		var j:int;
		for (i = 5; i < liu.length; i++) {
			if (i == 24) continue;
			if (i <= 5) {
				j = 0;
			} else if (i <= 14) {
				j = 1;
			} else if (i <= 24) {
				j = 2;
			} else if (i <= 33) {
				j = 3;
			} else {
				j = 4;
			}
			if (liu[i]) {
				if (Registry.times[i] > 0) {
					time = Registry.times[i].toPrecision(4);
				} else {
					time = "---";
				}
				statsStrings[j] += "    ("+stageNicks[i] + ")    "  + time + "    " + Registry.devTimes[i].toPrecision(4) + "    " + Registry.noteScores[i].toString() + "     "  + stageNames[i] + "\n";
			} else {
				statsStrings[j] += "???\n";
			}
		}
	}
	
	
	public function wait(time:Number):void {
		var timer:Number = time;
		while (timer > 0) {
			timer -= FlxG.elapsed;
		}
		super.update();
	}
	
	public function saveGame():void {
		Registry.level = level; //Save position on world map
		
		if (SaveData.saveGame(Registry.fileID)) {
			FlxG.play(fx1);
			saveText.text = "SUCCESS";
		} else {
			saveText.text = "FAILURE";
		}
	}
	
    override public function destroy():void {
        for (var i:int = 0; i < members.length; i++) {
            if (members[i] != null) members[i] = null;
        }
        mapPoints = stageNames = stageNicks = arrows = pathQueue = statsStrings = timeMedals = noteMedals = null;
        
        super.destroy();
    }
}
}