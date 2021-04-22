package view;

import config.SystemEvents;
import services.EventService;
import model.Model;
import view.shapes.BaseShapeView;
import view.shapes.PolygonView;
import view.shapes.EllipseView;
import view.shapes.StarView;

import openfl.display.Stage in OpenFLStage;

class View {
    private var _stage: OpenFLStage;
    private var _model: Model;
    private var _gravity: Int;
    private var _shapesPerSec: Int;
    private var _area: Int;
    private var _shapesList: Array<BaseShapeView>;
    private var _stepY: Int;
    private var _shapeMaxWidth: Int;
    
    public function new(stage: OpenFLStage, model: Model) {
        _stage = stage;
        _model = model;
        _shapesList = new Array<BaseShapeView>();
        _stepY = 100;
        _shapeMaxWidth = 300;

        js.Browser.document.getElementsByTagName("canvas")[0].addEventListener("pointerdown", function(event) {
            EventService.notify(SystemEvents.OnPointerDown, event);
        });
    }

    public function update(dt: Float): Void {
        if (_shapesList.length == 0) {
            return;
        }

        var index = 0;
        while(index < _shapesList.length) {
            var shape = _shapesList[index];
            shape.lower(Std.int(_stepY * dt * _model.getGravity()));
            if (checkShape(shape)) {
                index++;
            }
        }
    }

    public function getShapeByIndex(index: Int): BaseShapeView {
        return _shapesList[index];
    }

    public function checkShape(shape: BaseShapeView): Bool {
        // todo: _stage.heigth = 0. Why???
        if (shape.isLower(Std.int(800))) {
            EventService.notify(SystemEvents.ShapeOutOfScreen, _shapesList.indexOf(shape));
            return false;
        } else {
            return true;
        }
    }

    public function destroyShape(index: Int): Void{
        _shapesList.splice(index, 1);
        _stage.removeChildAt(index);
        // todo: shape.dispose();
    }

    public function refresh(): Void {
        // todo: refresh UI
        // todo: refresh gravity
    }

    public function createRandomTriangle(?x: Int, ?y: Int): BaseShapeView {
        var shape = new PolygonView(3, _shapeMaxWidth);
        _shapesList.push(shape);
        _stage.addChild(shape);

        if (x != null && y != null) {
            shape.moveCenterTo(x, y);
        }

        return shape;
    }

    public function createRandomQuadrangle(?x: Int, ?y: Int): BaseShapeView {
        var shape = new PolygonView(4, _shapeMaxWidth);
        _shapesList.push(shape);
        _stage.addChild(shape);

        if (x != null && y != null) {
            shape.moveCenterTo(x, y);
        }

        return shape;
    }

    public function createRandomPentagon(?x: Int, ?y: Int): BaseShapeView { 
        var shape = new PolygonView(5, _shapeMaxWidth);
        _shapesList.push(shape);
        _stage.addChild(shape);

        if (x != null && y != null) {
            shape.moveCenterTo(x, y);
        }

        return shape;
    }

    public function createRandomHexagon(?x: Int, ?y: Int): BaseShapeView {
        var shape = new PolygonView(6, _shapeMaxWidth);
        _shapesList.push(shape);
        _stage.addChild(shape);

        if (x != null && y != null) {
            shape.moveCenterTo(x, y);
        }

        return shape;
    }

    public function createRandomCircle(?x: Int, ?y: Int): BaseShapeView { 
        var shape = new EllipseView(_shapeMaxWidth, true);
        _shapesList.push(shape);
        _stage.addChild(shape);

        if (x != null && y != null) {
            shape.moveCenterTo(x, y);
        }

        return shape; 
    }

    public function createRandomEllipse(?x: Int, ?y: Int): BaseShapeView { 
        var shape = new EllipseView(_shapeMaxWidth);
        _shapesList.push(shape);
        _stage.addChild(shape);

        if (x != null && y != null) {
            shape.moveCenterTo(x, y);
        }

        return shape; 
    }

    public function createRandomStar(?x: Int, ?y: Int): BaseShapeView { 
        var shape = new StarView(_shapeMaxWidth);
        _shapesList.push(shape);
        _stage.addChild(shape);

        if (x != null && y != null) {
            shape.moveCenterTo(x, y);
        }

        return shape;
     }

     public function removeShapeAt(x: Int, y: Int): Bool {
        var index = _shapesList.length - 1;
        while(index >= 0) {
            var shape = _shapesList[index];
            if (shape.hasPoint(x, y)) {
                _shapesList.splice(_shapesList.indexOf(shape), 1);
                _stage.removeChild(shape);
                shape.dispose();
                return true;
            }
            index--;
        }

        return false;
     }
}
