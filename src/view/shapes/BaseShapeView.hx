package view.shapes;

import openfl.display.Shape;

class BaseShapeView extends Shape {
    public function getAreaValue(): Int { return 0; }
    public function lower(offsetY:Int): Void { }
    public function draw(): Void { }
    public function isLower(y: Int): Bool { return false; }
    public function hasPoint(x: Int, y: Int): Bool { return false; }
    public function moveCenterTo(x: Int, y: Int): Void {}
    public function dispose(): Void { 
        
    }
    public function getRandomColor(): Int {
        return getRandomInt(0, 16777215);
    }

    public function getRandomInt(min, max) {
        return Math.floor(Math.random() * (Math.floor(max) - Math.ceil(min) + 1)) + Math.ceil(min);
    }
}
