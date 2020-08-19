package 
{
	import flash.display.Sprite;
	import flash.display.Graphics;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import Figures;
	import flash.text.TextField;
	import flash.media.Sound;
	/**
	 * ...
	 * @author MegaOrion
	 */
	public class Game extends Sprite
	{
		public var snd: Sound = new TetroFall();
		public var tetromino: Sprite;
		public var currentTetromino: uint;
		public var currentRotation: uint;
		public const TS: uint = 24;
		
		public var fieldArray: Array;
		public var fieldSprite: Sprite;
		
		public var nextTetromino: uint = Math.floor(Math.random() * 7);
		
		public var tRow: int;
		public var tCol: int;
		public var interval: uint = 1001;		
		public var timeCount: Timer = new Timer(interval);
		
		public var gameOver: Boolean = true;
		
		public var fgr: Figures = new Figures();
		public var landed: Sprite;
		
		public var score: TextField = new TextField();
		public var scoreNum: TextField = new TextField();
		public var scoreCount: uint = 0;
		
		
			
		public function Game() 
		{
			generateField();
			fgr.initTetrominoes();
			generateTetramino();
			showScore();
		}
		
		public function showScore(): void {
			scoreNum.text = scoreCount.toString(10);
			score.text = "LINES: ";
			score.textColor = 0xFFFFFF;
			score.x = 400;
			score.y = 200;
			addChild(score);
			scoreNum.textColor = 0xFFFFFF;
			scoreNum.x = 450;
			scoreNum.y = 200;
			addChild(scoreNum);
		}
		
		public function generateTetramino(): void {
			if (!gameOver) {
				currentTetromino = nextTetromino;
				nextTetromino = Math.floor(Math.random() * 7);
				drawNext();
				currentRotation = 0;
				tRow = 0;
				tCol = 3;
				drawTetromino();
				placeTetramino();
				if (canFit(tRow, tCol, currentRotation)) {
					timeCount.addEventListener(TimerEvent.TIMER, onTime);
					timeCount.start();
				} else {
					removeChild(tetromino);
					gameOver = true;
				}
			}			
		}		
		
		public function onTime(e: TimerEvent): void {
			if (canFit(tRow + 1, tCol, currentRotation)) {
				tRow++;
				placeTetramino();
			} else {
				landTetramino();
				generateTetramino();
			}
		}
		
		public function checkForLines(): void {
			for (var i: int = 0; i < 20; i++) {
				if (fieldArray[i].indexOf(0) == -1){
					scoreCount++;
					showScore();
					for (var j: int = 0; j < 10; j++) {
						fieldArray[i][j] = 0;
						removeChild(getChildByName("r" + i + "c" + j));
					}
					for (j = i; j >= 0; j--) {
						for (var k: int = 0; k < 10; k++) {
							if (fieldArray[j][k] == 1) {
								fieldArray[j][k] = 0;
								fieldArray[j + 1][k] = 1;
								getChildByName("r" + j + "c" + k).y += TS;
								getChildByName("r" + j + "c" + k).name = "r" + (j + 1) + "c" + k;
							}
						}
					}
					timeCount = new Timer(interval = interval - 100);
				}				
			}
		}
		
		public function landTetramino(): void {			
			snd.play();
			var ct: uint = currentTetromino;
			var landed: Sprite;
			for (var i: int = 0; i < fgr.tetrominoes[ct][currentRotation].length; i++) {
				for (var j: int = 0; j < fgr.tetrominoes[ct][currentRotation][i].length; j++) {
					if (fgr.tetrominoes[ct][currentRotation][i][j] == 1) {
						landed = new Sprite();
						landed.graphics.lineStyle(0, 0x000000);
						landed.graphics.beginFill(fgr.colors[ct]);
						landed.graphics.drawRect(TS * (tCol + j) + 100, TS * (tRow + i) + 50, TS, TS);
						landed.graphics.endFill();
						landed.name = "r" + (tRow + i) + "c" + (tCol + j);
						fieldArray[tRow + i][tCol + j] = 1;
						addChild(landed);
					}
				}
			}
			removeChild(tetromino);
			timeCount.removeEventListener(TimerEvent.TIMER, onTime);
			timeCount.stop();
			checkForLines();
		}
		
		public function drawTetromino(): void {
			var ct: uint = currentTetromino;
			tetromino = new Sprite;
			addChild(tetromino);
			tetromino.graphics.lineStyle(0, 0x000000, 0.5);			
			for (var i: int = 0; i < fgr.tetrominoes[ct][currentRotation].length; i++) {
				for (var j: int = 0; j < fgr.tetrominoes[ct][currentRotation][i].length; j++) {
					if (fgr.tetrominoes[ct][currentRotation][i][j] == 1) {
						tetromino.graphics.beginFill(fgr.colors[ct]);
						tetromino.graphics.drawRect(TS * j, TS * i, TS, TS);
						tetromino.graphics.endFill();
					}
				}						
			}
		}	
		
		public function canFit(row: int, col: int, side: uint): Boolean {
			var ct: uint = currentTetromino;			
			for (var i: int = 0; i < fgr.tetrominoes[ct][side].length; i++) {
				for (var j: int = 0; j < fgr.tetrominoes[ct][side][i].length; j++) {
					if (fgr.tetrominoes[ct][side][i][j] == 1) {
						if (col + j < 0 || col + j > 9 || row + i > 19 || fieldArray[row + i][col + j] == 1) return false;
					}					
				}
			}
			return true;
		}
		
		public function placeTetramino(): void {
			tetromino.x = tCol * TS + 100;
			tetromino.y = tRow * TS + 50;
		}
		
		public function drawNext(): void {
			if (getChildByName("next") != null) {
				removeChild(getChildByName("next"));
			}
			var next_t: Sprite = new Sprite();
			next_t.x = 400;
			next_t.y = 100;
			next_t.name = "next";
			addChild(next_t);
			next_t.graphics.lineStyle(0, 0x000000);
			for (var i: int = 0; i < fgr.tetrominoes[nextTetromino][0].length; i++) {
				for (var j: int = 0; j < fgr.tetrominoes[nextTetromino][0][i].length; j++) {
					if (fgr.tetrominoes[nextTetromino][0][i][j] == 1) {
						next_t.graphics.beginFill(fgr.colors[nextTetromino]);
						next_t.graphics.drawRect(TS * j, TS * i, TS, TS);
						next_t.graphics.endFill();
					}
				}
			}
		}
		
		public function generateField(): void {
			scoreCount = 0;
			fieldArray = new Array;
			fieldSprite = new Sprite;
			fieldSprite.graphics.lineStyle(0, 0xFFFFFF, 0.1);
			for (var i: uint = 0; i < 20; i++) {
				fieldArray[i] = new Array;
				for (var j:uint = 0; j < 10; j++) {
					fieldArray[i][j] = 0;
					fieldSprite.graphics.beginFill(0x444444, 0);
					fieldSprite.graphics.drawRect(TS * j + 100, TS * i + 50, TS, TS);
					fieldSprite.graphics.endFill();
				}
			}
			addChild(fieldSprite);
		}
		
		public function emptyField(): void {
			for (var i: uint = 0; i < 20; i++) {
				for (var j:uint = 0; j < 10; j++) {
					if (fieldArray[i][j] == 1){						
						removeChild(getChildByName("r" + i + "c" + j));
					}					
				}
			}			
			removeChild(fieldSprite);
		}
	}
}