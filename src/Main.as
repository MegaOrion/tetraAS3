package
{	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import Controller;
	import flash.display.StageScaleMode;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author MegaOrion
	 */
	public class Main extends MovieClip
	{	
		
		
		[Embed(source = "carbon.jpg")]
        private var back: Class;
		private var bg= new back();
		public var ctrl: Controller = new Controller();
		
		public function Main(): void
		{
			bg.x = 0;
			bg.y = 0;
			addChild(bg);
			addChild(ctrl);
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
		}
	}	
}