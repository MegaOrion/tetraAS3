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
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.MouseEvent;
	import flash.events.KeyboardEvent;
	import flash.events.TimerEvent;
	import flash.media.Sound;
	import flash.text.TextField;
	import flash.utils.Timer;
	
	
	
	[SWF(width="1092", height="600", frameRate="31", backgroundColor="#FFFFFF")]
	public class Boa extends Sprite
	{
		[Embed(source = "../assets/carbon.jpg")]private var BackGround: Class;
		private var bg: Bitmap = new BackGround() as Bitmap;
		
		[Embed(source = "../assets/eating.mp3")]private var snd: Class;
		private var eatingSnd: Sound = new snd() as Sound;
		
		private var moving: Boolean = false;
		private var direction: String = "";
		private var fieldArray: Array;
		private var apple: Sprite;
		private var snakeSection: Sprite;
		private var snakeArray: Array = [];
		private var currentX: int;
		private var currentY: int;
		private var interval: int = 300
		private var timeCount: Timer = new Timer(interval);
		private var score: TextField = new TextField();
		private var scoreStr: TextField = new TextField();
		private var scoreCount: uint = 0;
		private var left: Sprite;
		private var up: Sprite;
		private var right: Sprite;
		private var down: Sprite;
		
		public function Boa()
		{			
			addChild(bg);
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			generateField();
			generateSnake();
			generateApple();
			showScore();
			addButtons();
			left.addEventListener(MouseEvent.CLICK, onBtnLeft);
			up.addEventListener(MouseEvent.CLICK, onBtnUp);
			right.addEventListener(MouseEvent.CLICK, onBtnRight);
			down.addEventListener(MouseEvent.CLICK, onBtnDOwn);
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			timeCount.addEventListener(TimerEvent.TIMER, onTime);
		}
		
		public function onBtnLeft(e: MouseEvent): void {
			if (!moving) {
				timeCount.start();				
				moveSnake();
			}
			moving = true;
			if (direction != "right") {						
				direction = "left";
			}
		}
		
		public function onBtnUp(e: MouseEvent): void {
			if (!moving) {
				timeCount.start();				
				moveSnake();
			}
			moving = true;
			if (direction != "down") {						
				direction = "up";
			}
		}
		
		public function onBtnRight(e: MouseEvent): void {
			if (!moving) {
				timeCount.start();				
				moveSnake();
			}
			moving = true;
			if (direction != "left") {					
				direction = "right";
			}
		}
		
		public function onBtnDOwn(e: MouseEvent): void {
			if (!moving) {
				timeCount.start();				
				moveSnake();
			}
			moving = true;
			if (direction != "up") {
				direction = "down";
			}
		}
		
		public function addButtons(): void {
			left = new Sprite();
			up = new Sprite();
			right = new Sprite();
			down = new Sprite();
			addChild(left);
			left.graphics.lineStyle(1, 0x000000);
			left.graphics.beginFill(0x888888);
			left.graphics.drawCircle(275, 300, 15);
			left.graphics.endFill();
			addChild(up);
			up.graphics.lineStyle(1, 0x000000);
			up.graphics.beginFill(0x888888);
			up.graphics.drawCircle(300, 275, 15);
			up.graphics.endFill();
			addChild(right);
			right.graphics.lineStyle(1, 0x000000);
			right.graphics.beginFill(0x888888);
			right.graphics.drawCircle(325, 300, 15);
			right.graphics.endFill();
			addChild(down);
			down.graphics.lineStyle(1, 0x000000);
			down.graphics.beginFill(0x888888);
			down.graphics.drawCircle(300, 325, 15);
			down.graphics.endFill();			
		}
		
		public function showScore(): void {
			scoreStr.text = scoreCount.toString(10);
			score.text = "SCORE: ";
			score.textColor = 0xFFFFFF;			
			score.x = stage.stageWidth / 4;
			score.y = stage.stageHeight / 4 - 10;
			addChild(score);
			scoreStr.textColor = 0xFFFFFF;
			scoreStr.x = stage.stageWidth / 4;
			scoreStr.y = stage.stageHeight / 4 + 10;
			addChild(scoreStr);
		}
		
		public function reset(): void {
			scoreCount = 0;
			showScore();
			moving = false;
			removeChild(apple);
			generateApple();
			for (var i: uint = snakeArray.length-1; i > 0; --i){
				removeChild(snakeArray[i]);
				snakeArray.splice(i,1);
			}
			generateSnake();
			direction = "";
			timeCount.stop();
			interval = 300;
		}
		
		public function onTime(e: TimerEvent): void {
			eatApple();
			switch (direction) {
				case "left":
					if (canMove(currentX - 1, currentY)) {						
						currentX--;
					}
					break;
				case "up":
					if (canMove(currentX, currentY - 1)) {
						currentY--;
					}
					break;
				case "right":
					if (canMove(currentX + 1, currentY)) {						
						currentX++;
					}
					break;
				case "down":
					if (canMove(currentX, currentY + 1)) {						
						currentY++;
					}
					break;
			}
			moveSnake();
			clashTail();
		}
		
		public function clashTail(): void {
			for(var i: uint = snakeArray.length - 1; i >= 1; --i){
				if (snakeArray[0].x == snakeArray[i].x && snakeArray[0].y == snakeArray[i].y) {
					reset();
					break;
				}
			}
		}
		
		public function eatApple(): void {
			for(var i: uint = snakeArray.length-1; i >= 1; --i){
				if(snakeArray[0].x == apple.x && snakeArray[0].y == apple.y){
					scoreCount += 1000;
					showScore();
					eatingSnd.play();
					snakeSection = new Sprite();
					snakeSection.graphics.lineStyle(0, 0x00FF00, 1);
					snakeSection.graphics.beginFill(0x00FF00);
					snakeSection.graphics.drawRect(0, 0, 15, 15);
					snakeSection.graphics.endFill();
					snakeSection.x = snakeArray[snakeArray.length - 1].x;
					snakeSection.y = snakeArray[snakeArray.length - 1].y;
					snakeArray.push(snakeSection);
					addChild(snakeSection);
					removeChild(apple);
					generateApple();
					timeCount.removeEventListener(TimerEvent.TIMER, onTime);
					timeCount.stop();
					timeCount = new Timer(interval = interval - interval * 0.1);
					timeCount.addEventListener(TimerEvent.TIMER, onTime);
					timeCount.start();
					break;
				}
			}
		}
		
		public function moveSnake(): void {
			var last: Sprite = snakeArray[snakeArray.length -1];
			last.x = currentX * 15 + stage.stageWidth / 2;
			last.y = currentY * 15 + 10;
			snakeArray.unshift(last);
			snakeArray.pop();
		}
		
		public function generateApple(): void {
			apple = new Sprite;
			apple.x = Math.floor(Math.random() * 36) * 15 + stage.stageWidth / 2;
			apple.y = Math.floor(Math.random() * 38) * 15 + 10;			
			addChild(apple);
			apple.graphics.lineStyle(0, 0xFF0000, 1);
			apple.graphics.beginFill(0xFF0000);
			apple.graphics.drawRect(0, 0, 15, 15);
			apple.graphics.endFill();
		}
		
		public function onKeyDown(e: KeyboardEvent): void {
			if (!moving) {
				timeCount.start();				
				moveSnake();
			}
			moving = true;
			switch (e.keyCode) {
				case 37:
					if (direction != "right") {						
						direction = "left";
					}
					break;
				case 38:
					if (direction != "down") {						
						direction = "up";
					}
					break;
				case 39:
					if (direction != "left") {					
						direction = "right";
					}
					break;
				case 40:
					if (direction != "up") {
						direction = "down";
					}
					break;
			}
		}
		
		public function canMove(row: int, col: int): Boolean {
			if (col < 0 || col >= 38 || row >= 36 || row < 0){
				reset();
				return false;
			}
				
			return true;
		}
		
		public function generateSnake(): void {
			currentX = 19;
			currentY = 18;			
			drawSection();
			placeSection();
		}
		
		public function placeSection(): void {	
			for (var i: uint = 0; i < snakeArray.length; i++) {
				snakeArray[i].x = currentX * 15 + stage.stageWidth / 2;
				snakeArray[i].y = currentY * 15 + 10;
			}
		}
		
		public function drawSection(): void {
			for (var i: uint = 0; i < 3; i++) {
				snakeSection = new Sprite();
				snakeSection.graphics.lineStyle(0, 0x00FF00, 1);
				snakeSection.graphics.beginFill(0x00FF00);
				snakeSection.graphics.drawRect(0, 0, 15, 15);
				snakeSection.graphics.endFill();
				snakeSection.x = i + currentX * 15 + stage.stageWidth / 2;
				snakeSection.y = currentY * 15 + 10;
				snakeArray.push(snakeSection);
				addChild(snakeSection);
			}
		}
		
		public function generateField(): void {
			scoreCount = 0;
			fieldArray = new Array();
			var fieldSprite: Sprite = new Sprite();
			
			fieldSprite.graphics.lineStyle(0, 0xFFFFFF, 0.1);
			
			for (var i: uint = 0; i < 38; i++) {
				fieldArray[i] = new Array;
				for (var j: uint = 0; j < 36; j++) {
					fieldArray[i][j] = 0;
					fieldSprite.graphics.beginFill(0x444444, 0);
					fieldSprite.graphics.drawRect(15*j + stage.stageWidth / 2, 15*i + 10, 15, 15);
					fieldSprite.graphics.endFill();
				}
			}
			addChild(fieldSprite);
		}
	}
