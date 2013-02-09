package
{
    import org.flixel.system.FlxPreloader;
	import Playtomic.Log;
    import 
   public class Preloader extends FlxPreloader
   {
      public function Preloader():void
      {	
        //Presumably MochiAds stuff goes here
        //Playtomic
        if (stage.loaderInfo.loaderURL.indexOf("Users/Sean") == -1) {
		    Log.View(6451, "d7cfbe258b9247e5", "d828b71e31634baf9fd7f1a1b4d4dc", stage.loaderInfo.loaderURL);
        }
		className = "Main";		  
        super();
      }
   }
}