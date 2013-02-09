package {
import entities.MovingPlatform;
import org.flixel.*;
import org.flixel.plugin.photonstorm.FlxBitmapFont;
import org.flixel.plugin.photonstorm.FlxStarField;
import org.flixel.system.FlxTile;
import Playtomic.Log;
import Playtomic.Link;
import statics.LevelData;
import entities.BreakyBlock;
import fxclasses.RectFX;
import com.newgrounds.API;
/* **
 * The logic for stages. Relies on Registry variables being set via the world map - the level name, nick (for stats),
 * Uses Playtomic's API to track the following, per level
	 * positions of deaths and manual restarts
	 * counter of quits
	 * average notes collected, if level finishes
	 * average time to finish, any notes
	 * average time to finish, all notes.
	 * number of deaths and restarts, if finished.
	 * */
public class PlayState extends FlxState {
	[Embed(source = "res/img/playstate/door.png")] public static var Door:Class;
	[Embed(source = "res/img/playstate/introTransBig.png")] public var IntroTransBig:Class;
	[Embed(source = "res/img/playstate/introTransSmall.png")] public var IntroTransSmall:Class;
	
	/* Sprites/sfx/music associated with the map */
	private var exit:FlxSprite; 
	private var currentMap:FlxTilemap = new FlxTilemap(); //The tiles the player collides with.
	private var currentMapBG:FlxTilemap = new FlxTilemap(); //Background tiles that the player is in front of.
	private var hasMapBG:Boolean = false;
	private var currentMapFG:FlxTilemap = new FlxTilemap(); //Foreground tiles the player walks behind.
	private var hasMapFG:Boolean = false;
	private var background:FlxSprite = new FlxSprite(0, 0);
	public static var song:FlxSound = new FlxSound();
	private var pills:FlxGroup = new FlxGroup(); 
	private var notes:FlxGroup = new FlxGroup();
	private var spikes:FlxGroup = new FlxGroup();
	private var breakyBlocks:FlxGroup = new FlxGroup();
	private var movingPlatforms:FlxGroup = new FlxGroup();
	/* Tutorial gfx */
	private var TUT_WALK:FlxSprite = new FlxSprite(81, 112);
	private var TUT_DOOR:FlxSprite = new FlxSprite(1600,32);
	private var TUT_JUMP1:FlxSprite = new FlxSprite(128+16*7,16*8);
	private var TUT_JUMP2:FlxSprite = new FlxSprite(256+16*9,16*8);
	private var TUT_RUN:FlxSprite = new FlxSprite(1358,32);
	private var TUT_NOTE:FlxSprite = new FlxSprite();
	/* Things for dealing with deaths. */
	public var deathText:FlxBitmapFont = new FlxBitmapFont(Registry.bigFontBlack, 14, 28, Registry.fontString, 26, 0, 0, 0, 2);
	public var deathTextBorder:FlxSprite = new FlxSprite(228, 158);
	public var deathTextBorder2:FlxSprite = new FlxSprite(220, 150);
	public var dt:FlxText = new FlxText(FlxG.width / 2, 400, 250); /* debug text? */
	public var didDeathAnimation:Boolean = false; public var didDeathAnimation2:Boolean = false;
	public var didDeathPhysics:Boolean = false;
	public var bloodGroup:FlxGroup = new FlxGroup();
	public var deathTimer:Number = 0;
	
	/* General state */
	public var NORMALSTATE:int = 0;
	public var EXITSTATE:int = 1;
	public var ENTERSTATE:int = 2;
	public var state:int = ENTERSTATE;
	public var nrDeaths:int = 0;
	public var nrRestarts:int = 0;
	/* Some state associated with entering */
	public var enterAnimationStarted:Boolean = false;
	public var enterTimer:Number = 0;
	public var enterAnimMoveOut:Boolean = false;
	public var stageName:FlxBitmapFont = new FlxBitmapFont(Registry.font, 7, 14, Registry.fontString, 26, 0, 0, 0, 1);
	public var stageNick:FlxBitmapFont = new FlxBitmapFont(Registry.font, 7, 14, Registry.fontString, 26, 0, 0, 0, 1);
	
	/* Some state associated with exiting */
	public var exitAnimationStarted:Boolean = false;
	public var exitTimer:Number = 0;
	public var displayScoreTimer:Number = 0;
	public var endNoteScoreShown:Boolean = false;
	public var endTimeShown:Boolean = false;
	public var incrementExitTimer:Boolean = false;

	/* Various visual FX */
	public var fgFade:FlxSprite = new FlxSprite(0,0);
	public var exciter:FlxText;
		public var exTimer:Number = 0; //Timers for disappear/flash
		public var exFlash:Number = 0;
	public var emitters:FlxGroup;
	public var squares:FlxGroup; //Holds the sprites that fill in the big note at the top of the screen
	
	public var enterBox:FlxSprite = new FlxSprite(0, 0);
	public var nameBorder:FlxSprite = new FlxSprite(0, 0);
	public var nickBorder:FlxSprite = new FlxSprite(0, 0);
	public var enterAnimationGroup:FlxGroup = new FlxGroup();
	
	public var colors:Array = new Array(0xcc00a851, 0xcc0ef34f, 0xcc0ef39b, 0xcc0ef3f9);
	public var hcolors:Array = new Array(0xcc55a851, 0xcc5ef34f, 0xcc5ef39b, 0xcc5ef3f9);
	
	public var sr1:RectFX = new RectFX(0,0, 17, 480, hcolors[0], true); 
	public var sr2:RectFX = new RectFX(0,0, 24, 480, hcolors[1], true); 
	public var sr3:RectFX = new RectFX(0,0, 13, 480, hcolors[2], true); 
	public var sr4:RectFX = new RectFX(0, 0, 640, 24, hcolors[3], true);
	public var sr5:RectFX = new RectFX(0, 0, 640, 27, hcolors[1], true);
	public var sr6:RectFX = new RectFX(0, 0, 640, 40, hcolors[0], true);
			
	public var mr1:RectFX = new RectFX(0, 170, 640, 120, colors[0], true);
	public var mr2:RectFX = new RectFX(0, 180, 640, 100, colors[1], true);
	public var mr3:RectFX = new RectFX(0, 185, 640, 90, colors[2], true); 
	public var mr4:RectFX = new RectFX(0, 195, 640, 70, colors[3], true); 
	
	public var endNoteScoreBG:FlxSprite = new FlxSprite();
	public var endTimeBG:FlxSprite = new FlxSprite();
	public var endTime:FlxBitmapFont = new FlxBitmapFont(Registry.bigFontBlack, 14, 28, Registry.fontString, 26, 0, 0, 0, 2); 
	public var endNoteScore:FlxBitmapFont = new FlxBitmapFont(Registry.bigFontBlack, 14, 28, Registry.fontString, 26, 0, 0, 0, 2);
	public var noteMedal:FlxSprite = new FlxSprite();
	public var timeMedal:FlxSprite = new FlxSprite();
	
	public var dancePlayer:FlxSprite = new FlxSprite();
	/* How long the player's been in the stage. */
	public var stageTime:Number = 0;

	/* Pause screen GUI stuff */
	public var pause:FlxGroup;
	public var pauseScreen:FlxSprite;
	public var pauseText:FlxBitmapFont = new FlxBitmapFont(Registry.bigFontBlack, 14, 28, Registry.fontString, 26, 0, 0, 0, 2);
	
	/* HUD */
	[Embed(source = "res/img/playstate/anxietybar.png")]  public static var AnxBar:Class;
	[Embed(source = "res/img/playstate/bignote.png")] public static var BigNote:Class;
	[Embed(source = "res/img/playstate/bignoteBG.png")] public static var BigNoteBG:Class;
	[Embed(source = "res/img/playstate/timeBG.png")] public static var TimeBG:Class;
	
	
	
	public var miniInfo:FlxBitmapFont = new FlxBitmapFont(Registry.font, 7, 14, Registry.fontString, 26, 0, 0, 0, 1);
	public var houseHud:FlxGroup = new FlxGroup();
	public var anxBar:FlxSprite;
	public var bigNote:FlxSprite;
		public  var bigNote_xs:Array = new Array(5,5,6,5,7,5,5,2,3,4,5,1,2,3,4,5,2,3,4,5);
		public  var bigNote_ys:Array = new Array(0,1,1,2,2,3,4,5,5,5,5,6,6,6,6,6,7,7,7,7);
		public var bigNoteBG:FlxSprite;
	
	public var pillbar:Pillbar;
	public var timeText:FlxBitmapFont = new FlxBitmapFont(Registry.bigFontBlack, 14, 28, Registry.fontString, 26, 0, 0, 0, 2);
	public var timeBG:FlxSprite;
    public var sponsorLogo:FlxSprite;
	
	/* Misc. */
	public var notesCollected:int = 0; //Running count of notes collected 
	private var collideTimer:Number = 0.2; /* Small latency before the player can collide with anything
											  on the map, this stops some strange glitch where
										      nearby notes/pills are collected upon spawning. */
	
	/** Info on the player specific to this map **/
	public var player:Player = new Player();
	private var initialX:int = 0; 
	private var initialY:int = 0;
	
	/** DISCO YEAH **/
	[Embed(source = "res/img/sprites/discoplayer.png")] public var DiscoPlayer:Class;
	private var isItDiscoTimeYet:Boolean = false;
	private var discoBall:FlxSprite = new FlxSprite(300, 0);
	private var discoTimer:Number = 0;
	private var discoman1:FlxSprite = new FlxSprite(50, 40);
	private var discoman2:FlxSprite = new FlxSprite(540, 40);
	private var discoman3:FlxSprite = new FlxSprite(0, 350);
	private var discoman4:FlxSprite = new FlxSprite(570,350);

	override public function create():void	{

        FlxG.camera.zoom = (4/3);
        FlxG.width = 480;
        FlxG.height = 360;
        FlxG.camera.y -= 80;
        FlxG.camera.x += 100;
        
        
		/* Initalize things in our HUD. */
		makeHouseHud();
		
		//FlxG.visualDebug = true; FlxG.debug = true;
		FlxG.camera.follow(player, 1);
        FlxG.camera.deadzone = null;
	
		/** Load the right stage, add in the notes, pills, etc **/
		makeStage();
		add(background);	
		if (hasMapBG) add(currentMapBG);	
		add(currentMap);
		add(pills);	
		add(notes);	add(spikes);  add(breakyBlocks);  add(movingPlatforms);
		add(exit);		
		if (Registry.level == 5) {
			add(TUT_DOOR); add(TUT_WALK);
			add(TUT_JUMP1); add(TUT_JUMP2); 
			var spikeTut:FlxBitmapFont = new FlxBitmapFont(Registry.font, 7, 14, Registry.fontString, 26, 0, 0, 0, 2);
			spikeTut.setText("It's advised not to touch spikes.", true, 0, 0, "left", true);
			spikeTut.x = 529; spikeTut.y = 210;
			add(spikeTut);
			var noteTut:FlxBitmapFont = new FlxBitmapFont(Registry.font, 7, 14, Registry.fontString, 26, 0, 0, 0, 2);
			noteTut.setText("", true, 0, 0, "left", true);
			noteTut.text = "Notes are OPTIONAL,\n but unlock secret levels,\n better endings,\n and MORE! (Oh boy!)";
			noteTut.x = 742; noteTut.y = 155;
			add(noteTut);
			var anxTut:FlxBitmapFont = new FlxBitmapFont(Registry.font, 7, 14, Registry.fontString, 26, 0, 0, 0, 2);
			anxTut.setText(" ", true, 0, 0, "left", true);
			anxTut.text = "Full anxiety bar means death!\n Pills help to lower the timer.";
			anxTut.x = 1076; anxTut.y = 215;
			pillbar.visible = true; anxBar.visible = true;
			add(anxTut); 
			var pauseTut:FlxBitmapFont = new FlxBitmapFont(Registry.font, 7, 14, Registry.fontString, 26, 0, 0, 0, 2);
			pauseTut.setText("",true, 0, 0, "left", true);
			pauseTut.text = "Hold Z or K to run. You can press shift to toggle perma-run.\nPress P at anytime to pause and review these instructions.\nEvery level has a par time, get all the notes\nand beat the time to get a time medal!\n(WHICH UNLOCK THINGS AT THE HUT!)    \n                 REMEMBER, HOLD Z TO RUN!";
			pauseTut.x = 1268; pauseTut.y = 139;
			add(pauseTut);
			pillbar.visible = true; anxBar.visible = true;
			add(TUT_RUN);
		} else if (Registry.level == 6) {
            var pauseTut:FlxBitmapFont = new FlxBitmapFont(Registry.font, 7, 14, Registry.fontString, 26, 0, 0, 0, 2);
			pauseTut.setText("", true, 0, 0, "left", true);
            pauseTut.setText("Remember, Hold Z or K to run!");
			pauseTut.x = 260; pauseTut.y = 139;
			add(pauseTut);
        }
			
		// For our particle effects.
		emitters = new FlxGroup();
		add(emitters);
		
		// The exciter text for collectping pills.
		exciter = new FlxText(0,0,100);
		exciter.exists = false;
		exciter.velocity.y = -50;
		add(exciter);
		/* Add player stuff */
		player.scale.x = 1;
		add(player.debugText);
		for (var p:int = 0; p < player.playerTrailSprites.length; p++) {
			add(player.playerTrailSprites[p]);
		}
		add(player);
		if (hasMapFG) add(currentMapFG);
		
		// The squares that make up the large HUD note.
		squares = new FlxGroup();
		add(houseHud);
		add(squares);
		
		// Foreground fade-to-black effect
		fgFade.makeGraphic(640, 480, 0xFF000000);
		fgFade.alpha = 0;
		fgFade.exists = true;
		fgFade.scrollFactor = new FlxPoint(0, 0);
		
		add(fgFade);
	
		// DEATH TEXT
		deathTextBorder.exists = deathTextBorder2.exists = deathText.exists = false;
		deathTextBorder.x = 14; deathTextBorder.y = 164;
		deathTextBorder2.x = 22; deathTextBorder2.y = 172;
		deathTextBorder.makeGraphic(470, 150, 0xDD131387);
		deathTextBorder2.makeGraphic(470 - 16, 150 - 16, 0xDDFFFFA9);
		deathTextBorder.scrollFactor = deathTextBorder2.scrollFactor = deathText.scrollFactor = new FlxPoint(0, 0);
		deathText.setText("WHOOPS. Can't explode like that.\n The neighbors'll complain. \nPress X/K to try again. \n     (You can do it!)", true, 0, 0, "center", true);
		deathText.x = 30; deathText.y = 180;
		add(bloodGroup);
	
		//DISCO
		if (Registry.secretsState[6]) {
			discoBall.visible = false;
			add(discoBall);
			discoman1.loadGraphic(DiscoPlayer, true, false, 15, 30); discoman1.addAnimation("a", [0, 1], 4, true); discoman1.play("a"); add(discoman1); discoman1.scale = new FlxPoint(4, 4); discoman1.scrollFactor = new FlxPoint(0, 0);
			discoman2.loadGraphic(DiscoPlayer, true, false, 15, 30); discoman2.addAnimation("a", [0, 1],4,true); discoman2.play("a"); add(discoman2); discoman2.scale = new FlxPoint(4, 4); discoman2.scrollFactor = new FlxPoint(0, 0);
			discoman3.loadGraphic(DiscoPlayer, true, false, 15, 30); discoman3.addAnimation("a", [2, 3],4,true); discoman3.play("a"); add(discoman3); discoman3.scale = new FlxPoint(4, 4); discoman3.scrollFactor = new FlxPoint(0, 0);
			discoman4.loadGraphic(DiscoPlayer, true, false, 15, 30); discoman4.addAnimation("a", [2, 3], 4, true); discoman4.play("a"); add(discoman4); discoman4.scale = new FlxPoint(4, 4); discoman4.scrollFactor = new FlxPoint(0, 0);
		}
		// DEBUG TEXT
		dt.scrollFactor = new FlxPoint(0,0);
		dt.exists = true;
		dt.visible = false;
		dt.color = 0x000000;
		dt.x = 0;
		dt.y = 380;
		//add(dt);
		
		// PAUSE MENU OBJECTS
		pause = new FlxGroup();
		pauseScreen = new FlxSprite(16,16);
		pauseScreen.makeGraphic(640 - 32, 480 - 32, 0xccaaaaaa);
	
		pause.add(pauseScreen);
		pause.add(pauseText);
		pause.setAll("scrollFactor",new FlxPoint(0,0));
		pause.exists = false;
		add(pause);
		FlxG.paused = false;
	}

	/**The main update logic, we handle keypresses here related to menus/restarting/etc**/
	override public function update():void {
    
        if (FlxG.keys.justPressed("FIVE")) {
            Log.LevelCounterMetric("Visited Sponsor In Game", "Links", true);
            Link.Open(Registry.SPONSOR_GAME, "sponsor site game", "sponsor links");
        }
		if (Registry.secretsState[6]) {
			discoTimer += FlxG.elapsed;
			if (discoTimer < 0.125) {
				FlxG.camera.color = 0x8822f3ea;
			} else if (discoTimer < 0.25) {
				FlxG.camera.color = 0x88821888;
			} else if (discoTimer < 0.375) {
				FlxG.camera.color = 0x88fe882a;
			} else if (discoTimer < 0.5) {
				FlxG.camera.color = 0x882344ba;
			} else if (discoTimer < 0.625) {
				FlxG.camera.color = 0x88880000;
			} else if (discoTimer < 0.75) {
				FlxG.camera.color = 0x88880088;
			} else if (discoTimer < 0.875) {
				FlxG.camera.color = 0x88771423;
			} else if (discoTimer < 1) {
				FlxG.camera.color = 0x88bb2212;
			}
			if (discoTimer > 1) {
				discoTimer = 0;
			}
		}
		
		if (FlxG.paused) {
			pause.exists = true;
			if (FlxG.keys.justPressed("R")) { resetStage(false); FlxG.paused = false; pause.exists = false; }
			if (FlxG.keys.justPressed("Q")) {
				Log.LevelCounterMetric("Quits", Registry.levelNick);

        FlxG.camera.zoom = 1;
        FlxG.width = 640;
        FlxG.height = 480;
        FlxG.camera.setBounds(0, 0, 640, 480, true);
     			FlxG.switchState(new WorldMap());

			}
			
			pause.update();
		} else if (state == 0) {
			updateGame();
		} else if (state == 1) {
			checkForExit();
		} else if (state == ENTERSTATE) {
			updateIntroAnimation();
		}
		
		if (FlxG.keys.justPressed("M")) {
			API.unlockMedal("MUTED");
			Log.CustomMetric("Pressed Mute",null, true);
			Registry.globalMute = !Registry.globalMute;
			if (Registry.globalMute) {
				FlxG.volume = 0;
			} else {
				FlxG.volume = 1.0;
			}
		}
		if (FlxG.keys.justPressed("P")) {
			pillbar.dangerSound.pause();
			pillbar.update();
			FlxG.play(LevelData.Bloop, 0.7, false);
			
			if (!FlxG.paused) {
				FlxG.paused = true;
				pillbar.dangerSound.play();
				pause.exists = true;
				pauseText.x = 15; pauseText.y = 95;
				pauseText.setText("\nPAUSED!\nArrows/AD: Move\nX/J: Jump\n Z/K/UP/W/SPACE: Hold to run\nSHIFT: Toggle perma-run\nR: Restart level   P: Pause\nDown/S:Enter door\n Q: Quit to map     M: Mute\n Get 20 notes on a level and beat the \n par time to get a medals, which \n unlock secrets at the hut!\n(Beat World 1 to unlock the hut!)"
				,true,0,0,"left",true);	
			} else {
				FlxG.paused = false;
				pause.exists = false;
			}
		}
		
		//show debug text, debug text updates
		dt.text = "Notes: "+Registry.noteScores.toString()+"\n Map width:"+currentMap.width.toString();;	
		
		if (FlxG.keys.justPressed("D")) 
			dt.exists = !dt.exists;	
		/* Use the state of the pillbar to check for death. */
		if (pillbar.scale.x > 319) {
			if (!didDeathAnimation) {
				FlxG.play(Player.DeathSound,0.7);
				for (var nrTrails:int = 0; nrTrails < player.playerTrailSprites.length; nrTrails ++) {
					player.playerTrailSprites[nrTrails].visible = false;
				}
				pillbar.dangerSound.stop();
				bloodAnimation(60);
				add(deathTextBorder);
				add(deathTextBorder2);
				add(deathText);
				didDeathAnimation = true;
			}
			if (deathTimer > 2.4 && !didDeathAnimation2) {
				bloodAnimation(100);
				
				FlxG.play(Player.DeathSound,0.7);
				player.visible = false;
				didDeathAnimation2 = true;
			} 
			deathTimer += FlxG.elapsed;
			deathText.exists = deathTextBorder.exists = deathTextBorder2.exists = true;
			if (FlxG.keys.justPressed("X") || FlxG.keys.justPressed("J")) {
			
				resetStage(true);
			}
		}
			
		if (FlxG.keys.justPressed("R") && !didDeathAnimation && !exitAnimationStarted) {
			Log.Heatmap("RestartPosition", Registry.levelNick, player.x, player.y);
			nrRestarts++;
			resetStage(false);
			
		}
		
	}
	

	public function updateIntroAnimation():void {
		if (!enterAnimationStarted) {
			var noScrollPt:FlxPoint = new FlxPoint(0, 0);
			
			pillbar.exists = false;
			enterAnimationStarted = true;
			
		
			for (var ans:int = 0; ans < 640;  ans++) {
				var box:FlxSprite = new FlxSprite(0, ans);
				box.makeGraphic(640, 1, 0xff000000);
				box.velocity.x = -300 * (1 - Math.sin((ans / 77) * 3.1415)) - 50*(1 + ans/640);
				enterAnimationGroup.add(box);
			}
		
			enterAnimationGroup.setAll("scrollFactor", noScrollPt);
			add(enterAnimationGroup);
			
			stageName.setText("                                                \n"+Registry.levelName, true, 0, 0, "left", true);
			stageName.scale = new FlxPoint(2, 2); stageName.x = 190 - 380;  stageName.y = 140; stageName.scrollFactor = noScrollPt;
			
			nameBorder.loadGraphic(IntroTransBig);
			nameBorder.x = 20 - 380; nameBorder.y = 140;
			nameBorder.scrollFactor = noScrollPt;
			stageNick.setText(Registry.levelNick);
			stageNick.x = 460 + 500; stageNick.y = 250; stageNick.scale = new FlxPoint(2, 2); stageNick.scrollFactor = noScrollPt;

			nickBorder.loadGraphic(IntroTransSmall);
			nickBorder.x = 400 + 500; nickBorder.y = 240; nickBorder.scrollFactor = noScrollPt;
			
			nickBorder.velocity.x = stageNick.velocity.x = -1500;
			stageName.velocity.x = nameBorder.velocity.x = 1500;
			add(nickBorder);  add(nameBorder); add(stageName); add(stageNick);
		}
		enterTimer += FlxG.elapsed;
		FlxG.collide(player, currentMap);
		super.update();
		
		if (enterTimer < 1) {
			enterAnimationGroup.setAll("x", 0);
		}
		if (stageName.x > 270 && enterTimer < 0.4) {
			stageName.x = 270; stageName.velocity.x = 140;
			nameBorder.x = 100; nameBorder.velocity.x = 140;
		}
		
		if (stageNick.x < 460 && enterTimer < 0.4) {
			stageNick.x = 460; stageNick.velocity.x = -140;
			nickBorder.x = 400; nickBorder.velocity.x = -140;
		}
		if (enterTimer > 1.4 && enterTimer < 1.6) {
			nickBorder.velocity.x = stageNick.velocity.x = -1500;
			stageName.velocity.x = nameBorder.velocity.x = 1500;
		}
		if (enterTimer > 2.2 && !enterAnimMoveOut) {
			for (var i:int = 1; i < 640; i+= 1) {
				enterAnimationGroup.members[i].velocity.x -= 2000 - (i / 640) * 50;
			}
			enterAnimMoveOut = true;
		}
		
		if (enterTimer > 3) {
			state = NORMALSTATE;
			enterAnimationGroup.kill();
			stageName.kill(); stageNick.kill(); nickBorder.kill(); nameBorder.kill()
			player.state = 0; //Normal update state for PLayer
			pillbar.exists = true;
		}
		
		if (FlxG.keys.justPressed("X") || FlxG.keys.justPressed("J")) {
			enterTimer = 4;
		}
		return;
	}
	public function updateGame():void {
		
		// Update timer text.
		if (!didDeathAnimation)
			stageTime += FlxG.elapsed;
		timeText.text = "Time:"+stageTime.toFixed(2).toString()+"s";
		
		// Darken the screen as the anxiety bar fills.
		if (pillbar.scale.x > 160) {
			
			fgFade.alpha = (pillbar.scale.x - 160) / 240.0;
		} else {
			fgFade.alpha = 0;
		}
			
		// Update the exciter text if we just got a pill.
		if (exciter.exists) 
			updateExciter();
			
		if (!didDeathPhysics) {
			if (collideTimer < 0)  {
				FlxG.overlap(player, notes, collectNote);
			} else {
				collideTimer -= FlxG.elapsed;
			}
			FlxG.overlap(player, pills, collectPill);
			
			/* Check whether to begin exit animations and leave the stage. */
			if (FlxG.overlap(player, exit) && (FlxG.keys.S || FlxG.keys.DOWN)) {		
				state = EXITSTATE;
				FlxG.play(LevelData.HitDoor);
				pillbar.dangerSound.volume = 0;
				pillbar.exists = false;
				player.exists = false;
				checkForExit();
			}
		}
	
		/* Check for death condition from running out of time. */
		if (pillbar.scale.x > 320 && !didDeathPhysics) {  
			Log.Heatmap("DeathPosition", Registry.levelNick, player.x, player.y);
			nrDeaths++;
			deathTextBorder.alpha = 0.5; deathTextBorder2.alpha = 0.5;
			didDeathPhysics = true;
			
			player.velocity.x = -200 * player.currentDirection;
			player.velocity.y = -200;
			player.angularVelocity = 300;
			player.angularDrag = 240;
			player.acceleration.y = 150;
			player.state = 1;
		}
			
		/* Update all the objects with this PlayState, do collisions. */
		super.update();
		FlxG.collide(spikes, player, spikeCallback);
		FlxG.collide(emitters, currentMap);
		FlxG.collide(bloodGroup, currentMap, stopBlood);
		FlxG.collide(bloodGroup, movingPlatforms, stopBlood);
		FlxG.collide(bloodGroup, breakyBlocks, stopBlood);
		FlxG.collide(breakyBlocks, player, steppedOnBreakyBlock);
		FlxG.collide(movingPlatforms, player, steppedOnMovingPlatform);
		FlxG.collide(player, currentMap);
	}
	/** The logic for the "exciter" text - flashing text when you collect a pill. **/
	public function updateExciter():void {
		exFlash += FlxG.elapsed;
		exTimer += FlxG.elapsed;
		exciter.alpha = 1 - (exTimer/2.0);
		if (exFlash < 0.1) {
			exciter.color = 0x00FF00;
		} else {
			exciter.color = 0x0000FF;
		}
		if (exFlash > 0.2)
			exFlash = 0;
		if (exTimer > 2) {
			exTimer = 0;	
			exciter.exists = false;
		}
		
	}
	
	private function steppedOnMovingPlatform(movingPlatform:MovingPlatform, player:Player):void {
		
		movingPlatform.startMoving();
		movingPlatform.isMoving = true;
		return;
	}
	private function steppedOnBreakyBlock(breakyBlock:BreakyBlock, player:Player):void {
		if (!breakyBlock.broken) {
			breakyBlock.broken = true;
		}
		return;
	}


	/** Logic for the colorful explosions when collecting pills. **/
	public function collectPill(player:Player, pill:Pill):void {
		pill.getCollected();
		pillbar.pillGet();

		exciter.x = pill.x - 16;
		exciter.y = pill.y;
		exciter.exists = true;
		var j:Number = Math.random();
		if (j < 0.25) {
			exciter.text = "OH YEAH!";
		} else if (j < 0.5) {
			exciter.text = "ADDICTIVE!";
		} else if (j < 0.75) {
			exciter.text = "CAN'T STOP!!";
		} else {
			exciter.text = "C'MON BABY!";
		}
		var em:FlxEmitter = new FlxEmitter(0,0,20);
		em.particleDrag = new FlxPoint(0,0);
		em.gravity = 200;
		for (var i:int = 0; i < 20; i++) {
				var particle:FlxParticle = new FlxParticle();
			if (Math.random() < 0.33) {
				particle.makeGraphic(4,4,0x88e64994);
			} else if (Math.random() < 0.5) {
				particle.makeGraphic(3,3,0x77e68b94);
			} else {
				particle.makeGraphic(4,3,0x99e6bf94);
			}
			particle.lifespan = 5;
			particle.solid = true;
			particle.exists = false;
			em.add(particle);
			
		}
		emitters.add(em);
		em.at(pill);
		em.start(true,1);
	
	}
	
	/** Logic for the explosion when collecting a note, as well as the large note GUI update. **/
	public function collectNote(player:Player, note:Note):void {
		// This does the logic for updating the array of notes/playing the soundeffect.
		
		// Local to this state, increase notes collected by one. 
		notesCollected += 1;
		note.getCollected();
		var noteEmitter:FlxEmitter = new FlxEmitter(0,0,20);
		noteEmitter.particleDrag = new FlxPoint(0,0);
		noteEmitter.gravity = 350;
		for (var i:int = 0; i < 20; i++) {
			var particle:FlxParticle = new FlxParticle();
			particle.makeGraphic(3,3,0x44000000);
			particle.lifespan = 2.4;
			particle.solid = true;
			particle.exists = false;
			noteEmitter.add(particle);
		}
		emitters.add(noteEmitter);
		noteEmitter.at(note);
		noteEmitter.start(true,1);
	
		var square:FlxSprite = new FlxSprite(bigNote.x + 8*bigNote_xs[note.id],bigNote.y + 8*bigNote_ys[note.id]);
		square.makeGraphic(8,8,0xFF000000);
		square.scrollFactor = new FlxPoint(0,0);
		squares.add(square);	
	}
	
	/**
	 * @param	justDied Should we reset after dying (need to reset other things)
	 */
	public function resetStage(justDied:Boolean):void {
		if (justDied) {
			Log.LevelCounterMetric("Deaths", Registry.levelNick);
		
			deathText.exists = deathTextBorder.exists = deathTextBorder2.exists = false;
			deathTimer = 0;
			didDeathAnimation = didDeathAnimation2 = false;
			player.resetAfterDeath();
		} else { //restarted
			Log.LevelCounterMetric("Restarts", Registry.levelNick);
		}
		pillbar.dangerSound.stop();
		pillbar.timeElapsed = 0;
		bloodGroup.callAll("kill");
		squares.callAll("kill");
		emitters.callAll("kill");
		notes.setAll("exists",true);
		pills.setAll("exists", true);
		movingPlatforms.callAll("resetStage");
		pillbar.scale.x = 0;
		FlxG.play(Player.DeathSound,0.7);
		bloodAnimation(5);
		player.x = initialX; player.y = initialY;	
		stageTime = 0;
		timeText.text = "Time:" + stageTime.toFixed(2).toString() + "s";
		notesCollected  = 0;
		collideTimer = 0.1;			
		didDeathPhysics = false;

		Registry.nrDeaths++;
		return;
		
	}
	public function checkForExit():void {
		if (!exitAnimationStarted) {
			
			exitAnimationStarted = true;
			
			
			add(sr1); add(sr2); add(sr3); add(sr4); add(sr5); add(sr6);
			add(mr1); add(mr2); add(mr3); 

			add(endNoteScoreBG); endNoteScoreBG.visible = false; add(endTimeBG); endTimeBG.visible = false;
			add(endNoteScore); endNoteScore.visible = false;  add(endTime); endTime.visible = false;
			add(timeMedal); timeMedal.visible = false; add(noteMedal); noteMedal.visible = false;
			endNoteScoreBG.scrollFactor = endNoteScore.scrollFactor = endTime.scrollFactor = endTimeBG.scrollFactor = new FlxPoint(0, 0);
			timeMedal.scrollFactor = noteMedal.scrollFactor = new FlxPoint(0, 0);
			
			sr1.moveInFrom(200,-480, -20 , 400, "t");  sr2.moveInFrom(400,480, 20 , -400, "b");
			sr3.moveInFrom (50, 480, 24, -400, "b");  sr4.moveInFrom(0, 400, 400, -15, "l");
			sr5.moveInFrom(640, 30, -400, 16, "r"); sr6.moveInFrom(640, 300, -400, 40, "r");
			mr1.moveInFrom(-640,170,550, 0,"l");  mr2.moveInFrom(-640,180,575, 0,"l"); mr3.moveInFrom(-640,185,525, 0,"l"); mr4.moveInFrom(0,195,550, 0,"l");
	
			var starfield:FlxStarField = new FlxStarField(0, 135, 640, 130, 50,1, 10);
			add(starfield);
			starfield.setBackgroundColor(0x00);
			starfield.setStarDepthColors(5, 0xaaffffff, 0xffffffff);
			starfield.scrollFactor = new FlxPoint(0, 0);
			
			var winText:FlxBitmapFont = new FlxBitmapFont(Registry.bigFontBlack, 14, 28, Registry.fontString, 26, 0, 0, 0, 2);
			winText.setText("Great, Level Complete!\n      (Press X/J)", 
							true, 0, 0, "center", true);
			winText.x = 20; winText.y = 210;
			
			winText.scrollFactor = new FlxPoint(0, 0);
			add(winText);
			
			dancePlayer.x = player.x; dancePlayer.y = player.y;
			dancePlayer.loadGraphic(Player.PlayerSprite, true, false, 15, 30);
			dancePlayer.addAnimation("Dance", [6, 7, 8, 9, 10], 2, false);
			dancePlayer.play("Dance");
			dancePlayer.alpha = 1;
			add(dancePlayer);
			
		}
		
		displayScoreTimer += FlxG.elapsed;
		if (displayScoreTimer > 0.5 && !endNoteScoreShown) {
			endNoteScoreShown = true;
			endNoteScore.setText("Notes: " + notesCollected.toString() + "/20   ", true, 0, 0, "left", true);
			//endNoteScore.x = 115; endNoteScore.y = 70;
            endNoteScore.x = 235; endNoteScore.y = 310;
			endNoteScore.visible = true;
			endNoteScoreBG.visible = true;
			endNoteScoreBG.makeGraphic(220, 50, 0xff00ffaa);
		//	endNoteScoreBG.x = 100; endNoteScoreBG.y = 56;
            endNoteScoreBG.x = 220; endNoteScoreBG.y = 296;
			FlxG.play(LevelData.Bloop);
			
			noteMedal.loadGraphic(WorldMap.NoteMedal, false, false, 9, 14);
			noteMedal.x = endNoteScore.x - 11; noteMedal.y = endNoteScore.y;
			if (notesCollected == 20) noteMedal.visible = true;
		} 
		if (displayScoreTimer > 1.0 && !endTimeShown) {
			endTimeShown = true;
			endTimeBG.visible = true;
			
			endTimeBG.makeGraphic(400, 100, 0xff00aaff);
			endTimeBG.x = 100; endTimeBG.y = 350;
			var prevBest:String;
			if (0 == Registry.times[Registry.level]) {
				if (notesCollected == 20) {
					prevBest = stageTime.toFixed(2);
				} else {
					prevBest = "---";
				}
			} else {
				if (stageTime < Registry.times[Registry.level] && notesCollected == 20) {
					prevBest = stageTime.toFixed(2);
				} else {
					prevBest = Registry.times[Registry.level].toFixed(2);
				}
			}
		endTime.setText("Time: " + stageTime.toFixed(2) + "\nGoal 100% time: " +Registry.devTimes[Registry.level].toFixed(2) + "\nYour best 100% time: " + prevBest, true, 0, 0, "left", true);
			endTime.visible = true;
			endTime.x = 115; endTime.y = 360;
			
			FlxG.play(LevelData.Bloop);
			
			timeMedal.loadGraphic(WorldMap.TimeMedal, false, false, 9, 14);
			timeMedal.x = endTime.x - 11; timeMedal.y = endTime.y;
			if (stageTime < Registry.devTimes[Registry.level] && notesCollected == 20) timeMedal.visible = true;

		}
		
		
		if (FlxG.keys.justPressed("X") || FlxG.keys.justPressed("J")) {			
			sr1.moveOutFrom("t", 400); sr2.moveOutFrom("b", -400);
			sr3.moveOutFrom("b", -400); sr4.moveOutFrom("l", 400);
			sr5.moveOutFrom("r", -400); sr6.moveOutFrom("r", -400);
			mr1.moveOutFrom("l", 650); mr2.moveOutFrom("l", 700); mr3.moveOutFrom("l", 750); mr4.moveOutFrom("l", 600);
			incrementExitTimer = true;
			fgFade.kill();
			remove(fgFade);
			fgFade.exists = true;
			add(fgFade);
			dancePlayer.velocity.y = -300;
			
		}	
	
		if (incrementExitTimer) {
			exitTimer += FlxG.elapsed;
			dancePlayer.alpha -= 0.01;
			noteMedal.alpha -= 0.01; timeMedal.alpha -= 0.01; endTimeBG.alpha -= 0.01; endTime.alpha -= 0.01;
			endNoteScore.alpha -= 0.01; endNoteScoreBG.alpha -= 0.01;
			dancePlayer.angularVelocity = 200;
			fgFade.alpha += 0.01;
			
		}
		
		
		if (exitTimer > 1.5) {	
			
			// Update the highest note score for the level.
			if (notesCollected > Registry.noteScores[Registry.level]) {
				Registry.noteScores[Registry.level] = notesCollected;
			}
			
			// Update best time.
			if (((stageTime < Registry.times[Registry.level]) || (Registry.times[Registry.level] == 0)) 
				&& (notesCollected == 20) ) {
				Registry.times[Registry.level] = stageTime;
			}
			
			if (Registry.level == 23) Registry.levelIsUnlocked[25] = true;
			// Unlock the next level, but don't do this if it's an extra stage (>= 34)
			if (!Registry.levelIsUnlocked[Registry.level + 1]) {
				if (Registry.level < 34 || Registry.level == 37) {
					Registry.levelIsUnlocked[Registry.level + 1] = true;
					Registry.wasJustUnlocked[Registry.level + 1] = true;
				}
			}
			FlxG.music.stop();
			
			//Log some stats
			if (notesCollected == 20) {
				Log.LevelAverageMetric("100Time", Registry.levelNick, stageTime);
			}
			Log.LevelAverageMetric("AnyTime", Registry.levelNick, stageTime);
			Log.LevelAverageMetric("Notes", Registry.levelNick, notesCollected);
			Log.LevelAverageMetric("Deaths", Registry.levelNick, nrDeaths);
			Log.LevelAverageMetric("Restarts", Registry.levelNick, nrRestarts);
			
                
            FlxG.camera.zoom = 1;
            FlxG.width = 640;
            FlxG.height = 480;
            FlxG.camera.setBounds(0, 0, 640, 480, true);
			if (!Registry.cutscenesWatched[1] && Registry.level == 14) {
				Registry.cutscene = 1;
				FlxG.switchState(new Cutscene());
			} else if (!Registry.cutscenesWatched[2] && Registry.level == 23) {
				Registry.cutscene = 2;
				FlxG.switchState(new Cutscene());
			}  else if (!Registry.cutscenesWatched[3] && Registry.level == 33) {
				Registry.cutscene = 3;
				FlxG.switchState(new Cutscene());
			} else {
				FlxG.switchState(new WorldMap());
			}
		}
		
		super.update();
		FlxG.collide(player,currentMap);
	}
	public function makeStage():void {
		background.scrollFactor.x = background.scrollFactor.y = 0;
        
		//Registry.level = 34;
		switch (Registry.level) {
			case 5: 
			setLevelDetails(LevelData.tutorial1, LevelData.HouseTiles, LevelData.HouseBG, 1000, LevelData.TutorialSong);
			TUT_DOOR.loadGraphic(LevelData.TutorialGFX, true, false, 64, 96); TUT_DOOR.addAnimation("a", [1]); TUT_DOOR.play("a");
			TUT_WALK.loadGraphic(LevelData.TutorialGFX, true, false, 64, 96); TUT_WALK.addAnimation("a", [0]);  TUT_WALK.play("a");
			TUT_JUMP1.loadGraphic(LevelData.TutorialGFX, true, false, 64, 96); TUT_JUMP1.addAnimation("a", [2]); TUT_JUMP1.play("a");
			TUT_JUMP2.loadGraphic(LevelData.TutorialGFX, true, false, 64, 96); TUT_JUMP2.addAnimation("a", [3]); TUT_JUMP2.play("a");
			TUT_RUN.loadGraphic(LevelData.TutorialGFX, true, false, 64, 96); TUT_RUN.addAnimation("a", [4]); TUT_RUN.play("a"); break;
			
			case 6: setLevelDetails(LevelData.A_1,LevelData.HouseTiles,LevelData.HouseBG,25,LevelData.PlainsSong); break;
			case 7: setLevelDetails(LevelData.A_2,LevelData.HouseTiles,LevelData.HouseBG,15,LevelData.PlainsSong); break;
			case 8: setLevelDetails(LevelData.A_3,LevelData.HouseTiles,LevelData.HouseBG,15,LevelData.PlainsSong); break;
			case 9: setLevelDetails(LevelData.A_4,LevelData.HouseTiles,LevelData.HouseBG,15,LevelData.PlainsSong); break;
			case 10: setLevelDetails(LevelData.A_5,LevelData.HouseTiles,LevelData.HouseBG,15,LevelData.PlainsSong); break;
			case 11: setLevelDetails(LevelData.A_6,LevelData.HouseTiles,LevelData.HouseBG,20,LevelData.PlainsSong); break;
			case 12: setLevelDetails(LevelData.A_7,LevelData.HouseTiles,LevelData.HouseBG,21,LevelData.PlainsSong); break;
			case 13: setLevelDetails(LevelData.A_8,LevelData.HouseTiles,LevelData.HouseBG,20,LevelData.PlainsSong); break;
			case 14: setLevelDetails(LevelData.A_9, LevelData.HouseTiles, LevelData.HouseBG, 25, LevelData.PlainsSong); break;
			
			case 15: setLevelDetails(LevelData.B_1, LevelData.HouseTiles, LevelData.forestBG, 30, LevelData.ForestSong); break;
			case 16: setLevelDetails(LevelData.B_2,LevelData.HouseTiles,LevelData.forestBG,25,LevelData.ForestSong); break;
			case 17: setLevelDetails(LevelData.B_3,LevelData.HouseTiles,LevelData.forestBG,25,LevelData.ForestSong); break;
			case 18: setLevelDetails(LevelData.B_4,LevelData.HouseTiles,LevelData.forestBG,35,LevelData.ForestSong); break;
			case 19: setLevelDetails(LevelData.B_5,LevelData.HouseTiles,LevelData.forestBG,25,LevelData.ForestSong); break;
			case 20: setLevelDetails(LevelData.B_6,LevelData.HouseTiles,LevelData.forestBG,35,LevelData.ForestSong); break;
			case 21: setLevelDetails(LevelData.B_7,LevelData.HouseTiles,LevelData.forestBG,25,LevelData.ForestSong); break;
			case 22: setLevelDetails(LevelData.B_8,LevelData.HouseTiles,LevelData.forestBG,18,LevelData.ForestSong); break;
			case 23: setLevelDetails(LevelData.B_9, LevelData.HouseTiles, LevelData.forestBG, 25, LevelData.ForestSong); break;

			case 25: setLevelDetails(LevelData.C_1, LevelData.HouseTiles, LevelData.NightCityBG, 15, LevelData.HouseSong, LevelData.C_1BG); break
			case 26: setLevelDetails(LevelData.C_2, LevelData.HouseTiles, LevelData.NightCityBG, 25, LevelData.HouseSong, LevelData.C_2BG); break;
			case 27: setLevelDetails(LevelData.C_3, LevelData.HouseTiles, LevelData.SleepBG, 25, LevelData.HouseSong); break;
			case 28: setLevelDetails(LevelData.C_4, LevelData.HouseTiles, LevelData.SleepBG, 25, LevelData.HouseSong, LevelData.C_4BG); break;
			case 29: setLevelDetails(LevelData.C_5, LevelData.HouseTiles, LevelData.CaveBG, 17, LevelData.CaveSong); break;
			case 30: setLevelDetails(LevelData.C_6, LevelData.HouseTiles, LevelData.CaveBG, 30, LevelData.CaveSong); break;
			case 31: setLevelDetails(LevelData.C_7, LevelData.HouseTiles, LevelData.CaveBG, 50, LevelData.CaveSong); break;
			case 32: setLevelDetails(LevelData.C_8, LevelData.HouseTiles, LevelData.CaveBG, 24, LevelData.CaveSong); break;
			case 33: setLevelDetails(LevelData.C_9, LevelData.HouseTiles, LevelData.CaveBG, 25, LevelData.CaveSong); break;

			
			case 34: setLevelDetails(LevelData.S_1, LevelData.HouseTiles, LevelData.SpecialBG, 25, LevelData.SpecialSong); break;
			case 35: setLevelDetails(LevelData.S_2, LevelData.HouseTiles, LevelData.SpecialBG, 22, LevelData.SpecialSong); break;
			case 36: setLevelDetails(LevelData.S_3, LevelData.HouseTiles, LevelData.SpecialBG, 22, LevelData.SpecialSong); break;
			case 37: setLevelDetails(LevelData.S_4, LevelData.HouseTiles, LevelData.SpecialBG, 215, LevelData.SpecialSong); break;
			case 38: setLevelDetails(LevelData.S_5, LevelData.HouseTiles, LevelData.SpecialBG, 30, LevelData.SpecialSong); break;




		}
		trace(Registry.level);
		currentMap.setTileProperties(76, 0x1111, spikeCallback, Player, 4);
        trace("Curmap dims: ", currentMap.width, currentMap.height);
       
		FlxG.camera.setBounds(0, -100, currentMap.width + 200, currentMap.height+100, true);
        
		var nc:int = 0; /* Note Count */
		/* Remove certain tiles and spawn things on them. Thrilling! */
		var tileType:int = 0;
		for (var i:int = 0; i < currentMap.heightInTiles; i++ ) {
			for (var j: int = 0; j < currentMap.widthInTiles; j++) {
				
				switch (tileType = currentMap.getTileByIndex(i * currentMap.widthInTiles + j)) {
					case 35:
						currentMap.setTileByIndex(i * currentMap.widthInTiles + j, 0, true);
						var n:Note = new Note(j, i,nc);
						notes.add(n);
						nc += 1;
						break;
					case 36:
						currentMap.setTileByIndex(i * currentMap.widthInTiles + j, 0, true);
						var p:Pill = new Pill(16*j, 16*i);
						pills.add(p);
						break;
					case 38:
						currentMap.setTileByIndex(i * currentMap.widthInTiles + j, 0, true);
					
						initialX = player.x = 16 * j;
						initialY = player.y = 16 * i + 2;
						player.scale.x = 1;
						player.state = 2;
						break;
					case 39:
						
						currentMap.setTileByIndex(i * currentMap.widthInTiles + j, 0, true);
						exit = new FlxSprite(16*j,16*i);
						exit.loadGraphic(Door, true, true, 16, 32);
						exit.addAnimation("door",[0],10);
						exit.play("door");
						break;
					case 76: case 77: case 78: case 79:
						currentMap.setTileByIndex(i * currentMap.widthInTiles + j, 0, false);
						var spike:FlxSprite = new FlxSprite(j * 16, i * 16);
						spike.makeGraphic(8, 8, 0x00000000);
						
						switch (tileType) {
							case 76:
								spike.x += 4; spike.y += 8;
								break;
							case 77:
								spike.y += 4;
								break;
							case 78:
								spike.x += 4;
								break;
							case 79:
								spike.x += 8; spike.y += 4;
								break;
						}
						spike.immovable = true;
						spikes.add(spike);
						break;
					case 86:
						//make breaky block
						var breakyBlock:BreakyBlock = new BreakyBlock(j * 16, i * 16);
						currentMap.setTileByIndex(i * currentMap.widthInTiles + j, 0, true);
						breakyBlocks.add(breakyBlock);
						break;
					case 147: //moving platform right
						var movingPlatform:MovingPlatform = new MovingPlatform("RIGHT", 70, j * 16, i * 16 );
						currentMap.setTileByIndex(i * currentMap.widthInTiles + j, 0, true);
						movingPlatforms.add(movingPlatform);
						break;
					case 148:
						var movingPlatform2:MovingPlatform = new MovingPlatform("UP", 70, j * 16, i * 16);
						currentMap.setTileByIndex(i * currentMap.widthInTiles + j, 0, true);
						movingPlatforms.add(movingPlatform2);
				}
			}
		}
	}
	private function setLevelDetails(mapAsCSV:String, tileset:Class, BGImage:Class, timeout:int, song:Class, mapBGasCSV:String = "", mapFGasCSV:String = ""):void {
			
		// If the tile secret is on, use the weird GFX
		if (Registry.secretsState[3]) {
			tileset = LevelData.GlitchTiles;
		}
		currentMap.loadMap(mapAsCSV, tileset, 16, 16);
		if (mapBGasCSV != "") { currentMapBG.loadMap(mapBGasCSV, tileset, 16, 16); hasMapBG = true; }
		if (mapFGasCSV != "") { currentMapFG.loadMap(mapFGasCSV, tileset, 16, 16); hasMapFG = true; }
	
		
		
			background.loadGraphic(BGImage);
		if (Registry.secretsState[6]) {
			FlxG.playMusic(LevelData.DiscoSong, 1.0);
			isItDiscoTimeYet = true;
		} else {
			FlxG.playMusic(song, 1.0);
		}
		pillbar.timeToFull = timeout;
		return;
	}
	
	/** Kill the player if touches a spike **/
	
	private function spikeCallback(spike:Object, player:Player):void {
		pillbar.scale.x = 321;
		
	}
	
	public function makeHouseHud():void {
		
		pillbar = new Pillbar();
		//pillbar.x += 44;
        pillbar.x -= 100;
        pillbar.y += 115;

		//anxBar = new FlxSprite(pillbar.x-1,pillbar.y-1);
		anxBar = new FlxSprite(pillbar.x - 1,pillbar.y - 1);
		anxBar.loadGraphic(AnxBar, true, true, 322, 18);
		
		//bigNote = new FlxSprite(FlxG.width - 92,8);	
        bigNote = new FlxSprite(FlxG.width - 82,128);	
		bigNote.loadGraphic(BigNote, true, true, 64, 64);
		
		bigNoteBG = new FlxSprite(bigNote.x - 4, bigNote.y - 4);
		bigNoteBG.loadGraphic(BigNoteBG, false, false, 72, 72);
	
		timeText.setText("Time:0.0s", false, 0, 0, "left", true);
		timeText.x = 8; timeText.y = 148;
		timeBG = new FlxSprite(timeText.x - 3, timeText.y - 3);
		timeBG.loadGraphic(TimeBG, false, false, 180, 28);
		
		miniInfo.setText("(P)ause, (R)estart, (M)ute, More Games: (5)", true, 0, 0, "left", true);
		miniInfo.x = 20;
		miniInfo.y = 6 + 461;
        
        sponsorLogo = new FlxSprite(200, 40);
        sponsorLogo.loadGraphic(Registry.SPONSOR_LOGO_SMALL, false, false, 142, 31);
        sponsorLogo.x = 342; sponsorLogo.y = 450;
        houseHud.add(sponsorLogo);
		
		var miniInfoBG:FlxSprite = new FlxSprite(20 - 11, 5 + 458);
		var miniInfoBG2:FlxSprite = new FlxSprite(20 - 8, 6 + 460);
		miniInfoBG.makeGraphic(298+33,16,0xFF0022EE);
		miniInfoBG2.makeGraphic(292+33, 16, 0xFF11FFFF);
		houseHud.add(anxBar);	
		houseHud.add(pillbar);

		houseHud.add(miniInfoBG);
		houseHud.add(miniInfoBG2);
		houseHud.add(miniInfo);
		houseHud.add(bigNoteBG);
		houseHud.add(bigNote);
		houseHud.add(timeBG);
		houseHud.add(timeText);
		houseHud.setAll("scrollFactor",new FlxPoint(0,0));
		return;
	}
	
	public function bloodAnimation(n:int):void {
		
		for (var i:int = 0; i < n; i++) {
			var blood:FlxSprite = new FlxSprite(player.x + 7, player.y + 15);
			var size:int = int(3 * Math.random()) + 1 + 2;
			blood.makeGraphic(size,size - 1 + int(Math.random() * 3), player.demBloodColors[int(4 * Math.random())]);
			blood.velocity.x = -300 + 600 * Math.random();
			blood.velocity.y = -300 + 400 * Math.random();
			blood.drag.x = 30;
			blood.acceleration.y = 150;
			blood.angularDrag = 150;
			blood.angularVelocity = 200;
			blood.exists = true;
			bloodGroup.add(blood);
			add(blood);
		}
	}
	
	public function stopBlood(blood:Object, foo:Object):void {
		blood.velocity.x = 0;
		blood.velocity.y = 0;
		blood.acceleration.y = 0;
	}
	
	public function quit():void {

        FlxG.camera.zoom = 1;
        FlxG.width = 640;
        FlxG.height = 480;
        FlxG.camera.setBounds(0, 0, 640, 480, true);
		notes.kill(); //free up dat memory yall
		FlxG.music.stop();
		FlxG.switchState(new WorldMap());
	}
	
	public function restart():void {
		
		notes.kill();
		FlxG.music.stop();
		FlxG.switchState(new PlayState());
		Registry.restart();
		FlxG.paused = false;
	}
        
    override public function destroy():void {
        for (var i:int = 0; i < members.length; i++) {
           if (members[i] != null) members[i] = null;
        }
        super.destroy();
        return;
    }
}


}
