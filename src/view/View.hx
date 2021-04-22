package view;

import model.Model;
import view.shapes.BaseShapeView;
import view.shapes.PolygonView;
import view.shapes.EllipseView;
import view.shapes.StarView;

import openfl.display.Sprite;
import openfl.display.Stage in OpenFLStage;

class View extends Sprite {
    private var _stage: OpenFLStage;
    private var _model: Model;
    private var _gravity: Int;
    private var _shapesPerSec: Int;
    private var _area: Int;
    private var _shapesList: Array<BaseShapeView>;
    private var _stepY: Int;
    private var _shapeMaxWidth: Int;
    
    public function new(stage: OpenFLStage, model: Model) {
        super();
        _stage = stage;
        _model = model;
        _shapesList = new Array<BaseShapeView>();
        _stepY = 100;
        _shapeMaxWidth = 300;
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

    public function checkShape(shape: BaseShapeView): Bool {
        // todo: _stage.heigth = 0. Why???
        if (shape.isLower(Std.int(800))) {
            _shapesList.splice(_shapesList.indexOf(shape), 1);
            _stage.removeChild(shape);
            // todo: fire event onRemoveShape
            shape.dispose();
            return false;
        } else {
            return true;
        }
    }

    public function refresh(): Void {
        // todo: refresh UI
        // todo: refresh gravity
    }

    public function createRandomTriangle(): BaseShapeView {
        var shape = new PolygonView(3, _shapeMaxWidth);
        _shapesList.push(shape);
        _stage.addChild(shape);

        return shape;
    }

    public function createRandomQuadrangle(): BaseShapeView {
        var shape = new PolygonView(4, _shapeMaxWidth);
        _shapesList.push(shape);
        _stage.addChild(shape);

        return shape;
    }

    public function createRandomPentagon(): BaseShapeView { 
        var shape = new PolygonView(5, _shapeMaxWidth);
        _shapesList.push(shape);
        _stage.addChild(shape);

        return shape;
    }

    public function createRandomHexagon(): BaseShapeView {
        var shape = new PolygonView(6, _shapeMaxWidth);
        _shapesList.push(shape);
        _stage.addChild(shape);

        return shape;
    }

    public function createRandomCircle(): BaseShapeView { 
        var shape = new EllipseView(_shapeMaxWidth, true);
        _shapesList.push(shape);
        _stage.addChild(shape);

        return shape; 
    }

    public function createRandomEllipse(): BaseShapeView { 
        var shape = new EllipseView(_shapeMaxWidth);
        _shapesList.push(shape);
        _stage.addChild(shape);

        return shape; 
     }

    public function createRandomStar(): BaseShapeView { 
        var shape = new StarView(_shapeMaxWidth);
        _shapesList.push(shape);
        _stage.addChild(shape);

        return shape;
     }
}
