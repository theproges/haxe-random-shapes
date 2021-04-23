package view.shapes;

import config.GameSettings;

class StarView extends BaseShapeView {
    private var _centerPoint: Array<Int>;
    private var _coords: Array<Array<Int>>;
    private var _spikes: Int;
    private var _outerRadius: Int;
    private var _innerRadius: Int;
    private var _color: Int;
    private var _area: Int;
    private var _maxWidth: Int;

    public function new(maxWidth: Int) {
        super();
        _maxWidth = maxWidth;
        _centerPoint = getCenterPoint();
        _spikes = getRandomInt(5, 9);
        _outerRadius = getRandomInt(30, maxWidth);
        _innerRadius = Std.int(_outerRadius / 2);
        _color = getRandomColor();
        _coords = getCoords();
        _area = calcArea();
    }

    public override function draw(): Void {
        graphics.clear();
        graphics.beginFill(_color);
        graphics.moveTo(_coords[0][0], _coords[0][1]);
        for (i in 1..._coords.length) {
            graphics.lineTo(_coords[i][0], _coords[i][1]);
        }
        graphics.lineTo(_coords[0][0], _coords[0][1]);
        graphics.endFill();
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

    private function getCoords(): Array<Array<Int>> {
        var coords = [];
        var cx = _centerPoint[0];
        var cy = _centerPoint[1];
        var x, y;

        var rotation = Math.PI / 2 * 3;
        var step = Math.PI / _spikes;

        coords.push([cx, cy - _outerRadius]);

        for(i in 0..._spikes) {
            x = cx + Math.cos(rotation) * _outerRadius;
            y = cy + Math.sin(rotation) * _outerRadius;
            coords.push([Std.int(x), Std.int(y)]);
            rotation += step;

            x = cx + Math.cos(rotation) * _innerRadius;
            y = cy + Math.sin(rotation) * _innerRadius;
            coords.push([Std.int(x), Std.int(y)]);
            rotation += step;
        }

        return coords;
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

    private function getCenterPoint(): Array<Int> {
        return [
            getRandomInt(_maxWidth / 2, GameSettings.SCENE_WIDTH - _maxWidth),
            -_maxWidth
        ];
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