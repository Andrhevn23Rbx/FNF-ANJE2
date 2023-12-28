package;

import flixel.math.FlxMath;
import flixel.FlxSprite;
import openfl.utils.Assets as OpenFlAssets;
import flixel.FlxG;

using StringTools;

class HealthIcon extends FlxSprite
{
	public var sprTracker:FlxSprite;
	public var canBounce:Bool = false;
	private var isOldIcon:Bool = false;
	private var isPlayer:Bool = false;
	private var char:String = '';
	public var iconAmount:Int = 2;

	public function new(char:String = 'bf', isPlayer:Bool = false, ?allowGPU:Bool = true)
	{
		super();
		isOldIcon = (char == 'bf-old');
		this.isPlayer = isPlayer;
		changeIcon(char);
		if (char == 'bf') iconAmount = 3;
		scrollFactor.set();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (sprTracker != null)
			setPosition(sprTracker.x + sprTracker.width + 10, sprTracker.y - 30);

		if(canBounce) {
			var mult:Float = FlxMath.lerp(1, scale.x, CoolUtil.boundTo(1 - (elapsed * 9), 0, 1));
			scale.set(mult, mult);
			updateHitbox();
		}
	}

	public function swapOldIcon() {
		if(isOldIcon = !isOldIcon) changeIcon('bf-old');
		else changeIcon('bf');
	}

	public function changeIconAmount(amount:Int) {
		if(this.iconAmount != amount) {
			var name:String = 'icons/' + char;
			if(!Paths.fileExists('images/' + name + '.png', IMAGE)) name = 'icons/icon-' + char; //Older versions of psych engine's support
			if(!Paths.fileExists('images/' + name + '.png', IMAGE)) name = 'icons/icon-face'; //Prevents crash from missing icon
			var file:Dynamic = Paths.image(name);

			loadGraphic(file); //Load stupidly first for getting the file size
			switch(amount) 
			{
				case 3:
					loadGraphic(file, true, Math.floor(width / 3), Math.floor(height)); //Then load it fr
					iconOffsets[0] = (width - 150) / 3;
					iconOffsets[1] = (width - 150) / 3;
					iconOffsets[2] = (width - 150) / 3;
				case 2:
					loadGraphic(file, true, Math.floor(width / 2), Math.floor(height)); //Then load it fr
					iconOffsets[0] = (width - 150) / 2;
					iconOffsets[1] = (width - 150) / 2;
				case 1:
					loadGraphic(file, true, Math.floor(width), Math.floor(height)); //Then load it fr
					iconOffsets[0] = (width - 150);
			}
			
			updateHitbox();
			switch(amount)
			{
				case 3:
					animation.add(char, [0, 1, 2], 0, false, isPlayer);
				case 2:
					animation.add(char, [0, 1], 0, false, isPlayer);
				case 1:
					animation.add(char, [0], 0, false, isPlayer);
			}
			this.iconAmount = amount;
		}
	}

	private var iconOffsets:Array<Float> = [0, 0, 0];
	public function changeIcon(char:String) {
		if(this.char != char) {
			var name:String = 'icons/' + char;
			if(!Paths.fileExists('images/' + name + '.png', IMAGE)) name = 'icons/icon-' + char; //Older versions of psych engine's support
			if(!Paths.fileExists('images/' + name + '.png', IMAGE)) name = 'icons/icon-face'; //Prevents crash from missing icon
			var file:Dynamic = Paths.image(name);

			loadGraphic(file); //Load stupidly first for getting the file size
			var width2 = width;
			if (width == 450) {
				loadGraphic(file, true, Math.floor(width / 3), Math.floor(height)); //Then load it fr // winning icons go br
				iconOffsets[0] = (width - 150) / 3;
				iconOffsets[1] = (width - 150) / 3;
				iconOffsets[2] = (width - 150) / 3;
				iconAmount = 3;
			} else {
				loadGraphic(file, true, Math.floor(width / 2), Math.floor(height)); //Then load it fr // winning icons go br
				iconOffsets[0] = (width - 150) / 2;
				iconOffsets[1] = (width - 150) / 2;
				iconAmount = 2;
			}

			updateHitbox();
			if (width2 == 450) {
				animation.add(char, [0, 1, 2], 0, false, isPlayer);
			} else {
				animation.add(char, [0, 1], 0, false, isPlayer);
			}
			updateHitbox();
			animation.play(char);
			this.char = char;

			antialiasing = ClientPrefs.globalAntialiasing;
			if(char.endsWith('-pixel')) {
				antialiasing = false;
			}
		}
	}

	//Gets the amount of icons that should be used. Only compatible with normal icons
	public function getIconAmount(char:String) {
			var name:String = 'icons/' + char;
			if(!Paths.fileExists('images/' + name + '.png', IMAGE)) name = 'icons/icon-' + char; //Older versions of psych engine's support
			if(!Paths.fileExists('images/' + name + '.png', IMAGE)) name = 'icons/icon-face'; //Prevents crash from missing icon
			var file:Dynamic = Paths.image(name);

			loadGraphic(file); //Load stupidly first for getting the file size
			var width2 = width;
			if (width > 300)
				changeIconAmount(3);
			else if (width > 150 && width < 300)
				changeIconAmount(2);
			else if (width <= 150)
				changeIconAmount(1);
	}

	public function bounce() {
		if(canBounce) {
			var mult:Float = 1.2;
			scale.set(mult, mult);
			updateHitbox();
		}
	}

	override function updateHitbox()
	{
		if (ClientPrefs.iconBounceType != 'Golden Apple' && ClientPrefs.iconBounceType != 'Dave and Bambi' || Type.getClassName(Type.getClass(FlxG.state)) != 'PlayState')
		{
		super.updateHitbox();
		offset.x = iconOffsets[0];
		offset.y = iconOffsets[1];
		} else {
		super.updateHitbox();
		}
	}

	public function getCharacter():String {
		return char;
	}
}
