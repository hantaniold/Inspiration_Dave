package {
	import entities.WrapSprite;
	import org.flixel.FlxBasic;
	import org.flixel.FlxGroup;
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.FlxState;
	import org.flixel.FlxButton;
	import org.flixel.FlxText;
	import org.flixel.FlxG;
	import org.flixel.plugin.photonstorm.FlxSpecialFX;
	import org.flixel.plugin.photonstorm.FX.PlasmaFX;
	import statics.LevelData;
	import Playtomic.Log;
    import Playtomic.Link;
	import org.flixel.plugin.photonstorm.FlxBitmapFont;
	
public class MainMenuState extends FlxState {
	[Embed(source = "res/mp3/bloop.mp3")] public var Bloop:Class;
	[Embed(source = "res/mp3/notefx1.mp3")] public var Fx1:Class;
	
	[Embed(source = "res/img/mainmenu/mainmenu.png")] public var MainMenuPic:Class;
	private var mainMenu:FlxSprite; 
	
	[Embed(source = "res/img/mainmenu/mainmenumarquee.png")] public var Marquee:Class;
	private var marquee:FlxSprite = new FlxSprite(0, 0, Marquee);
	
	[Embed(source = "res/img/mainmenu/mainmenudeletemarquee.png")] public var DeleteMarquee:Class;
	[Embed(source = "res/img/mainmenu/mainmenubg.png")] public var MainMenuBG:Class;
	[Embed(source = "res/img/mainmenu/titlebar.png")] public var TitleBar:Class;
	
	private var file1:FlxBitmapFont = new FlxBitmapFont(Registry.bigFontBlack, 14, 28, Registry.fontString, 26, 0, 0, 0, 2);
	private var file2:FlxBitmapFont = new FlxBitmapFont(Registry.bigFontBlack, 14, 28, Registry.fontString, 26, 0, 0, 0, 2);
	private var file3:FlxBitmapFont = new FlxBitmapFont(Registry.bigFontBlack, 14, 28, Registry.fontString, 26, 0, 0, 0, 2);
	private var areYouSureBG1:FlxSprite = new FlxSprite(0, 0);
	private var areYouSureBG2:FlxSprite = new FlxSprite(0, 0);
	private var areYouSure:FlxBitmapFont = new FlxBitmapFont(Registry.bigFontWhite, 14, 28, Registry.fontString, 26, 0, 0, 0, 2);
	private var obvious:FlxBitmapFont = new FlxBitmapFont(Registry.font, 7, 14, Registry.fontString, 26, 0, 0, 0, 1);
	private var deleteState:int = 0;
	private var dancePlayer:FlxSprite = new FlxSprite();
	private var exitAnimationStarted:Boolean = false;
	private var overWhatButton:int = 0; /** 0  1
											2  3
											4  5 **/
											
	private var i:int = 0;
	private var offy:int = 0;
	private var offx:int = 0;
	private var addSquareTimer:Number = 0;
	private var clicks:FlxText;
	private var hBox:FlxSprite;
	private var boxArray:Array = new Array(0, 0);
	private var squares:FlxGroup = new FlxGroup();
	private var fade:FlxSprite = new FlxSprite(0, 0);
	private var colors:Array = new Array(0xFF000000, 0xFFFFFFFF, 0xFF888888, 0xFF444444);
	
	private var bg1:WrapSprite = new WrapSprite(0, 0, 640, -100);
	private var bg2:WrapSprite = new WrapSprite(640, 0, 640, -100);
	private var titleBar:FlxSprite = new FlxSprite(8, 8);
	
		
	private var UP_P:Boolean = (FlxG.keys.UP || FlxG.keys.W);
	private var DOWN_P:Boolean = (FlxG.keys.DOWN || FlxG.keys.S);
	private var LEFT_P:Boolean = (FlxG.keys.LEFT || FlxG.keys.A);
	private var RIGHT_P:Boolean = (FlxG.keys.RIGHT || FlxG.keys.D);
	private var ADV_P:Boolean = (FlxG.keys.X || FlxG.keys.K);
	private var BACK_P:Boolean = (FlxG.keys.Z || FlxG.keys.J);
	
	/* Sponsor assets */
    private var sponsorLogo:FlxSprite = new FlxSprite(500, 8);
    
	override public function create():void {
	FlxG.volume = 1.0;
	bg1.loadGraphic(MainMenuBG, false, false, 640, 480);
	bg2.loadGraphic(MainMenuBG, false, false, 640, 480);
	titleBar.loadGraphic(TitleBar, false, false, 370, 103);
	add(bg1); add(bg2); add(titleBar);
	
	dancePlayer.loadGraphic(Player.PlayerSprite, true, false, 15, 30);
	dancePlayer.addAnimation("1", [1,2,3,4,5,6,7,8,9,10], 10, true);
	//dancePlayer.addAnimation("2", [3, 4], 2, true);
	//dancePlayer.addAnimation("3", [8, 9], 2, true);
	dancePlayer.x = 35; dancePlayer.y =  190;
	dancePlayer.scale.x = dancePlayer.scale.y = 2;
	dancePlayer.play("1");
	add(dancePlayer);
	FlxG.playMusic(LevelData.MenuSong, 1.0);
	
	file1.setText("NEW", true, 0, 0, "left", true);
	file1.x = 90; file1.y = 175;			
	file2.setText("NEW", true, 0, 0, "left", true);
	file2.x = 90; file2.y = 280;
	file3.setText("NEW", true, 0, 0, "left", true);
	file3.x = 90; file3.y = 385;
	
	var o1:FlxSprite = new FlxSprite(8 , 108 + 10); o1.makeGraphic(4 + 16 * 9, 4 + 28, 0xff00eeee);
	var o2:FlxSprite = new FlxSprite(6 , 106 + 10); o2.makeGraphic(8 + 16 * 9, 8 + 28, 0xff00aaee);
	obvious.setText("X/K to select. \nArrows/WASD to move!\n", true, 0, 0, "left", true);
	obvious.x = 10; obvious.y = 110 + 10;
	add(o2); add(o1); 	add(obvious);

	areYouSure.setText("NEW", true, 0, 0, "left", true);
	areYouSure.x = 100; areYouSure.y = 100;  areYouSure.visible = false;
	areYouSureBG1.x = areYouSure.x - 2; areYouSureBG1.y = areYouSure.y - 2;
	areYouSureBG2.x = areYouSure.x - 4; areYouSureBG2.y = areYouSure.y - 4;
	areYouSureBG1.makeGraphic(4 + 32 * 14, 4 + 56, 0xff00ffff); areYouSureBG1.visible = false; 
	areYouSureBG2.makeGraphic(8 + 32 * 14, 8 + 56, 0xff00aaff); areYouSureBG2.visible = false; 
	add(areYouSureBG2); add(areYouSureBG1); add(areYouSure);

	if (SaveData.loadExists(1)) {
		SaveData.load(1);
		file1.text = "File 1: " + getPercentage() + "%\nDeaths:" + Registry.nrDeaths.toString() + " Rate: " + getTimeScore();
		
	} 
	if (SaveData.loadExists(2)) {
		SaveData.load(2);
		file2.text = "File 2: " + getPercentage() + "%\nDeaths:" + Registry.nrDeaths.toString() + " Rate: " + getTimeScore();
	}
	if (SaveData.loadExists(3)) {
		SaveData.load(3);
		file3.text = "File 3: " + getPercentage() + "%\nDeaths:" + Registry.nrDeaths.toString() + " Rate: " + getTimeScore();
	}
	
	
	marquee = new FlxSprite(0, 0);
	marquee.loadGraphic(Marquee, false, false, 53, 13);
	marquee.addAnimation("flash", [0, 1], 10, true);
	marquee.play("flash");
	marquee.scale.x = marquee.scale.y = 8;
	marquee.x = 254;
	marquee.y = 201;
	add(marquee);
	
	mainMenu = new FlxSprite(0, 0);
	mainMenu.loadGraphic(MainMenuPic, false, false, 80, 60);
	mainMenu.scale = new FlxPoint(8, 8);
	mainMenu.x = 300;
	mainMenu.y = 213;
	add(mainMenu);
	
	add(file1);
	add(file2);
	add(file3);
	add(clicks);
    
    var sponsorLogoText:FlxBitmapFont = new FlxBitmapFont(Registry.font, 7, 14, Registry.fontString, 26, 0, 0, 0, 2);
    sponsorLogoText.setText(" Press 'M' to\n play more games! \n You know you want to!", true, 0, 0, "left", true);
    sponsorLogoText.x = 380; sponsorLogoText.y = 40;
    sponsorLogo.loadGraphic(Registry.SPONSOR_LOGO, false, false, 142, 136);
    
    add(sponsorLogo);
    add(sponsorLogoText);
    
	/* Some exit animation - stick a fade behind these squares, squares explode...*/
	fade.makeGraphic(640, 480, 0xFF000000);
	fade.visible = false;
	add(fade);
	add(squares);
	}
	
	override public function update():void {
	
		UP_P = (FlxG.keys.justPressed("UP") || FlxG.keys.justPressed("W"));
		DOWN_P = (FlxG.keys.justPressed("DOWN") || FlxG.keys.justPressed("S"));
		LEFT_P = (FlxG.keys.justPressed("LEFT") || FlxG.keys.justPressed("A"));
		RIGHT_P = (FlxG.keys.justPressed("RIGHT") || FlxG.keys.justPressed("D"));
		ADV_P = (FlxG.keys.justPressed("X") || FlxG.keys.justPressed("J") || FlxG.keys.justPressed("ENTER") || FlxG.keys.justPressed("SPACE"));
		BACK_P = (FlxG.keys.justPressed("Z") || FlxG.keys.justPressed("K") || FlxG.keys.justPressed("ESCAPE") || FlxG.keys.justPressed("BACKSPACE"));
		
	
        if (FlxG.keys.justPressed("M"))  {
            Log.LevelCounterMetric("Visited Sponsor In Main Menu", "Links", true);
            Link.Open(Registry.SPONSOR_MAINMENU, "sponsor site main menu", "sponsor links");
        }
		if (exitAnimationStarted) {
			addSquareTimer += FlxG.elapsed;
			if (addSquareTimer > 0.02 && i < 4 * 12) {
				FlxG.play(Player.LandSound,0.3);
				addSquareTimer = 0;
				offy = i / 8;
				offx = i % 8;
				var square:FlxSprite = new FlxSprite(offx * 80, offy * 80);
				square.makeGraphic(80, 80, colors[int(Math.random() * 4)]);
				squares.add(square)
				i++;
			}
			if (i >= 4 * 12) { 
				if (i == 4 * 12) {
					fade.visible = true;
					FlxG.play(Pill.PillSound);
					i++;
					
					for each (var st:FlxSprite in squares.members ) {
						st.velocity.x = -40 + 80 * Math.random();
						st.velocity.y = -150 - 100 * Math.random();
						st.acceleration.y = 450;
					}
				}
				FlxG.volume -= 0.01;
				if (addSquareTimer > 2.5)
					loadGame(Registry.fileID);
			}
			super.update();
			return;
		}
		
		if (FlxG.keys.justPressed("C")) {
		//	Registry.sponsorOn = true;
		//	Registry.SPONSORRR = true;
			FlxG.play(LevelData.Bloop);
		}
		if (UP_P || DOWN_P || RIGHT_P || LEFT_P)
			FlxG.play(Bloop);
		if ((deleteState > 0) || ((overWhatButton % 2 == 1) && (ADV_P || FlxG.keys.justPressed("Y")))) {
			if (deleteState == 0) {
				areYouSure.visible = areYouSureBG1.visible = areYouSureBG2.visible = true;
				areYouSure.text = "Are you sure you want to delete?\n Y = yes, X/K = no";
				deleteState++;
				return;
			} else if (deleteState == 1) {
				if (ADV_P) {
				areYouSure.visible = areYouSureBG1.visible = areYouSureBG2.visible = false;
					deleteState = 0;
					return;
				} else if (FlxG.keys.justPressed("Y")) {
					deleteState++;
					areYouSure.text = "Are you REALLY sure?\n Y = yes, X/K = no";
					return;
				} else { super.update(); return; }
			} else if (deleteState == 2) {
				if (ADV_P) {
				areYouSure.visible = areYouSureBG1.visible = areYouSureBG2.visible = false;
					deleteState = 0;
					return;
				} else if (FlxG.keys.justPressed("Y")) {
				areYouSure.visible = areYouSureBG1.visible = areYouSureBG2.visible = false;
					deleteState = 0;
				}  else { super.update(); return; }
			}
		}
		
		
		
		switch (overWhatButton) {
		case 0:
			if (ADV_P)
				loadGame(1);
			if (DOWN_P) {
				dancePlayer.play("1");
				dancePlayer.y += 100;
				overWhatButton = 2;
				marquee.y += 104;
			}
			if (RIGHT_P) {
				marquee.loadGraphic(DeleteMarquee, true, false, 13, 13, false);
				marquee.x += 292;
				overWhatButton = 1;	
			}
			break;
		case 1:
			if (FlxG.keys.justPressed("Y"))
				del(1);
			if (LEFT_P) {
				overWhatButton = 0;
				marquee.loadGraphic(Marquee, true, false, 53, 13, false);
				marquee.x -= 292;
			}
			break;
		case 2:

			if (ADV_P)
				loadGame(2);
			if (DOWN_P) {
				overWhatButton = 4;
				marquee.y += 104;
				dancePlayer.y += 100;
				dancePlayer.play("1");
			}
			if (UP_P) {
				overWhatButton = 0;
				dancePlayer.y -= 100;
				marquee.y -= 104;
				dancePlayer.play("1");
			}
			if (RIGHT_P) {
				marquee.loadGraphic(DeleteMarquee, true, false, 13, 13, false);
				marquee.x += 292;
				overWhatButton = 3;	
			}
			break;
		case 3:
			if (FlxG.keys.justPressed("Y"))
				del(2);
			if (LEFT_P) {
				overWhatButton = 2;
				marquee.loadGraphic(Marquee, true, false, 53, 13, false);
				marquee.x -= 292;
			}
			break;
		case 4:
			if (ADV_P)
				loadGame(3);
			if (RIGHT_P) {
				marquee.loadGraphic(DeleteMarquee, true, false, 13, 13, false);
				marquee.x += 292;
				overWhatButton = 5;	
			}
			if (UP_P) {
				dancePlayer.y -= 100;
				dancePlayer.play("1");
				overWhatButton = 2;
				marquee.y -= 104;
			}
			break;
		case 5:
			if (FlxG.keys.justPressed("Y"))
				del(3);
			if (LEFT_P) {
				overWhatButton = 4;
				marquee.loadGraphic(Marquee, true, false, 53, 13, false);
				marquee.x -= 292;
			}
			break;
		}
		super.update();
	}
	public function loadGame(i:int):void {
		
		if (!exitAnimationStarted) {
			
			dancePlayer.frame = 10;
			FlxG.play(Fx1,1.0);
			Registry.fileID = i;
			exitAnimationStarted = true;
		} else {
			Log.Play();
			if (false == SaveData.load(Registry.fileID)) Registry.reset();
			if (Registry.level < Registry.INIT_LEVEL) Registry.level = Registry.INIT_LEVEL;
			if (Registry.cutscenesWatched[0]) { //If we watched the intro already then skip it.
				Log.LevelAverageMetric("Current Percent", "Menu", parseFloat(getPercentage()));
				Log.LevelAverageMetric("Current Rate", "Menu", parseFloat(getTimeScore()));
				FlxG.switchState(new WorldMap());
			} else {
				
				Registry.cutscene = 0; //Otherwise watch it herp derp
				FlxG.music.stop();
				FlxG.switchState(new Cutscene());
			}
		}
	}
	
	public function del(i:int):void {
		if (SaveData.deleteData(i)) {
			switch (i) {
				case 1: file1.text = "NEW"; break;
				case 2: file2.text = "NEW"; break;
				case 3: file3.text = "NEW";
			}
		}
	}
	
	public function getPercentage():String {
		
		var noteWeight:Number; //70%, percentage of notes gotten.
		var totalNotes:Number = 0;
		var timesBeaten:Number = 0;
		var timeWeight:Number; //30%, percentage of dev times beat.
		var i:int = 0;
		//Set to 39 - because of 37 levels, 1 hut, and indexing from one.
		Registry.devTimes.length = Registry.nrLevels + 2;
		Registry.times.length = Registry.nrLevels + 2;
		Registry.noteScores.length = Registry.nrLevels + 2;
		for (i = 1; i < Registry.times.length; i++) {
			if (Registry.times[i] == null) Registry.times[i] = 0;
		}
		for (i = 1; i < Registry.noteScores.length; i++) {
			if (Registry.noteScores[i] == null) Registry.noteScores[i] = 0;
			totalNotes += Registry.noteScores[i];
		}
		noteWeight = .7 * (totalNotes / Registry.maxNotes);
		for (i = 5; i < Registry.times.length; i++) {
			if (i == 24) continue;
			if (Registry.times[i] < Registry.devTimes[i] && Registry.times[i] != 0) {
				timesBeaten++;
			}
		}
		timeWeight = .3 * (timesBeaten / 33);
		var percentage:Number = 100 * (timeWeight + noteWeight);
		return percentage.toFixed(2);
	}
	
	public static function getTimeScore():String {
	  var timeScore:Number = 0;
	  var i:int;
	  //trace("times length in getTimeScore:", Registry.times.length);
	  for (i = 5; i < Registry.times.length; i++) {
		  if (i == 24) continue; //skip hut
		  if (Registry.times[i] == 0 || Registry.noteScores[i] != 20) { //No time is 100 time at all. That doesn't make sense...
			timeScore += 100;
			continue;
		  } 
		  //Add your time if you beat the dev time.
		  if (Registry.times[i] < Registry.devTimes[i]) {
			  timeScore += Registry.times[i];
		  }
	  }
	  return timeScore.toFixed(2);
		  
		  
	}
    
    override public function destroy():void {
        for (var i:int = 0; i < members.length; i++) {
            if (members[i] != null) members[i] = null;
        }
        super.destroy();
    }
	
	
}

}