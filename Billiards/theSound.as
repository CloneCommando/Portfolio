package
{
	import flash.display.*;
	import flash.net.*;
	import flash.media.*;
	
	public class theSound extends MovieClip
	{
		var mySong:String;
		var myURL:URLRequest;
		var myChannel:SoundChannel;
		var mySound:Sound;
		var myTransform:SoundTransform;
		
		public function theSound(theName:String)
		{
			//the file
			mySong = "sounds/" + theName;
			myURL = new URLRequest(mySong);
			
			// the sound
			mySound = new Sound(myURL);
			
			myTransform = new SoundTransform();
			
		}
		
		public function setVolume(num:Number)
		{
			myTransform.volume = num;
			
			if(myChannel != null)
			{
				myChannel.soundTransform = myTransform;
			}
			

		}
		
		public function playSound()
		{
			myChannel = mySound.play();
			setVolume(0.1);
		}
		
		
		public function stopSound()
		{
			if(myChannel != null)
			{
				myChannel.stop(); //Stops the song from playing
			}
		}
	}
}