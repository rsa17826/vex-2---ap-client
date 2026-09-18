package
{
  import flash.display.MovieClip;
  import flash.display.Shape;
  import flash.events.Event;
  import flash.filters.GlowFilter;
  import flash.geom.Point;
  import flash.external.ExternalInterface;

  [Embed(source="/_assets/assets.swf", symbol="symbol284")]
  public class key extends MovieClip
  {

    public var target:MovieClip;

    public var main:MovieClip;

    public var arrayIndex:int;

    private var startPoint:Point = new Point();

    private var traceLine:Shape;

    private var gravity:Number = 0;

    private var used:Boolean = false;

    public var keyNum:Number = 0;

    public var saveUse:Boolean = false;

    public function key()
    {
      super();
      addEventListener(Event.ADDED_TO_STAGE, this.pushArray);
      rotation = -5;
      this.gravity = 0;
    }

    public function update():void
    {
      var _loc1_:MovieClip = null;
      var _loc2_:int = 0;
      var _loc3_:Array = null;
      var _loc4_:int = 0;
      if (!visible)
      {
        return;
      }
      if (this.used)
      {
        if (scaleX > 0.1)
        {
          scaleX -= 0.1;
          scaleY = scaleX;
          rotation -= 5;
        }
        else
        {
          this.endKey();
        }
        return;
      }
      _loc1_ = MovieClip(parent).player;
      if (this.target == null)
      {
        if (this.hitTestObject(_loc1_) && ExternalInterface.call("canUseMove", "key"))
        {
          ++_loc1_.keysObtained;
          if (_loc1_.keysObtained > 1)
          {
            this.main.incAchievement(29);
          }
          this.target = _loc1_;
          this.keyNum = _loc1_.keysObtained;
          this.traceLine = new Shape();
          parent.addChild(this.traceLine);
          this.traceLine.graphics.lineStyle(2, 16763904);
          this.traceLine.graphics.moveTo(x, y);
          this.traceLine.graphics.lineTo(_loc1_.x, _loc1_.y - 16);
          this.main.playSound("keyPickup", false);
        }
      }
      else if (this.target == _loc1_)
      {
        _loc2_ = (this.keyNum - 1) * 10;
        rotation = _loc1_.xSpeed * -4;
        if (this.gravity < 0)
        {
          this.gravity += 0.5;
        }
        y += this.gravity;
        if (_loc1_.swimming)
        {
          additionalMaths.easeToPoint(this, _loc1_.x, _loc1_.y + 20 - _loc2_);
        }
        else if (_loc1_.scaleX > 0)
        {
          additionalMaths.easeToPoint(this, _loc1_.x - 30, _loc1_.y - 6 - _loc2_);
        }
        else
        {
          additionalMaths.easeToPoint(this, _loc1_.x + 30, _loc1_.y - 6 - _loc2_);
        }
        _loc3_ = MovieClip(root).blocks;
        _loc4_ = 0;
        while (_loc4_ < _loc3_.length)
        {
          if (_loc3_[_loc4_].visible)
          {
            if (this.hitTestObject(_loc3_[_loc4_].topBound))
            {
              if (_loc1_.xSpeed < 5)
              {
                this.gravity = _loc1_.xSpeed * _loc1_.xSpeed * -0.2;
              }
              else
              {
                this.gravity = -5;
              }
              y = _loc3_[_loc4_].y - height * 0.5;
            }
            else if (this.hitTestObject(_loc3_[_loc4_].rightBound))
            {
              x = _loc3_[_loc4_].x + _loc3_[_loc4_].width + width * 0.5;
            }
            else if (this.hitTestObject(_loc3_[_loc4_].leftBound))
            {
              x = _loc3_[_loc4_].x - width * 0.5;
            }
            else if (this.hitTestObject(_loc3_[_loc4_].bottomBound))
            {
              this.gravity *= -1;
              y = _loc3_[_loc4_].y + _loc3_[_loc4_].height + height * 0.5;
            }
          }
          _loc4_++;
        }
        parent.removeChild(this.traceLine);
        this.traceLine.graphics.clear();
        this.traceLine = new Shape();
        parent.addChild(this.traceLine);
        this.traceLine.graphics.lineStyle(2, 16763904);
        this.traceLine.graphics.moveTo(x, y);
        if (_loc1_.currentPole)
        {
          this.traceLine.graphics.lineTo(_loc1_.x + _loc1_.xSpeed, _loc1_.y + _loc1_.ySpeed - 31);
        }
        else if (_loc1_.crouching)
        {
          this.traceLine.graphics.lineTo(_loc1_.x + _loc1_.xSpeed, _loc1_.y + _loc1_.ySpeed - 6);
        }
        else
        {
          this.traceLine.graphics.lineTo(_loc1_.x + _loc1_.xSpeed, _loc1_.y + _loc1_.ySpeed - 16);
        }
        parent.setChildIndex(this.traceLine, parent.getChildIndex(_loc1_) - 2);
      }
    }

    private function pushArray(param1:Event):*
    {
      var _loc2_:GlowFilter = new GlowFilter(16777113, 1, 10, 10, 1.5, 3);
      filters = [_loc2_];
      this.main = MovieClip(root);
      this.startPoint.x = x;
      this.startPoint.y = y;
      this.arrayIndex = this.main.obstacles.length;
      this.main.obstacles.push(this);
      removeEventListener(Event.ADDED_TO_STAGE, this.pushArray);
    }

    public function useKey():void
    {
      this.used = true;
      parent.removeChild(this.traceLine);
      this.traceLine.graphics.clear();
    }

    public function endKey():void
    {
      visible = false;
      --MovieClip(parent).player.keysObtained;
      this.target = null;
      x = this.startPoint.x;
      y = this.startPoint.y;
    }

    public function respawn():void
    {
      x = this.startPoint.x;
      y = this.startPoint.y;
      scaleX = 1;
      scaleY = 1;
      this.target = null;
      visible = true;
      rotation = -5;
      if (this.traceLine)
      {
        this.traceLine.graphics.clear();
      }
      this.keyNum = 0;
      this.used = false;
    }
  }
}
