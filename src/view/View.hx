package view;

import config.GameSettings;
import config.SystemEvents;
import services.EventService;
import model.Model;
import view.shapes.BaseShapeView;
import view.shapes.PolygonView;
import view.shapes.EllipseView;
import view.shapes.StarView;

import openfl.display.Stage in OpenFLStage;

import js.Browser.document;

class View {
    private var _stage: OpenFLStage;
    private var _model: Model;
    private var _gravity: Int;
    private var _shapesPerSec: Int;
    private var _area: Int;
    private var _shapesList: Array<BaseShapeView>;
    private var _stepY: Int;
    private var _shapeMaxWidth: Int;

    private var _shapesCountEl: js.html.Element;
    private var _areaEl: js.html.Element;
    private var _gravityEl: js.html.Element;
    private var _shapesPerSecEl: js.html.Element;
    
    public function new(stage: OpenFLStage, model: Model) {
        _stage = stage;
        _model = model;
        _shapesList = new Array<BaseShapeView>();
        _stepY = GameSettings.SHAPE_STEP_Y;
        _shapeMaxWidth = GameSettings.SHAPE_MAX_WIDTH;
        _gravity = _model.getGravity();

        _shapesCountEl = document.getElementById("shapes-count");
        _areaEl = document.getElementById("area");
        _gravityEl = document.getElementById("gravity-value");
        _shapesPerSecEl = document.getElementById("shapes-gen-value");

        document.getElementsByTagName("canvas")[0].addEventListener("pointerdown", function(event) {
            EventService.notify(SystemEvents.OnPointerDown, event);
        });
        document.getElementById("increase-gravity-btn").addEventListener("pointerdown", function() {
            EventService.notify(SystemEvents.OnGravityIncrease, null);
        });
        document.getElementById("decrease-gravity-btn").addEventListener("pointerdown", function() {
            EventService.notify(SystemEvents.OnGravityDecrease, null);
        });
        document.getElementById("increase-shapes-btn").addEventListener("pointerdown", function() {
            EventService.notify(SystemEvents.OnShapesPerSecIncrease, null);
        });
        document.getElementById("decrease-shapes-btn").addEventListener("pointerdown", function() {
            EventService.notify(SystemEvents.OnShapesPerSecDecrease, null);
        });
    }

    public function update(dt: Float): Void {
        if (_shapesList.length == 0) {
            return;
        }

        var index = 0;
        while(index < _shapesList.length) {
            var shape = _shapesList[index];
            shape.lower(Std.int(_stepY * dt * _gravity));
            if (checkShape(shape)) {
                index++;
            }
        }
    }

    public function getShapeByIndex(index: Int): BaseShapeView {
        return _shapesList[index];
    }

    public function checkShape(shape: BaseShapeView): Bool {
        if (shape.isLower(Std.int(GameSettings.SCENE_HEIGHT))) {
            EventService.notify(SystemEvents.ShapeOutOfScreen, _shapesList.indexOf(shape));
            return false;
        } else {
            return true;
        }
    }

    public function destroyShape(index: Int): Void{
        _shapesList.splice(index, 1);
        _stage.removeChildAt(index + 1);
    }

    public function refresh(): Void {
        _shapesCountEl.innerHTML = "COUNT: " + _shapesList.length;
        _areaEl.innerHTML = "AREA: " + _model.getArea();
        _gravityEl.innerHTML = "GRAVITY: " + _model.getGravity();
        _shapesPerSecEl.innerHTML = "SHAPES PER SECOND: " + _model.getShapesPerSec();
        _gravity = _model.getGravity();
    }

    public function createRandomTriangle(?x: Int, ?y: Int): BaseShapeView {
        var shape = new PolygonView(3, _shapeMaxWidth);
        installShape(shape, x, y);

        return shape;
    }

    public function createRandomQuadrangle(?x: Int, ?y: Int): BaseShapeView {
        var shape = new PolygonView(4, _shapeMaxWidth);
        installShape(shape, x, y);

        return shape;
    }

    public function createRandomPentagon(?x: Int, ?y: Int): BaseShapeView { 
        var shape = new PolygonView(5, _shapeMaxWidth);
        installShape(shape, x, y);

        return shape;
    }

    public function createRandomHexagon(?x: Int, ?y: Int): BaseShapeView {
        var shape = new PolygonView(6, _shapeMaxWidth);
        installShape(shape, x, y);

        return shape;
    }

    public function createRandomCircle(?x: Int, ?y: Int): BaseShapeView { 
        var shape = new EllipseView(_shapeMaxWidth, true);
        installShape(shape, x, y);

        return shape; 
    }

    public function createRandomEllipse(?x: Int, ?y: Int): BaseShapeView { 
        var shape = new EllipseView(_shapeMaxWidth);
        installShape(shape, x, y);

        return shape; 
    }

    public function createRandomStar(?x: Int, ?y: Int): BaseShapeView { 
        var shape = new StarView(_shapeMaxWidth);
        installShape(shape, x, y);

        return shape;
     }

     public function getShapeIndexByCoords(x: Int, y: Int): Int {
        var index = _shapesList.length - 1;
        while(index >= 0) {
            var shape = _shapesList[index];
            if (shape.hasPoint(x, y)) {
                return index;
            }
            index--;
        }

        return null;
     }

     private function installShape(shape: BaseShapeView, x: Int, y: Int): Void {
        _shapesList.push(shape);
        _stage.addChild(shape);

        if (x != null && y != null) {
            shape.moveCenterTo(x, y);
        }
     }
}
