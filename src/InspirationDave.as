package 
{
    import com.newgrounds.components.FlashAd;
    import com.newgrounds.components.MedalPopup;
    import com.newgrounds.*;
	import org.flixel.FlxGame;
	import org.flixel.FlxG;
	import statics.LevelData;
    import mochi.as3.*;
	
//	[SWF(width="640", height="480", backgroundColor="#000000")]
	public class InspirationDave extends FlxGame
	{
		public function InspirationDave()
		{
            
		    Registry.init();
			LevelData.init();
            
            var a:String  = Registry.PORTAL_SOURCE;
            
            Registry.SPONSOR_SPLASH = "http://adventuregameshq.com/?utm_source=" + a + "&utm_medium=brandedgames_external&utm_content=splashscreen&utm_campaign=inspirationdave";
            Registry.SPONSOR_MAINMENU = "http://adventuregameshq.com/?utm_source=" + a + "&utm_medium=brandedgames_external&utm_content=mainmenu&utm_campaign=inspirationdave";
            Registry.SPONSOR_GAME = "http://adventuregameshq.com/?utm_source=" + a + "&utm_medium=brandedgames_external&utm_content=gameplay&utm_campaign=inspirationdave";
            Registry.SPONSOR_WORLDMAP = "http://adventuregameshq.com/?utm_source=" + a + "&utm_medium=brandedgames_external&utm_content=worldmap&utm_campaign=inspirationdave";
			super(640, 480, Intro);
            var medalPopup:MedalPopup = new MedalPopup();
            medalPopup.x = medalPopup.y = 5;
            addChild(medalPopup);
		}

	}
}
