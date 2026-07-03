package funkin.other;

import flixel.FlxG;
import flixel.FlxCamera;
import flixel.system.frontEnds.CameraFrontEnd;

class CustomCameraFrontEnd extends CameraFrontEnd
{
	override public function reset(?NewCamera:FlxCamera):Void
	{
		while (list.length > 0)
			remove(list[0]);

		if (NewCamera == null)
			NewCamera = new FlxCameraExt(0, 0, FlxG.width, FlxG.height);

		FlxG.camera = add(NewCamera);
		NewCamera.ID = 0;

		FlxCamera._defaultCameras = defaults;
	}
}
