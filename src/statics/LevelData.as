package statics {
	/** More or less just need to load these once instead of on every single level load **/
	public class LevelData {
		
	/** Import the CSV map files. **/

/** Tutorial stages. **/
	[Embed(source = "../csv/mapCSV_Tutorial_1.csv", mimeType = "application/octet-stream")] private static var tutorial1_CSV:Class;
	public static var tutorial1:String = new tutorial1_CSV();

	/** Grass/plain stages **/
	[Embed(source = "../csv/mapCSV_A_1.csv", mimeType = "application/octet-stream")] private static var A_1_CSV:Class;
	public static var A_1:String = new A_1_CSV();
	[Embed(source = "../csv/mapCSV_A_2.csv", mimeType = "application/octet-stream")] private static var A_2_CSV:Class;
	public static var A_2:String = new A_2_CSV();
	[Embed(source = "../csv/mapCSV_A_3.csv", mimeType = "application/octet-stream")] private static var A_3_CSV:Class;
	public static var A_3:String = new A_3_CSV();
	[Embed(source = "../csv/mapCSV_A_4.csv", mimeType = "application/octet-stream")] private static var A_4_CSV:Class;
	public static var A_4:String = new A_4_CSV();
	[Embed(source = "../csv/mapCSV_A_5.csv", mimeType = "application/octet-stream")] private static var A_5_CSV:Class;
	public static var A_5:String = new A_5_CSV();
	[Embed(source = "../csv/mapCSV_A_6.csv", mimeType = "application/octet-stream")] private static var A_6_CSV:Class;
	public static var A_6:String = new A_6_CSV();
	[Embed(source = "../csv/mapCSV_A_7.csv", mimeType = "application/octet-stream")] private static var A_7_CSV:Class;
	public static var A_7:String = new A_7_CSV();
	[Embed(source = "../csv/mapCSV_A_8.csv", mimeType = "application/octet-stream")] private static var A_8_CSV:Class;
	public static var A_8:String = new A_8_CSV();
	[Embed(source = "../csv/mapCSV_A_9.csv", mimeType = "application/octet-stream")] private static var A_9_CSV:Class;
	public static var A_9:String = new A_9_CSV();
	
	/** Forest stages **/
	[Embed(source = "../csv/mapCSV_B_1.csv", mimeType = "application/octet-stream")] private static var B_1_CSV:Class;
	public static var B_1:String = new B_1_CSV();
	[Embed(source = "../csv/mapCSV_B_2.csv", mimeType = "application/octet-stream")] private static var B_2_CSV:Class;
	public static var B_2:String = new B_2_CSV();
	[Embed(source = "../csv/mapCSV_B_3.csv", mimeType = "application/octet-stream")] private static var B_3_CSV:Class;
	public static var B_3:String = new B_3_CSV();
	[Embed(source = "../csv/mapCSV_B_4.csv", mimeType = "application/octet-stream")] private static var B_4_CSV:Class;
	public static var B_4:String = new B_4_CSV();
	[Embed(source = "../csv/mapCSV_B_5.csv", mimeType = "application/octet-stream")] private static var B_5_CSV:Class;
	public static var B_5:String = new B_5_CSV();
	[Embed(source = "../csv/mapCSV_B_6.csv", mimeType = "application/octet-stream")] private static var B_6_CSV:Class;
	public static var B_6:String = new B_6_CSV();
	[Embed(source = "../csv/mapCSV_B_7.csv", mimeType = "application/octet-stream")] private static var B_7_CSV:Class;
	public static var B_7:String = new B_7_CSV();
	[Embed(source = "../csv/mapCSV_B_8.csv", mimeType = "application/octet-stream")] private static var B_8_CSV:Class;
	public static var B_8:String = new B_8_CSV();
	[Embed(source = "../csv/mapCSV_B_9.csv", mimeType = "application/octet-stream")] private static var B_9_CSV:Class;
	public static var B_9:String = new B_9_CSV();
	
	
	/**House themed stages **/
	[Embed(source = "../csv/mapCSV_C_1.csv", mimeType = "application/octet-stream")] private static var C_1_CSV:Class;
	public static var C_1:String = new C_1_CSV();
	[Embed(source = "../csv/mapCSV_C_1BG.csv", mimeType = "application/octet-stream")] private static var C_1BG_CSV:Class;
	public static var C_1BG:String = new C_1BG_CSV();
	[Embed(source = "../csv/mapCSV_C_2.csv", mimeType = "application/octet-stream")] private static var C_2_CSV:Class;
	public static var C_2:String = new C_2_CSV();
	[Embed(source = "../csv/mapCSV_C_2BG.csv", mimeType = "application/octet-stream")] private static var C_2BG_CSV:Class;
	public static var C_2BG:String = new C_2BG_CSV();
	[Embed(source = "../csv/mapCSV_C_3.csv", mimeType = "application/octet-stream")] private static var C_3_CSV:Class;
	public static var C_3:String = new C_3_CSV();
	[Embed(source = "../csv/mapCSV_C_4.csv", mimeType = "application/octet-stream")] private static var C_4_CSV:Class;
	public static var C_4:String = new C_4_CSV();
	[Embed(source = "../csv/mapCSV_C_4BG.csv", mimeType = "application/octet-stream")] private static var C_4BG_CSV:Class;
	public static var C_4BG:String = new C_4BG_CSV();
	[Embed(source = "../csv/mapCSV_C_5.csv", mimeType = "application/octet-stream")] private static var C_5_CSV:Class;
	public static var C_5:String = new C_5_CSV();
	[Embed(source = "../csv/mapCSV_C_6.csv", mimeType = "application/octet-stream")] private static var C_6_CSV:Class;
	public static var C_6:String = new C_6_CSV();
	[Embed(source = "../csv/mapCSV_C_7.csv", mimeType = "application/octet-stream")] private static var C_7_CSV:Class;
	public static var C_7:String = new C_7_CSV();
	[Embed(source = "../csv/mapCSV_C_8.csv", mimeType = "application/octet-stream")] private static var C_8_CSV:Class;
	public static var C_8:String = new C_8_CSV();
	[Embed(source = "../csv/mapCSV_C_9.csv", mimeType = "application/octet-stream")] private static var C_9_CSV:Class;
	public static var C_9:String = new C_9_CSV();
	
	/** Special **/
	[Embed(source = "../csv/mapCSV_S_1.csv", mimeType = "application/octet-stream")] private static var S_1_CSV:Class;
	public static var S_1:String = new S_1_CSV();
	[Embed(source = "../csv/mapCSV_S_2.csv", mimeType = "application/octet-stream")] private static var S_2_CSV:Class;
	public static var S_2:String = new S_2_CSV();
	[Embed(source = "../csv/mapCSV_S_3.csv", mimeType = "application/octet-stream")] private static var S_3_CSV:Class;
	public static var S_3:String = new S_3_CSV();
	[Embed(source = "../csv/mapCSV_S_4.csv", mimeType = "application/octet-stream")] private static var S_4_CSV:Class;
	public static var S_4:String = new S_4_CSV();
	[Embed(source = "../csv/mapCSV_S_5.csv", mimeType = "application/octet-stream")] private static var S_5_CSV:Class;
	public static var S_5:String = new S_5_CSV();
	
	/** Hut **/
	[Embed(source = "../csv/mapCSV_HUT_1.csv", mimeType = "application/octet-stream")] private static var HUT_1_CSV:Class;
	public static var HUT:String = new HUT_1_CSV();
	[Embed(source = "../csv/mapCSV_HUT_1-BG.csv", mimeType = "application/octet-stream")] private static var HUT_1BG_CSV:Class;
	public static var HUTBG:String = new HUT_1BG_CSV();
	
	
	
/** Backgrounds **/
	[Embed(source = "../res/img/bg/houseBG.png")] public static var HouseBG:Class;
	[Embed(source = "../res/img/bg/sleepBG.png")] public static var SleepBG:Class;
	[Embed(source = "../res/img/bg/caveBG.png")] public static var CaveBG:Class;
	[Embed(source = "../res/img/bg/weirdbg.png")] public static var SpecialBG:Class;
	[Embed(source = "../res/img/bg/nightcity.png")] public static var  NightCityBG:Class;
	[Embed(source = "../res/img/bg/forestBG.png")] public static var forestBG:Class;
	
/** Songs **/
	[Embed(source = "../res/mp3/housetheme.mp3")] public static var HouseSong:Class;
	[Embed(source = "../res/mp3/cavesaredeep.mp3")] public static var SpecialSong:Class;
	[Embed(source = "../res/mp3/cave.mp3")] public static var CaveSong:Class;
	[Embed(source = "../res/mp3/tutorialtheme.mp3")] public static var TutorialSong:Class;
	[Embed(source = "../res/mp3/cutscenebossa.mp3")] public static var BossaSong:Class;
	[Embed(source = "../res/mp3/menutheme.mp3")] public static var MenuSong:Class;
	[Embed(source = "../res/mp3/plains.mp3")] public static var PlainsSong:Class;
	[Embed(source = "../res/mp3/inspirationdavetitle.mp3")] public static var TitleSong:Class;
	[Embed(source = "../res/mp3/inspirationdaveforest.mp3")] public static var ForestSong:Class;
	[Embed(source = "../res/mp3/disco.mp3")] public static var DiscoSong:Class;
	
/** Tilemaps **/
	[Embed(source = "../res/houseTiles.png")] public static var HouseTiles:Class;
	[Embed(source = "../res/glitchTiles.png")] public static var GlitchTiles:Class;


/** SFX **/
	[Embed(source = "../res/mp3/bloop.mp3")] public static var Bloop:Class;
	[Embed(source = "../res/mp3/hitdoor.mp3")] public static var HitDoor:Class;
	[Embed(source = "../res/mp3/enterlevel.mp3")] public static var EnterLevel:Class;
	
/** Tutorial GFX **/
    [Embed(source = "../res/img/playstate/tutorialPopups.png")] public static var TutorialGFX:Class;
	
/** Level names **/
	public static var levelNames:Array = new Array("bob", 
	"bilL");
	
		public function LevelData() {
			
		}
		public static function init():void {
			
		}
	}
}