package  
{
    import com.newgrounds.*;
    import com.newgrounds.components.*;
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.MovieClip;
    import Playtomic.Log;

    public class Preloader extends MovieClip
    {
        [Embed (source = "res/img/bg/preloaderBG.png")] public var PreBG:Class;
        public function Preloader() 
        {
            var bg:Bitmap = new PreBG();
            addChild(bg);
            var apiConnector:APIConnector = new APIConnector();
            apiConnector.className = "Main";
        apiConnector.encryptionKey = "pSq086W6dxYxOTuKvbTRFzjj0tHypqOR";
        apiConnector.apiId = "24202:EUFh65az";
//        apiConnector.redirectOnHostBlocked = true;
            addChild(apiConnector);
            
        if (stage.loaderInfo.loaderURL.indexOf("Users/Sean") == -1) {
		    Log.View(6451, "d7cfbe258b9247e5", "d828b71e31634baf9fd7f1a1b4d4dc", stage.loaderInfo.loaderURL);
        }

            // center connector on screen
            if(stage)
            {   
                
                apiConnector.x = (stage.stageWidth - apiConnector.width) / 2;
                apiConnector.y = (stage.stageHeight - apiConnector.height) / 2;
            }
        }    
    }
}