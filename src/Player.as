package {
	
import org.flixel.FlxG;

import org.flixel.FlxSprite;
import org.flixel.FlxText;
import org.flixel.FlxPoint;

import org.flixel.FlxObject;

import org.flixel.FlxSound;

public class Player extends FlxSprite
{
	[Embed(source = "res/img/sprites/player2.png")] public static var PlayerSprite:Class;	
	[Embed(source = "res/img/sprites/player.png")] public static var OldPlayer:Class;
	[Embed(source="res/mp3/deathsound.mp3")] public static var DeathSound:Class;
	[Embed(source="res/mp3/jumpdown.mp3")] public static var JumpSound:Class;
	[Embed(source="res/mp3/jumpup.mp3")] public static var LandSound:Class;
	public var state:int = 0; //Normal state. 1 = death
	public var jumpState:int = 0; //1 = has jumped once
	public var playedJump:Boolean = false;
	public var jumpTimer:Number = 0.0;
	public var deathJingle:FlxSound = new FlxSound();
	public var deathSound:FlxSound = new FlxSound();
	public var debugText:FlxText = new FlxText(0,150,300);
	public var currentDirection:int = 1;
	public var demBloodColors:Array = new Array(0xfff30e0e, 0xffaaFF00, 0xff33DDDD, 0xff00AABB);
	
	public var playerTrailSprites:Array = new Array(new FlxSprite(0, 0), new FlxSprite(0, 0), new FlxSprite(0, 0), new FlxSprite(0,0), new FlxSprite(0,0) );
	private var trailTimer:int = 0;
	private var S_STILL:int = 0;
	private var S_WALK:int = 1;
	private var S_AIR_WALK:int = 2;
	private var S_AIR_WALK_DRAG:int = 3;
	private var S_AIR_RUN:int = 4;
	private var S_AIR_RUN_DRAG:int = 5;
	private var S_RUN_R:int = 6;
	private var S_RUN_L:int = 7;
	private var walkState:int = 0;
	
	private var ACCEL:int = 50;
	private var MAX_X_VEL:int = 210;
	private var WALK_VEL:int = 100;
	private var RUN_VEL:int = 160;
	private var AIR_DRAG:int = 400;
	
	
	private var LEFT_P:Boolean = false;
	private var RIGHT_P:Boolean = false;
	private var JUMP_P:Boolean = false;
	private var RUN_P:Boolean = false;
	
	public function Player() {
		super();
		if (Registry.secretsState[4]) {
			loadGraphic(OldPlayer, true, false, 15, 30, false);
		} else {
			loadGraphic(PlayerSprite, true, true, 15, 30);
		}
		height = 27;  offset.y = 3;
		width = 12;
		//addAnimation("walk",[1,2],5);
		addAnimation("walk", [1, 2, 3, 4, 5, 6, 7, 8, 9, 10], 8, true);
		addAnimation("stop", [0], 5);
		addAnimation("run", [1,2,3,4,5,6,7,8,9,10], 10);
		addAnimation("jump", [11, 12, 13, 14, 15], 10, false);
		addAnimation("fall", [15, 16, 17,16], 10, false);
		deathSound.loadEmbedded(DeathSound,false);
		maxVelocity.y = 250;
		velocity.y = 100;
		acceleration.y = 650;
		maxVelocity.x = MAX_X_VEL;
		debugText.scrollFactor = new FlxPoint(0, 0);
		debugText.x = 0;
		debugText.y = 470;
		var bob:FlxSprite = new FlxSprite(0, 0);
		
	
		
		if (Registry.secretsState[2]) {
			extendTrail();
		}
		for (var i:int = 0; i < playerTrailSprites.length; i++) {
			if (Registry.secretsState[4]) {
				playerTrailSprites[i].loadGraphic(OldPlayer, true, true, 15, 30);
			} else {
				playerTrailSprites[i].loadGraphic(PlayerSprite, true, true, 15, 30);
			}
			playerTrailSprites[i].offset.y = 3;
			playerTrailSprites[i].visible = false;
		}
	}

	override public function update():void {
		
		//debugText.text = "vx " + velocity.x.toString();
		
		if (state == 2) {
			scale.x = 1;
			return;
		
		} else if (state == 1) {
			super.update();
		} else if (state == 0){ 
			normal();
		
		} 	
	}


	public function normal():void {
		//trace(velocity.x);
		
		LEFT_P = (FlxG.keys.LEFT || FlxG.keys.A);
		RIGHT_P = (FlxG.keys.RIGHT || FlxG.keys.D);
		JUMP_P = (FlxG.keys.X || FlxG.keys.J || FlxG.keys.UP || FlxG.keys.SPACE || FlxG.keys.W);
		RUN_P = (FlxG.keys.Z || FlxG.keys.K);
        if (FlxG.keys.justPressed("SHIFT")) {
             Registry.GLOBAL_SPRINT = !Registry.GLOBAL_SPRINT;
             if (Registry.GLOBAL_SPRINT == false) {
                for (var eh:int = 0; eh < playerTrailSprites.length; eh++) {
                    playerTrailSprites[eh].visible = false;
                    }

             }
        }
        if (Registry.GLOBAL_SPRINT) RUN_P = true;
		
		if (jumpState == 1) { /* Have jumped, still holding down X. */
			jumpTimer += FlxG.elapsed;
			if (isTouching(FlxObject.FLOOR)) {
				jumpState = 0;	
				jumpTimer = 0;
			}
		    if ((jumpTimer > 1.0) || !JUMP_P) {
				velocity.y *= 0.5;
				jumpState = 2;
			}
		} else if (JUMP_P && (jumpState == 0) && isTouching(FlxObject.FLOOR)) { /* On ground */
			velocity.y = -300;
			jumpState = 1;
			FlxG.play(JumpSound,0.5);
		} else if (jumpState == 2) { /* Let go of X and or held it down too long */
			if (isTouching(FlxObject.FLOOR)) {
				jumpTimer = 0;
				jumpState = 0;
				FlxG.play(LandSound,0.5);
			}
		} 
	
		calculateXVel();
		
		//Toggle spinny jump
		if (Registry.secretsState[1]) {
			if (isTouching(FlxObject.FLOOR)) {
				angularVelocity = 0; angle = 0;
			} else {
				angularVelocity = 800;
			}
		}
		
		
		if (LEFT_P) {
			scale.x = -1; currentDirection = -1;
		} else if (RIGHT_P) {
			scale.x = 1; currentDirection = 1;
		}
		
		/** Some outer-level logic for the "trail" **/
		
		
		if (RUN_P || Registry.GLOBAL_SPRINT) {
			doTrail(3,playerTrailSprites);
		} 
		if (FlxG.keys.justPressed("Z") || FlxG.keys.justPressed("K") || (FlxG.keys.justPressed("SHIFT") && Registry.GLOBAL_SPRINT)) { //want sprites to appear at new positions, so make em visible after doTrail()
			for (var k:int = 0; k < playerTrailSprites.length; k++) {
				playerTrailSprites[k].visible = true;
				playerTrailSprites[k].x = x;
				playerTrailSprites[k].y = y;
			}
		}
		if ((FlxG.keys.justReleased("Z") || FlxG.keys.justReleased("K")) && !Registry.GLOBAL_SPRINT) {
			for (var d:int = 0; d < playerTrailSprites.length; d++) {
				playerTrailSprites[d].visible = false;	
			}
		}
		
		
		
		/* Choose what animation to play */
		
		if (!isTouching(FlxObject.FLOOR)) {
			if (!playedJump && velocity.y < 0) {
				play("jump"); 
				playedJump = true;
			}
			if (velocity.y > 0) {
				play("fall");
				playedJump = false;
			}
			
			
		} else {
			if (Math.abs(velocity.x) < WALK_VEL)
				play("stop");
			else if (Math.abs(velocity.x) < WALK_VEL + 5) 
				play("walk");
			else {
				play("run");
			}
		}
		if (currentDirection == 1)
			scale.x = 1;
		else 
			scale.x = -1;
	}

	/* @a The array of FlxSprite to be a shadowy magic trail
	 * @freq Frequency (integer) - i.e. how far apart the trail will be */
	public function doTrail(freq:int, a:Array):void {
	
		
		var index:int = (trailTimer % (a.length * freq)) / freq; /* get an index into the array based on the freq */
		if (trailTimer % freq == 0) {
			a[index].x = x;
			a[index].y = y;
			a[index].frame = frame;
			a[index].scale.x = scale.x;
			
			if (a.length <= 5) {
				a[index].alpha = 0.05 + 0.07 * index; 
			} else {
				a[index].alpha = 0.1 + 0.01 * index;
			}
		}
		
		trailTimer += 1;
	}
	
	public function calculateXVel():void {
		//trace(velocity.x);
		switch (walkState) {
		case S_STILL:
			//trace("still");
			acceleration.x = 0;
			velocity.x = 0;
			if (LEFT_P) {
				velocity.x = -WALK_VEL;
				walkState = S_WALK;
			} else if (RIGHT_P) {
				velocity.x = WALK_VEL;
				walkState = S_WALK;
			}
			break;
		case S_WALK:
			//trace("walk");
			acceleration.x = 0;
			if (RUN_P && LEFT_P) {
				walkState = S_RUN_L;
				break;
			} else if (RUN_P && RIGHT_P) {
				walkState = S_RUN_R;
				break;
			}
			if (!LEFT_P && !RIGHT_P) {
				velocity.x = 0;
				walkState = S_STILL;
			} else if (LEFT_P) {
				velocity.x = -WALK_VEL; 
			} else if (RIGHT_P) {
				velocity.x = WALK_VEL; 

			}
			if (jumpState > 0) {
				walkState = S_AIR_WALK;
				
			}
			break;
		case S_AIR_WALK:
			//trace("air walk");
			if (isTouching(FlxObject.FLOOR)) {
				walkState = S_WALK;
			} else if (!LEFT_P && !RIGHT_P) {
				
				walkState = S_AIR_WALK_DRAG;
			} else if (LEFT_P) {
				acceleration.x = -50;
				if (velocity.x > 0) { velocity.x = -WALK_VEL/2; } 
				else { velocity.x = -WALK_VEL; }
				
			} else if (RIGHT_P) {
				acceleration.x = 50;
				if (velocity.x < 0) { velocity.x = WALK_VEL/2; }
				else { velocity.x = WALK_VEL; }
			}
			break;
		case S_AIR_WALK_DRAG: 
			//trace("air walk drag");
			if (LEFT_P || RIGHT_P) {
				acceleration.x = 0;
				walkState = S_AIR_WALK;
			} else if (isTouching(FlxObject.FLOOR)) {
				acceleration.x = 0;
				walkState = S_WALK;
			} else {
				if (currentDirection == -1 && velocity.x > 0) {
					velocity.x = 0;
					acceleration.x = 0;
				} else if (currentDirection == 1 && velocity.x <= 0) {
					velocity.x = 0;
					acceleration.x = 0;
				} else {
					acceleration.x = -currentDirection * AIR_DRAG * 2;
				}
			}
			break;
		case S_RUN_R:
			//trace("run r");
		//	trace(velocity.x);
			velocity.x = Math.max(velocity.x, RUN_VEL);
			if (!RUN_P) {
				walkState = S_WALK;
				break;
			}
			if (!RIGHT_P && !LEFT_P) {
				walkState = S_STILL;
				break;
			}
			if (!RIGHT_P && LEFT_P) {
				walkState = S_RUN_L;
				velocity.x = -RUN_VEL;
				acceleration.x = -ACCEL;
				break;
			}
			if (jumpState > 0) {
				walkState = S_AIR_RUN;
				break;
			}
			acceleration.x = ACCEL;
			velocity.x = Math.min(MAX_X_VEL, velocity.x);
			break;
		case S_RUN_L:
			//trace("run l");
			velocity.x = Math.min(velocity.x, -RUN_VEL);
			if (!RUN_P) {
				walkState = S_WALK;
				break;
			}
			if (!RIGHT_P && !LEFT_P) {
				walkState = S_STILL;
				break;
			}
			if (RIGHT_P && !LEFT_P) {
				walkState = S_RUN_R;
				velocity.x = RUN_VEL;
				acceleration.x = ACCEL;
			}
			if (jumpState > 0) {
				walkState = S_AIR_RUN;
				break;
			}
			acceleration.x = -ACCEL;
			
			velocity.x = Math.max( -MAX_X_VEL, velocity.x);
			break;
		case S_AIR_RUN:
			//trace("air run");
			if (velocity.x == 0) velocity.x = currentDirection * RUN_VEL;
			if (velocity.x < 0) {
				velocity.x = Math.max(-MAX_X_VEL,velocity.x) 
			} else {
				velocity.x = Math.min(MAX_X_VEL, velocity.x);
			}
			if (!LEFT_P && !RIGHT_P) {
				walkState = S_AIR_RUN_DRAG;
				acceleration.x = 0;
				break;
			}
			
			if (RIGHT_P && LEFT_P) {
				break;
			}
			if (velocity.x < 0 && RIGHT_P) {
				velocity.x = -80;
				velocity.x *= -1;
				acceleration.x = 200;
			} else if (velocity.x > 0 && LEFT_P) {
				velocity.x = 80;
				velocity.x *= -1;
				acceleration.x = -200;
			}
			if (RUN_P) {
				if (isTouching(FlxObject.FLOOR)) {
					if (velocity.x < 0) {
						walkState = S_RUN_L;
						break;
					} else {
						walkState = S_RUN_R;
						break;
					}
				}
			} else {
				if (isTouching(FlxObject.FLOOR)) {
					walkState = S_WALK;
					break;
				}
			}
			break;
		case S_AIR_RUN_DRAG:
			//trace("air run drag");
			if (isTouching(FlxObject.FLOOR)) {
				walkState = S_STILL;
				break;
			}
			if (Math.abs(velocity.x) <= WALK_VEL) {
				walkState = S_AIR_WALK_DRAG;
				break;
			}
			if (LEFT_P || RIGHT_P) {
				walkState = S_AIR_RUN;
				break;
			}
			
			if (currentDirection == -1 && velocity.x > 0) {
				velocity.x = 0;
				acceleration.x = 0;
			} else if (currentDirection == 1 && velocity.x < 0) {
				velocity.x = 0;
				acceleration.x = 0;
			} else {
				acceleration.x = currentDirection * -AIR_DRAG;
			}
			
			break;
		}
	}
	/* called when restarting a stage after death - changes the physics back to default */
	public function resetAfterDeath():void {
		maxVelocity.y = 250;
		velocity.y = 100;
		acceleration.y = 650;
		maxVelocity.x = MAX_X_VEL;
		state = 0;
		angularAcceleration = 0;
		angularVelocity = 0;
		angle = 0;
		visible = true;
		return;
	}
	
	public function extendTrail():void {
		if (playerTrailSprites.length >= 50) return;
		for (var i:int = 0; i < 45; i++) {
			playerTrailSprites.push(new FlxSprite(0, 0));
			playerTrailSprites[i+5].loadGraphic(PlayerSprite, true, true, 15, 30);
			playerTrailSprites[i+5].offset.y = 3;
			playerTrailSprites[i+5].visible = false;
		}
	}

}

}
