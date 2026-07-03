package;

import flixel.math.FlxMath;
import flixel.util.FlxDestroyUtil;
import flixel.math.FlxPoint;
import funkin.data.CharJson.DataIcon;
import flixel.FlxG;
import flixel.FlxSprite;

using StringTools;

class HealthIcon extends FlxSprite
{
	public var char:String = 'bf';
	public var isPlayer:Bool = false;
	public var isOldIcon:Bool = false;

	/**
	 * Used for FreeplayState! If you use it elsewhere, prob gonna annoying
	 */
	public var sprTracker:FlxSprite;

	public function new(?char:String = "bf", ?isPlayer:Bool = false)
	{
		super();

		this.char = char;
		this.isPlayer = isPlayer;

		isPlayer = isOldIcon = false;
		changeIcon(char);
	}

	public function swapOldIcon()
	{
		(isOldIcon = !isOldIcon) ? changeIcon("bf-old") : changeIcon(char);
	}

	var baseScale:FlxPoint = FlxPoint.get(1, 1);
	var bopScale:FlxPoint = FlxPoint.get(1, 1);

	public function loadFromData(data:DataIcon)
	{
		changeIcon(data?.iconName ?? 'dad');
		scale.set(data?.scale?.x ?? 1, data?.scale?.y ?? 1);
		antialiasing = data?.antialiasing ?? true;
		updateHitbox();
	}

	public function changeIcon(char:String)
	{
		loadGraphic(Paths.image('icons/icon-' + char));
		loadGraphic(Paths.image('icons/icon-' + char), true, Math.floor(frameWidth / 2), frameHeight);
		if (char.endsWith('-pixel') || char.startsWith('senpai') || char.startsWith('spirit'))
			antialiasing = false
		else
			antialiasing = FlxG.save.data.antialiasing;
		animation.add(char, [0, 1], 0, false, isPlayer);
		animation.play(char);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (sprTracker != null)
			setPosition(sprTracker.x + sprTracker.width + 10, sprTracker.y - 30);
	}

	override function destroy()
	{
		baseScale = FlxDestroyUtil.put(baseScale);
		bopScale = FlxDestroyUtil.put(bopScale);
		super.destroy();
	}

	public function bump(mult:Float = 1)
	{
		scale.copyFrom(baseScale).scale(mult * bopScale.x, mult * bopScale.y);
		updateHitbox();
	}

	public function bumpLerp(mult:Float = 1)
	{
		final LERP = Math.exp(-FlxG.elapsed * 8);
		var iconLerpX = FlxMath.lerp(baseScale.x, scale.x, LERP);
		var iconLerpY = FlxMath.lerp(baseScale.y, scale.y, LERP);
		scale.set(iconLerpX, iconLerpY);
		updateHitbox();
	}
}
