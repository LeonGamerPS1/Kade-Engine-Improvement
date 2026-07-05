package;

import flixel.graphics.tile.FlxDrawQuadsItem;
import flixel.math.FlxAngle;
import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxFrame;
import flixel.system.FlxAssets.FlxShader;
import openfl.display.BlendMode;
import openfl.geom.ColorTransform;
import openfl.display.BitmapData;
import flixel.math.FlxMatrix;
import flixel.FlxG;
import flixel.FlxCamera;

using flixel.util.FlxColorTransformUtil;
class FlxCameraExt extends FlxCamera
{
	public var rotateSprite(default, set):Bool = false;

	@:noCompletion
	var _sinAngle:Float = 0;

	@:noCompletion
	var _cosAngle:Float = 1;

	function set_rotateSprite(rotate:Bool):Bool
	{
		rotateSprite = rotate;
		set_angle(angle);
		return rotateSprite;
	}

	override function set_angle(Angle:Float):Float
	{
		angle = Angle;
		flashSprite.rotation = rotateSprite ? Angle : 0;

		var radians:Float = angle * FlxAngle.TO_RAD;
		_sinAngle = Math.sin(radians);
		_cosAngle = Math.cos(radians);
		return Angle;
	}

	override public function drawPixels(?frame:FlxFrame, ?pixels:BitmapData, matrix:FlxMatrix, ?transform:ColorTransform, ?blend:BlendMode,
			?smoothing:Bool = false, ?shader:FlxShader):Void
	{
		if (FlxG.save.data != null && !FlxG.save.data.antialiasing)
			smoothing = false;
		if (FlxG.renderBlit)
		{
			_helperMatrix.copyFrom(matrix);

			if (_useBlitMatrix)
			{
				_helperMatrix.concat(_blitMatrix);
				buffer.draw(pixels, _helperMatrix, null, null, null, (smoothing || antialiasing));
			}
			else
			{
				_helperMatrix.translate(-viewMarginLeft, -viewMarginTop);
				buffer.draw(pixels, _helperMatrix, null, blend, null, (smoothing || antialiasing));
			}
		}
		else
		{
			var isColored = (transform != null #if !html5 && transform.hasRGBMultipliers() #end);
			var hasColorOffsets:Bool = (transform != null && transform.hasRGBAOffsets());

			if (!rotateSprite && angle != 0)
			{
				matrix.translate(-width / 2, -height / 2);
				matrix.rotateWithTrig(_cosAngle, _sinAngle);
				matrix.translate(width / 2, height / 2);
			}

			#if FLX_RENDER_TRIANGLE
			final drawItem:FlxDrawTrianglesItem = startTrianglesBatch(frame.parent, smoothing, isColored, blend, hasColorOffsets, shader);
			#else
			final drawItem:FlxDrawQuadsItem = startQuadBatch(frame.parent, isColored, hasColorOffsets, blend, smoothing, shader);
			#end
			drawItem.addQuad(frame, matrix, transform);
		}
	}

	override public function startQuadBatch(graphic:FlxGraphic, colored:Bool, hasColorOffsets:Bool = false, ?blend:BlendMode, smooth:Bool = false,
			?shader:FlxShader)
	{
		if (FlxG.save.data != null && !FlxG.save.data.antialiasing)
			smooth = false;

		return super.startQuadBatch(graphic, colored, hasColorOffsets, blend, smooth, shader);
	}
}
