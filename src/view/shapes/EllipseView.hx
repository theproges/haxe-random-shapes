package view.shapes;

class EllipseView extends BaseShapeView {
    private var _centerPoint: Array<Int>;
    private var _maxWidth: Int;
    private var _color: Int;
    private var _area: Int;
    private var _width: Int;
    private var _height: Int;
    private var _equalSize: Bool;

    public function new(maxWidth: Int, equalSize: Bool = false) {
        super();
        if (equalSize) {
            _width = _height = getRandomInt(maxWidth / 2, maxWidth);
        } else {
            _width = getRandomInt(maxWidth / 2, maxWidth);
            _height = getRandomInt(maxWidth / 2, maxWidth);
        }

        _maxWidth = maxWidth;
        _centerPoint = getCenterPoint();
        _color = getRandomColor();
        _area = calcArea();
        _equalSize = equalSize;
        trace(_width, _height);
    }

    public override function draw(): Void {
        graphics.clear();
        graphics.beginFill(_color);
        graphics.moveTo(_centerPoint[0], _centerPoint[1]);
        graphics.drawEllipse(_centerPoint[0], _centerPoint[1], _width, _height);
        graphics.endFill();
    }

    public override function getAreaValue(): Int {
        return _area;
    }

    public override function lower(offsetY:Int): Void {
        _centerPoint[1] += offsetY;
        draw();
    }

    public override function isLower(y: Int): Bool {
        return (_centerPoint[1] - height) > y;
    }

    private function calcArea(): Int {
        return Std.int(_width * _height * Math.PI);
    }

    private function getCenterPoint(): Array<Int> {
        return [
            // todo: remove 800
            getRandomInt(_maxWidth / 2, 800 - _maxWidth),
            -_maxWidth
        ];
    }

    private function pointInPolygon (point: Array<Int>): Bool {
        var result = Math.pow(point[0] - _centerPoint[0], 2) / Math.pow(width, 2) + Math.pow(point[1] - _centerPoint[1], 2) / Math.pow(height, 2);

        return result <= 1;
    }
}