window.addEventListener("load", function(){
	var drawData = {
		drawFlag : false,
		oldX : 0,	// 直前のX座標を保存するためのもの
		oldY : 0,	// 直前のY座標を保存するためのもの
		brushSize : 1,	// ブラシサイズ
		colorList : {
						"black"   : "rgba(0,0,0,1)",
						"blue"    : "rgba(0,0,255,1)",
						"red"     : "rgba(255,0,0,1)",
						"magenta" : "rgba(255,0,255,1)",
						"green"   : "rgba(0,255,0,1)",
						"cyan"    : "rgba(0,255,255,1)",
						"yellow"  : "rgba(255,255,0,1)",
						"white"   : "rgba(255,255,255,1)"
		},
		penColor : "rgba(255,0,0,1)"
	}
	var can = document.getElementById("myCanvas");
	can.addEventListener("mousemove", function draw(e){
		if (!drawData.drawFlag) return;
		var x = e.clientX;
		var y = e.clientY;
		var can = document.getElementById("myCanvas");
		var context = can.getContext("2d");
		context.strokeStyle = drawData.penColor;
		context.lineWidth = drawData.brushSize;
		context.lineJoin= "round";	// 連結部分を丸にする
		context.lineCap = "round";
		context.beginPath();
		context.moveTo(drawData.oldX, drawData.oldY);
		context.lineTo(x, y);
		context.stroke();
		context.closePath();
		drawData.oldX = x;
		drawData.oldY = y;
	}

	, true);
	can.addEventListener("mousedown", function(e){
		drawData.drawFlag = true;
		drawData.oldX = e.clientX;
		drawData.oldY = e.clientY;
	}, true);
	window.addEventListener("mouseup", function(){	// キャンバスでなくウィンドウに
		drawData.drawFlag = false;
	}, true);

	// カラーパレット初期化
	$("#colorPalet div").click(function(e){
		drawData.penColor = drawData.colorList[this.id];
	});

	// ブラシサイズの設定を行うスライダー
	$("#slider").slider({
		min: 0,
		max: 100,	// ブラシの最大サイズ
		value : 1,	// 最初のブラシサイズ
		slide : function(evt, ui){
			drawData.brushSize = ui.value;	// ブラシサイズを設定
		}
	});

}, true);
// 保存処理　(Canvas2Image)
//　http://www.nihilogic.dk/labs/canvas2image/
function saveData(){
	var can = document.getElementById("myCanvas");
	Canvas2Image.saveAsPNG(can);	// PNG形式で保存
}

