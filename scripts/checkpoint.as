package
{
  import flash.display.MovieClip;
  import flash.events.Event;
  import flash.geom.Point;
  import flash.external.ExternalInterface;

  [Embed(source="/_assets/assets.swf", symbol="symbol1610")]
  public class checkpoint extends MovieClip
  {

    private var animated:Boolean = false;

    public var main:MovieClip;

    public var player:MovieClip;

    public var animation:MovieClip;

    public var lettersArray:Array = [];

    public function checkpoint()
    {
      super();
      addFrameScript(0, this.frame1);
      addEventListener(Event.ADDED_TO_STAGE, this.pushArray);
      // NOTE fixes hitboxes on first level load to be same as after first reset
      this.reset();
    }

    public function update():void
    {
      var _loc1_:int = 0;
      var _loc2_:Object = null;
      var _loc3_:Point = null;
      this.player = MovieClip(parent).player;
      if (this.hitTestObject(this.player))
      {
        if (ExternalInterface.call("dontWantCheckpoints"))
        {
          this.player.kill(20);
          return;
        }
        if (currentFrame == 1)
        {
          this.nullCheckpoints();
          gotoAndStop(2);
          this.scanLetters();
          this.player.checkPoint.x = x;
          this.player.checkPoint.y = y - 40;
          ++this.player.checkpointsReached;
          ++this.main.stats[8];
          this.main.playSound("ding", false);
          this.checkLockBlocks();
          this.resetPlayerTraits();
          this.resetLevers();
        }
      }
      if (currentFrame == 2)
      {
        if (!this.animated)
        {
          _loc1_ = 0;
          while (_loc1_ < this.animation.numChildren)
          {
            _loc2_ = this.animation.getChildAt(_loc1_);
            _loc3_ = this.lettersArray[_loc1_];
            additionalMaths.easeToPoint(_loc2_, _loc3_.x, _loc3_.y, _loc1_ + 2);
            _loc2_.alpha += 0.1;
            if (_loc1_ == this.animation.numChildren - 1 && _loc2_.x == Math.round(_loc3_.x) && _loc2_.y == Math.round(_loc3_.y))
            {
              this.animated = true;
            }
            _loc1_++;
          }
        }
        else if (this.animation.getChildAt(this.animation.numChildren - 1).alpha > 0)
        {
          _loc1_ = 0;
          while (_loc1_ < this.animation.numChildren)
          {
            _loc2_ = this.animation.getChildAt(_loc1_);
            _loc2_.alpha -= 0.1;
            _loc1_++;
          }
        }
      }
      else if (currentFrame == 3)
      {
        if (this.animation)
        {
          if (this.animation.getChildAt(this.animation.numChildren - 1).alpha > 0)
          {
            _loc1_ = 0;
            while (_loc1_ < this.animation.numChildren)
            {
              _loc2_ = this.animation.getChildAt(_loc1_);
              _loc2_.alpha -= 0.1;
              _loc1_++;
            }
          }
        }
      }
    }

    private function nullCheckpoints():void
    {
      var _loc1_:* = MovieClip(root).checkpoints;
      var _loc2_:int = 0;
      while (_loc2_ < _loc1_.length)
      {
        if (_loc1_[_loc2_].currentFrame == 2)
        {
          _loc1_[_loc2_].gotoAndStop(3);
        }
        _loc2_++;
      }
    }

    protected function checkLockBlocks():void
    {
      var _loc1_:* = MovieClip(root).obstacles;
      var _loc2_:int = 0;
      while (_loc2_ < _loc1_.length)
      {
        if (_loc1_[_loc2_] is key)
        {
          if (!_loc1_[_loc2_].visible)
          {
            _loc1_[_loc2_].saveUse = true;
          }
        }
        _loc2_++;
      }
      var _loc3_:* = MovieClip(root).blocks;
      var _loc4_:int = 0;
      while (_loc4_ < _loc3_.length)
      {
        if (_loc3_[_loc4_] is lockBlock)
        {
          if (_loc3_[_loc4_].unlocked)
          {
            _loc3_[_loc4_].saveUse = true;
          }
        }
        else if (_loc3_[_loc4_] is pushBlock)
        {
          if (_loc3_[_loc4_].pushed)
          {
            _loc3_[_loc4_].saveUse = true;
          }
        }
        _loc4_++;
      }
    }

    private function scanLetters():void
    {
      var _loc2_:Object = null;
      var _loc3_:* = undefined;
      var _loc1_:int = 0;
      while (_loc1_ < this.animation.numChildren)
      {
        _loc2_ = this.animation.getChildAt(_loc1_);
        _loc3_ = new Point(_loc2_.x, _loc2_.y);
        this.lettersArray.push(_loc3_);
        _loc2_.alpha = 0;
        _loc2_.x = 40;
        _loc2_.y = 20;
        _loc1_++;
      }
    }

    private function pushArray(param1:Event):void
    {
      var _loc2_:int = 0;
      var _loc3_:Object = null;
      if (this)
      {
        this.main = MovieClip(root);
        MovieClip(root).checkpoints.push(this);
        removeEventListener(Event.ADDED_TO_STAGE, this.pushArray);
        _loc2_ = 0;
        while (_loc2_ < this.animation.numChildren)
        {
          _loc3_ = this.animation.getChildAt(_loc2_);
          _loc3_.alpha = 0;
          _loc2_++;
        }
      }
    }

    private function resetPlayerTraits():void
    {
      var _loc1_:* = undefined;
      var _loc2_:int = 0;
      this.player.filters = [];
      if (this.player.gravity != this.player.startGravity)
      {
        _loc1_ = new gravityChange();
        _loc1_.x = 0;
        if (this.player.gravity > this.player.startGravity)
        {
          _loc1_.y = this.main.stageHeight;
          _loc1_.direction = "up";
          _loc1_.blendMode = "screen";
          this.main.addChild(_loc1_);
          this.main.setChildIndex(_loc1_, this.main.getChildIndex(this.main.level) + 1);
          adjustColour.colourChange(_loc1_, 130, 100, 0, 0);
        }
        else
        {
          _loc1_.y = -_loc1_.height;
          _loc1_.direction = "down";
          _loc1_.blendMode = "screen";
          this.main.addChild(_loc1_);
          this.main.setChildIndex(_loc1_, this.main.getChildIndex(this.main.level) + 1);
        }
        this.player.gravity = this.player.startGravity;
      }
      if (this.player.maxSpeed != 6)
      {
        _loc1_ = new gravityChange();
        _loc1_.x = 0;
        _loc1_.y = -_loc1_.height;
        _loc1_.direction = "down";
        _loc1_.blendMode = "screen";
        this.main.addChild(_loc1_);
        this.main.setChildIndex(_loc1_, this.main.getChildIndex(this.main.level) + 1);
        adjustColour.colourChange(_loc1_, -85, 0, 40, 0);
        this.player.maxSpeed = 6;
      }
      if (this.main.dark is darkOverlay)
      {
        this.main.removeChild(this.main.dark);
        this.main.dark = null;
        // this.main.dark = new flashOverlay();
        // this.main.dark.x = this.player.x + parent.x;
        // this.main.dark.y = this.player.y + parent.y - this.player.height * 0.5;
        // this.main.addChild(this.main.dark);
        // _loc2_ = this.main.getChildIndex(this.main.level) + 1;
        // this.main.setChildIndex(this.main.dark,_loc2_);
      }
    }

    private function resetLevers():void
    {
      var _loc1_:Array = this.main.obstacles;
      var _loc2_:Boolean = false;
      var _loc3_:int = 0;
      while (_loc3_ < _loc1_.length)
      {
        if (_loc1_[_loc3_] is lever)
        {
          if (_loc1_[_loc3_].active)
          {
            _loc1_[_loc3_].active = false;
            _loc2_ = true;
          }
        }
        _loc3_++;
      }
      if (_loc2_)
      {
        this.main.playSound("powerDown", false);
      }
      this.player.destLevelTintStr = 0;
    }

    public function reset():void
    {
      gotoAndStop(1);
      this.lettersArray = [];
      this.animated = false;
      this.scanLetters();
    }

    internal function frame1():*
    {
      stop();
    }
  }
}
