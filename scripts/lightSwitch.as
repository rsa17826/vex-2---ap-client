package
{
  import flash.display.MovieClip;
  import flash.events.Event;
  import flash.filters.BevelFilter;
  import flash.filters.DropShadowFilter;
  import flash.ui.Keyboard;
  import flash.events.KeyboardEvent;

  [Embed(source="/_assets/assets.swf", symbol="symbol378")]
  public class lightSwitch extends MovieClip
  {
    private function setupKeyListener():void
    {
      if (!gKeyListenerAdded && stage)
      {
        gKeyListenerAdded = true;
        stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
      }
    }

    private static var lKeyJustPressed:Boolean = false;
    private function onKeyDown(param1:KeyboardEvent):void
    {
      if (param1.keyCode == Keyboard.L)
      {
        lKeyJustPressed = true;
      }
    }
    private static var gKeyListenerAdded:Boolean = false;
    public var main:MovieClip;

    public var arrayIndex:int;

    public var toggle:MovieClip;

    private var shadow:DropShadowFilter;

    private var bevel:BevelFilter;

    public function lightSwitch()
    {
      super();
      addEventListener(Event.ADDED_TO_STAGE, this.pushArray);
    }

    public function update():void
    {
      var _loc1_:int = 0;
      if (this.hitTestObject(this.main.level.player) || lKeyJustPressed)
      {
        lKeyJustPressed = false;
        if (this.main.dark == null)
        {
          this.main.playSound("nightVision", false);
          this.main.dark = new darkOverlay();
          this.main.dark.x = this.main.level.player.x + this.main.level.x;
          this.main.dark.y = this.main.level.player.y + this.main.level.y - this.main.level.player.height * 0.5;
          // TODO
          this.main.addChild(this.main.dark);
          _loc1_ = this.main.getChildIndex(this.main.level) + 1;
          this.main.setChildIndex(this.main.dark,_loc1_);
          this.toggle.gotoAndStop(2);
        }
      }
    }

    private function pushArray(param1:Event):*
    {
      this.shadow = new DropShadowFilter(1, 45, 0, 1, 3, 3, 0.25, 3);
      this.bevel = new BevelFilter(1, 45, 16777215, 1, 0, 1, 1, 1, 0.73);
      filters = [this.shadow, this.bevel];
      this.main = MovieClip(root);
      this.arrayIndex = this.main.obstacles.length;
      this.main.obstacles.push(this);
      removeEventListener(Event.ADDED_TO_STAGE, this.pushArray);
    }

    public function respawn():void
    {
      this.toggle.gotoAndStop(1);
    }
  }
}
