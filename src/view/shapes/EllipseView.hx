package view.shapes;

import openfl.display.Shape;
import config.GameSettings;

class EllipseView extends BaseShapeView {
    private var _leftTopPoint: Array<Int>;
    private var _maxWidth: Int;
    private var _color: Int;
    private var _area: Int;
    private var _width: Int;
    private var _height: Int;
    private var _equalSize: Bool;

    public function new(canvas: Shape, maxWidth: Int, equalSize: Bool = false) {
        super(canvas);
        if (equalSize) {
            _width = _height = getRandomInt(maxWidth / 2, maxWidth);
        } else {
            _width = getRandomInt(maxWidth / 2, maxWidth);
            _height = getRandomInt(maxWidth / 2, maxWidth);
        }
        _maxWidth = maxWidth;
        _leftTopPoint = getCenterPoint();
        _color = getRandomColor();
        _area = calcArea();
        _equalSize = equalSize;
    }

    public override function draw(): Void {
        _canvas.graphics.beginFill(_color);
        _canvas.graphics.moveTo(_leftTopPoint[0], _leftTopPoint[1]);
        _canvas.graphics.drawEllipse(_leftTopPoint[0], _leftTopPoint[1], _width, _height);
        _canvas.graphics.endFill();
    }

    public override function getAreaValue(): Int {
        return _area;
    }

    public override function lower(offsetY:Int): Void {
        _leftTopPoint[1] += offsetY;
        draw();
    }

    public override function isLower(y: Int): Bool {
        return (_leftTopPoint[1] - _height) > y;
    }

    public override function hasPoint(x: Int, y: Int): Bool {
        var halfAxisX = Std.int(_width / 2);
        var halfAxixY = Std.int(_height / 2);
        var cx = _leftTopPoint[0] + halfAxisX;
        var cy = _leftTopPoint[1] + halfAxixY;
        
        x -= cx;
        y -= cy;

        return Math.pow(x, 2) / Math.pow(halfAxisX, 2) + Math.pow(y, 2) / Math.pow(halfAxixY, 2) <= 1;
    }

    public override function moveCenterTo(x: Int, y: Int): Void {
        _leftTopPoint[0] = x - Std.int(_width / 2);
        _leftTopPoint[1] = y - Std.int(_height / 2);
    }

    private function calcArea(): Int {
        return Std.int(_width * _height * Math.PI);
    }

    private function getCenterPoint(): Array<Int> {
        return [
            getRandomInt(_maxWidth / 2, GameSettings.SCENE_WIDTH - _maxWidth),
            -_maxWidth
        ];
    }
}