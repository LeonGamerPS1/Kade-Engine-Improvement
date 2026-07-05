package funkin.states.editors;

import openfl.geom.Rectangle;
import flixel.FlxSprite;
import funkin.data.CharJson.CharacterData;
import flixel.addons.ui.FlxUICheckBox;
import flixel.addons.ui.FlxUINumericStepper;
import flixel.addons.ui.FlxUIDropDownMenu;
import flixel.text.FlxText;
import flixel.addons.ui.FlxUIButton;
import flixel.addons.ui.FlxUI;
import flixel.addons.ui.FlxUITabMenu;
import flixel.FlxCamera;
import flixel.util.FlxColor;
import flixel.addons.display.FlxGridOverlay;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.addons.display.FlxBackdrop;
import flixel.addons.ui.FlxUIState;

class CharacterEdit extends FlxUIState
{
	var character:Character;

	var bg:FlxBackdrop;
	var camFollow:FlxObject;
	var adolf:FlxCamera;
	var animDropDowns:Array<FlxUIDropDownMenu> = [];

	public function new(characterName:String = "", ?isPlayer:Bool = false)
	{
		super();
		character = new Character(0, 0, characterName, isPlayer);

		ghost = new FlxAnimate();
		adolf = new FlxCamera();
		adolf.bgColor = 0x0;
	}

	var UI_box:FlxUITabMenu;
	var tabs = [{name: "Character", label: 'Character'}, {name: "Ghost", label: 'Ghost'}];
	var ghost:FlxAnimate; // FlxAnimate inncase the char is adobe atlas
	var uiChar:FlxUI;
	var uiGhost:FlxUI;
	var controls = PlayerSettings.player1.controls;
	var animationNames:Array<String> = [];

	override function create()
	{
		FlxG.cameras.add(adolf, false);
		UI_box = new FlxUITabMenu(null, tabs, true);
		UI_box.resize(400, 400);
		UI_box.x = 0;
		UI_box.y = 20;
		UI_box.cameras = [adolf];
		add(UI_box);

		refreshAnimList();
		addCharUI();
		addGhostUI();

		camera.bgColor = FlxColor.GRAY;
		var Stage = new Stage("stage");
		for (i in Stage.toAdd)
		{
			add(i);
		}
		add(ghost);
		add(character);
		for (array in Stage.layInFront)
		{
			for (bg in array)
				add(bg);
		}

		camFollow = new FlxObject();
		camFollow.setPosition(character.x, character.y);
		FlxG.camera.follow(camFollow, LOCKON, 0.09);
		add(camFollow);

		cross = new FlxSprite();
		cross.makeGraphic(16, 16, 0x00000000, false, 'cross_graphic');
		cross.pixels.fillRect(new Rectangle(0, 8, 16, 1), 0xFFFFFFFF);
		cross.pixels.fillRect(new Rectangle(8, 0, 1, 16), 0xFFFFFFFF);
		add(cross);

		FlxG.camera.snapToTarget();
		updateGhost();
	}

	function refreshAnimList()
	{
		animationNames.resize(0);
		for (anim in character.animation.getAnimationList())
			animationNames.push(anim.name);
	}

	var ghostAnim:String;

	public function updateGhost()
	{
		// 1. Copy over visual properties and textures first
		ghost.alpha = 0.5;
		ghost.color = FlxColor.GRAY;
		ghost.frames = character.frames;
		ghost.scale.copyFrom(character.scale);
		ghost.origin.copyFrom(character.origin);
		ghost.anim.copyFrom(character.anim);
		ghost.updateHitbox();
		ghost.setPosition(character.x, character.y);
		ghostAnim ??= character.anim.name;
		// 4. Handle animation switching safely
		ghost.anim.play(ghostAnim, true);
		ghost.offset.set(character.animOffsets.get(ghostAnim)[0], character.animOffsets.get(ghostAnim)[1]);
	}

	function addGhostUI()
	{
		uiGhost = new FlxUI(null, UI_box);
		uiGhost.name = "Ghost";
		uiGhost.cameras = UI_box.cameras;
		UI_box.addGroup(uiGhost);

		var placeGhost:FlxUIButton = new FlxUIButton(25, 50, 'Place Ghost', updateGhost);
		placeGhost.x = 50;
		uiGhost.add(placeGhost);

		var animationDropDown:FlxUIDropDownMenu = new FlxUIDropDownMenu(25, 25, FlxUIDropDownMenu.makeStrIdLabelArray(animationNames, true), (anim) ->
		{
			ghostAnim = animationNames[Std.parseInt(anim)];
			updateGhost();
		}); // uiGhost.add(new FlxText(50, placeGhost.y - 15, 0, 'Place Ghost:'));
		uiGhost.add(animationDropDown);
		animDropDowns.push(animationDropDown);
		uiGhost.add(new FlxText(animationDropDown.x, animationDropDown.y - 60, 0, 'Ghost Animation:'));
	}

