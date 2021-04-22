package;

import model.Model;
import view.View;
import controller.Controller;

import openfl.display.Stage in OpenFLStage;
import openfl.events.Event;

import haxe.Timer;


class Main {
	private static var _curTime: Float;
	private static var _prevTime: Float;

	static function main() {
		var stage = new OpenFLStage(800, 800, 0xffffff);
        var content = js.Browser.document.getElementById("content");
        content.appendChild(stage.element);

		var model = new Model();
		var view = new View(stage, model);
		var controller = new Controller(model, view);
		controller.launch();

		stage.addEventListener(Event.ENTER_FRAME, function (event: Event) {
			var dt: Float = 0;

			_curTime = Timer.stamp();
			if (_prevTime != null) {
				dt = _curTime - _prevTime;
			}
			_prevTime = _curTime;

			controller.update(dt);
			view.update(dt);
		});
	}
}
