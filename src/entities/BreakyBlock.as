package entities 
{
	import org.flixel.FlxSprite;
	import org.flixel.FlxG;
	public class BreakyBlock  extends FlxSprite
	{
		[Embed(source = "../res/img/sprites/breakyblock.png")] public static var BreakyBlockSprite:Class;
		public var broken:Boolean = false;
		private var interval:Number = 0.2;
		private var timer:Number = 0;
		public function BreakyBlock(_x:int, _y:int) 
		{
			super(_x, _y);
			immovable = true;
			loadGraphic(BreakyBlockSprite, true, false, 16, 16);
			
		}
		
		override public function update():void {
			
			if (broken) {
				timer += FlxG.elapsed;
				if (timer > interval) {
					timer = 0;
					frame = (frame + 1) % 4;
					if (frame == 0) {
						visible = false;
						solid = false;
						broken = false;
					}
				}
			}
			
			if (!solid) {
				timer += FlxG.elapsed;
				if (timer > 1) {
					timer = 0;
					solid = true;
					visible = true;
					
				}
			}
			super.update();
		}
		
	}

}