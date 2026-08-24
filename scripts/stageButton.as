package
{
  import flash.display.MovieClip;
  import flash.events.Event;
  import flash.events.MouseEvent;
  import flash.text.TextField;
  import flash.external.ExternalInterface;

  [Embed(source="/_assets/assets.swf", symbol="symbol860")]
  public class stageButton extends button
  {

    public var stageName:TextField;

    public var stageID:int;

    public var select:Boolean = false;

    public var removed:Boolean = false;

    public var renderScreen:MovieClip;

    private var rendered:Boolean = false;

    private var renderingProgress:int = 0;

    public function stageButton()
    {
      super();
      addFrameScript(0, this.frame1, 28, this.frame29, 29, this.frame30);
      this.stageName.visible = false;
    }

    override protected function update(param1:Event):void
    {
      if (!this.removed)
      {
        if (currentFrame > 1)
        {
          if (y > startY)
          {
            y += gravity;
            gravity -= 0.25;
            if (y < startY)
            {
              gravity = 0;
              y = startY;
            }
          }
          else if (y < startY)
          {
            y -= gravity;
            gravity -= 0.25;
            if (y > startY)
            {
              gravity = 0;
              y = startY;
            }
          }
        }
        if (currentFrame == 30)
        {
          this.stageName.text = main.savedStagesNames[this.stageID];
          if (!this.rendered)
          {
            this.renderStage();
          }
        }
      }
    }

    override protected function rollOver(param1:MouseEvent):void
    {
      if (currentFrame == 1)
      {
        this.stageName.visible = true;
        buttonBG.gotoAndStop(2);
      }
      if (currentFrame >= 30)
      {
        if (y == startY)
        {
          gravity = 1.5;
          y -= gravity;
        }
      }
    }

    override protected function rollOut(param1:MouseEvent):void
    {
      if (currentFrame == 1)
      {
        this.stageName.visible = false;
        buttonBG.gotoAndStop(1);
      }
    }

    override protected function click(param1:MouseEvent):void
    {
      var _loc2_:Boolean = false;
      var _loc3_:Array = main.savedItemPacks;
      var _loc4_:int = 0;
      while (_loc4_ < _loc3_.length)
      {
        if (_loc3_[_loc4_])
        {
          _loc2_ = true;
          break;
        }
        _loc4_++;
      }
      if (!_loc2_)
      {
        gotoAndPlay(2);
        return;
      }
      if (currentFrame == 1)
      {
        main.newStageFunction();
        main.stageSelected = this.stageID;
        main.localMap = [];
      }
      else if (!this.select)
      {
        this.select = true;
        main.stageSelected = this.stageID;
        parent.setChildIndex(this, parent.numChildren - 1);
        parent.setChildIndex(MovieClip(parent).playStage, parent.numChildren - 1);
        parent.setChildIndex(MovieClip(parent).editStage, parent.numChildren - 1);
        parent.setChildIndex(MovieClip(parent).shareStage, parent.numChildren - 1);
        parent.setChildIndex(MovieClip(parent).deleteStage, parent.numChildren - 1);
      }
      else
      {
        this.select = false;
      }
    }

    public function playThisStage():void
    {
      main.newStageFunction();
      main.stageSelected = this.stageID;
      main.localMap = main.savedStages[this.stageID];
    }

    public function renderStage():void
    {
      var _loc4_:* = undefined;
      var _loc5_:int = 0;
      var _loc1_:Array = main.savedStages[this.stageID];
      _loc1_ = _loc1_.filter(main.fm);
      ExternalInterface.call("log", _loc1_, "_loc1_");
      var _loc2_:Array = [];
      var _loc3_:int = 4;
      while (_loc3_ < _loc1_.length - 1)
      {
        _loc2_ = main.getSCParameters(_loc1_[_loc3_]);
        if (_loc2_.length == 0)
        {
          break;
        }
        switch (_loc1_[_loc3_])
        {
          case 0:
            _loc4_ = new basicBlock();
            break;
          case 1:
            _loc4_ = new leftSlope();
            break;
          case 2:
            _loc4_ = new rightSlope();
            break;
          case 3:
            _loc4_ = new fallingBlock();
            break;
          case 4:
            _loc4_ = new swimmingPool();
            break;
          case 5:
            _loc4_ = new checkpoint();
            break;
          case 6:
            _loc4_ = new spike();
            break;
          case 8:
            _loc4_ = new bounceBlock();
            break;
          case 9:
            _loc4_ = new verticalDownBlock();
            break;
          case 10:
            _loc4_ = new verticalUpBlock();
            break;
          case 11:
            _loc4_ = new horizontalBlock();
            break;
          case 12:
            _loc4_ = new pendulum();
            break;
          case 13:
            _loc4_ = new iceBlock();
            break;
          case 14:
            _loc4_ = new lockBlock();
            break;
          case 15:
            _loc4_ = new pushBlock();
            break;
          case 16:
            _loc4_ = new enlargingBlock();
            break;
          case 17:
            _loc4_ = new darkBlock();
            break;
          case 18:
            _loc4_ = new invisBlock();
            break;
          case 19:
            _loc4_ = new spikeRaise();
            break;
          case 20:
            _loc4_ = new spinningBuzzsaw();
            break;
          case 21:
            _loc4_ = new shurikanSpawner();
            break;
          case 22:
            _loc4_ = new spiralRight();
            break;
          case 23:
            _loc4_ = new reaper();
            break;
          case 24:
            _loc4_ = new bouncingBuzzsaw();
            break;
          case 25:
            _loc4_ = new closingSpikes();
            break;
          case 26:
            _loc4_ = new laser();
            break;
          case 27:
            _loc4_ = new buzzsawOnStick();
            break;
          case 28:
            _loc4_ = new gravityUpLever();
            break;
          case 29:
            _loc4_ = new pole();
            break;
          case 30:
            _loc4_ = new cannon();
            break;
          case 31:
            _loc4_ = new breatheBlaster();
            break;
          case 32:
            _loc4_ = new windBlasterSmall();
            break;
          case 33:
            _loc4_ = new windBlaster();
            break;
          case 34:
            _loc4_ = new teleporter();
            break;
          case 35:
            _loc4_ = new teleporterReceiver();
            break;
          case 36:
            _loc4_ = new key();
            break;
          case 38:
            _loc4_ = new speedUpLever();
            break;
          case 39:
            _loc4_ = new lightSwitch();
            break;
          case 40:
            _loc4_ = new pulley();
            break;
          case 41:
            _loc4_ = new gravityDownLever();
            break;
          case 42:
            _loc4_ = new microwave();
            break;
          case 43:
            _loc4_ = new enlargingBuzzsaw();
            break;
          case 44:
            _loc4_ = new classicLaser();
            break;
          case 45:
            _loc4_ = new wiredBlock();
            break;
          case 46:
            _loc4_ = new poleQuadrant();
        }
        _loc5_ = 0;
        while (_loc5_ < _loc2_.length)
        {
          if (_loc2_[_loc5_] == "x")
          {
            _loc4_.x = _loc1_[_loc3_ + _loc5_ + 1];
          }
          else if (_loc2_[_loc5_] == "y")
          {
            _loc4_.y = _loc1_[_loc3_ + _loc5_ + 1];
          }
          else if (_loc2_[_loc5_] == "width")
          {
            _loc4_.width = _loc1_[_loc3_ + _loc5_ + 1];
            _loc4_.height = _loc1_[_loc3_ + _loc5_ + 1];
          }
          else if (_loc2_[_loc5_] == "height")
          {
            _loc4_.height = _loc1_[_loc3_ + _loc5_ + 1];
          }
          else if (_loc2_[_loc5_] == "rotation")
          {
            _loc4_.rotation = _loc1_[_loc3_ + _loc5_ + 1];
          }
          _loc5_++;
        }
        this.renderScreen.container.addChild(_loc4_);
        _loc3_ += _loc2_.length + 1;
      }
      this.renderScreen.container.scaleX = 0.05;
      this.renderScreen.container.scaleY = 0.05;
      MovieClip(this.renderScreen.container).cacheAsBitmap = true;
      this.rendered = true;
    }

    internal function frame1():*
    {
      stop();
    }

    internal function frame29():*
    {
      gotoAndStop(1);
    }

    internal function frame30():*
    {
      this.renderStage();
    }
  }
}
