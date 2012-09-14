package {
	import flash.display.Sprite;
	
	public class Ball extends Sprite {
		public var radius:Number;
		private var color:uint;
		public var vx:Number = 0;
		public var vy:Number = 0;
		public var mass:Number;
		public var isWhite:Boolean = false;
		public var num:Number;
		
		public function Ball(num:Number, mass:Number = 1, radius:Number=40, color:uint=0xff0000) 
		{
			if(radius <= 0)
				radius = 1;
				
			this.radius = radius;
			
			if(mass < 0)
				mass = 0;
			
			this.mass = mass;
			this.num = num;
			this.color = Math.round(Math.random()*0xffffff + 2);
			vx = 0;
			vy = 0;
			init();
		}
		
		public function init():void 
		{
			graphics.beginFill(color);
			graphics.drawCircle(0, 0, radius);
			graphics.endFill();
		}
		
		public function getSpeed():Number
		{
			return Math.sqrt(this.vx * this.vx + this.vy * this.vy);
		}
		
		public function changeColor(num:uint)
		{
			this.color= num;
			init();
		}
		
	}
}