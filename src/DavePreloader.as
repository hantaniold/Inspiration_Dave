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
		    Log.View(, "", "", stage.loaderInfo.loaderURL);
        }
		className = "Main";		  
        super();
      }
   }
}
