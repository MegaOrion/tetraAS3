package 
{
	import flash.events.KeyboardEvent;
	import Game;
	import flash.events.MouseEvent;
	import flash.utils.Timer;
	/**
	 * ...
	 * @author MegaOrion
	 */
	public class Controller extends Game
	{
		private var _btnPlay: btnPlay = new btnPlay();	
		private var _btnPause: btnPause = new btnPause();
		private var _btnRotate: btnRotate = new btnRotate();	
		private var _btnDown: btnDown = new btnDown();
		private var _btnLeft: btnLeft = new btnLeft();	
		private var _btnRight: btnRight = new btnRight();
		
		public function Controller() 
		{
			_btnRotate.x = 500;
			_btnRotate.y = 375;
			addChild(_btnRotate);
			
			_btnDown.x = 500;
			_btnDown.y = 485;
			addChild(_btnDown);
			
			_btnLeft.x = 440;
			_btnLeft.y = 425;
			addChild(_btnLeft);
			
			_btnRight.x = 560;
			_btnRight.y = 425;
			addChild(_btnRight);
			
			_btnPlay.x = 700;
			_btnPlay.y = 300;
			addChild(_btnPlay);
			
			_btnPause.x = 700;
			_btnPause.y = 250;
			addChild(_btnPause);
			
			_btnPlay.addEventListener(MouseEvent.CLICK, onBtnPlay);
			_btnPause.addEventListener(MouseEvent.CLICK, onBtnPause);	
			_btnRotate.addEventListener(MouseEvent.CLICK, onBtnRotate);
			_btnDown.addEventListener(MouseEvent.CLICK, onBtnDown);
			_btnLeft.addEventListener(MouseEvent.CLICK, onBtnLeft);
			_btnRight.addEventListener(MouseEvent.CLICK, onBtnRight);
		}
		
		private function onBtnRotate(e:MouseEvent): void {
			var ct: uint = currentRotation;
			var rot: uint = (ct + 1) % fgr.tetrominoes[currentTetromino].length;
			if (canFit(tRow, tCol, rot)) {
				currentRotation = rot;
				removeChild(tetromino);
				drawTetromino();
				placeTetramino();
			} 
		}
		
		private function onBtnDown(e:MouseEvent): void {
			if (canFit(tRow + 1, tCol, currentRotation)) {
				tRow++;
				placeTetramino();
			} else {
				landTetramino();
				generateTetramino();
			}
		}
		
		private function onBtnLeft(e:MouseEvent): void {
			if (canFit(tRow, tCol - 1, currentRotation)) {
				tCol--;
				placeTetramino();
			} 
		}
		
		private function onBtnRight(e:MouseEvent): void {
			
			if (canFit(tRow, tCol + 1, currentRotation)) {
				tCol++;
				placeTetramino();
			}
		}
		
		private function onBtnPause(e: MouseEvent): void {
			trace(parent.stage);
			timeCount.stop();
			parent.stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKDown);
			_btnRotate.removeEventListener(MouseEvent.CLICK, onBtnRotate);
			_btnDown.removeEventListener(MouseEvent.CLICK, onBtnDown);
			_btnLeft.removeEventListener(MouseEvent.CLICK, onBtnLeft);
			_btnRight.removeEventListener(MouseEvent.CLICK, onBtnRight);
		}
		
		private function onBtnPlay(e: MouseEvent): void {
			
			if (!gameOver) {				
				timeCount.start();
				parent.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKDown);
				_btnRotate.addEventListener(MouseEvent.CLICK, onBtnRotate);
				_btnDown.addEventListener(MouseEvent.CLICK, onBtnDown);
				_btnLeft.addEventListener(MouseEvent.CLICK, onBtnLeft);
				_btnRight.addEventListener(MouseEvent.CLICK, onBtnRight);
			} else {
				gameOver = false;
				interval = 1001;
				timeCount = new Timer(interval);
				emptyField();
				generateField();
				fgr.initTetrominoes();
				generateTetramino();
				parent.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKDown);
				_btnRotate.addEventListener(MouseEvent.CLICK, onBtnRotate);
				_btnDown.addEventListener(MouseEvent.CLICK, onBtnDown);
				_btnLeft.addEventListener(MouseEvent.CLICK, onBtnLeft);
				_btnRight.addEventListener(MouseEvent.CLICK, onBtnRight);
			}			
		}
		
		private function onKDown(e:KeyboardEvent): void {
			if (!gameOver) {
				switch (e.keyCode) {
					case 37:
						if (canFit(tRow, tCol - 1, currentRotation)) {
							tCol--;
							placeTetramino();
						} 
					break;
					case 38:
						var ct: uint = currentRotation;
						var rot: uint = (ct + 1) % fgr.tetrominoes[currentTetromino].length;
						if (canFit(tRow, tCol, rot)) {
							currentRotation = rot;
							removeChild(tetromino);
							drawTetromino();
							placeTetramino();
						} 
					break;
					case 39:
						if (canFit(tRow, tCol + 1, currentRotation)) {
							tCol++;
							placeTetramino();
						} 
					break;
					case 40:
						if (canFit(tRow + 1, tCol, currentRotation)) {
							tRow++;
							placeTetramino();
						} else {
							landTetramino();
							generateTetramino();
						} 
					break;
				}
			}			
		}
	}
}