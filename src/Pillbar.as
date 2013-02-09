package {

import org.flixel.FlxSprite;
import org.flixel.FlxG;
import org.flixel.FlxSound;
public class Pillbar extends FlxSprite {
	public var timeToFull:Number = 12; //time in sec for bar to empty
	public var timeElapsed:Number = 0; //time since last pill
	public var maxScale:Number = 320;
	public var dangerSound:FlxSound = new FlxSound();
	[Embed(source="res/mp3/closetodeath.mp3")] public var Danger:Class;
	
	public function Pillbar() {
		super(160,10);
		dangerSound.loadEmbedded(Danger,false);
		dangerSound.alive = false;
		makeGraphic(1,16,0x88FF0000);
		scale.x = 20;
		origin.x = origin.y = 0;
	}

	public function pillGet():void {
		dangerSound.volume = 0;
		dangerSound.alive = false;
		scale.x = 1;
		timeElapsed = 0;
	}

	override public function update():void {
		timeElapsed += FlxG.elapsed;
		if (scale.x <= 320)
			scale.x = maxScale * (timeElapsed/timeToFull);
		if (!dangerSound.alive && (timeToFull - timeElapsed < 6.5)) {
			dangerSound.volume = 1;
			dangerSound.alive = true;
			dangerSound.play();
		}
	}
}

}
