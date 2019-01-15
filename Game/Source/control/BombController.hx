package control;

import display.game.BombTile;

class BombController extends ObjectController<BombTile> {

	public var active(default, null):Bool;
	public var passthrough(default, null):Bool;
	
	public function new() {
		super(Physics.bomb, Main.instance.gameState.tilemap.bomb);
	}
	
	override function activate():Void {
		super.activate();
		active = false;
	}
	
	override function update(delta:Float):Void {
		if (!active)
			return;
		
		super.update(delta);
		
		if (passthrough && body.position.y > tile.height) {
			body.cbTypes.remove(Physics.cbTypePassthrough);
			passthrough = false;
			
		} else if (body.position.y > Physics.GROUND_Y - tile.originY) {
			explode();
		}
	}
	
	override function updateTile():Void {
		super.updateTile();
		tile.rotation = body.rotation * (180 / Math.PI);
	}
	
	public function spawn(left:Bool):Void {
		var spaceHalfWidth = Physics.SPACE_WIDTH / 2;
		var padding = 30;
		var fenceHalfWidth = Main.instance.gameState.tilemap.fence.originX;
		body.position.x = (left ? 0 : spaceHalfWidth + fenceHalfWidth) + padding + (spaceHalfWidth - fenceHalfWidth - padding) / 2;
		body.position.y = -tile.height;
		body.velocity.setxy(0, 0);
		body.rotation = 0;
		body.angularVel = 0;
		body.space = Physics.space;
		body.cbTypes.add(Physics.cbTypePassthrough);
		passthrough = true;
		active = true;
		tile.playNormal();
	}
	
	function explode():Void {
		tile.explode(function() onExplosionComplete(body.position.x > Physics.SPACE_WIDTH / 2));
		body.space = null;
		active = false;
	}
	
	function onExplosionComplete(leftScored:Bool):Void {
		spawn(leftScored);
	}
	
}