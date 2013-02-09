package 
{
    import com.newgrounds.components.FlashAd;
	import flash.display.Sprite;
	import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.ui.Mouse;
	import Playtomic.Log;  
    import com.newgrounds.*;

	[SWF(width="640", height="480", backgroundColor="#000000")]
	[Frame(factoryClass = "Preloader")]
	public class Main extends Sprite
	{
		public function Main():void
		{	    
			if (stage) {
				init();
			} else {
				addEventListener(Event.ADDED_TO_STAGE, init);
			}
		}
		
		private function init(event:Event=null):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
            /* UNCOMMENT FOR  KONGREGATE * 
            QuickKong.connectToKong(stage); */
            //NG API stuff 
                
            //DECOMMENT ONLY FOR MOCHI-ADS FOR NEWGROUNDS
           // API.connect(root, "", "");
            
            API.addEventListener(APIEvent.MEDAL_UNLOCKED, onMedalUnlocked);
            var game:InspirationDave = new InspirationDave;
            addChild(game);
		}
    
  
        
        internal function onMedalUnlocked(event:APIEvent):void {
            if (event.success) {
                var medal:Medal = Medal(event.data);
                trace("Got medal: " + medal.name);
            } else {
                trace("Medal unlock failed: " + event.error);
            }
        }
	}

}
