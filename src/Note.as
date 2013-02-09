package {

import org.flixel.FlxSprite;
import org.flixel.FlxG;
public class Note extends FlxSprite{

	[Embed(source="res/img/sprites/notes.png")] public static var NoteSprites:Class;
	[Embed(source="res/mp3/notefx1.mp3")] public static var fx1:Class;
	[Embed(source="res/mp3/notefx2.mp3")] public var fx2:Class;
	[Embed(source="res/mp3/notefx3.mp3")] public var fx3:Class;
	[Embed(source="res/mp3/notefx4.mp3")] public var fx4:Class;
	[Embed(source="res/mp3/notefx5.mp3")] public var fx5:Class;
	public var fxArray:Array = new Array(fx1,fx2,fx3,fx4,fx5);
	public var id:int = -1;

	public function Note(_x:int, _y:int,_id:int) {
		super();
		x = 16*_x;
		y = 16*_y;	
		id = _id;

	//randomly pick what note to look like
		loadGraphic(NoteSprites,true,true,16,16);
		addAnimation("note",[int(Math.random() * 4)]);
		play("note");
	}

	public function getCollected():void {
//update note count for a stage
		FlxG.play(fxArray[int(Math.random() * 5)],0.5);
		exists = false;
		//kill();
	}

}
}
