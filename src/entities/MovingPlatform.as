package entities 
{
	import org.flixel.FlxSprite;
	/**
	 * ...
	 * @author seaga
	 */
	public class MovingPlatform extends FlxSprite
	{
		[Embed (source = "../res/img/sprites/movingplatform.png")] public var MovingPlatforms:Class;
		private var direction:String = ""; 
		public var isMoving:Boolean = false;
		private var speed:int;
		private var ix:int;
		private var iy:int;
		public function MovingPlatform(_direction:String,_speed:int,_x:int,_y:int) 
		{
			super(_x, _y);
			immovable = true;
			loadGraphic(MovingPlatforms, false, false, 48, 16);
			direction = _direction;
			speed = _speed;
			ix = _x;
			iy = _y;
		}
		
		override public function update():void {
			super.update();
		}
		
		public function startMoving():void {
			
			if (direction == "LEFT") {
				velocity.x = -speed;
			} else if (direction == "DOWN") {
				velocity.y = speed;
			} else if (direction == "RIGHT") {
				velocity.x = speed;
			} else if (direction == "UP") {
				velocity.y = -speed;
			}
			isMoving = true;
		}
		
		public function resetStage():void {
			x = ix;
			y = iy;
			velocity.x = velocity.y = 0;
			return;
		}
	}

}