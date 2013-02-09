package {
//pill class. getting one of these...activates the timer for 
//anxiety or whatever.
import org.flixel.FlxSprite;
import org.flixel.FlxG;
public class Pill extends FlxSprite {

	[Embed(source="res/mp3/pill.mp3")] public static var PillSound:Class;
	[Embed(source="res/img/sprites/meds.png")] public static var PillSprites:Class;
	public function Pill(_x:int, _y:int) {
		super();
		x = _x;
		y = _y;
		loadGraphic(PillSprites,true,true,16,16);
		addAnimation("pill",[0,1,2,3,4,5],4);
		play("pill");

	}

	public function getCollected():void {
		FlxG.shake(0.003);
		FlxG.play(PillSound,0.5);
		//Sets the timer on the bar thing. 
		//player polls the bar to change movement or detect death orw hatever
		exists = false;
		//kill();
	}
}
}
