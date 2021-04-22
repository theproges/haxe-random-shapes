package model;

class Model {
    private var _area: Int;

    private var _gravity: Int;
    private var _gravityDefault: Int = 5;
    private var _gravityMinMax: Array<Int> = [1, 10];

    private var _shapesPerSec: Int;
    private var _shapesPerSecDefault: Int = 1;
    private var _shapesPerSecMinMax: Array<Int> = [1, 10];
 
    public function new() {
        _area = 0;
        _gravity = _gravityDefault;
        _shapesPerSec = _shapesPerSecDefault;
    }

    public function getArea(): Int {
        return _area;
    }

    public function getGravity(): Int {
        return _gravity;
    }

    public function getShapesPerSec(): Int {
        return _shapesPerSec;
    }

    public function addArea(value: Int): Void {
        _area += value;
    }

    public function removeArea(value: Int): Void {
        _area -= value;
    }

    public function increaseGravity(): Int {
        _gravity++;
        if (_gravity > _gravityMinMax[1]) {
            _gravity = _gravityMinMax[1];
        }

        return _gravity;
    }

    public function decreaseGravity(): Int {
        _gravity--;
        if (_gravity < _gravityMinMax[0]) {
            _gravity = _gravityMinMax[0];
        }

        return _gravity;
    }

    public function increaseShapesPerSec(): Int {
        _shapesPerSec++;
        if (_shapesPerSec > _shapesPerSecMinMax[1]) {
            _shapesPerSec = _shapesPerSecMinMax[1];
        }

        return _shapesPerSec;
    }

    public function decreaseShapesPerSec(): Int {
        _shapesPerSec--;
        if (_shapesPerSec < _shapesPerSecMinMax[0]) {
            _shapesPerSec = _shapesPerSecMinMax[0];
        }

        return _shapesPerSec;
    }
}