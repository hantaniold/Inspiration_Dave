package fxclasses 
{
	import org.flixel.FlxPoint;
	import org.flixel.FlxSprite;
	import org.flixel.FlxG;
	/**
	 * A class that makes FlxSprite rectangles that have velocities and boundaries and timers and yay
	 * @author seagaia
	 */
	
	public class RectFX extends FlxSprite {
		
		public var timer:Number;
		public var xMax:Number;
		public var yMax:Number;
		public var ix:Number;
		public var iy: Number;
		public var xVelFinal:Number;
		public var yVelFinal:Number;
		public var shouldWait:Boolean;
		public var isHor:Boolean;
		/** 
		 * @param fixed Should this not depend where we are in the screen (defaults to true) 
		 * @param _xMax Within 4 pixels, rectangles will stop moving or start moving from here. Usually this is 0 since sprites have x,y measured from top left.
		 * @param _yMax see xMax
		 * */
		public function RectFX(x:int, y:int,width:int,height:int,color:uint,fixed:Boolean,_xMax:Number=0,_yMax:Number=0) {
			super(x, y);
			ix = x;
			iy = y;
			xMax = _xMax;
			yMax = _yMax;
			shouldWait = true;
			isHor = false;
			makeGraphic(width, height, color);
			if (fixed) {
				scrollFactor = new FlxPoint(0, 0);
			}
			
		}
		
		override public function update():void {
			
			if (Math.abs(x - xMax) < 10 && isHor) {
				velocity.x = 0;
				//velocity.y = -velocity.y;
				x = xMax;
				shouldWait = true;
			}
			
			if (Math.abs(y - yMax) < 10 && !isHor) {
				velocity.y = 0;
				
				//velocity.x = -velocity.x;
				y = yMax;
				shouldWait = true;
			}
			super.update();
		}
		/** Moves the RectFX in from the left, waits for a bit, then moves out. **/
	
		
		public function moveInFrom(_x:int, _y:int, xVelIn:int, yVelIn:int, dir:String):void {
			x = _x; y = _y;
			velocity.x = xVelIn; velocity.y = yVelIn;
			if (dir == "t") {
				isHor = false;
			} else if (dir == "b") {
				isHor = false;
			} else if (dir == "l") {
				isHor = true;
			} else if (dir == "r") {
				isHor = true;
			}
			shouldWait = false;
		}
		
		public function moveOutFrom(dir:String, speed:int):void {
			if (dir == "t" || dir == "b") {
				yMax = -20000;
				velocity.y = speed;
			} else {
				xMax = -20000;
				velocity.x = speed;
			}
		}
		
	}
	
	
	

	

}