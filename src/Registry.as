package
{
public class Registry {

    
	//If site-locke is the player loading from the wrong site
	public static var wrongSite:Boolean = false;
	//font
	[Embed(source = "res/font/proggy.png")] public static var font:Class;
	[Embed(source = "res/font/proggyx2black.png")] public static var bigFontBlack:Class;
	[Embed(source = "res/font/proggyx2white.png")] public static var bigFontWhite:Class;
	public static var fontString:String = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890!?.'/,:-()%";
    public static var adsDone:Boolean = false;
	
	public static var sponsorOn:Boolean = false;
	public static var SPONSORRR:Boolean = false;
    
    public static var PORTAL_SOURCE:String;
    public static var SPONSOR_SPLASH:String;
    public static var SPONSOR_MAINMENU:String;
    public static var SPONSOR_WORLDMAP:String;
    public static var SPONSOR_GAME:String;
    [Embed (source = "sponsorlogo.png")] public static var SPONSOR_LOGO:Class;
    [Embed (source = "sponsorlogosmaller.png")] public static var SPONSOR_LOGO_SMALL:Class;
	
	// State we wish to carry throughout the game. "SAVED" refers to things that should be serialized.
    public static var GLOBAL_SPRINT:Boolean = false;
	public static var globalMute:Boolean = false;
	public static var isNoteStage:Boolean = true;
	public static var INIT_LEVEL:int = 5;
	public static var level:int = 5; //SAVED Determines where we pop up on the world map load.
	public static var levelName:String = ""; //This is for the intro animation.
	public static var levelNick:String = ""; //T-1, 1-4, S-1, etc
	public static var fileID:int; //Determines what file to write to when saving.
	/*How many stages currently, prevents the bug where if I update with new stages then
	* Score calculations update incorrectly because of a saved array */
	public static var nrLevels:int = 37; 
/* Treasures for (out of 33 time medals and 660 notes: 
	 *  150 notes, 5 time medals: Jukebox - HutState 
	 *  260 notes, 10 time medals: Super long trail - Player, HutState
	 *  360 notes, 15 time medals: Annoying spinny jump - Player code
	 *  460 notes, 20 time medals: Glitched tileset - PlayState, HutState
	 *  560 notes, 25 time medals: Crappy dave sprite - PlayState, HutState, (Ending?), Worldmap
	 *  620 notes, 31 time medals: Secret stages - Done.
	 *  660 notes, 33 time medals: Stupid trophy next to name, Disco mode */
	public static var boxesOpened:Array = new Array(false, false, false, false, false, false, false);
	public static var secretsState:Array = new Array(false,false, false, false, false, false, false);
	/* My best times for the stages, with a little leeway - unlock things by beating the scoores */
	public static var devTimes:Array = new Array( 0.0, 0.0, 0.0, 0.0, 0.0, 14.0,  //tutorial
													   8.0,  10.0,  7.0,  12.0, 8.0,  11.0, 21.0, 13.0, 30.0,  //plains
													   32.0, 24.0, 38.0, 34.0, 13.0, 36.0, 22.0, 24, 23.0,  //forest
													   -2,  //hut (ihnore)
													   32, 19.0, 43.0, 17.0, 30, 38.0, 76.0, 32.0, 43.0, //house
													   38.0, 46.0, 60, 100, 80); //sadistic
	/* The max notes obtainable. Used in conjunction with times to calculate a "percentage" score. */
	public static var maxNotes:Number = 20 + 20 * 27 + 20 * 5;
	// SAVED Determines if the corresponding level markers on the world map will be drawn.
	public static var levelIsUnlocked:Array = new Array(
	false, true , false, false, false, false, false, false, false, false,
	false, false, false, false, false, false, false, false, false, false,
	false, false, false, false, false, false, false, false, false, false,
	false, false, false, false, false, false, false, false, false);
	// Determines if on the next WorldMap load, the animation for unlocking is played.
	public static var wasJustUnlocked:Array = new Array(
	false, false, false, false, false, false, false, false, false, false,
	false, false, false, false, false, false, false, false, false, false,
	false, false, false, false, false, false, false, false, false, false,
	false, false, false, false, false, false, false, false, false);
	// Intro, Middle, ending - saved!
	public static var cutscenesWatched:Array = new Array(false, false, false,false);
	// SAVED
	public static var noteScores:Array = new Array(0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
												   0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
												   0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
												   0, 0, 0, 0, 0, 0, 0, 0, 0);
	
	// SAVED
	public static var times:Array = new Array(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 
											  0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
											  0, 0, 0, 0, -1, 0, 0, 0, 0, 0,
											  0, 0, 0, 0, 0, 0, 0, 0, 0);
	public static var cutscene:int = 0; 
	// SAVED
	public static var nrDeaths:int = 0;
	
	// Truly tiny things.
	public static var mainMenuToMapTrigger:int = 0;

	public function Registry() {
	}
/* Called when deleting a file */
	public static function reset():void {
		nrDeaths = 0;
		level = 1;
		for (var i:int = 0; i < levelIsUnlocked.length; i++) {
			levelIsUnlocked[i] = false;
			noteScores[i] = 0;
			times[i] = 0;
		}
		cutscenesWatched[0] = cutscenesWatched[1] = cutscenesWatched[2] = cutscenesWatched[3] = false;
		for (var j:int = 0; j < 7; j++) {
			boxesOpened[j] = false;
		}
		levelIsUnlocked[0] = true;
		sponsorOn = false;
	}
	
	public static function init():void {	
	}

	public static function restart():void {
		if (isNoteStage) {
			Registry.noteScores[level] = 0;
		} else {
			Registry.times[level] = 0.0;
		}
	}
		
}

}
