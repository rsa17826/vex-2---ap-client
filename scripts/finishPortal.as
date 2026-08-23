package
{
  import flash.display.MovieClip;
  import flash.events.Event;
  import flash.events.KeyboardEvent;
  import flash.ui.Keyboard;
  import flash.external.ExternalInterface;

  [Embed(source="/_assets/assets.swf", symbol="symbol338")]
  public class finishPortal extends MovieClip
  {

    public var main:MovieClip;

    public var player:MovieClip;

    public var hitbox:MovieClip;

    protected var particleTimer:int = 0;

    protected var particleSpawnRate:int = 3;

    protected var teleportingToThis:Boolean = false;

    private static var gKeyJustPressed:Boolean = false;
    private static var gKeyListenerAdded:Boolean = false;

    public function finishPortal()
    {
      super();
      addEventListener(Event.ADDED_TO_STAGE, this.pushArray);
    }

    private function setupKeyListener():void
    {
      if (!gKeyListenerAdded && stage)
      {
        gKeyListenerAdded = true;
        stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
      }
    }

    private function onKeyDown(param1:KeyboardEvent):void
    {
      if (!ExternalInterface.call("debugModeEnabled"))
      {
        return;
      }
      if (param1.keyCode == Keyboard.G)
      {
        ExternalInterface.call("newItem", "stage" + ((this.main.act == 0 ? 1 : this.main.act) - 1) + " - level:stage" + (this.main.act == 0 ? 1 : this.main.act));
        this.main.levelComplete();
      }
    }

    public function update():void
    {
      var _loc1_:int = 0;
      this.setupKeyListener();
      this.player = MovieClip(parent).player;
      if (this.hitbox.hitTestObject(this.player))
      {
        this.main.fadingIn = false;
        this.player.xSpeed = 0;
        this.player.ySpeed = 0;
        if (!this.player.teleporting)
        {
          this.main.playSound("Portal", false);
        }
        this.player.teleporting = true;
        this.teleportingToThis = true;
        additionalMaths.easeToPoint(this.player, x, y, 10);
        if (additionalMaths.getDistance(this.player, this) <= 1)
        {
          ExternalInterface.call("newItem", "stage" + ((this.main.act == 0 ? 1 : this.main.act) - 1) + " - level:stage" + (this.main.act == 0 ? 1 : this.main.act));
          this.main.levelComplete();
        }
        this.player.gotoAndStop(2);
        if (this.player.inner_animation.currentFrame < 28)
        {
          this.player.inner_animation.gotoAndPlay(28);
        }
        _loc1_ = 8;
        this.player.rotation += _loc1_ - Math.sqrt(this.player.scaleX * this.player.scaleX) * _loc1_;
        this.player.scaleX *= 0.95;
        if (this.player.scaleX > 0)
        {
          this.player.scaleY = this.player.scaleX;
        }
        else
        {
          this.player.scaleY = this.player.scaleX * -1;
        }
      }
      else if (this.player.teleporting)
      {
        if (this.teleportingToThis)
        {
          additionalMaths.easeToPoint(this.player, x, y, 10);
        }
      }
      this.createParticles();
      this.suckParticles();
    }

    protected function createParticles():void
    {
      var _loc1_:int = 0;
      var _loc2_:* = undefined;
      ++this.particleTimer;
      if (this.particleTimer > this.particleSpawnRate)
      {
        _loc1_ = 100;
        _loc2_ = new particle(4649252, 4, false);
        _loc2_.x = int(x + (Math.random() * (width + _loc1_) - width * 0.5 - _loc1_ * 0.5));
        _loc2_.y = int(y + (Math.random() * (this.hitbox.height + _loc1_) - this.hitbox.height * 0.5 - _loc1_ * 0.5));
        _loc2_.xSpeed = 0;
        _loc2_.ySpeed = 0;
        parent.addChild(_loc2_);
        this.particleTimer = 0;
      }
    }

    protected function suckParticles():void
    {
      var _loc3_:int = 0;
      var _loc1_:Array = this.main.particles;
      var _loc2_:int = 0;
      while (_loc2_ < _loc1_.length)
      {
        _loc3_ = additionalMaths.getDistance(this, _loc1_[_loc2_]);
        if (_loc3_ < 250)
        {
          if (_loc3_ < 50)
          {
            _loc1_[_loc2_].fadeTime = 150;
            _loc1_[_loc2_].alpha *= 0.5;
          }
          if (_loc1_[_loc2_].y < y)
          {
            _loc1_[_loc2_].ySpeed += 0.75;
          }
          else if (_loc1_[_loc2_].y > y)
          {
            _loc1_[_loc2_].ySpeed -= 0.75;
          }
          if (_loc1_[_loc2_].x < x)
          {
            _loc1_[_loc2_].xSpeed += 0.75;
          }
          else if (_loc1_[_loc2_].x > x)
          {
            _loc1_[_loc2_].xSpeed -= 0.75;
          }
        }
        _loc2_++;
      }
    }

    private function pushArray(param1:Event):void
    {
      if (this)
      {
        this.main = MovieClip(root);
        MovieClip(root).checkpoints.push(this);
        removeEventListener(Event.ADDED_TO_STAGE, this.pushArray);
      }
    }
  }
}