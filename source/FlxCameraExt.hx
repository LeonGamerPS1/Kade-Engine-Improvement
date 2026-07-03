package;

import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxFrame;
import flixel.system.FlxAssets.FlxShader;
import openfl.display.BlendMode;
import openfl.geom.ColorTransform;
import openfl.display.BitmapData;
import flixel.math.FlxMatrix;
import flixel.FlxG;
import flixel.FlxCamera;

class FlxCameraExt extends FlxCamera
{
	override public function drawPixels(?frame:FlxFrame, ?pixels:BitmapData, matrix:FlxMatrix, ?transform:ColorTransform, ?blend:BlendMode,
			?smoothing:Bool = false, ?shader:FlxShader):Void
	{
		if (FlxG.save.data != null && !FlxG.save.data.antialiasing)
			smoothing = false;
        @:private
		super.drawPixels(frame, pixels, matrix, transform, blend, smoothing, shader);
	}

	override public function startQuadBatch(graphic:FlxGraphic, colored:Bool, hasColorOffsets:Bool = false, ?blend:BlendMode, smooth:Bool = false,
			?shader:FlxShader)
	{
		if (FlxG.save.data != null && !FlxG.save.data.antialiasing)
			smooth = false;
      
		return super.startQuadBatch(graphic, colored, hasColorOffsets, blend, smooth, shader);
	}
}
