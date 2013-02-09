package {
    import flash.display.Bitmap;
    import flash.display.DisplayObject;
    import flash.display.MovieClip;
    import flash.events.IOErrorEvent;
    import flash.utils.getDefinitionByName;

    import mochi.as3.*;
    import Playtomic.Log;

/* USE THIS PRELAODER FOR MOCHI ADS ADD MEDALS OR SOMETHING FCUCKC UWEC*/

    // Must be dynamic!
    public dynamic class Preloader extends MovieClip {
        // Keep track to see if an ad loaded or not
        private var did_load:Boolean;

        // Change this class name to your main class
        public static var MAIN_CLASS:String = "Main";

        [Embed (source = "res/img/bg/preloaderBG.png")] public var PreBG:Class;
        // Substitute these for what's in the MochiAd code
        public static var GAME_OPTIONS:Object = {id: "15b51a6ff4a27288", res:"320x480", background:0x2AB9AF, color:0x11115F, outline:0x000000, no_bg:true};

        public function Preloader() {
            super();

            var f:Function = function(ev:IOErrorEvent):void {
                // Ignore event to prevent unhandled error exception
            }
            loaderInfo.addEventListener(IOErrorEvent.IO_ERROR, f);

            var bg:Bitmap = new PreBG();
            addChild(bg);
            var opts:Object = {};
            for (var k:String in GAME_OPTIONS) {
                opts[k] = GAME_OPTIONS[k];
            }

            opts.ad_started = function ():void {
                did_load = true;
            }

            opts.ad_finished = function ():void {
                // don't directly reference the class, otherwise it will be
                // loaded before the preloader can begin
                
                if (stage.loaderInfo.loaderURL.indexOf("Users/Sean") == -1) {
                    Log.View(6451, "d7cfbe258b9247e5", "d828b71e31634baf9fd7f1a1b4d4dc", stage.loaderInfo.loaderURL);
                }
                var mainClass:Class = Class(getDefinitionByName(MAIN_CLASS));
                var app:Object = new mainClass();
                addChild(app as DisplayObject);
            }

            opts.clip = this;
            //opts.skip = true;


        
            MochiAd.showPreGameAd(opts);
        }


    }

}