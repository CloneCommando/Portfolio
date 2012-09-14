package
{
	import flash.display.Sprite;
	import flash.events.*;
	import flash.display.StageScaleMode;
	import flash.display.StageAlign;
	import flash.geom.Point;

	public class MultiBilliard2 extends Sprite
	{
		private var balls:Array;
		private var holes:Array;
		private var numBalls:Number = 16; // the total number of balls in the game
		private var bounce:Number = -0.98;
		private var friction:Number = 0.98;
		private var lineXs:Number = 0;
		private var lineYs:Number = 0;
		private var lineXf:Number = 0;
		private var lineYf:Number = 0;
		private var isClicked:Boolean = false;
		private var maxSpeed:Number = 25;//Set the Max velocity of the white ball
		private var numBallsLeft:Number;
		private var hitSound:theSound;
		private var pocketSound:theSound;
		
		public function MultiBilliard2()
		{
			// Set up the sounds to be used
			hitSound = new theSound("billiardhit.mp3");
			pocketSound = new theSound("power_up.mp3");
			pocketSound.setVolume(1);
			hitSound.setVolume(0.1);
			
			init();
		}
		
		private function init():void
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			numBallsLeft = numBalls;
			balls = new Array();
			
			for(var i:uint = 0; i < numBalls; i++)
			{
				/// Ball(index, mass, radius)
				var ball:Ball = new Ball(i, 100, 15);
				
				addChild(ball);
				balls.push(ball);
			}
			
			holes = new Array();
			for(var j:uint = 0; j < 6; j++)
			{
				var hole:Ball = new Ball(j, 0, 25);
				addChild(hole);
				holes.push(hole);
			}
			
			setBallsPosition();
			
			setHolesPosition();
			
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			addEventListener(MouseEvent.MOUSE_DOWN, onClick);
			stage.addEventListener(MouseEvent.MOUSE_UP, OnUp);
		}
		
		public function reset()
		{
			for(var i:Number = 0; i < numBallsLeft; i++)
				removeChild(balls[i]);
			
			removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			removeEventListener(MouseEvent.MOUSE_DOWN, onClick);
			stage.removeEventListener(MouseEvent.MOUSE_UP, OnUp);
			
			init();
		}
		
		
		public function setHolesPosition()//Sets the position of the pockets on the pool table
		{
			
			for(var j:uint = 0; j < 6; j++)
			{
				holes[j].changeColor(0x000000);
			}
			
			holes[0].x = 0;
			holes[0].y = 0;
			
			holes[1].x = stage.stageWidth/2;
			holes[1].y = 0;
			
			holes[2].x = stage.stageWidth;
			holes[2].y = 0;
			
			holes[3].x = 0;
			holes[3].y = stage.stageHeight;
			
			holes[4].x = stage.stageWidth/2;
			holes[4].y = stage.stageHeight;
			
			holes[5].x = stage.stageWidth;
			holes[5].y = stage.stageHeight;
			
		}
		
		public function setBallsPosition()
		{
			for(var i:uint = 0; i < numBalls; i++) // Sets the initial position for all of the balls
			{
				var ball:Ball = balls[i];
				
				switch (i) // Switch for the balls position, probably could have done this a lot neater....
				{
					case 0: ball.x = stage.stageWidth/2 + 125;
							ball.y = stage.stageHeight/2;
							ball.changeColor(0xffffff);
							ball.isWhite = true;
						break;
					
					case 1: ball.x = 205;
							ball.y = 200;
						break;
						
					//Next Group of 2
					case 2: ball.x = 175;
							ball.y = 182;
						break;
						
					case 3: ball.x = 175;
							ball.y = 217;
						break;
						
					//Next Group of 3
					case 4: ball.x = 145;
							ball.y = 200;
						break;
						
					case 5: ball.x = 145;
							ball.y = 235;
						break;
						
					case 6: ball.x = 145;
							ball.y = 165;
						break;
						
					//Next Group of 4
					case 7: ball.x = 115;
							ball.y = 142;
						break;
						
					case 8: ball.x = 115;
							ball.y = 180;
						break;
						
					case 9: ball.x = 115;
							ball.y = 215;
						break;
						
					case 10: ball.x = 115;
							ball.y = 250;
						break;
						
					//Next Group of 5
					
					case 11: ball.x = 85;
							ball.y = 120;
						break;
						
					case 12: ball.x = 85;
							ball.y = 160;
						break;
						
					case 13: ball.x = 85;
							ball.y = 200;
						break;
						
					case 14: ball.x = 85;
							ball.y = 235;
						break;
						
					case 15: ball.x = 85;
							ball.y = 270;
						break;
				}
			}
		}
		
		public function onClick(event:MouseEvent):void
		{
			if(event.target.isWhite == true && balls[0].vx == 0 && balls[0].vy == 0) // Click on the cue ball
			{
				lineXs = mouseX;
				lineYs = mouseY;
				isClicked = true;
				stage.addEventListener(MouseEvent.MOUSE_MOVE, onMyMouseMove);
			}
		}
		
		public function OnUp(event:MouseEvent):void
		{
			if(isClicked == true)
			{
				graphics.clear();
				lineXf = mouseX;
				lineYf = mouseY;
				stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMyMouseMove);
				
				var dx:Number = lineXf - lineXs;
				var dy:Number = lineYf - lineYs;
				var vxMod:Number = 1;
				var vyMod:Number = 1;
				
				if(dx > 0)  // Was line drawn left to right?
				{
					vxMod = -1; //Ball will move left
				}
				else
				{
					vxMod = 1; // Ball will move right
				}
				
				if(dy > 0) //Was line drawn bottom to top?
				{
					vyMod = -1; // Ball will move down
				}
				else
				{
					vyMod = 1; // Ball will move up
				}
				
				if(balls[0].vx == 0 && balls[0].vy == 0)//Makes sure that the white ball is not moving
				{
					balls[0].vx = (1/4) * Math.abs(dx) * vxMod;
					balls[0].vy = (1/4) * Math.abs(dy) * vyMod;
					
					if(Math.abs(balls[0].vx) > maxSpeed) // Set the max velocity in either direction to 50
					{
						balls[0].vx = maxSpeed*vxMod;
					}
					
					if(Math.abs(balls[0].vy) > maxSpeed)
					{
						balls[0].vy = maxSpeed*vyMod;
					}
					
				}
				
				isClicked = false;
			
			}//End If isClicked
			
		}
		
		// Lets us draw the black line that represents the pool cue
		private function onMyMouseMove(event:MouseEvent):void
		{
			graphics.clear();
			graphics.lineStyle(3);
			graphics.moveTo(lineXs, lineYs);
			graphics.lineTo(mouseX, mouseY);
		}
		
		// Runs every frame
		private function onEnterFrame(event:Event):void
		{
			for(var i:uint = 0; i < numBallsLeft; i++)
			{
				var ball:Ball = balls[i];
				
				ball.vx *= friction;
				ball.vy *= friction;
				
				if( Math.round(ball.getSpeed()) < 1 )//Balls slows to a stop
				{
					ball.vx = 0;
					ball.vy = 0;
				}
				
				ball.x += ball.vx;
				ball.y += ball.vy;
				
				if(checkHoles(ball, i))//Colliding with a hole? If so we dont need to check anything else
					return;
					
				if(checkWalls(ball))//Colliding with a wall? If so we dont need to check collision with other ball
					return;
					
				for(var j:Number = 0; j < numBallsLeft; j++)//Colliding with another Ball?
				{
					var ballB:Ball = balls[j];
					
					// Make sure we are not checking ourself
					if(ball.num != ballB.num) 
						checkCollision(ball, ballB);
				}
			}
			
		}
		
		//Check if the ball fell in a hole
		private function checkHoles(theBall:Ball, index:Number):Boolean
		{
			
			for(var j:uint = 0; j < 6; j++) // Loop through all 6 holes and check
			{
				var myHole:Ball = holes[j];
				var distX:Number = theBall.x - myHole.x;
				var distY:Number = theBall.y - myHole.y;
				var dist:Number = Math.sqrt(distX*distX + distY*distY);
				
				if(dist < theBall.radius + myHole.radius)//The ball fell in the hole
				{
					// Remove is from the game
					removeChild(balls[index]); 
					balls.splice(index,1);
					numBallsLeft--;
					
					pocketSound.playSound();
					
					if(theBall.isWhite == true)//White ball fell into hole
					{
						trace("Scratch");
						reset();//restes the game
					}
					if(numBallsLeft == 1)//sunk all the balls
					{
						trace("YOU WIN!");
						reset();//resets the game
					}
					
					return true;
				}
			}//end j for
			
			return false;
		}
		
		// used to check if a ball collides with a wall
		private function checkWalls(ball:Ball):Boolean
		{
			if(ball.x + ball.radius > stage.stageWidth)
			{
				ball.x = stage.stageWidth - ball.radius;
				ball.vx *= bounce;
				return true;
			}
			else if(ball.x - ball.radius < 0)
			{
				ball.x = ball.radius;
				ball.vx *= bounce;
				return true;
			}
			else if(ball.y + ball.radius > stage.stageHeight)
			{
				ball.y = stage.stageHeight - ball.radius;
				ball.vy *= bounce;
				return true;
			}
			else if(ball.y - ball.radius < 0)
			{
				ball.y = ball.radius;
				ball.vy *= bounce;
				return true;
			}
			
			return false;
		}
		
		// does collision detection between two balls
		private function checkCollision(ball0:Ball, ball1:Ball):void
		{
			var dx:Number = ball1.x - ball0.x;
			var dy:Number = ball1.y - ball0.y;
			var dist:Number = Math.sqrt(dx*dx + dy*dy);
			
			if(dist < ball0.radius + ball1.radius)
			{
				// calculate angle, sine and cosine
				var angle:Number = Math.atan2(dy, dx);
				var sin:Number = Math.sin(angle);
				var cos:Number = Math.cos(angle);
				
				// rotate ball0's position
				var pos0:Point = new Point(0, 0);
				
				// rotate ball1's position
				var pos1:Point = rotate(dx, dy, sin, cos, true);
				
				// rotate ball0's velocity
				var vel0:Point = rotate(ball0.vx,
										ball0.vy,
										sin,
										cos,
										true);
				
				// rotate ball1's velocity
				var vel1:Point = rotate(ball1.vx,
										ball1.vy,
										sin,
										cos,
										true);
				
				// collision reaction
				var vxTotal:Number = vel0.x - vel1.x;
				vel0.x = ((ball0.mass - ball1.mass) * vel0.x + 
				          2 * ball1.mass * vel1.x) / 
				          (ball0.mass + ball1.mass);
				vel1.x = vxTotal + vel0.x;

				// update position
				var absV:Number = Math.abs(vel0.x) + Math.abs(vel1.x);
				var overlap:Number = (ball0.radius + ball1.radius) 
				                      - Math.abs(pos0.x - pos1.x);
				pos0.x += vel0.x / absV * overlap;
				pos1.x += vel1.x / absV * overlap;
				
				// rotate positions back
				var pos0F:Object = rotate(pos0.x,
										  pos0.y,
										  sin,
										  cos,
										  false);
										  
				var pos1F:Object = rotate(pos1.x,
										  pos1.y,
										  sin,
										  cos,
										  false);

				// adjust positions to actual screen positions
				ball1.x = ball0.x + pos1F.x;
				ball1.y = ball0.y + pos1F.y;
				ball0.x = ball0.x + pos0F.x;
				ball0.y = ball0.y + pos0F.y;
				
				// rotate velocities back
				var vel0F:Object = rotate(vel0.x,
										  vel0.y,
										  sin,
										  cos,
										  false);
				var vel1F:Object = rotate(vel1.x,
										  vel1.y,
										  sin,
										  cos,
										  false);
				ball0.vx = vel0F.x;
				ball0.vy = vel0F.y;
				ball1.vx = vel1F.x;
				ball1.vy = vel1F.y;
				
				// play sound of balls hitting, after all calculations are done
				if(dist - 1.0 < ball0.radius + ball1.radius) // Fixes bug of sound playing when balls are barely touching
					hitSound.playSound();
			}
		}
		
		private function rotate(x:Number,
								y:Number,
								sin:Number,
								cos:Number,
								reverse:Boolean):Point
		{
			var result:Point = new Point();
			if(reverse)
			{
				result.x = x * cos + y * sin;
				result.y = y * cos - x * sin;
			}
			else
			{
				result.x = x * cos - y * sin;
				result.y = y * cos + x * sin;
			}
			return result;
		}		
	}
}