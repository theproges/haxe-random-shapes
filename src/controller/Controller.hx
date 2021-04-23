package controller;

import config.SystemEvents;
import services.EventService;
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

        EventService.subscribe(SystemEvents.ShapeOutOfScreen, function(shapeIndex: Int) { onShapeOutOfScreen(shapeIndex); });
        EventService.subscribe(SystemEvents.OnPointerDown, function(event) { onPointerDown(event); });
        EventService.subscribe(SystemEvents.OnGravityIncrease, function(event) { onGravityIncrease(); });
        EventService.subscribe(SystemEvents.OnGravityDecrease, function(event) { onGravityDecrease(); });
        EventService.subscribe(SystemEvents.OnShapesPerSecIncrease, function(event) { onShapesPerSecIncrease(); });
        EventService.subscribe(SystemEvents.OnShapesPerSecDecrease, function(event) { onShapesPerSecDecrease(); });
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

    private function createRandomShape(?x: Int, ?y: Int): Void {
        var shapeTypes = 7;
        var probability = (Math.random() * 100) / (100 / shapeTypes);
        var shape: BaseShapeView;
        
        if (probability <= 1) {
            shape = _view.createRandomTriangle(x, y);
        } else if (probability <= 2) {
            shape = _view.createRandomQuadrangle(x, y);
        } else if(probability <= 3) {
            shape = _view.createRandomPentagon(x, y);
        } else if (probability <= 4) {
            shape = _view.createRandomHexagon(x, y);
        } else if (probability <= 5) {
            shape = _view.createRandomCircle(x, y);
        } else if (probability <= 6) {
            shape = _view.createRandomEllipse(x, y);
        } else {
            shape = _view.createRandomStar(x, y);
        }

        _model.addArea(shape.getAreaValue());
        _view.refresh();
    }

    private function onShapeOutOfScreen(shapeIndex: Int): Void {
        var area = _view.getShapeByIndex(shapeIndex).getAreaValue();
        _model.removeArea(area);
        _view.destroyShape(shapeIndex);
        _view.refresh();
    }

    private function onPointerDown(event: Dynamic): Void {
        var x = event.offsetX;
        var y = event.offsetY;
        var shapeIndex = _view.getShapeIndexByCoords(x, y);

        if (shapeIndex != null) {
            onShapeOutOfScreen(shapeIndex);
        } else {
            createRandomShape(x, y);
        }

        _view.refresh();
    }

    private function onGravityIncrease(): Void {
        _model.increaseGravity();
        _view.refresh();
    }

    private function onGravityDecrease(): Void {
        _model.decreaseGravity();
        _view.refresh();
    }

    private function onShapesPerSecIncrease(): Void {
        _model.increaseShapesPerSec();
        _view.refresh();
    }

    private function onShapesPerSecDecrease(): Void {
        _model.decreaseShapesPerSec();
        _view.refresh();
    }
}
