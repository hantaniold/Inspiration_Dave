package {
    import flash.events.Event;
    import flash.media.SoundTransform;
    import flash.ui.MouseCursor;
	import org.flixel.FlxBasic;
	import org.flixel.FlxGroup;
	import org.flixel.FlxState;
	import org.flixel.FlxText;
	import org.flixel.FlxSprite;
	import org.flixel.FlxG;
    import flash.ui.Mouse;
	import org.flixel.plugin.photonstorm.FlxBitmapFont;
	import statics.LevelData;
    import Playtomic.Link;
    import Playtomic.Log;
	import entities.WrapSprite;
    import flash.display.MovieClip;
public class Intro extends FlxState {

	[Embed(source = "res/img/intro/seagaia.png")] public var Seagaia:Class;
	[Embed(source = "res/img/intro/bg.png")] public var BG:Class;
	[Embed(source = "res/img/intro/clouds.png")] public var Clouds:Class;
	[Embed(source = "res/img/intro/hills.png")] public var Hills:Class;
	[Embed(source = "res/img/intro/trees.png")] public var Trees:Class;
	[Embed(source = "res/img/intro/pressxbg.png")] public var PressXBG:Class;
	[Embed(source = "res/img/intro/title.png")] public var Title:Class;

    [Embed (source = "sponsorloader.swf")] private var   SwfSymbol:Class;   
//Make sure that MyExportedSymbol base class is MovieClip
    private var movie:MovieClip = new SwfSymbol;
    private var sponsorSplashTimer:Number = 0;
	
	private var state:int = 0;
	private var S_TITLE:int = 3;
    private var S_SPONSOR:int = 44;
	private var timer:Number = 0;
	private var logo:FlxSprite = new FlxSprite(220, 140);
	
	/* Title screen sprites, in draw order.*/
	private var fadeIn:FlxSprite = new FlxSprite(0, 0);
	private var bg:FlxSprite = new FlxSprite(0, 0);
	private var cloud1:WrapSprite = new WrapSprite(0, 0, 640, -40);
	private var cloud2:WrapSprite = new WrapSprite(640, 0, 640, -40);
	private var hills1:WrapSprite = new WrapSprite(0, 140, 640, -80);
	private var hills2:WrapSprite = new WrapSprite(640, 140, 640, -80);
	private var trees1:WrapSprite = new WrapSprite(0, 320, 640, -130);
	private var trees2:WrapSprite = new WrapSprite(640, 320, 640, -130);
	private var titleGroup:FlxGroup = new FlxGroup();
	private var title:FlxSprite = new FlxSprite(170, 10);
	private var pressX:FlxBitmapFont = new FlxBitmapFont(Registry.bigFontBlack, 14, 28, Registry.fontString, 26, 0, 0, 0, 2);
	private var pressXBG:FlxSprite = new FlxSprite(268, 302);
	private var pressXTimer:Number = 0.0;
	private var pressXInterval:Number = 0.5;
	private var exitTimer:Number = 0.0;
	private var beginExit:Boolean = false;
	private var ADV_P:Boolean = false;
    private var notVisitedSponsor:Boolean = true;
	override public function create():void {
		if (Registry.wrongSite) {
			while (1) {
				
			}
		}
		logo.loadGraphic(Seagaia, false, false, 200, 200, false);
		logo.alpha = 1;
        logo.visible = false;
		add(logo);
		bg.loadGraphic(BG, false, false, 640, 480); titleGroup.add(bg);
		cloud1.loadGraphic(Clouds, false, false, 640, 218); titleGroup.add(cloud1);
		cloud2.loadGraphic(Clouds, false, false, 640, 218); titleGroup.add(cloud2);
		hills1.loadGraphic(Hills, false, false, 640, 202); titleGroup.add(hills1);
		hills2.loadGraphic(Hills, false, false, 640, 202); titleGroup.add(hills2);
		trees1.loadGraphic(Trees, false, false, 640, 210); titleGroup.add(trees1);
		trees2.loadGraphic(Trees, false, false, 640, 210); titleGroup.add(trees2);
		pressXBG.loadGraphic(PressXBG);
		titleGroup.add(pressXBG);
		pressX.setText("Press X!", false, 0, 0, "center", true);
		pressX.x = 268 + 10; pressX.y = 302 + 11;
		titleGroup.add(pressX);
		title.loadGraphic(Title, false, false, 300, 96);
		titleGroup.add(title);
		titleGroup.setAll("visible", false);
		add(titleGroup);
		fadeIn.makeGraphic(640, 480, 0xff000000); add(fadeIn); fadeIn.visible = false; fadeIn.alpha = 1;
        FlxG.stage.addChild(movie);
        movie.x = FlxG.width / 2 - (movie.width / 2);
        movie.y = FlxG.height / 2 - (movie.height / 2);
        state = S_SPONSOR;
        Mouse.show();
        Mouse.cursor = MouseCursor.BUTTON;
        
	}
    
    internal function closeSponsorSplash():void {
        logo.visible = true;
		FlxG.play(Note.fx1);
        movie.stop();
        var st:SoundTransform = new SoundTransform(0, 0);
        movie.soundTransform = st;
        movie.visible = false;
        FlxG.stage.removeChild(movie);
        movie = null;
    }
	override public function update():void {
        if (state == S_SPONSOR) {
            if (FlxG.mouse.x > 200 && FlxG.mouse.x < 400) {
                Mouse.cursor = MouseCursor.BUTTON;
            } else {
                Mouse.cursor = MouseCursor.ARROW;
            }
            if (FlxG.mouse.justPressed() && notVisitedSponsor && (Mouse.cursor == MouseCursor.BUTTON)) {
                notVisitedSponsor = false;
                Link.Open(Registry.SPONSOR_SPLASH, "sponsor site splash", "sponsor links");
                Log.LevelCounterMetric("Visited Sponsor In Splash", "Links", true);
                closeSponsorSplash();
                state = 0;
            }
            sponsorSplashTimer += FlxG.elapsed;
            if (sponsorSplashTimer > 6.7) { // or some click condition
                closeSponsorSplash();
                state = 0;
            }  
            return;
        } else {
            
        if (movie != null)
            movie.stop();
        }


		ADV_P = FlxG.keys.justReleased("X")  || FlxG.keys.justReleased("J") || FlxG.keys.justPressed("SPACE") || FlxG.keys.justPressed("ENTER");
		timer += FlxG.elapsed;
		if (state == 0) {
            Mouse.show();
            
            if (FlxG.mouse.x > 200 && FlxG.mouse.x < 400) {
                Mouse.cursor = MouseCursor.BUTTON;
            } else {
                Mouse.cursor = MouseCursor.ARROW;
            }
            if (FlxG.mouse.justPressed() && (Mouse.cursor == MouseCursor.BUTTON)) {
                Log.LevelCounterMetric("Went to twitter (splash)", "Links", false);
				Link.Open("http://twitter.com/seagaia2", "Twitter (splash)", "Links");
            }
			logo.alpha = 1 - (timer / 3);
			if (ADV_P || (timer > 3)) {
                Mouse.hide();
				fadeIn.visible = true;
				titleGroup.setAll("visible", true);
				state = S_TITLE;
				FlxG.play(LevelData.TitleSong,1.0,true);
			}
		} else if (state == S_TITLE) {
			updateTitle();
		}
		super.update();
		return;
	}
	
	public function updateTitle():void {
		if (ADV_P) {
			pressXInterval = 0.1;
			FlxG.play(LevelData.Bloop);
			beginExit = true;
		}
		
		if (beginExit) {
			exitTimer += FlxG.elapsed;
			fadeIn.alpha += 0.02;
			pressXBG.alpha -= 0.02;
			pressX.alpha -= 0.02;		
			FlxG.volume -= 0.01;
			if (exitTimer > 1.5) {
				
				FlxG.switchState(new MainMenuState());
			}
		} else {
			if (fadeIn.alpha > 0) fadeIn.alpha -= 0.02;
		}
		pressXTimer += FlxG.elapsed;
		if (pressXTimer > pressXInterval) {
			pressXTimer = 0;
			pressXBG.visible = !pressXBG.visible;
			pressX.visible = !pressX.visible;
		}
		return;
	}
    
    override public function destroy():void {
        var b:FlxBasic;
        for (var i:int = 0; i < members.length; i++) {
            if (members[i] != null) {
                b = members[i] as FlxBasic;
                b = null;
            }
        }
        super.destroy();
    }
}	
}
