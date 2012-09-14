package 
{
    import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.geom.*;

    public class GhramScan extends Sprite
	{
		
		private var points:Array;
		private var myStack:Array;
		private var numBalls:Number;
		private var bounce:Number = -1.0;
		
		public function GhramScan() 
		{
           init();
		   stage.addEventListener(KeyboardEvent.KEY_DOWN,keyDownHandler);
		   addEventListener(Event.ENTER_FRAME, onEnterFrame);
        }
		
		public function init()
		{
			points = new Array();
			numBalls = 6;
			
			//Add the balls to the screen
			for(var i:uint = 0; i < numBalls; i++)
			{
				var ball = new Ball(4,0x003366);
				ball.x = i * 100
				ball.y = i * 50;
				ball.vx = Math.random() * 10 - 5;
				ball.vy = Math.random() * 10 - 5;
				
				//Makes sure the velocity is not zero
				if(ball.vx == 0) ball.vx = 5;
				if(ball.vy == 0) ball.vy = -5;
				addChild(ball);
				points.push(ball);
			}
		}
		
		//Uses Graham Scan Algorithm to figure out which points make up the convex hull
		private function SortStack()
		{
			myStack = new Array();
			findPivot();
			sortAngle();
			
			myStack.push(points[0]);
			myStack.push(points[1]);
			
			for(var i:uint = 2; i < points.length; i++)
			{
				while(myStack.length >= 2 && crossProduct(myStack[myStack.length-2],myStack[myStack.length-1],points[i]) <= 0)
				{
					myStack.pop();
				}
				
				myStack.push(points[i]);
			}
		}
		
		//Finds and sorts the points by the angle they make with the pivot point, smallest first
		private function sortAngle()
		{
			var angle:Number = 0;
			var pivot:Ball = points[0];
			
			for(var i:uint = 1; i < points.length; i++)
			{
				angle = Math.atan2(points[i].y - pivot.y, points[i].x - pivot.x);
				points[i].angleP = angle;
			}
			bubbleSort();
		}
		
		//Yes I know bubble sorts are evil
		private function bubbleSort()
		{
			var finished:Boolean = false;
			while(finished == false)
			{
				finished = true;//Pretend it is done
				
				for(var i:uint = 1; i < points.length-1; i++)
				{
					if(points[i+1].angleP < points[i].angleP)
					{
						var temp:Ball = points[i];
						points[i] = points[i + 1];
						points[i + 1] = temp;
						finished = false;//If it needed to switch the points it is not done sorting
					}
					else if(points[i+1].angleP == points[i].angleP)//If the angles are the same
					{
						//Find which one is further away from he pivot point
						var dx1:Number = points[i].x - points[0].x;
						var dy1:Number = points[i].y - points[0].y;
						var dx2:Number = points[i+1].x - points[0].x;
						var dy2:Number = points[i+1].y - points[0].y;
						
						var dist1 = dx1*dx1 + dy1*dy1;
						var dist2 = dx2*dx2 + dy2*dy2;
						
						if(dist2 < dist1)//If the second point is closer
						{
							var temp2:Ball = points[i];
							points[i] = points[i + 1];
							points[i + 1] = temp;
							finished = false;//If it needed to switch the points it is not done sorting
						}
					}
				}
			}
		}
		
		//Finds the pivot point
		private function findPivot()
        {
            var lowestBall:Ball = points[0];    //Changed to find the lowest because of Flash coordinate system
            var num:Number;
            var temp:Ball;
            
            for(var i:uint = 1; i < points.length; i++)
            {
                var ball:Ball = points[i];
                if(lowestBall.y > ball.y)
                {
                    lowestBall = ball;
                    num = i;
                }
                else if(lowestBall.y == ball.y)
                {
                    if(lowestBall.x > ball.x)
                    {
                        lowestBall = ball;
                         num = i;
                    }
                }
            }
			
			//Switches the position of the Pivot Point to the front of the array
			temp = points[0];
			points[0] = lowestBall;
			points[num] = temp;
		}
		
		private function crossProduct(p1:Ball,p2:Ball,p3:Ball)
		{
			return(p2.x - p1.x)*(p3.y - p1.y) - (p3.x - p1.x)*(p2.y - p1.y);
		}
		
		// allows the balls to bounce off of the wall
		private function checkWalls(ball:Ball):void
		{
			if(ball.x + ball.radius > stage.stageWidth)
			{
				ball.x = stage.stageWidth - ball.radius;
				ball.vx *= bounce;
			}
			else if(ball.x - ball.radius < 0)
			{
				ball.x = ball.radius;
				ball.vx *= bounce;
			}
			if(ball.y + ball.radius > stage.stageHeight)
			{
				ball.y = stage.stageHeight - ball.radius;
				ball.vy *= bounce;
			}
			else if(ball.y - ball.radius < 0)
			{
				ball.y = ball.radius;
				ball.vy *= bounce;
			}
		}
		
		private function onEnterFrame(event:Event):void
		{
			//Collision Detection for the Balls
			for(var i:uint = 0; i < points.length; i++)
			{
				var ball:Ball = points[i];
				ball.x += ball.vx;
				ball.y += ball.vy;
				checkWalls(ball);
			}
			
			SortStack();
			
			//Draws the Convex Hull
			graphics.clear();
			graphics.lineStyle(1);
			graphics.moveTo(myStack[0].x,myStack[0].y);
			
			for(var j:uint = 1; j < myStack.length; j++)
			{
				graphics.lineTo(myStack[j].x,myStack[j].y);
			}
			
			graphics.lineTo(myStack[0].x,myStack[0].y);
		}
		
		
		private function keyDownHandler(event:KeyboardEvent) 
		{
			if (event.keyCode== Keyboard.UP)//Add a new ball, when the up arrow is pressed
			{
				if(numBalls <= 30)//Can only have a max of 30 balls on the screen
				{
					numBalls++;
					
					var ball:Ball = new Ball(4,0x003366);
					ball.x = Math.random() * 200 + 50;
					ball.y = Math.random() * 200 + 50;
					ball.vx = Math.random() * 10 - 5;
					ball.vy = Math.random() * 10 - 5;
					
					//Makes sure the velocity is not zero
					if(ball.vx == 0) ball.vx = 5;
					if(ball.vy == 0) ball.vy = -5;
					
					addChild(ball);
					points.push(ball);
				}
			}
			else if(event.keyCode== Keyboard.DOWN)//Take away one of the balls, when the down arrow is pressed
			{
				if(numBalls > 2)//Need to have atleast 2 balls on screen
				{
					numBalls--;
					var tempBall:Ball = points.pop();
					tempBall.visible = false;
				}
			}
		}
        
    }
}