	function addCharUI()
	{
		uiChar = new FlxUI(null, UI_box);
		uiChar.name = "Character";
		uiChar.cameras = UI_box.cameras;
		UI_box.addGroup(uiChar);

		var animationDropDown:FlxUIDropDownMenu = new FlxUIDropDownMenu(25, 25, FlxUIDropDownMenu.makeStrIdLabelArray(animationNames, true), (anim) ->
		{
			character.playAnim(animationNames[Std.parseInt(anim)]);
		});
		animDropDowns.push(animationDropDown);

		var stepperPosOffsetX:FlxUINumericStepper = new FlxUINumericStepper(animationDropDown.x + animationDropDown.width + 10, 25, 10,
			character?.json?.global_offset.x ?? 0, -90000, 90000, 0);

		var stepperPosOffsetY:FlxUINumericStepper = new FlxUINumericStepper(animationDropDown.x + animationDropDown.width + 10, 25 + stepperPosOffsetX.height,
			1, character?.json?.global_offset.y ?? 0, -90000, 90000, 0);
		uiChar.add(stepperPosOffsetX);
		uiChar.add(stepperPosOffsetY);

		var stepperPosOffsetXCam:FlxUINumericStepper = new FlxUINumericStepper(stepperPosOffsetX.x + stepperPosOffsetX.width + 50, 25, 10,
			character?.json?.camera_offset.x ?? 0, -90000, 90000, 0);

		var stepperPosOffsetYCam = new FlxUINumericStepper(stepperPosOffsetX.x + stepperPosOffsetX.width + 50, 25 + stepperPosOffsetX.height, 1,
			character?.json?.camera_offset.y ?? 0, -90000, 90000, 0);
		uiChar.add(stepperPosOffsetXCam);
		uiChar.add(stepperPosOffsetYCam);
		stepperPosOffsetXCam.name = 'camOX';
		stepperPosOffsetYCam.name = 'camOY';
		stepperPosOffsetX.name = 'posOX';
		stepperPosOffsetY.name = 'posOY';

		isPlayer = new FlxUICheckBox(animationDropDown.x, animationDropDown.y + 20, null, null, 'Player Side', 50, null, () ->
		{
			character.isPlayer = isPlayer.checked;
			updatePlayerPosIG();
		});
		isPlayer.checked = character.isPlayer;
		uiChar.add(isPlayer);

		flipX = new FlxUICheckBox(animationDropDown.x, animationDropDown.y + 40, null, null, 'FlippedX', 50, null, () ->
		{
			if (character.json != null)
				character.json.flip.x = flipX.checked;
			character.flipX = isPlayer.checked;
			updatePlayerPosIG();
		});
		flipX.checked = character.json?.flip.x ?? false;
		uiChar.add(flipX);

		uiChar.add(animationDropDown);
		uiChar.add(new FlxText(animationDropDown.x, animationDropDown.y - 60, 0, 'Current Animation:'));
		uiChar.add(new FlxText(stepperPosOffsetX.x, stepperPosOffsetX.y - 60, 0, 'Global Offset X/Y:'));
		uiChar.add(new FlxText(stepperPosOffsetXCam.x, stepperPosOffsetXCam.y - 60, 0, 'Camera Offset X/Y:'));
	}

	function updatePlayerPosIG()
	{
		character.flipX = (flipX.checked ?? false) != character.isPlayer;
	}

	var flipX:FlxUICheckBox;
	var isPlayer:FlxUICheckBox;
	var cross:FlxSprite;

	override function update(elapsed:Float)
	{
		final mainPos = !character.isPlayer ? dadPos : bfPos;
		final offsetX = character.json?.camera_offset?.x ?? 0.0;
		final offsetY = character.json?.camera_offset?.y ?? 0.0;
		if (!character.isPlayer)
			cross.setPosition(character.getMidpoint().x + 150 + offsetX, character.getMidpoint().y - 100 + offsetY);

		super.update(elapsed);
		final adde = elapsed * 600;
		final add2 = 1.5;
		character.holdTimer = 0;
		character.setPosition(mainPos[0] + offsetX, mainPos[1] + offsetY);

		if (controls.LEFT)
			camFollow.x -= adde;
		if (controls.DOWN)
			camFollow.y += adde;
		if (controls.UP)
			camFollow.y -= adde;
		if (controls.RIGHT)
			camFollow.x += adde;

		if (FlxG.keys.pressed.E)
			camera.zoom += elapsed * add2;
		if (FlxG.keys.pressed.Q)
			camera.zoom -= elapsed * add2;

		if (FlxG.keys.justPressed.SPACE)
			character.playAnim(character.animation.name, true);
		flipX.active = flipX.visible = isPlayer.visible = isPlayer.active = !animDropDowns[0].dropPanel.visible;
	}

	var dadPos = [100, 100];
	var bfPos = [770, 100];

	override function getEvent(id:String, sender:Dynamic, data:Dynamic, ?params:Array<Dynamic>)
	{
		super.getEvent(id, sender, data, params);
		trace('$id $sender $data $params');

		if (id == FlxUIDropDownMenu.CLICK_EVENT)
		{
			var check:FlxUIDropDownMenu = cast sender;
			var label = check.name;
			trace(label);
		}
		else if (id == FlxUINumericStepper.CHANGE_EVENT && (sender is FlxUINumericStepper))
		{
			var nums:FlxUINumericStepper = cast sender;
			var wname = nums.name;
			trace(wname);
			switch (wname)
			{
				case 'camOX':
					if (character.json != null)
						character.json.camera_offset.x = nums.value;
				case 'camOY':
					if (character.json != null)
						character.json.camera_offset.y = nums.value;

				case 'posOX':
					if (character.json != null)
						character.json.global_offset.x = nums.value;
				case 'posOY':
					if (character.json != null)
						character.json.global_offset.y = nums.value;
			}
		}
	}
}
