package controller;

import view.shapes.BaseShapeView;
import model.Model;
import view.View;

import Math;

class Controller {
    private var _timer: Float;
    private var _model: Model;
    private var _view: View;
    private var _isActive: Bool;

    public function new(model:Model, view:View) {
        _model = model;
        _view = view;
        _timer = 0;
        _isActive = false;
    }

    public function launch(): Void {
        _isActive = true;
    }

    public function update(dt: Float): Void {
        if (!_isActive) {
            return;
        }

        if (_timer >= 1) {
            for(i in 0..._model.getShapesPerSec()) {
                createRandomShape();
            }
        }
        _timer = _timer >= 1 ? 0 : _timer + dt;
    }

    private function createRandomShape(): Void {
        var shapeTypes = 7;
        var probability = (Math.random() * 100) / (100 / shapeTypes);
        var shape: BaseShapeView;
        
        if (probability <= 1) {
            shape = _view.createRandomTriangle();
        } else if (probability <= 2) {
            shape = _view.createRandomQuadrangle();
        } else if(probability <= 3) {
            shape = _view.createRandomPentagon();
        } else if (probability <= 4) {
            shape = _view.createRandomHexagon();
        } else if (probability <= 5) {
            shape = _view.createRandomCircle();
        } else if (probability <= 6) {
            shape = _view.createRandomEllipse();
        } else {
            shape = _view.createRandomStar();
        }

        _model.addArea(shape.getAreaValue());
        _view.refresh();
    }

    private function onRemoveShape(shape: BaseShapeView): Void {
        _model.removeArea(shape.getAreaValue());
        _view.refresh();
    }
}
