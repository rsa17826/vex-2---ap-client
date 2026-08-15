package
{
  import flash.external.ExternalInterface;
  import fl.motion.Color;
  import flash.display.MovieClip;
  import flash.events.Event;
  import flash.events.KeyboardEvent;
  import flash.events.MouseEvent;
  import flash.events.TimerEvent;
  import flash.filters.*;
  import flash.geom.Point;
  import flash.utils.Timer;

  import flash.display.MovieClip;
  import flash.events.Event;
  import flash.filters.BevelFilter;
  import flash.filters.DropShadowFilter;
  import flash.ui.Keyboard;
  import flash.events.KeyboardEvent;

  [Embed(source="/_assets/assets.swf", symbol="symbol1568")]
  public class player extends MovieClip
  {

    protected var aDown:Boolean = false;

    protected var wDown:Boolean = false;

    protected var wHold:Boolean = false;

    protected var sDown:Boolean = false;

    protected var sHold:Boolean = false;

    protected var dDown:Boolean = false;

    protected var rDown:Boolean = false;

    protected var rHold:Boolean = false;

    protected var spaceDown:Boolean = false;

    public const startGravity:Number = 0.5;

    public var gravity:Number = 0.5;

    protected var friction:Number = 0.98;

    public var maxSpeed:Number = 6;

    protected var acc:Number = 1;

    public var breathe:int = 10;

    public var startPoint:Point = new Point();

    public var checkPoint:Point = new Point();

    public var ySpeed:Number = 0;

    public var xSpeed:Number = 0;

    protected var running:Boolean = false;

    public var swimming:Boolean = false;

    public var falling:Boolean = true;

    public var kicking:Boolean = false;

    public var squeezing:Boolean = false;

    public var teleporting:Boolean = false;

    public var diving:Boolean = false;

    public var hanging:Boolean = false;

    protected var scaling:Boolean = false;

    public var crouching:Boolean = false;

    public var pushing:Boolean = false;

    protected var scaleHistory:MovieClip = null;

    protected var scaleTime:int = 0;

    protected var maxScaleTime:int = 45;

    protected var hangTime:int = 10;

    protected var maxHangCoolDown:int = 10;

    protected var fallingMax:int = 20;

    protected var poleTimer:int = 0;

    public var breatheTimer:Timer;

    public var startStageHeight:int;

    public var keysObtained:int = 0;

    protected var rotationDest:int = 0;

    protected var swimmingLegs:Array = [];

    protected var lastTrail:Boolean = true;

    public var currentTint:Color = new Color();

    public var tintStr:int = 0;

    public var levelTint:Color = new Color();

    public var levelTintStr:int = 0;

    public var destLevelTintStr:int = 0;

    public var levelTintColour:uint = 0;

    public var feet:MovieClip;

    public var body:MovieClip;

    public var head:MovieClip;

    public var hands:MovieClip;

    public var inner_animation:MovieClip;

    public var main:MovieClip = MovieClip(root);

    public var level:MovieClip = MovieClip(parent);

    public var currentSlope:MovieClip = null;

    public var currentPool:MovieClip = null;

    public var currentLever:MovieClip = null;

    public var currentPole:MovieClip = null;

    public var currentCannon:MovieClip = null;

    public var currentPulley:MovieClip = null;

    public var checkpointsReached:int = 0;

    private var metersMoved:Number = 0;

    public function player()
    {
      super();
      addFrameScript(0, this.frame1);
      this.boundsInvis();
      stage.addEventListener(KeyboardEvent.KEY_DOWN, this.keyPressed);
      stage.addEventListener(KeyboardEvent.KEY_UP, this.keyReleased);
      stage.addEventListener(MouseEvent.CLICK, this.teleportToMouse);
      gotoAndStop(14);
      camera.snap(this, parent, 320, 240);
      addEventListener(Event.ADDED_TO_STAGE, this.addedToStage, false, 0, true);
      this.breatheTimer = new Timer(2000, 1);
      this.breatheTimer.addEventListener(TimerEvent.TIMER_COMPLETE, this.breatheDown, false, 0, true);
      ExternalInterface.call("markPlayerLoaded");
    }

    public function teleportToMouse(param1:MouseEvent):void
    {
      if (!ExternalInterface.call("debugModeEnabled")){return}
      var _loc2_:Point = new Point(stage.mouseX, stage.mouseY);
      if (this.parent)
      {
        _loc2_ = this.parent.globalToLocal(_loc2_);
      }
      this.x = _loc2_.x;
      this.y = _loc2_.y;
      this.xSpeed = 0;
      this.ySpeed = 0;
    }

    public var arrayIndex:int;

    public var toggle:MovieClip;

    private var shadow:DropShadowFilter;

    private var bevel:BevelFilter;

    public function update():void
    {
      if (this.main.darkBG != null && this.main.level && this.main.level.player)
      {
        if (this.main.darkBG.x != this.main.level.player.x + this.main.level.x || this.main.darkBG.y != this.main.level.player.y + this.main.level.y - this.main.level.player.height * 0.5)
        {
          this.main.darkBG.x = this.main.level.player.x + this.main.level.x;
          this.main.darkBG.y = this.main.level.player.y + this.main.level.y - this.main.level.player.height * 0.5;
          this.main.removeChild(this.main.darkBG);
          this.main.addChild(this.main.darkBG);
          this.main.setChildIndex(this.main.darkBG, this.main.getChildIndex(this.main.level) - 1);
        }
      }
      var _loc1_:Number = NaN;
      var _loc2_:Number = NaN;
      var _loc3_:int = 0;
      if (parent)
      {
        _loc1_ = Number(parent.x);
        _loc2_ = Number(parent.y);
        if (!this.startStageHeight)
        {
          if (parent)
          {
            this.startStageHeight = parent.height;
          }
        }
        this.checkCinematics();
        if (currentFrame < 14)
        {
          if (visible)
          {
            if (!this.teleporting)
            {
              this.checkTrail();
              this.updateGravity();
              if (currentFrame != 9)
              {
                if (!this.swimming)
                {
                  if (!this.currentCannon)
                  {
                    if (this.currentPulley == null)
                    {
                      this.getMovement();
                    }
                  }
                  this.getJump();
                }
                else
                {
                  this.getSwim();
                }
              }
              else
              {
                this.leverLogic();
              }
              this.getCrouch();
              this.getHang();
              if (this.ySpeed < this.fallingMax)
              {
                this.getRotation();
              }
              this.checkPoolCollisions();
              if (this.swimming)
              {
                this.checkSwimBlockCollisions();
              }
              else
              {
                this.checkBlockCollisions();
                this.checkSlopeCollisions();
                this.checkPoleCollisions();
                this.checkPulleyCollisions();
                this.metersMoved += Math.sqrt(this.xSpeed * this.xSpeed);
                if (this.metersMoved > 20)
                {
                  this.metersMoved -= 20;
                  ++this.main.stats[2];
                  this.main.incAchievement(17, 1);
                  this.main.incAchievement(18, 1);
                }
              }
              if (this.currentPole)
              {
                this.getSwing();
              }
              else if (currentFrame == 11)
              {
                this.backflip();
              }
              if (this.currentCannon)
              {
                this.getCannon();
                camera.follow(this, parent, 20, 320, 540);
              }
              else
              {
                this.checkCannonCollisions();
                if (this.ySpeed > 10)
                {
                  _loc3_ = Math.random() * this.ySpeed * 2;
                }
                camera.follow(this, parent, 10, 320 + _loc3_, 280);
              }
              this.checkLeverCollisions();
              this.main.updateBackground(-this.xSpeed * 0.3, -this.ySpeed * 0.3 + (this.gravity - 0.5) * 2);
              if (MovieClip(parent).currentFrame != 2)
              {
                this.incMilliseconds(3.33);
              }
              this.checkHotkeys();
            }
            else
            {
              camera.follow(this, parent, 10, 320, 280);
            }
          }
          else
          {
            camera.follow(this, parent, 3, 320, 280);
          }
        }
        if (this.tintStr > 0)
        {
          if (this.tintStr >= 100)
          {
            this.kill(14);
          }
          else
          {
            this.tintStr -= 5;
            if (this.tintStr < 0)
            {
              this.tintStr = 0;
            }
            this.createTint(16711680, this.tintStr);
          }
        }
        if (this.levelTintStr != this.destLevelTintStr)
        {
          if (this.levelTintStr > this.destLevelTintStr)
          {
            this.levelTintStr -= 5;
          }
          if (this.levelTintStr < this.destLevelTintStr)
          {
            this.levelTintStr += 5;
          }
          if (this.levelTintStr < 0)
          {
            this.levelTintStr = 0;
          }
          this.createTint(this.levelTintColour, this.levelTintStr, true);
        }
        MovieClip(root).updateBackground(-(_loc1_ - parent.x) * 0.2, -(_loc2_ - parent.y) * 0.2);
      }
    }

    protected function checkCinematics():void
    {
      var _loc1_:Array = null;
      var _loc2_:int = 0;
      if (currentFrame == 1 && this.inner_animation.currentFrame > 45)
      {
        _loc1_ = this.main.blocks;
        _loc2_ = 0;
        while (_loc2_ < _loc1_.length)
        {
          if (_loc1_[_loc2_].visible)
          {
            if (this.feet.hitTestObject(_loc1_[_loc2_].topBound))
            {
              _loc1_[_loc2_].landed();
            }
          }
          _loc2_++;
        }
      }
      if (currentFrame == 2 && this.inner_animation.currentFrame > 87)
      {
        this.rotationDest = 135;
        this.xSpeed = 0;
      }
    }

    public function checkHotkeys():void
    {
      if (this.rDown)
      {
        if (!this.rHold)
        {
          if (!this.main.resetWarning)
          {
            this.reset();
            this.rHold = true;
            return;
          }
          if (this.main.window == null)
          {
            this.main.createWindow("reset");
            this.rHold = true;
          }
          else if (this.main.window is resetWindow)
          {
            this.reset();
            this.rHold = true;
            this.main.removeChild(this.main.window);
            this.main.window = null;
          }
        }
      }
      if (this.main.window is resetWindow)
      {
        if (this.spaceDown)
        {
          this.main.removeChild(this.main.window);
          this.main.window = null;
        }
      }
    }

    private function checkTrail():void
    {
      var _loc1_:* = undefined;
      if (this.lastTrail)
      {
        if (this.maxSpeed > 6)
        {
          if (this.xSpeed != 0 || this.ySpeed != 0)
          {
            _loc1_ = new playerTrail();
            _loc1_.x = x;
            _loc1_.y = y;
            _loc1_.scaleX = scaleX;
            _loc1_.scaleY = scaleY;
            _loc1_.rotation = rotation;
            _loc1_.alpha = 0.8;
            _loc1_.blendMode = "darken";
            _loc1_.gotoAndStop(currentFrame);
            _loc1_.inner_animation.gotoAndStop(this.inner_animation.currentFrame);
            if (this.swimming)
            {
              _loc1_.inner_animation.top_half.rotation = this.inner_animation.top_half.rotation;
              _loc1_.inner_animation.bottom_half.rotation = this.inner_animation.bottom_half.rotation;
            }
            parent.addChild(_loc1_);
            parent.setChildIndex(_loc1_, 0);
            this.lastTrail = false;
          }
        }
      }
      else
      {
        this.lastTrail = true;
      }
    }

    private function getCannon():void
    {
      this.crouching = false;
      this.hanging = false;
      this.scaling = false;
      this.pushing = false;
      if (y > this.currentCannon.y + this.currentCannon.cannonTube.y)
      {
        this.ySpeed = 0;
        y = this.currentCannon.y + this.currentCannon.cannonTube.y;
        gotoAndStop(1);
      }
      parent.setChildIndex(this.currentCannon, parent.numChildren - 1);
      additionalMaths.easeToPoint(this, this.currentCannon.x, this.y);
      if (x == this.currentCannon.x)
      {
        if (y == this.currentCannon.y + this.currentCannon.cannonTube.y)
        {
          this.falling = false;
          this.currentCannon.rotating = true;
        }
        else
        {
          this.currentCannon.rotating = false;
        }
      }
      this.rotationDest = this.currentCannon.rotation + this.currentCannon.cannonTube.rotation;
    }

    private function getSwing():void
    {
      x = this.currentPole.x - scaleX * 5;
      y = this.currentPole.y + 32;
      this.xSpeed = 0;
      this.ySpeed = 0;
      this.rotationDest = 0;
      gotoAndStop(11);
      if (this.currentPole.redSection.alpha < 1)
      {
        this.currentPole.redSection.alpha += 0.1;
      }
      if (scaleX > 0)
      {
        if (this.currentPole.redSection.rotation > 30)
        {
          this.currentPole.redSection.rotation -= 5;
        }
      }
      else if (this.currentPole.redSection.rotation < 150)
      {
        this.currentPole.redSection.rotation += 5;
      }
      this.scaleHistory = null;
    }

    private function getHang():void
    {
      if (this.hanging)
      {
        if (this.scaleHistory)
        {
          if (scaleX > 0)
          {
            this.xSpeed = this.scaleHistory.xSpeed;
            this.ySpeed = this.scaleHistory.ySpeed;
            this.falling = false;
            this.hanging = true;
            this.rotationDest = 0;
            x = this.scaleHistory.x - 3.5;
            y = this.scaleHistory.y + 34;
            if (this.scaleHistory.ySpeed > 0)
            {
              y += this.scaleHistory.ySpeed;
            }
            gotoAndStop(6);
          }
          else
          {
            this.xSpeed = this.scaleHistory.xSpeed;
            this.ySpeed = this.scaleHistory.ySpeed;
            this.falling = false;
            this.hanging = true;
            this.rotationDest = 0;
            x = this.scaleHistory.x + this.scaleHistory.width + 3.5;
            y = this.scaleHistory.y + 34;
            if (this.scaleHistory.ySpeed > 0)
            {
              y += this.scaleHistory.ySpeed;
            }
            gotoAndStop(6);
          }
        }
      }
    }

    private function getRotation():void
    {
      var _loc1_:int = 0;
      if (this.diving)
      {
        _loc1_ = 1;
      }
      else
      {
        _loc1_ = 5 + Math.sqrt(this.xSpeed * this.xSpeed);
      }
      if (rotation < this.rotationDest)
      {
        rotation += Math.sqrt(this.rotationDest * this.rotationDest) / 3 + _loc1_;
        if (rotation > this.rotationDest - 1)
        {
          rotation = this.rotationDest;
        }
      }
      else if (rotation > this.rotationDest)
      {
        rotation -= Math.sqrt(this.rotationDest * this.rotationDest) / 3 + _loc1_;
        if (rotation < this.rotationDest + 1)
        {
          rotation = this.rotationDest;
        }
      }
    }

    private function updateGravity():void
    {
      if (!this.hanging)
      {
        if (!this.swimming)
        {
          if (this.currentPulley == null)
          {
            if (this.ySpeed < 50)
            {
              this.ySpeed += this.gravity;
            }
            y += this.ySpeed;
            if (this.ySpeed > 2)
            {
              if (!this.scaling)
              {
                this.falling = true;
                if (currentFrame != 2 && currentFrame != 11)
                {
                  gotoAndStop(2);
                }
                if (this.crouching)
                {
                  this.crouching = false;
                  this.inner_animation.gotoAndPlay(52);
                }
              }
              if (this.ySpeed > this.fallingMax)
              {
                if (this.inner_animation.currentFrame < 28)
                {
                  this.inner_animation.gotoAndPlay(28);
                }
                rotation += -scaleX * (this.ySpeed * 0.25);
                if (rotation < -150 || rotation > 150)
                {
                  this.kill(5);
                }
              }
              else if (this.inner_animation.currentFrame < 82)
              {
                this.rotationDest = 0;
              }
            }
          }
        }
      }
    }

    private function getSwim():void
    {
      var _loc1_:int = 0;
      var _loc2_:Number = NaN;
      var _loc3_:Number = NaN;
      var _loc4_:int = 0;
      var _loc5_:* = undefined;
      if (currentFrame != 10)
      {
        return;
      }
      if (!this.wDown)
      {
        if (!this.sDown)
        {
          this.xSpeed *= 0.9;
          this.ySpeed *= 0.9;
        }
      }
      if (this.aDown)
      {
        this.inner_animation.top_half.rotation -= 5;
      }
      else if (this.dDown)
      {
        this.inner_animation.top_half.rotation += 5;
      }
      this.swimmingLegs.push(this.inner_animation.top_half.rotation);
      if (this.swimmingLegs.length > 4)
      {
        this.inner_animation.bottom_half.rotation = this.swimmingLegs[0];
        this.inner_animation.back_block.rotation = (this.inner_animation.bottom_half.rotation + this.inner_animation.top_half.rotation) * 0.5;
        this.swimmingLegs.splice(0, 1);
      }
      if (this.wDown)
      {
        if (this.inner_animation.top_half.currentFrame < 4)
        {
          this.inner_animation.top_half.play();
        }
        _loc1_ = this.inner_animation.top_half.rotation - 90;
        _loc2_ = Number(Math.cos(_loc1_ / 180 * Math.PI));
        _loc3_ = Number(Math.sin(_loc1_ / 180 * Math.PI));
        _loc4_ = 5;
        this.xSpeed += _loc2_;
        this.ySpeed += _loc3_;
        if (_loc2_ >= 0 && this.xSpeed > _loc2_ * _loc4_)
        {
          this.xSpeed = _loc2_ * _loc4_;
        }
        if (_loc2_ < 0 && this.xSpeed < _loc2_ * _loc4_)
        {
          this.xSpeed = _loc2_ * _loc4_;
        }
        if (_loc3_ > 0 && this.ySpeed > _loc3_ * _loc4_)
        {
          this.ySpeed = _loc3_ * _loc4_;
        }
        if (_loc3_ <= 0 && this.ySpeed < _loc3_ * _loc4_)
        {
          this.ySpeed = _loc3_ * _loc4_;
        }
        if (Math.random() < 0.4)
        {
          _loc5_ = new particle(3394815, 4, true, true);
          _loc5_.x = x + Math.random() * 10 - 5;
          _loc5_.y = y - width * 0.5 + Math.random() * 10 - 5;
          _loc5_.xSpeed = -_loc2_;
          _loc5_.ySpeed = -_loc3_;
          parent.addChild(_loc5_);
          parent.setChildIndex(_loc5_, 0);
        }
      }
      else if (this.inner_animation.top_half.currentFrame > 1)
      {
        this.inner_animation.top_half.play();
      }
      if (this.sDown)
      {
        _loc1_ = this.inner_animation.top_half.rotation - 90;
        _loc2_ = -Math.cos(_loc1_ / 180 * Math.PI);
        _loc3_ = -Math.sin(_loc1_ / 180 * Math.PI);
        _loc4_ = 2;
        this.xSpeed += _loc2_;
        this.ySpeed += _loc3_;
        if (_loc2_ > 0)
        {
          if (this.xSpeed > _loc2_ * _loc4_)
          {
            this.xSpeed = _loc2_ * _loc4_;
          }
        }
        if (_loc2_ < 0)
        {
          if (this.xSpeed < _loc2_ * _loc4_)
          {
            this.xSpeed = _loc2_ * _loc4_;
          }
        }
        if (_loc3_ > 0)
        {
          if (this.ySpeed > _loc3_ * _loc4_)
          {
            this.ySpeed = _loc3_ * _loc4_;
          }
        }
        if (_loc3_ < 0)
        {
          if (this.ySpeed < _loc3_ * _loc4_)
          {
            this.ySpeed = _loc3_ * _loc4_;
          }
        }
      }
      x += this.xSpeed;
      y += this.ySpeed;
    }

    private function getMovement():void
    {
      var _loc1_:Number = NaN;
      if (this.kicking)
      {
        return;
      }
      if (this.hangTime < this.maxHangCoolDown)
      {
        ++this.hangTime;
      }
      if (this.aDown)
      {
        if (!this.hanging)
        {
          if (!this.scaling)
          {
            if (this.ySpeed < 20)
            {
              if (!this.crouching)
              {
                if (this.xSpeed > -this.maxSpeed)
                {
                  this.xSpeed -= this.acc;
                  if (this.xSpeed > 0)
                  {
                    this.xSpeed *= 0.5;
                  }
                }
                else
                {
                  this.xSpeed += this.acc * 0.2;
                }
                if (this.currentPole)
                {
                  if (this.inner_animation.currentFrame >= 10 && this.inner_animation.currentFrame <= 23)
                  {
                    if (scaleX > 0)
                    {
                      scaleX *= -1;
                    }
                  }
                }
                else if (scaleX > 0)
                {
                  if (this.pushing)
                  {
                    this.pushing = false;
                    gotoAndStop(1);
                  }
                  scaleX *= -1;
                }
                if (currentFrame == 1 || currentFrame == 4)
                {
                  gotoAndStop(3);
                }
              }
            }
          }
        }
        if (this.crouching)
        {
          if (!this.currentSlope)
          {
            if (this.xSpeed > 2)
            {
              this.xSpeed -= this.acc * 0.1;
            }
            else if (this.xSpeed < -2)
            {
              this.xSpeed += this.acc * 0.1;
            }
            if (this.xSpeed < 2)
            {
              if (this.xSpeed > -2)
              {
                if (this.friction == 1)
                {
                  this.xSpeed = 0;
                }
                gotoAndStop(7);
              }
            }
          }
          else
          {
            this.xSpeed *= 1 + (1 - this.friction);
          }
        }
      }
      else if (this.dDown)
      {
        if (!this.hanging)
        {
          if (!this.scaling)
          {
            if (this.ySpeed < 20)
            {
              if (!this.crouching)
              {
                if (this.xSpeed < this.maxSpeed)
                {
                  this.xSpeed += this.acc;
                  if (this.xSpeed < 0)
                  {
                    this.xSpeed *= 0.5;
                  }
                }
                else
                {
                  this.xSpeed -= this.acc * 0.2;
                }
                if (this.currentPole)
                {
                  if (this.inner_animation.currentFrame >= 10 && this.inner_animation.currentFrame <= 23)
                  {
                    if (scaleX < 0)
                    {
                      scaleX *= -1;
                    }
                  }
                }
                else if (scaleX < 0)
                {
                  if (this.pushing)
                  {
                    this.pushing = false;
                    gotoAndStop(1);
                  }
                  scaleX *= -1;
                }
                if (currentFrame == 1 || currentFrame == 4)
                {
                  gotoAndStop(3);
                }
              }
            }
          }
        }
        if (this.crouching)
        {
          if (!this.currentSlope)
          {
            if (this.xSpeed < -2)
            {
              this.xSpeed += this.acc * 0.1;
            }
            else if (this.xSpeed > 2)
            {
              this.xSpeed -= this.acc * 0.1;
            }
            if (this.xSpeed < 2)
            {
              if (this.xSpeed > -2)
              {
                this.xSpeed = 0;
                gotoAndStop(7);
              }
            }
          }
          else
          {
            this.xSpeed *= 1 + (1 - this.friction);
          }
        }
      }
      else if (this.crouching)
      {
        gotoAndStop(7);
        this.xSpeed = 0;
      }
      else
      {
        _loc1_ = this.acc * 1;
        if (this.falling)
        {
          _loc1_ = this.acc * 0.5;
        }
        if (this.xSpeed < 0)
        {
          this.xSpeed += _loc1_;
          if (this.xSpeed > 0)
          {
            this.xSpeed = 0;
          }
        }
        if (this.xSpeed > 0)
        {
          this.xSpeed -= _loc1_;
          if (this.xSpeed < 0)
          {
            this.xSpeed = 0;
          }
        }
        if (currentFrame == 3 || currentFrame == 13)
        {
          this.pushing = false;
          gotoAndStop(1);
        }
      }
      x += this.xSpeed;
      if (this.currentSlope is leftSlope)
      {
        y -= this.xSpeed;
        if (scaleX < 0)
        {
          if (this.crouching)
          {
            if (this.xSpeed > 0)
            {
              this.xSpeed = 1;
            }
          }
        }
      }
      else if (this.currentSlope is rightSlope)
      {
        y += this.xSpeed;
        if (scaleX > 0)
        {
          if (this.crouching)
          {
            if (this.xSpeed < 0)
            {
              this.xSpeed = 1;
            }
          }
        }
      }
    }

    private function getJump():void
    {
      if (!this.falling)
      {
        if (this.currentCannon)
        {
          if (this.wDown)
          {
            if (!this.wHold)
            {
              if (this.currentCannon.rotating)
              {
                this.currentCannon.firing = true;
                this.wHold = true;
                return;
              }
            }
          }
        }
        if (this.currentPole)
        {
          if (this.wDown)
          {
            if (!this.wHold)
            {
              if (this.inner_animation.currentFrame >= 3 && this.inner_animation.currentFrame <= 12)
              {
                this.ySpeed = -8;
                this.acc = 1;
                y += this.ySpeed;
                this.falling = true;
                this.wHold = true;
                this.rotationDest = 0;
                this.currentPole.redSection.alpha = 0;
                this.currentPole = null;
                this.poleTimer = 0;
                this.xSpeed = scaleX * 8;
                ++this.main.stats[3];
                return;
              }
              if (this.inner_animation.currentFrame >= 31 && this.inner_animation.currentFrame <= 35)
              {
                this.ySpeed = -6;
                this.acc = 1;
                y += this.ySpeed;
                this.falling = true;
                this.wHold = true;
                this.rotationDest = 0;
                this.currentPole.redSection.alpha = 0;
                this.currentPole = null;
                this.poleTimer = 0;
                this.xSpeed = scaleX * 8;
                ++this.main.stats[3];
                return;
              }
              this.ySpeed = 1;
              this.acc = 1;
              y += this.ySpeed;
              this.falling = true;
              this.wHold = true;
              this.rotationDest = 0;
              this.currentPole.redSection.alpha = 0;
              this.currentPole = null;
              this.poleTimer = 0;
              gotoAndStop(2);
              ++this.main.stats[3];
            }
          }
        }
        if (this.currentPulley)
        {
          if (this.wDown)
          {
            if (!this.wHold)
            {
              if (this.inner_animation.currentFrame < 9)
              {
                this.inner_animation.gotoAndPlay(9);
              }
              this.inner_animation.play();
              this.wHold = true;
              return;
            }
          }
        }
        if (this.wDown)
        {
          if (!this.wHold)
          {
            if (!this.crouching)
            {
              this.ySpeed = -8;
              y += this.ySpeed;
              this.falling = true;
              this.running = false;
              this.scaling = false;
              this.hanging = false;
              gotoAndStop(2);
              this.wHold = true;
              this.rotationDest = 0;
              this.acc = 1;
              if (this.currentSlope)
              {
                this.currentSlope = null;
              }
              ++this.main.stats[6];
            }
          }
        }
      }
      else if (this.wDown)
      {
        if (this.inner_animation.currentFrame == 8)
        {
          if (!this.wHold)
          {
            this.inner_animation.play();
            this.wHold = true;
          }
        }
      }
    }

    private function getCrouch():void
    {
      if (!this.swimming)
      {
        if (!this.falling)
        {
          if (!this.scaling)
          {
            if (!this.hanging)
            {
              if (!this.kicking)
              {
                if (this.sDown)
                {
                  if (this.currentLever != null)
                  {
                    if (currentFrame != 9)
                    {
                      if (this.currentLever.leverTime <= 0)
                      {
                        gotoAndStop(9);
                        this.xSpeed = 0;
                      }
                    }
                  }
                  else
                  {
                    if (this.currentPole)
                    {
                      this.currentPole.redSection.alpha = 0;
                      this.currentPole = null;
                      this.poleTimer = 0;
                      return;
                    }
                    if (this.currentPulley)
                    {
                      this.pulleyDrop();
                      return;
                    }
                    if (!this.crouching)
                    {
                      if (this.xSpeed < 1 && this.xSpeed > -1)
                      {
                        gotoAndStop(7);
                        this.crouching = true;
                        this.sHold = true;
                      }
                      else if (this.currentSlope is leftSlope)
                      {
                        if (this.dDown)
                        {
                          gotoAndStop(7);
                          this.crouching = true;
                          this.sHold = true;
                          this.xSpeed = 0;
                        }
                        else
                        {
                          gotoAndStop(8);
                          this.crouching = true;
                          this.sHold = true;
                        }
                      }
                      else if (this.currentSlope is rightSlope)
                      {
                        if (this.aDown)
                        {
                          gotoAndStop(7);
                          this.crouching = true;
                          this.sHold = true;
                          this.xSpeed = 0;
                        }
                        else
                        {
                          gotoAndStop(8);
                          this.crouching = true;
                          this.sHold = true;
                        }
                      }
                      else
                      {
                        gotoAndStop(8);
                        this.crouching = true;
                        this.sHold = true;
                      }
                    }
                    else
                    {
                      if (currentFrame == 8)
                      {
                        if (this.currentSlope is leftSlope)
                        {
                          if (this.dDown)
                          {
                            gotoAndStop(7);
                            this.crouching = true;
                            this.sHold = true;
                            this.xSpeed = 0;
                          }
                        }
                      }
                      if (currentFrame == 8)
                      {
                        if (this.currentSlope is rightSlope)
                        {
                          if (this.aDown)
                          {
                            gotoAndStop(7);
                            this.crouching = true;
                            this.sHold = true;
                            this.xSpeed = 0;
                          }
                        }
                      }
                    }
                  }
                }
                else if (currentFrame == 7 || currentFrame == 8)
                {
                  this.inner_animation.play();
                  if (this.inner_animation.currentFrame == this.inner_animation.totalFrames)
                  {
                    gotoAndStop(1);
                    this.crouching = false;
                  }
                }
              }
            }
          }
        }
      }
      if (this.scaling || this.hanging)
      {
        if (this.sDown)
        {
          if (!this.sHold)
          {
            this.scaling = false;
            this.hanging = false;
            this.falling = true;
            this.hangTime = 0;
            gotoAndStop(2);
            this.sHold = true;
          }
        }
      }
    }

    private function keyPressed(param1:KeyboardEvent):*
    {
      var _loc2_:* = param1.keyCode;
      if (_loc2_ == 87 || _loc2_ == 38)
      {
        this.wDown = true;
      }
      if (_loc2_ == 65 || _loc2_ == 37)
      {
        this.aDown = true;
      }
      if (_loc2_ == 83 || _loc2_ == 40)
      {
        this.sDown = true;
      }
      if (_loc2_ == 68 || _loc2_ == 39)
      {
        this.dDown = true;
      }
      if (_loc2_ == 82)
      {
        this.rDown = true;
      }
      if (_loc2_ == 32)
      {
        this.spaceDown = true;
      }
    }

    private function keyReleased(param1:KeyboardEvent):*
    {
      var _loc2_:* = param1.keyCode;
      if (_loc2_ == 87 || _loc2_ == 38)
      {
        this.wDown = false;
        this.wHold = false;
      }
      if (_loc2_ == 65 || _loc2_ == 37)
      {
        this.aDown = false;
      }
      if (_loc2_ == 83 || _loc2_ == 40)
      {
        this.sDown = false;
        this.sHold = false;
      }
      if (_loc2_ == 68 || _loc2_ == 39)
      {
        this.dDown = false;
      }
      if (_loc2_ == 82)
      {
        this.rDown = false;
        this.rHold = false;
      }
      if (_loc2_ == 32)
      {
        this.spaceDown = false;
      }
    }

    protected function checkSwimBlockCollisions():void
    {
      var _loc5_:int = 0;
      var _loc7_:Array = null;
      var _loc8_:int = 0;
      var _loc9_:Number = NaN;
      var _loc10_:* = undefined;
      var _loc1_:Array = this.main.pools;
      var _loc2_:Boolean = false;
      var _loc3_:int = 0;
      while (_loc3_ < _loc1_.length)
      {
        if (this.hitTestObject(_loc1_[_loc3_]))
        {
          _loc2_ = true;
          break;
        }
        _loc3_++;
      }
      if (!_loc2_)
      {
        this.breathe = 10;
        this.breatheTimer.stop();
        this.swimming = false;
        this.falling = true;
        gotoAndStop(2);
        return;
      }
      var _loc4_:Array = this.main.blocks;
      _loc5_ = 0;
      for (; _loc5_ < _loc4_.length; _loc5_++)
      {
        if (_loc4_[_loc5_].visible)
        {
          if (this.hitTestObject(_loc4_[_loc5_]))
          {
            if (_loc4_[_loc5_] is lockBlock)
            {
              if (_loc4_[_loc5_].unlocked)
              {
                continue;
              }
              if (this.keysObtained > 0)
              {
                _loc4_[_loc5_].unlock();
                _loc7_ = this.main.obstacles;
                _loc8_ = 0;
                while (_loc8_ < _loc7_.length)
                {
                  if (_loc7_[_loc8_] is key)
                  {
                    if (_loc7_[_loc8_].target == this)
                    {
                      _loc7_[_loc8_].useKey();
                      break;
                    }
                  }
                  _loc8_++;
                }
                continue;
              }
            }
            if (this.inner_animation.hitTestObject(_loc4_[_loc5_].topBound))
            {
              if (_loc4_[_loc5_].y > this.currentPool.y)
              {
                if (this.ySpeed >= 0)
                {
                  this.ySpeed *= -0.5;
                  y = _loc4_[_loc5_].y - 1;
                }
                else if (this.xSpeed > 0 && x < _loc4_[_loc5_].x)
                {
                  if (this.xSpeed >= 0)
                  {
                    this.xSpeed *= -0.5;
                  }
                  x = _loc4_[_loc5_].x - 1 - this.inner_animation.width * 0.5;
                }
                else if (this.xSpeed < 0 && x > _loc4_[_loc5_].x + _loc4_[_loc5_].width)
                {
                  if (this.xSpeed <= 0)
                  {
                    this.xSpeed *= -0.5;
                  }
                  x = _loc4_[_loc5_].x + 1 + this.inner_animation.width * 0.5 + _loc4_[_loc5_].width;
                }
              }
              else if (this.xSpeed > 0 && x < _loc4_[_loc5_].x)
              {
                if (this.xSpeed >= 0)
                {
                  this.xSpeed *= -0.5;
                }
                x = _loc4_[_loc5_].x - 1 - this.inner_animation.width * 0.5;
              }
              else if (this.xSpeed < 0 && x > _loc4_[_loc5_].x + _loc4_[_loc5_].width)
              {
                if (this.xSpeed <= 0)
                {
                  this.xSpeed *= -0.5;
                }
                x = _loc4_[_loc5_].x + 1 + this.inner_animation.width * 0.5 + _loc4_[_loc5_].width;
              }
              this.checkCrushTop(_loc4_[_loc5_]);
            }
            else if (this.inner_animation.hitTestObject(_loc4_[_loc5_].bottomBound))
            {
              if (y > _loc4_[_loc5_].y - this.inner_animation.height + this.ySpeed + 1 && x > _loc4_[_loc5_].x && x < _loc4_[_loc5_].x + _loc4_[_loc5_].width)
              {
                if (this.ySpeed <= 0)
                {
                  this.ySpeed *= -0.5;
                  _loc4_[_loc5_].snapBottom(this);
                }
                else if (this.xSpeed > 0 && x < _loc4_[_loc5_].x)
                {
                  if (this.xSpeed >= 0)
                  {
                    this.xSpeed *= -0.5;
                  }
                  x = _loc4_[_loc5_].x - 1 - this.inner_animation.width * 0.5;
                }
                else if (this.xSpeed < 0 && x > _loc4_[_loc5_].x + _loc4_[_loc5_].width)
                {
                  if (this.xSpeed <= 0)
                  {
                    this.xSpeed *= -0.5;
                  }
                  x = _loc4_[_loc5_].x + 1 + this.inner_animation.width * 0.5 + _loc4_[_loc5_].width;
                }
              }
              else if (this.xSpeed > 0 && x < _loc4_[_loc5_].x)
              {
                if (this.xSpeed >= 0)
                {
                  this.xSpeed *= -0.5;
                }
                x = _loc4_[_loc5_].x - 1 - this.inner_animation.width * 0.5;
              }
              else if (this.xSpeed < 0 && x > _loc4_[_loc5_].x + _loc4_[_loc5_].width)
              {
                if (this.xSpeed <= 0)
                {
                  this.xSpeed *= -0.5;
                }
                x = _loc4_[_loc5_].x + 1 + this.inner_animation.width * 0.5 + _loc4_[_loc5_].width;
              }
            }
            else if (this.inner_animation.hitTestObject(_loc4_[_loc5_].leftBound))
            {
              if (this.xSpeed >= 0)
              {
                this.xSpeed *= -0.5;
              }
              x = _loc4_[_loc5_].x - 1 - this.inner_animation.width * 0.5;
            }
            else if (this.inner_animation.hitTestObject(_loc4_[_loc5_].rightBound))
            {
              if (this.xSpeed <= 0)
              {
                this.xSpeed *= -0.5;
              }
              x = _loc4_[_loc5_].x + 1 + this.inner_animation.width * 0.5 + _loc4_[_loc5_].width;
            }
          }
        }
      }
      var _loc6_:Array = this.main.slopes;
      _loc5_ = 0;
      for (; _loc5_ < _loc6_.length; _loc5_++)
      {
        if (_loc6_[_loc5_].visible)
        {
          if (this.body.hitTestObject(_loc6_[_loc5_].wall))
          {
            if (_loc6_[_loc5_] is leftSlope)
            {
              if (!this.hanging)
              {
                if (this.xSpeed < 0)
                {
                  x = _loc6_[_loc5_].x + _loc6_[_loc5_].width + 7;
                  this.xSpeed *= -0.5;
                  continue;
                }
              }
            }
            else if (_loc6_[_loc5_] is rightSlope)
            {
              if (!this.hanging)
              {
                if (this.xSpeed > 0)
                {
                  x = _loc6_[_loc5_].x - 7;
                  this.xSpeed *= -0.5;
                  continue;
                }
              }
            }
          }
          if (this.head.hitTestObject(_loc6_[_loc5_].bottom))
          {
            if (this.ySpeed < 0)
            {
              if (y >= _loc6_[_loc5_].y + _loc6_[_loc5_].height + height - this.ySpeed)
              {
                y = _loc6_[_loc5_].y + _loc6_[_loc5_].height + height + _loc6_[_loc5_].ySpeed;
                this.ySpeed *= -0.5;
                y += this.ySpeed;
              }
            }
          }
          if (x > _loc6_[_loc5_].x)
          {
            if (x < _loc6_[_loc5_].x + _loc6_[_loc5_].width)
            {
              if (y > _loc6_[_loc5_].y - 5)
              {
                if (y < _loc6_[_loc5_].y + _loc6_[_loc5_].height + 5)
                {
                  if (_loc6_[_loc5_] is leftSlope)
                  {
                    _loc9_ = (x - _loc6_[_loc5_].x) / _loc6_[_loc5_].width;
                    if (y >= _loc6_[_loc5_].y + _loc6_[_loc5_].height - _loc6_[_loc5_].height * _loc9_)
                    {
                      y = _loc6_[_loc5_].y + _loc6_[_loc5_].height - _loc6_[_loc5_].height * _loc9_ + 2;
                      _loc10_ = this.ySpeed;
                      if (this.ySpeed > 0)
                      {
                        this.ySpeed = this.xSpeed * -1;
                      }
                      if (this.xSpeed > 0)
                      {
                        this.xSpeed = _loc10_ * -1;
                      }
                      x += this.xSpeed;
                      y += this.ySpeed;
                    }
                  }
                  else if (_loc6_[_loc5_] is rightSlope)
                  {
                    _loc9_ = 1 - (x - _loc6_[_loc5_].x) / _loc6_[_loc5_].width;
                    if (y >= _loc6_[_loc5_].y + _loc6_[_loc5_].height - _loc6_[_loc5_].height * _loc9_)
                    {
                      y = _loc6_[_loc5_].y + _loc6_[_loc5_].height - _loc6_[_loc5_].height * _loc9_ + 2;
                      _loc10_ = this.ySpeed;
                      if (this.ySpeed > 0)
                      {
                        this.ySpeed = this.xSpeed * -1;
                      }
                      if (this.xSpeed < 0)
                      {
                        this.xSpeed = _loc10_ * -1;
                      }
                      x += this.xSpeed;
                      y += this.ySpeed;
                    }
                  }
                }
              }
            }
          }
        }
      }
    }

    protected function checkCannonCollisions():void
    {
      var _loc1_:Array = null;
      var _loc2_:int = 0;
      if (!ExternalInterface.call("canUseMove", "cannon"))
      {
        return;
      }
      if (!this.hanging)
      {
        if (!this.scaling)
        {
          if (!this.currentPole)
          {
            _loc1_ = this.main.obstacles;
            _loc2_ = 0;
            while (_loc2_ < _loc1_.length)
            {
              if (_loc1_[_loc2_] is cannon)
              {
                if (this.hitTestObject(_loc1_[_loc2_]))
                {
                  if (!this.currentCannon)
                  {
                    this.main.playSound("cannonEnter", false);
                  }
                  this.currentCannon = _loc1_[_loc2_];
                  this.falling = true;
                  this.running = false;
                  gotoAndStop(2);
                  this.ySpeed = -5.5;
                  y = this.currentCannon.y + this.ySpeed;
                  this.xSpeed = 0;
                  this.scaleHistory = null;
                  break;
                }
              }
              _loc2_++;
            }
          }
        }
      }
    }

    protected function checkPoleCollisions():void
    {
      var _loc1_:Array = null;
      var _loc2_:int = 0;
      if (!ExternalInterface.call("canUseMove", "polejump"))
      {
        return;
      }
      if (this.poleTimer >= 10)
      {
        _loc1_ = this.main.obstacles;
        _loc2_ = 0;
        while (_loc2_ < _loc1_.length)
        {
          if (_loc1_[_loc2_] is pole)
          {
            if (this.hands.hitTestObject(_loc1_[_loc2_].poleBound))
            {
              if (!this.currentPole)
              {
                this.xSpeed = 0;
                this.ySpeed = 0;
                this.currentPole = _loc1_[_loc2_];
                this.currentPole.redSection.gotoAndPlay(1);
                this.falling = false;
                rotation = 0;
                x = this.currentPole.x - scaleX * 5;
                y = this.currentPole.y + 32;
                this.main.playSound("Connect", false, false, true);
              }
            }
            else if (this.body.hitTestObject(_loc1_[_loc2_].poleBound))
            {
              if (this.xSpeed > 0)
              {
                this.xSpeed = 0;
                x = _loc1_[_loc2_].x - _loc1_[_loc2_].poleBound.width * 0.5;
              }
              else if (this.xSpeed < 0)
              {
                this.xSpeed = 0;
                x = _loc1_[_loc2_].x + _loc1_[_loc2_].poleBound.width * 0.5;
              }
            }
          }
          _loc2_++;
        }
      }
      else
      {
        ++this.poleTimer;
      }
    }

    protected function checkPulleyCollisions():void
    {
      var _loc1_:Array = null;
      var _loc2_:int = 0;
      if (this.ySpeed < 0)
      {
        if (this.currentPulley == null && ExternalInterface.call("canUseMove", "pulley"))
        {
          _loc1_ = this.main.obstacles;
          _loc2_ = 0;
          while (_loc2_ < _loc1_.length)
          {
            if (_loc1_[_loc2_] is pulley)
            {
              if (this.hands.hitTestObject(_loc1_[_loc2_]))
              {
                this.currentPulley = _loc1_[_loc2_];
                gotoAndStop(12);
                this.falling = false;
                break;
              }
            }
            _loc2_++;
          }
        }
      }
      if (this.currentPulley)
      {
        x = this.currentPulley.x;
        y = this.currentPulley.y + height + this.currentPulley.height * 0.5;
        this.ySpeed = 0;
        if (this.currentPulley.speed > 0)
        {
          scaleX = 1;
        }
        else
        {
          scaleX = -1;
          x += 10;
        }
      }
    }

    public function pulleyDrop():void
    {
      this.xSpeed = this.currentPulley.speed;
      this.currentPulley = null;
      gotoAndStop(2);
      this.inner_animation.gotoAndStop(8);
      this.falling = true;
      this.ySpeed = 0.5;
    }

    protected function checkBlockCollisions():void
    {
      var _loc4_:Array = null;
      var _loc5_:int = 0;
      var _loc6_:Boolean = false;
      var _loc7_:Array = null;
      var _loc8_:int = 0;
      var _loc9_:Point = null;
      var _loc10_:* = undefined;
      var _loc11_:Point = null;
      var _loc12_:Boolean = false;
      var _loc13_:Boolean = false;
      var _loc14_:int = 0;
      if (currentFrame == 10)
      {
        this.swimming = true;
        this.falling = false;
        this.checkSwimBlockCollisions();
        return;
      }
      var _loc1_:Array = this.main.blocks;
      var _loc2_:Boolean = false;
      if (this.scaling && this.hands.hitTestObject(this.scaleHistory) == false)
      {
        this.falling = true;
        this.scaling = false;
        gotoAndStop(2);
      }
      var _loc3_:int = 0;
      for (; _loc3_ < _loc1_.length; _loc3_++)
      {
        if (_loc1_[_loc3_].visible)
        {
          if (this.hitTestObject(_loc1_[_loc3_]))
          {
            if (_loc1_[_loc3_] is lockBlock)
            {
              if (_loc1_[_loc3_].unlocked)
              {
                continue;
              }
              if (this.keysObtained > 0)
              {
                _loc1_[_loc3_].unlock();
                _loc4_ = this.main.obstacles;
                _loc5_ = 0;
                while (_loc5_ < _loc4_.length)
                {
                  if (_loc4_[_loc5_] is key)
                  {
                    if (_loc4_[_loc5_].target == this)
                    {
                      _loc4_[_loc5_].useKey();
                      break;
                    }
                  }
                  _loc5_++;
                }
                continue;
              }
            }
            if (this.ySpeed > 20)
            {
              this.freeFallHit(_loc1_[_loc3_]);
            }
            _loc2_ = true;
            if (this.currentPulley)
            {
              if (this.body.hitTestObject(_loc1_[_loc3_]))
              {
                if (_loc1_[_loc3_] is lockBlock)
                {
                  if (_loc1_[_loc3_].unlocked)
                  {
                    continue;
                  }
                }
                if (_loc1_[_loc3_] is iceBlock)
                {
                  if (_loc1_[_loc3_].melted)
                  {
                    continue;
                  }
                }
                this.pulleyDrop();
              }
            }
            if (this.feet.hitTestObject(_loc1_[_loc3_].topBound))
            {
              _loc6_ = true;
              _loc7_ = _loc1_.concat(this.main.slopes);
              _loc8_ = 0;
              while (_loc8_ < _loc7_.length)
              {
                if (_loc7_[_loc8_].visible)
                {
                  _loc9_ = new Point(_loc1_[_loc3_].x + 1, _loc1_[_loc3_].y - 1);
                  _loc10_ = parent.localToGlobal(_loc9_);
                  if (_loc7_[_loc8_].hitTestPoint(_loc10_.x, _loc10_.y))
                  {
                    if (Math.round(_loc7_[_loc8_].x) == Math.round(_loc1_[_loc3_].x) && x - 2 < _loc1_[_loc3_].x)
                    {
                      this.falling = true;
                      _loc6_ = false;
                      break;
                    }
                  }
                  else
                  {
                    _loc9_ = new Point(_loc1_[_loc3_].x + _loc1_[_loc3_].width - 1, _loc1_[_loc3_].y - 1);
                    _loc11_ = parent.localToGlobal(_loc9_);
                    if (_loc7_[_loc8_].hitTestPoint(_loc11_.x, _loc11_.y))
                    {
                      if (Math.round(_loc7_[_loc8_].x + _loc7_[_loc8_].width) == Math.round(_loc1_[_loc3_].x + _loc1_[_loc3_].width) && x + 2 > _loc1_[_loc3_].x + _loc1_[_loc3_].width)
                      {
                        this.falling = true;
                        _loc6_ = false;
                        break;
                      }
                    }
                  }
                }
                _loc8_++;
              }
              if (_loc6_)
              {
                parent.setChildIndex(this, parent.numChildren - 1);
                if (this.ySpeed > -2)
                {
                  this.scaleHistory = null;
                  if (this.falling || this.scaling || this.hanging)
                  {
                    gotoAndStop(4);
                  }
                  this.ySpeed = 0;
                  x += _loc1_[_loc3_].xSpeed;
                  y = _loc1_[_loc3_].y;
                  if (_loc1_[_loc3_].ySpeed > 0)
                  {
                    y += _loc1_[_loc3_].ySpeed * 0.5;
                  }
                  this.running = true;
                  this.falling = false;
                  this.scaling = false;
                  this.hanging = false;
                  this.currentCannon = null;
                  if (!this.currentSlope)
                  {
                    this.rotationDest = 0;
                  }
                  _loc1_[_loc3_].landed();
                  this.acc = 1;
                  if (_loc1_[_loc3_] is iceBlock)
                  {
                    this.acc = 0.15;
                  }
                  this.checkCrushTop(_loc1_[_loc3_]);
                }
              }
            }
            else if (this.hands.hitTestObject(_loc1_[_loc3_].leftHangBound))
            {
              if (this.ySpeed >= _loc1_[_loc3_].ySpeed)
              {
                if (this.hangTime >= this.maxHangCoolDown && ExternalInterface.call("canUseMove", "walljump"))
                {
                  if (this.falling || this.hanging)
                  {
                    if (currentFrame == 2)
                    {
                      if (this.inner_animation.currentFrame > 8)
                      {
                        this.inner_animation.gotoAndStop(8);
                      }
                    }
                    this.scaleHistory = _loc1_[_loc3_];
                    _loc12_ = true;
                    _loc7_ = _loc1_.concat(this.main.slopes);
                    _loc8_ = 0;
                    while (_loc8_ < _loc7_.length)
                    {
                      if (_loc7_[_loc8_].visible)
                      {
                        _loc9_ = new Point(this.scaleHistory.x + 1, this.scaleHistory.y - 1);
                        _loc10_ = parent.localToGlobal(_loc9_);
                        if (_loc7_[_loc8_].hitTestPoint(_loc10_.x, _loc10_.y))
                        {
                          if (!(_loc7_[_loc8_] is verticalUpBlock || _loc1_[_loc3_] is verticalUpBlock))
                          {
                            this.falling = true;
                            this.hanging = false;
                            _loc12_ = false;
                            gotoAndStop(2);
                            this.inner_animation.gotoAndStop(8);
                            break;
                          }
                          if (currentFrame == 6 && this.inner_animation.currentFrame > 65)
                          {
                            this.falling = true;
                            this.hanging = false;
                            _loc12_ = false;
                            gotoAndStop(2);
                            this.inner_animation.gotoAndStop(8);
                            break;
                          }
                          if (this.inner_animation.currentFrame == 6)
                          {
                            this.inner_animation.gotoAndPlay(53);
                          }
                        }
                      }
                      _loc8_++;
                    }
                    if (_loc12_)
                    {
                      this.xSpeed = _loc1_[_loc3_].xSpeed;
                      this.ySpeed = _loc1_[_loc3_].ySpeed;
                      this.falling = false;
                      if (!this.hanging)
                      {
                        this.main.playSound("ConnectHang", false, false, true);
                      }
                      this.hanging = true;
                      x = _loc1_[_loc3_].x - 4.5;
                      y = _loc1_[_loc3_].y + 35;
                      if (_loc1_[_loc3_].ySpeed > 0)
                      {
                        y += _loc1_[_loc3_].ySpeed;
                      }
                      gotoAndStop(6);
                    }
                  }
                }
              }
            }
            else if (this.hands.hitTestObject(_loc1_[_loc3_].rightHangBound))
            {
              if (this.ySpeed >= _loc1_[_loc3_].ySpeed)
              {
                if (this.hangTime >= this.maxHangCoolDown && ExternalInterface.call("canUseMove", "walljump"))
                {
                  if (this.falling || this.hanging)
                  {
                    if (currentFrame == 2)
                    {
                      if (this.inner_animation.currentFrame > 8)
                      {
                        this.inner_animation.gotoAndStop(8);
                      }
                    }
                    this.scaleHistory = _loc1_[_loc3_];
                    _loc12_ = true;
                    _loc7_ = _loc1_.concat(this.main.slopes);
                    _loc8_ = 0;
                    while (_loc8_ < _loc7_.length)
                    {
                      if (_loc7_[_loc8_].visible)
                      {
                        _loc9_ = new Point(this.scaleHistory.x + this.scaleHistory.width - 1, this.scaleHistory.y - 1);
                        _loc10_ = parent.localToGlobal(_loc9_);
                        if (_loc7_[_loc8_].hitTestPoint(_loc10_.x, _loc10_.y))
                        {
                          if (!(_loc7_[_loc8_] is verticalUpBlock || _loc1_[_loc3_] is verticalUpBlock))
                          {
                            this.falling = true;
                            this.hanging = false;
                            _loc12_ = false;
                            gotoAndStop(2);
                            this.inner_animation.gotoAndStop(8);
                            break;
                          }
                          if (currentFrame == 6 && this.inner_animation.currentFrame > 65)
                          {
                            this.falling = true;
                            this.hanging = false;
                            _loc12_ = false;
                            gotoAndStop(2);
                            this.inner_animation.gotoAndStop(8);
                            break;
                          }
                          if (this.inner_animation.currentFrame == 6)
                          {
                            this.inner_animation.gotoAndPlay(53);
                          }
                        }
                      }
                      _loc8_++;
                    }
                    if (_loc12_)
                    {
                      this.xSpeed = _loc1_[_loc3_].xSpeed;
                      this.ySpeed = _loc1_[_loc3_].ySpeed;
                      this.falling = false;
                      if (!this.hanging)
                      {
                        this.main.playSound("ConnectHang", false, false, true);
                      }
                      this.hanging = true;
                      x = _loc1_[_loc3_].x + _loc1_[_loc3_].width + 4.5;
                      y = _loc1_[_loc3_].y + 35;
                      if (_loc1_[_loc3_].ySpeed > 0)
                      {
                        y += _loc1_[_loc3_].ySpeed;
                      }
                      gotoAndStop(6);
                    }
                  }
                }
              }
            }
            else if (this.head.hitTestObject(_loc1_[_loc3_].bottomBound))
            {
              if (this.ySpeed < 0)
              {
                _loc1_[_loc3_].snapBottom(this);
                this.ySpeed *= -0.5;
                y += this.ySpeed;
                continue;
              }
            }
            else if (this.hands.hitTestObject(_loc1_[_loc3_].leftBound))
            {
              if (_loc1_[_loc3_] is pushBlock)
              {
                if (scaleX > 0)
                {
                  if (!this.falling)
                  {
                    if (currentFrame == 13 || currentFrame == 3)
                    {
                      _loc13_ = false;
                      _loc14_ = 0;
                      while (_loc14_ < _loc1_.length)
                      {
                        if (_loc1_[_loc14_].visible)
                        {
                          _loc9_ = new Point(_loc1_[_loc3_].x + _loc1_[_loc3_].width + 1, _loc1_[_loc3_].y + _loc1_[_loc3_].height - 1);
                          _loc10_ = parent.localToGlobal(_loc9_);
                          if (_loc1_[_loc14_].hitTestPoint(_loc10_.x, _loc10_.y))
                          {
                            this.xSpeed = 0;
                            gotoAndStop(3);
                            _loc13_ = true;
                            x = _loc1_[_loc3_].x - 7;
                            break;
                          }
                        }
                        _loc14_++;
                      }
                      if (!_loc13_)
                      {
                        _loc1_[_loc3_].xSpeed = this.xSpeed;
                        _loc1_[_loc3_].pushed = true;
                        this.pushing = true;
                        if (currentFrame != 13)
                        {
                          gotoAndStop(13);
                        }
                      }
                    }
                  }
                }
                else if (currentFrame == 13)
                {
                  gotoAndStop(1);
                  this.pushing = false;
                }
              }
              if (this.xSpeed >= 9.5)
              {
                this.kill(11);
                return;
              }
              if (scaleX > 0)
              {
                if (!this.scaling)
                {
                  if (this.falling)
                  {
                    if (y < _loc1_[_loc3_].y + _loc1_[_loc3_].height + height * 0.5)
                    {
                      if (this.ySpeed > -4)
                      {
                        if (this.scaleHistory != _loc1_[_loc3_].leftBound && ExternalInterface.call("canUseMove", "walljump"))
                        {
                          this.main.playSound("Connect", false, false, true);
                          if (this.ySpeed > 10)
                          {
                            this.main.playSound("wallSlide", false, false, true);
                          }
                          this.scaleHistory = _loc1_[_loc3_].leftBound;
                          this.scaling = true;
                          this.rotationDest = 0;
                          this.falling = false;
                          this.hanging = false;
                          this.scaleTime = 0;
                          gotoAndStop(5);
                          x = _loc1_[_loc3_].x - width * 0.5 + 3;
                          this.xSpeed = 0;
                          if (this.ySpeed < 1 + _loc1_[_loc3_].ySpeed)
                          {
                            this.ySpeed = 1 + _loc1_[_loc3_].ySpeed;
                          }
                        }
                      }
                    }
                  }
                }
                else
                {
                  x = _loc1_[_loc3_].x - width * 0.5 + 3;
                  this.xSpeed = 0;
                  if (this.ySpeed > 1 + _loc1_[_loc3_].ySpeed)
                  {
                    this.ySpeed -= 2;
                    if (this.ySpeed < 1 + _loc1_[_loc3_].ySpeed)
                    {
                      this.ySpeed = 1 + _loc1_[_loc3_].ySpeed;
                    }
                  }
                  this.falling = false;
                  gotoAndStop(5);
                  ++this.scaleTime;
                  if (this.scaleTime == this.maxScaleTime)
                  {
                    this.scaling = false;
                    this.falling = true;
                    gotoAndStop(2);
                  }
                }
              }
            }
            else if (this.hands.hitTestObject(_loc1_[_loc3_].rightBound))
            {
              this.checkCrushSide(_loc1_[_loc3_]);
              if (_loc1_[_loc3_] is house)
              {
                return;
              }
              if (_loc1_[_loc3_] is pushBlock)
              {
                if (scaleX < 0)
                {
                  if (!this.falling)
                  {
                    if (currentFrame == 13 || currentFrame == 3)
                    {
                      _loc13_ = false;
                      _loc14_ = 0;
                      while (_loc14_ < _loc1_.length)
                      {
                        if (_loc1_[_loc14_].visible)
                        {
                          _loc9_ = new Point(_loc1_[_loc3_].x - 1, _loc1_[_loc3_].y + _loc1_[_loc3_].height - 1);
                          _loc10_ = parent.localToGlobal(_loc9_);
                          if (_loc1_[_loc14_].hitTestPoint(_loc10_.x, _loc10_.y))
                          {
                            this.xSpeed = 0;
                            gotoAndStop(3);
                            _loc13_ = true;
                            x = _loc1_[_loc3_].x + _loc1_[_loc3_].width + 7;
                            break;
                          }
                        }
                        _loc14_++;
                      }
                      if (!_loc13_)
                      {
                        _loc1_[_loc3_].xSpeed = this.xSpeed;
                        _loc1_[_loc3_].pushed = true;
                        this.pushing = true;
                        if (currentFrame != 13)
                        {
                          gotoAndStop(13);
                        }
                      }
                    }
                  }
                }
                else if (currentFrame == 13)
                {
                  gotoAndStop(1);
                  this.pushing = false;
                }
              }
              if (this.xSpeed <= -9.5)
              {
                this.kill(11);
                return;
              }
              if (scaleX < 0)
              {
                if (!this.scaling)
                {
                  if (this.falling)
                  {
                    if (y < _loc1_[_loc3_].y + _loc1_[_loc3_].height + height * 0.5)
                    {
                      if (this.ySpeed > -4)
                      {
                        if (this.scaleHistory != _loc1_[_loc3_].rightBound && ExternalInterface.call("canUseMove", "walljump"))
                        {
                          this.main.playSound("Connect", false, false, true);
                          if (this.ySpeed > 10)
                          {
                            this.main.playSound("wallSlide", false, false, true);
                          }
                          this.scaleHistory = _loc1_[_loc3_].rightBound;
                          this.scaling = true;
                          this.rotationDest = 0;
                          this.falling = false;
                          this.hanging = false;
                          this.scaleTime = 0;
                          gotoAndStop(5);
                          x = _loc1_[_loc3_].x + _loc1_[_loc3_].width + width * 0.5 - 3;
                          this.xSpeed = 0;
                          if (this.ySpeed < 1 + _loc1_[_loc3_].ySpeed)
                          {
                            this.ySpeed = 1 + _loc1_[_loc3_].ySpeed;
                          }
                        }
                      }
                    }
                  }
                }
                else
                {
                  x = _loc1_[_loc3_].x + _loc1_[_loc3_].width + width * 0.5 - 3;
                  this.xSpeed = 0;
                  if (this.ySpeed > 1 + _loc1_[_loc3_].ySpeed)
                  {
                    this.ySpeed -= 2;
                    if (this.ySpeed < 1 + _loc1_[_loc3_].ySpeed)
                    {
                      this.ySpeed = 1 + _loc1_[_loc3_].ySpeed;
                    }
                  }
                  this.falling = false;
                  gotoAndStop(5);
                  ++this.scaleTime;
                  if (this.scaleTime == this.maxScaleTime)
                  {
                    this.scaling = false;
                    this.falling = true;
                    gotoAndStop(2);
                  }
                }
              }
            }
            if (this.body.hitTestObject(_loc1_[_loc3_].leftBound))
            {
              if (!this.hanging)
              {
                if (this.xSpeed >= 0)
                {
                  x = _loc1_[_loc3_].x - 7;
                  this.xSpeed = _loc1_[_loc3_].xSpeed;
                  this.currentPole = null;
                }
              }
            }
            else if (this.body.hitTestObject(_loc1_[_loc3_].rightBound))
            {
              if (_loc1_[_loc3_] is house)
              {
                return;
              }
              if (!this.hanging)
              {
                if (this.xSpeed <= 0)
                {
                  x = _loc1_[_loc3_].x + _loc1_[_loc3_].width + 7;
                  this.xSpeed = _loc1_[_loc3_].xSpeed;
                  this.currentPole = null;
                }
              }
              this.checkCrushSide(_loc1_[_loc3_]);
            }
          }
        }
      }
    }

    protected function boundsInvis():void
    {
      this.feet.visible = false;
      this.body.visible = false;
      this.hands.visible = false;
      this.head.visible = false;
    }

    public function kill(param1:int = 0):void
    {
      var _loc3_:* = undefined;
      var _loc2_:int = 0;
      while (_loc2_ < 15)
      {
        if (Math.random() < 0.5 || param1 == 14)
        {
          _loc3_ = new particle(16711680, 4);
        }
        else
        {
          _loc3_ = new particle();
        }
        _loc3_.x = x;
        _loc3_.y = y;
        if (this.swimming)
        {
          _loc3_.xSpeed = Math.random() * 30 - 15;
          _loc3_.ySpeed = Math.random() * 6 - 3;
        }
        else
        {
          _loc3_.xSpeed = Math.random() * 15 - 8;
          _loc3_.ySpeed = Math.random() * 15 - 8;
        }
        parent.addChild(_loc3_);
        _loc2_++;
      }
      this.main.incDeath(param1);
      this.respawn();
    }

    public function respawn(param1:Boolean = false):void
    {
      var _loc6_:int = 0;
      this.destLevelTintStr = 0;
      if (MovieClip(parent).currentFrame != 2)
      {
        x = this.checkPoint.x;
        y = this.checkPoint.y;
      }
      else
      {
        this.searchBlocks();
      }
      this.ySpeed = 0;
      this.xSpeed = 0;
      rotation = 0;
      this.rotationDest = 0;
      this.friction = 1;
      this.keysObtained = 0;
      this.falling = true;
      this.hanging = false;
      this.scaling = false;
      this.crouching = false;
      this.teleporting = false;
      this.squeezing = false;
      this.swimming = false;
      this.kicking = false;
      if (this.currentPole)
      {
        this.currentPole.redSection.alpha = 0;
      }
      this.currentPole = null;
      this.currentPool = null;
      this.currentSlope = null;
      this.currentCannon = null;
      this.currentPulley = null;
      this.breathe = 10;
      visible = false;
      scaleX = 1;
      scaleY = 1;
      this.gravity = this.startGravity;
      this.maxSpeed = 6;
      filters = [];
      this.tintStr = 0;
      this.createTint(16711680, this.tintStr);
      if (this.main.dark is darkOverlay)
      {
        this.main.removeChild(this.main.dark);
        this.main.dark = null;
        // this.main.dark = new flashOverlay();
        // this.main.dark.x = x + parent.x;
        // this.main.dark.y = y + parent.y - height * 0.5;
        // this.main.addChild(this.main.dark);
        // _loc6_ = this.main.getChildIndex(this.main.level) + 1;
        // this.main.setChildIndex(this.main.dark, _loc6_);
      }
      var _loc2_:Array = this.main.obstacles;
      var _loc3_:int = 0;
      while (_loc3_ < _loc2_.length)
      {
        if (_loc2_[_loc3_] is lever)
        {
          _loc2_[_loc3_].active = false;
        }
        if (_loc2_[_loc3_] is key)
        {
          if (!_loc2_[_loc3_].saveUse)
          {
            _loc2_[_loc3_].respawn();
          }
        }
        else if ("respawn" in _loc2_[_loc3_])
        {
          _loc2_[_loc3_].respawn();
        }
        _loc3_++;
      }
      var _loc4_:Array = this.main.blocks;
      var _loc5_:int = 0;
      while (_loc5_ < _loc4_.length)
      {
        _loc4_[_loc5_].respawn();
        _loc5_++;
      }
    }

    public function reset():void
    {
      this.main.resetStage();
      this.main.incMilliseconds(0);
      this.checkPoint.x = 0;
      this.checkPoint.y = 0;
      if (this.level.currentFrame == 13)
      {
        this.checkPoint.x = this.main.localMap[0];
        this.checkPoint.y = this.main.localMap[1];
      }
      this.checkpointsReached = 0;
      this.forceRespawnItems();
      this.respawn();
    }

    private function searchBlocks():void
    {
      var _loc3_:int = 0;
      var _loc1_:* = MovieClip(root).blocks;
      var _loc2_:int = additionalMaths.getDistance(this, _loc1_[0]);
      _loc3_ = 0;
      while (_loc3_ < _loc1_.length)
      {
        if (additionalMaths.getDistance(this, _loc1_[_loc3_]) < _loc2_)
        {
          _loc2_ = additionalMaths.getDistance(this, _loc1_[_loc3_]);
        }
        _loc3_++;
      }
      _loc3_ = 0;
      while (_loc3_ < _loc1_.length)
      {
        if (additionalMaths.getDistance(this, _loc1_[_loc3_]) == _loc2_)
        {
          y = _loc1_[_loc3_].y - height;
          x = _loc1_[_loc3_].x + _loc1_[_loc3_].width * 0.5;
          break;
        }
        _loc3_++;
      }
    }

    private function forceRespawnItems():void
    {
      var _loc1_:Array = this.main.blocks;
      var _loc2_:int = 0;
      while (_loc2_ < _loc1_.length)
      {
        if ("saveUse" in _loc1_[_loc2_])
        {
          _loc1_[_loc2_].saveUse = false;
        }
        _loc2_++;
      }
      var _loc3_:Array = this.main.obstacles;
      var _loc4_:int = 0;
      while (_loc4_ < _loc3_.length)
      {
        if ("saveUse" in _loc3_[_loc4_])
        {
          _loc3_[_loc4_].saveUse = false;
        }
        _loc4_++;
      }
    }

    public function decideSpawnFrame():void
    {
      gotoAndStop(2);
      var _loc1_:Array = this.main.blocks;
      var _loc2_:int = 0;
      while (_loc2_ < _loc1_.length)
      {
        if (_loc1_[_loc2_].visible)
        {
          if (this.hitTestObject(_loc1_[_loc2_].topBound))
          {
            gotoAndStop(1);
          }
        }
        _loc2_++;
      }
      this.xSpeed = 0;
      this.ySpeed = 0;
    }

    protected function freeFallHit(param1:MovieClip):void
    {
      if (param1 is bounceBlock)
      {
        this.ySpeed = 0;
        y = param1.y;
        if (param1.ySpeed > 0)
        {
          y += param1.ySpeed;
        }
        this.running = true;
        this.falling = false;
        this.scaling = false;
        this.hanging = false;
        if (!this.currentSlope)
        {
          this.rotationDest = 0;
        }
        param1.landed();
        this.main.incAchievement(28);
      }
      else
      {
        this.kill(2);
      }
    }

    protected function checkLeverCollisions():void
    {
      this.currentLever = null;
      if (!ExternalInterface.call("canUseMove", "lever"))
      {
        return;
      }
      var _loc1_:Array = this.main.obstacles;
      var _loc2_:int = 0;
      while (_loc2_ < _loc1_.length)
      {
        if (_loc1_[_loc2_] is lever)
        {
          if (this.hitTestObject(_loc1_[_loc2_]))
          {
            this.currentLever = _loc1_[_loc2_];
          }
        }
        _loc2_++;
      }
    }

    protected function checkSlopeCollisions():void
    {
      var _loc3_:Boolean = false;
      var _loc4_:Array = null;
      var _loc5_:Array = null;
      var _loc6_:int = 0;
      var _loc7_:* = undefined;
      var _loc8_:Point = null;
      var _loc9_:Number = NaN;
      var _loc10_:* = undefined;
      this.currentSlope = null;
      var _loc1_:Array = this.main.slopes;
      var _loc2_:int = 0;
      for (; _loc2_ < _loc1_.length; _loc2_++)
      {
        if (_loc1_[_loc2_].visible)
        {
          if (this.hands.hitTestObject(_loc1_[_loc2_].wall))
          {
            if (_loc1_[_loc2_] is leftSlope)
            {
              if (scaleX < 0)
              {
                if (this.scaling)
                {
                  x = _loc1_[_loc2_].x + _loc1_[_loc2_].width + 5;
                  this.xSpeed = 0;
                  if (this.ySpeed > 1)
                  {
                    this.ySpeed -= 2;
                    if (this.ySpeed < 1)
                    {
                      this.ySpeed = 1;
                    }
                  }
                  this.falling = false;
                  gotoAndStop(5);
                  ++this.scaleTime;
                  if (this.scaleTime == this.maxScaleTime)
                  {
                    this.scaling = false;
                    this.falling = true;
                    gotoAndStop(2);
                  }
                  parent.setChildIndex(this, parent.numChildren - 1);
                  continue;
                }
                if (this.falling)
                {
                  if (y < _loc1_[_loc2_].y + _loc1_[_loc2_].height + height * 0.5)
                  {
                    if (this.ySpeed > -4)
                    {
                      if (this.scaleHistory != _loc1_[_loc2_].wall && ExternalInterface.call("canUseMove", "walljump"))
                      {
                        this.scaleHistory = _loc1_[_loc2_].wall;
                        this.scaling = true;
                        this.rotationDest = 0;
                        this.falling = false;
                        this.hanging = false;
                        this.scaleTime = 0;
                        gotoAndStop(5);
                        x = _loc1_[_loc2_].x + _loc1_[_loc2_].width + 5;
                        this.xSpeed = 0;
                        continue;
                      }
                    }
                  }
                }
              }
            }
            else if (_loc1_[_loc2_] is rightSlope)
            {
              if (scaleX > 0)
              {
                if (this.scaling)
                {
                  x = _loc1_[_loc2_].x - 5;
                  this.xSpeed = 0;
                  if (this.ySpeed > 1)
                  {
                    this.ySpeed -= 2;
                    if (this.ySpeed < 1)
                    {
                      this.ySpeed = 1;
                    }
                  }
                  this.falling = false;
                  gotoAndStop(5);
                  ++this.scaleTime;
                  if (this.scaleTime == this.maxScaleTime)
                  {
                    this.scaling = false;
                    this.falling = true;
                    gotoAndStop(2);
                  }
                  parent.setChildIndex(this, parent.numChildren - 1);
                  continue;
                }
                if (this.falling)
                {
                  if (y < _loc1_[_loc2_].y + _loc1_[_loc2_].height + height * 0.5)
                  {
                    if (this.ySpeed > -4)
                    {
                      if (this.scaleHistory != _loc1_[_loc2_].wall && ExternalInterface.call("canUseMove", "walljump"))
                      {
                        this.scaleHistory = _loc1_[_loc2_].wall;
                        this.scaling = true;
                        this.rotationDest = 0;
                        this.falling = false;
                        this.hanging = false;
                        this.scaleTime = 0;
                        gotoAndStop(5);
                        x = _loc1_[_loc2_].x - 5;
                        this.xSpeed = 0;
                        continue;
                      }
                    }
                  }
                }
              }
            }
          }
          if (this.body.hitTestObject(_loc1_[_loc2_].wall))
          {
            if (_loc1_[_loc2_] is leftSlope)
            {
              if (!this.hanging)
              {
                if (!this.scaling)
                {
                  if (this.xSpeed < 0)
                  {
                    x = _loc1_[_loc2_].x + _loc1_[_loc2_].width + 7;
                    this.xSpeed = 0;
                    continue;
                  }
                }
              }
            }
            else if (_loc1_[_loc2_] is rightSlope)
            {
              if (!this.hanging)
              {
                !this.scaling;
              }
              if (this.xSpeed > 0)
              {
                x = _loc1_[_loc2_].x - 7;
                this.xSpeed = 0;
                continue;
              }
            }
          }
          if (this.head.hitTestObject(_loc1_[_loc2_].bottom))
          {
            if (this.ySpeed < 0)
            {
              if (y >= _loc1_[_loc2_].y + _loc1_[_loc2_].height - this.ySpeed)
              {
                _loc3_ = false;
                _loc4_ = this.main.blocks;
                _loc5_ = _loc4_.concat(this.main.slopes);
                _loc6_ = 0;
                while (_loc6_ < _loc5_.length)
                {
                  if (_loc5_[_loc6_].visible)
                  {
                    if (_loc1_[_loc2_] is leftSlope)
                    {
                      _loc8_ = new Point(_loc1_[_loc2_].x + 1, _loc1_[_loc2_].y + _loc1_[_loc2_].height + 1);
                    }
                    else
                    {
                      _loc8_ = new Point(_loc1_[_loc2_].x + _loc1_[_loc2_].width - 1, _loc1_[_loc2_].y + _loc1_[_loc2_].height + 1);
                    }
                    _loc7_ = parent.localToGlobal(_loc8_);
                    if (_loc5_[_loc6_].hitTestPoint(_loc7_.x, _loc7_.y))
                    {
                      _loc3_ = true;
                    }
                  }
                  _loc6_++;
                }
                if (!_loc3_)
                {
                  y = _loc1_[_loc2_].y + _loc1_[_loc2_].height + height;
                  this.ySpeed *= -0.5;
                  y += this.ySpeed;
                  this.scaleHistory = null;
                }
              }
            }
          }
          if (x > _loc1_[_loc2_].x)
          {
            if (x < _loc1_[_loc2_].x + _loc1_[_loc2_].width)
            {
              if (y > _loc1_[_loc2_].y - 5)
              {
                if (y < _loc1_[_loc2_].y + _loc1_[_loc2_].height + 5)
                {
                  if (_loc1_[_loc2_] is leftSlope)
                  {
                    _loc9_ = (x - _loc1_[_loc2_].x) / _loc1_[_loc2_].width;
                    if (y >= _loc1_[_loc2_].y + _loc1_[_loc2_].height - _loc1_[_loc2_].height * _loc9_)
                    {
                      _loc10_ = _loc1_[_loc2_].height / _loc1_[_loc2_].width;
                      if (this.ySpeed > -5 - _loc10_ && ExternalInterface.call("canUseMove", "slide"))
                      {
                        if (this.ySpeed >= 20)
                        {
                          this.kill(3);
                          return;
                        }
                        if (this.ySpeed > 1)
                        {
                          this.xSpeed = -this.ySpeed * 0.5;
                        }
                        this.ySpeed = 0;
                        this.rotationDest = -45 * _loc10_;
                        y = _loc1_[_loc2_].y + _loc1_[_loc2_].height - _loc1_[_loc2_].height * _loc9_ + 2;
                        if (y < _loc1_[_loc2_].y)
                        {
                          y = _loc1_[_loc2_].y;
                        }
                        this.currentSlope = _loc1_[_loc2_];
                        this.scaleHistory = null;
                        if (this.falling || this.scaling)
                        {
                          gotoAndStop(4);
                        }
                        this.running = true;
                        this.falling = false;
                        this.scaling = false;
                        this.hanging = false;
                      }
                    }
                  }
                  else if (_loc1_[_loc2_] is rightSlope)
                  {
                    _loc9_ = 1 - (x - _loc1_[_loc2_].x) / _loc1_[_loc2_].width;
                    if (y >= _loc1_[_loc2_].y + _loc1_[_loc2_].height - _loc1_[_loc2_].height * _loc9_)
                    {
                      _loc10_ = _loc1_[_loc2_].height / _loc1_[_loc2_].width;
                      if (this.ySpeed > -5 - _loc10_ && ExternalInterface.call("canUseMove", "slide"))
                      {
                        if (this.ySpeed >= 20)
                        {
                          this.kill(3);
                          return;
                        }
                        if (this.ySpeed > 1)
                        {
                          this.xSpeed = this.ySpeed * 0.5;
                        }
                        this.ySpeed = 0;
                        this.rotationDest = 45 * _loc10_;
                        y = _loc1_[_loc2_].y + _loc1_[_loc2_].height - _loc1_[_loc2_].height * _loc9_ + 2;
                        if (y < _loc1_[_loc2_].y)
                        {
                          y = _loc1_[_loc2_].y;
                        }
                        this.currentSlope = _loc1_[_loc2_];
                        this.scaleHistory = null;
                        if (this.falling || this.scaling)
                        {
                          gotoAndStop(4);
                        }
                        this.running = true;
                        this.falling = false;
                        this.scaling = false;
                        this.hanging = false;
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    }

    protected function checkPoolCollisions():void
    {
      var _loc3_:int = 0;
      var _loc4_:Number = NaN;
      var _loc5_:* = undefined;
      var _loc1_:Array = this.main.pools;
      var _loc2_:Boolean = false;
      _loc3_ = 0;
      while (_loc3_ < _loc1_.length)
      {
        if (this.body.hitTestObject(_loc1_[_loc3_]))
        {
          _loc2_ = true;
          if (currentFrame != 10 && ExternalInterface.call("canUseMove", "swim"))
          {
            if (this.ySpeed >= 0)
            {
              _loc4_ = Number(Math.random());
              if (_loc4_ < 0.33)
              {
                this.main.playSound("splash1", false);
              }
              else if (_loc4_ < 0.66)
              {
                this.main.playSound("splash2", false);
              }
              else
              {
                this.main.playSound("splash3", false);
              }
              this.currentPool = _loc1_[_loc3_];
              this.swimming = true;
              this.scaling = false;
              this.hanging = false;
              this.falling = false;
              this.crouching = false;
              scaleX = 1;
              this.swimmingLegs = [];
              gotoAndStop(10);
              this.inner_animation.top_half.rotation = 0;
              this.inner_animation.bottom_half.rotation = 0;
              this.scaleHistory = null;
              _loc3_ = 0;
              while (_loc3_ < 10)
              {
                _loc5_ = new particle(3394815, 4, true, true);
                _loc5_.x = x + Math.random() * 10 - 5;
                _loc5_.y = y - height * 0.5;
                _loc5_.xSpeed = Math.random() * 8 - 4;
                _loc5_.ySpeed = Math.random() * -8;
                parent.addChild(_loc5_);
                parent.setChildIndex(_loc5_, 0);
                _loc3_++;
              }
              this.breatheTimer.start();
            }
          }
        }
        if (this.ySpeed < 0)
        {
          if (this.feet.hitTestObject(_loc1_[_loc3_].topBound))
          {
            if (this.swimming)
            {
              this.main.playSound("splash1", false, false, true);
            }
            this.currentPool = null;
            this.swimming = false;
            gotoAndStop(2);
            this.ySpeed = -5;
            this.falling = true;
            this.getJump();
            _loc3_ = 0;
            while (_loc3_ < 10)
            {
              _loc5_ = new particle(3394815, 4, true, true);
              _loc5_.x = x + Math.random() * 10 - 5;
              _loc5_.y = y - height * 0.5;
              _loc5_.xSpeed = Math.random() * 8 - 4;
              _loc5_.ySpeed = Math.random() * -6;
              parent.addChild(_loc5_);
              parent.setChildIndex(_loc5_, 0);
              _loc3_++;
            }
          }
        }
        _loc3_++;
      }
      if (!_loc2_)
      {
        this.swimming = false;
        this.breathe = 10;
        this.breatheTimer.stop();
      }
    }

    protected function breatheDown(param1:TimerEvent):void
    {
      if (this.swimming)
      {
        if (this.main.window == null)
        {
          --this.breathe;
          if (this.breathe <= 0)
          {
            this.kill(8);
            this.breatheTimer.reset();
            return;
          }
          this.breatheTimer.reset();
          this.breatheTimer.start();
          return;
        }
      }
      this.breatheTimer.reset();
      this.breatheTimer.start();
    }

    protected function stageBlur():void
    {
      parent.filters = null;
      var _loc1_:BitmapFilter = new BlurFilter(int(Math.sqrt(this.xSpeed * this.xSpeed - 19) * 0.2), int(Math.sqrt(this.ySpeed * this.ySpeed - 19) * 0.2), BitmapFilterQuality.LOW);
      var _loc2_:Array = new Array();
      _loc2_.push(_loc1_);
      parent.filters = _loc2_;
    }

    public function createGlow(param1:uint = 16777215):void
    {
      var _loc2_:GlowFilter = new GlowFilter();
      _loc2_.inner = true;
      _loc2_.color = param1;
      _loc2_.quality = 3;
      filters = [_loc2_];
    }

    protected function leverLogic():void
    {
      var _loc1_:int = 0;
      if (this.currentLever != null)
      {
        if (scaleX > 0)
        {
          _loc1_ = this.currentLever.x - 2;
          y = this.currentLever.y + 15;
          additionalMaths.easeToPoint(this, _loc1_, y);
          if (!this.currentLever.active)
          {
            if (this.inner_animation.currentFrame >= 2)
            {
              if (this.currentLever.leverTime <= 0)
              {
                this.currentLever.leverTime = 30;
                this.currentLever.activate();
                ++this.main.stats[7];
                this.main.playSound("leverClank", false);
                this.main.playSound("powerUp", false);
              }
            }
          }
          else if (this.inner_animation.currentFrame == 7)
          {
            if (this.currentLever.leverTime <= 0)
            {
              this.currentLever.leverTime = 30;
              this.currentLever.deactivate();
              this.main.playSound("leverClank", false);
              this.main.playSound("powerDown", false);
            }
          }
        }
        else
        {
          _loc1_ = this.currentLever.x + 23;
          y = this.currentLever.y + 15;
          additionalMaths.easeToPoint(this, _loc1_, y);
          if (this.currentLever.active)
          {
            if (this.inner_animation.currentFrame <= 2)
            {
              if (this.currentLever.leverTime <= 0)
              {
                this.currentLever.leverTime = 30;
                this.currentLever.deactivate();
                this.main.playSound("leverClank", false);
                this.main.playSound("powerDown", false);
              }
            }
          }
          else if (this.inner_animation.currentFrame == 7)
          {
            if (this.currentLever.leverTime <= 0)
            {
              this.currentLever.leverTime = 30;
              this.currentLever.activate();
              ++this.main.stats[7];
              this.main.playSound("leverClank", false);
              this.main.playSound("powerUp", false);
            }
          }
        }
      }
    }

    protected function checkCrushTop(param1:MovieClip):void
    {
      var _loc2_:Array = this.main.blocks;
      var _loc3_:int = 0;
      while (_loc3_ < _loc2_.length)
      {
        if (_loc2_[_loc3_].visible)
        {
          if (_loc2_[_loc3_] != param1)
          {
            if (this.head.hitTestObject(_loc2_[_loc3_].bottomBound))
            {
              if (_loc2_[_loc3_].ySpeed > 0.5 || param1.ySpeed < -0.5)
              {
                this.kill(7);
              }
            }
          }
        }
        _loc3_++;
      }
    }

    protected function checkCrushSide(param1:MovieClip):void
    {
      var _loc2_:Array = this.main.blocks;
      var _loc3_:int = 0;
      while (_loc3_ < _loc2_.length)
      {
        if (_loc2_[_loc3_].visible)
        {
          if (_loc2_[_loc3_] != param1)
          {
            if (this.body.hitTestObject(_loc2_[_loc3_].leftBound))
            {
              if (_loc2_[_loc3_].xSpeed > 0.5 || param1.xSpeed < -0.5)
              {
                this.kill(7);
              }
              else if (_loc2_[_loc3_] is enlargingBlock && _loc2_[_loc3_].enlargeInc > 0)
              {
                this.kill(7);
              }
              else if (param1 is enlargingBlock && param1.enlargeInc > 0)
              {
                this.kill(7);
              }
            }
          }
        }
        _loc3_++;
      }
    }

    protected function addedToStage(param1:Event):void
    {
      if (this.main.player != null)
      {
        parent.removeChild(this);
        return;
      }
      parent.setChildIndex(this, parent.numChildren - 1);
      this.startPoint.x = x;
      this.startPoint.y = y;
      this.checkPoint = this.startPoint;
    }

    public function backflip():void
    {
      gotoAndStop(2);
      this.inner_animation.gotoAndPlay(67);
    }

    public function cannonJump():void
    {
      var _loc3_:* = undefined;
      var _loc1_:int = this.currentCannon.rotation + this.currentCannon.cannonTube.rotation - 90;
      this.currentCannon.rotating = false;
      this.currentCannon.firing = false;
      parent.setChildIndex(this.currentCannon, 0);
      y = this.currentCannon.y - this.currentCannon.height;
      this.xSpeed = Math.cos(_loc1_ / 180 * Math.PI) * this.currentCannon.power;
      this.ySpeed = Math.sin(_loc1_ / 180 * Math.PI) * this.currentCannon.power;
      var _loc2_:int = 0;
      while (_loc2_ < 15)
      {
        if (Math.random() < 0.5)
        {
          _loc3_ = new particle(16711680, 4);
        }
        else
        {
          _loc3_ = new particle(16732240, 4);
        }
        _loc3_.x = x;
        _loc3_.y = y;
        _loc3_.xSpeed = this.xSpeed * 0.8 + Math.random() * 6 - 3;
        _loc3_.ySpeed = this.ySpeed * 0.8 + Math.random() * 6 - 3;
        parent.addChild(_loc3_);
        this.main.findColourChangeTransition(_loc3_);
        _loc2_++;
      }
      ++this.main.stats[5];
      y += this.ySpeed;
      this.falling = true;
      gotoAndStop(2);
      this.inner_animation.gotoAndPlay(82);
      this.currentCannon = null;
      this.main.playSound("cannonFire", false);
    }

    public function blewAway():void
    {
      this.falling = true;
      this.hanging = false;
      this.scaleHistory = null;
      gotoAndStop(2);
      this.inner_animation.gotoAndPlay(28);
      rotation = 90 * scaleX;
      this.ySpeed = -3;
      x += -width * scaleX;
      this.xSpeed = -10 * scaleX;
      this.main.incAchievement(20, 1);
    }

    protected function createTint(param1:uint = 16777215, param2:int = 50, param3:Boolean = false):void
    {
      if (param3)
      {
        this.levelTint.setTint(param1, param2 * 0.01);
        parent.transform.colorTransform = this.levelTint;
      }
      else
      {
        this.currentTint.setTint(param1, param2 * 0.01);
        this.transform.colorTransform = this.currentTint;
      }
    }

    protected function incMilliseconds(param1:Number = 1):void
    {
      this.main.incMilliseconds(param1);
    }

    internal function frame1():*
    {
      stop();
    }
  }
}
