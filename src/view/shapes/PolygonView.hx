package view.shapes;

import openfl.display.Shape;
import config.GameSettings;

class PolygonView extends BaseShapeView {
    private var _coords: Array<Array<Int>>;
    private var _color: Int;
    private var _area: Int;
    private var _shapeMaxWidth: Int;

    public function new(canvas: Shape, sides: Int, shapeMaxWidth: Int) {
        super(canvas);
        _shapeMaxWidth = shapeMaxWidth;
        _coords = getCoords(sides);
        _color = getRandomColor();
        _area = calcArea();
    }

    public override function draw(): Void {
        _canvas.graphics.beginFill(_color);
        _canvas.graphics.moveTo(_coords[0][0], _coords[0][1]);

        for (i in 1..._coords.length) {
            _canvas.graphics.lineTo(_coords[i][0], _coords[i][1]);
        }

        _canvas.graphics.lineTo(_coords[0][0], _coords[0][1]);

        _canvas.graphics.endFill();
    }

    public override function getAreaValue(): Int {
        return _area;
    }

    public override function lower(offsetY:Int): Void {
        for (i in 0..._coords.length) {
            _coords[i][1] += offsetY;
        }
        draw();
    }

    public override function isLower(y: Int): Bool {
        var result = true;

        for (i in 0..._coords.length) {
            if(_coords[i][1] <= y) {
                result = false;
            }
        }

        return result;
    }

    public override function hasPoint(x: Int, y: Int): Bool {
        var len = _coords.length;
        var j = len - 1;
        var inside = false;
        for (i in 0...len) {
            if (i > 0) j = i - 1;
            var xi = _coords[i][0], yi = _coords[i][1];
            var xj = _coords[j][0], yj = _coords[j][1];
            
            var intersect = ((yi > y) != (yj > y))
                && (x < (xj - xi) * (y - yi) / (yj - yi) + xi);
            if (intersect) inside = !inside;
        }

        return inside;
    }

    public override function moveCenterTo(x: Int, y: Int): Void {
        var minMax = getMinMaxPoints();
        var cx = minMax[0][0] + (minMax[1][0] - minMax[0][0]) / 2;
        var cy = minMax[0][1] + (minMax[1][1] - minMax[0][1]) / 2;

        var offsetX = Std.int(x - cx);
        var offsetY = Std.int(y - cy);

        for (i in 0..._coords.length) {
            _coords[i][0] += offsetX;
            _coords[i][1] += offsetY;
        }
    }

    private function getCoords(sidesCount: Int): Array<Array<Int>> {
        var sumAngle = 180 * (sidesCount - 2);
        var maxAngle = sumAngle / sidesCount / 2;
        var angleStep = getRandomInt(maxAngle / 2, maxAngle);
        var leftAngle = sumAngle;
        var points = [
            [getRandomInt(_shapeMaxWidth, GameSettings.SCENE_WIDTH - _shapeMaxWidth), -_shapeMaxWidth]
        ];

        for (i in 0...sidesCount - 1) {
            var dDistance = getRandomInt(0, 200);
            leftAngle -= angleStep;
            points.push([
                    Std.int(points[0][0] + (_shapeMaxWidth - dDistance) * Math.cos(leftAngle * Math.PI / 180)),
                    Std.int(points[0][1] + (_shapeMaxWidth - dDistance) * Math.sin(leftAngle * Math.PI / 180))
                ]
            );
        }

        return points;
    }

    private function calcArea(): Int {
        var area = 0;
        var minMax = getMinMaxPoints();

        for(x in minMax[0][0]...(minMax[1][0] + 1)) {
            for (y in minMax[0][1]...(minMax[1][1] + 1)) {
                if (hasPoint(x, y)) {
                    area++;
                }
            }
        }

        return area;
    }

    private function getMinMaxPoints(): Array<Array<Int>> {
        var maxX = _coords[0][0];
        var maxY = _coords[0][1];
        var minX = _coords[0][0];
        var minY = _coords[0][1];

        for(i in 1..._coords.length) {
            maxX = maxX < _coords[i][0] ? _coords[i][0] : maxX;
            maxY = maxY < _coords[i][1] ? _coords[i][1] : maxY;
            minX = minX > _coords[i][0] ? _coords[i][0] : minX;
            minY = minY > _coords[i][1] ? _coords[i][1] : minY;
        }

        return [[minX, minY], [maxX, maxY]];
    }
}