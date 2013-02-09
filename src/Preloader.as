package
{
    import com.newgrounds.components.APIConnector;
    import com.newgrounds.components.FlashAd;
    import com.newgrounds.*;
    import CPMStar.AdLoader;
    import flash.events.MouseEvent;
    import flash.ui.Mouse;
    import NewgroundsAPIComponents_fla.MainTimeline;
    import org.flixel.system.FlxPreloader;
	import Playtomic.Log;
    
   public class Preloader extends FlxPreloader
   {
                public var CPMStarAd:AdLoader;

       public static var apiconnector:APIConnector = new APIConnector();
      public function Preloader():void
      {	
        //Presumably MochiAds stuff goes here
        //Playtomic
        //if (stage.loaderInfo.loaderURL.indexOf("Users/Sean") == -1) {
		    Log.View(6451, "d7cfbe258b9247e5", "d828b71e31634baf9fd7f1a1b4d4dc", stage.loaderInfo.loaderURL);
       // }
        Registry.PORTAL_SOURCE = stage.loaderInfo.loaderURL;
        var splitname:Array = new Array();
        splitname = Registry.PORTAL_SOURCE.split("/");
        if (splitname.length > 2) Registry.PORTAL_SOURCE = splitname[2];

         CPMStarAd = new AdLoader("6949Q86E036D7");
        CPMStarAd.x =  240 - 150;
        CPMStarAd.y = 240  - 125;
        addChild( CPMStarAd );
        addEventListener(MouseEvent.CLICK, onClick);
		className = "Main";		  
        super();
      }
        internal function onAPIConnected(event:APIEvent):void {
            if (event.success) {
                trace("NEWGROUNDS API SUCCESS");
               /*addChild(flashAd);
                addChild(flashAd.playButton);
                flashAd.playButton.addEventListener(MouseEvent.CLICK, startGame);
                flashAd.showPlayButton = true;*/
               // flashAd.playButton.addEventListener(MouseEvent.CLICK, clickAdPlay);
            } else {
                trace("Error with NG API: " + event.error);
            }
        }
        
        internal function onClick(event:MouseEvent):void {
            
             Registry.adsDone = true;
            removeEventListener(MouseEvent.CLICK, onClick);
//uh meez ads appear if i removechild hm
            trace("hi");
            //removeChild(CPMStarAd);
            CPMStarAd.y += 4000;
            CPMStarAd.visible = false;
            //CPMStarAd = null;
        }
   }
}