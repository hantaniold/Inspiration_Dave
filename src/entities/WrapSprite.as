package entities 
{
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.FlxG;
	public class WrapSprite extends FlxSprite
	{
		
		public var myWidth:int;
	
		public function WrapSprite(_x:int, _y:int, _myWidth:int,xvel:int,isFixed:Boolean = true) 
		{
			x = _x;
			y = _y;
			myWidth = _myWidth;
			velocity.x = xvel;
			if (isFixed) {
				scrollFactor = new FlxPoint(0, 0);
			}
		}
		
		override public function update():void {
			if (x < -myWidth) x = myWidth;
			super.update();
		}
		
	}

}