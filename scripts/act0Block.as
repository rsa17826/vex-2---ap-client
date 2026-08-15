package
{
  import flash.display.MovieClip;
  import flash.text.TextField;
  import flash.external.ExternalInterface;

  [Embed(source="/_assets/assets.swf", symbol="symbol1562")]
  public class act0Block extends block
  {

    public var timeText:TextField;

    public var titleText:TextField;

    public var rankText:TextField;

    public var fastestTimeText:TextField;

    public var enterStage:TextField;

    public var animatingDetails:MovieClip = null;

    private var type:int;

    private var stars:Array = [];

    private var timeline:MovieClip;

    private var playerOn:Boolean = false;

private var locked:Boolean = true;

private function getLocked():void
{
  main = MovieClip(root);
  if (ExternalInterface.available)
  {
    // Let JS call back into this instance to push lock-state changes
    try
    {
      ExternalInterface.addCallback("setActLocked_" + (this.type==0?0:this.type-1), this.onLockedChanged);
    }
    catch (e:Error)
    {
      // callback name already registered elsewhere, ignore
    }
  }

  if (ExternalInterface.call("isActUnlocked", (this.type==0?0:this.type-1)))
  {
    this.locked = false;
    this.displayTimes();
  }
  else
  {
    this.locked = true;
    gotoAndStop(2);
  }
}

// Called from JS: document.getElementById("swfid").setActLocked_3(false)
private function onLockedChanged(isLocked:Boolean):void
{
  if (isLocked == this.locked) return;
  this.locked = isLocked;
  if (this.locked)
  {
    gotoAndStop(2);
  }
  else
  {
    gotoAndStop(1);
    this.displayTimes();
  }
}

    public function act0Block()
    {
      super();
      addFrameScript(0, this.frame1);
      this.getType();
      this.getLocked();
      if (currentFrame != 2)
      {
        this.getStars();
        this.enterStage.alpha = 0;
      }
      this.createTimeline();
    }

    override public function update():void
    {
      var _loc1_:int = 0;
      if (currentFrame == 1)
      {
        if (this.playerOn)
        {
          if (this.timeline.alpha <= 0)
          {
            main.playSound("levelOpen", false);
          }
          this.timeText.alpha -= 0.1;
          this.timeline.alpha += 0.05;
          additionalMaths.easeToPoint(this.timeline, x, y, 8);
          if (this.timeline.alpha > 1)
          {
            this.timeline.alpha = 1;
          }
          if (this.timeText.alpha < 0)
          {
            this.timeText.alpha = 0;
          }
          this.titleText.alpha = this.timeText.alpha;
          this.fastestTimeText.alpha = this.timeText.alpha;
          this.rankText.alpha = this.timeText.alpha;
          _loc1_ = 0;
          while (_loc1_ < this.stars.length)
          {
            this.stars[_loc1_].alpha = this.timeText.alpha;
            _loc1_++;
          }
          if (this.timeText.alpha <= 0)
          {
            if (this.enterStage.alpha < 1)
            {
              this.enterStage.alpha += 0.1;
              if (this.enterStage.alpha > 1)
              {
                this.enterStage.alpha = 1;
              }
            }
          }
        }
        else
        {
          this.enterStage.alpha -= 0.1;
          this.timeline.alpha -= 0.05;
          additionalMaths.easeToPoint(this.timeline, x, y + height, 8);
          if (this.timeline.alpha < 0)
          {
            this.timeline.alpha = 0;
          }
          if (this.enterStage.alpha < 0)
          {
            this.enterStage.alpha = 0;
          }
          if (this.enterStage.alpha <= 0)
          {
            if (this.timeText.alpha < 1)
            {
              this.timeText.alpha += 0.1;
              if (this.timeText.alpha > 1)
              {
                this.timeText.alpha = 1;
              }
              this.titleText.alpha = this.timeText.alpha;
              this.fastestTimeText.alpha = this.timeText.alpha;
              this.rankText.alpha = this.timeText.alpha;
              _loc1_ = 0;
              while (_loc1_ < this.stars.length)
              {
                this.stars[_loc1_].alpha = this.timeText.alpha;
                _loc1_++;
              }
            }
          }
        }
      }
      this.playerOn = false;
      if (ySpeed > 0)
      {
        y += ySpeed;
        ySpeed -= 0.5;
      }
      checkRender();
    }

    override public function landed():void
    {
      var _loc1_:* = undefined;
      var _loc2_:int = 0;
      var _loc3_:* = undefined;
      if (currentFrame == 1)
      {
        this.playerOn = true;
        _loc1_ = main.player;
        if (_loc1_.crouching)
        {
          if (_loc1_.xSpeed == 0)
          {
            _loc1_.gotoAndStop(1);
            _loc1_.teleporting = true;
            _loc1_.visible = false;
            _loc2_ = 0;
            while (_loc2_ < 15)
            {
              _loc3_ = new particle();
              _loc3_.x = _loc1_.x;
              _loc3_.y = _loc1_.y;
              _loc3_.xSpeed = Math.random() * 8 - 4;
              _loc3_.ySpeed = Math.random() * 8 - 12;
              parent.addChild(_loc3_);
              _loc2_++;
            }
            if (this.type > 0)
            {
              main.levelComplete(this.type + 1);
            }
            else
            {
              main.levelComplete(this.type);
            }
            main.fadingIn = false;
          }
        }
      }
    }

    private function getType():void
    {
      if (this is act0Block)
      {
        this.type = 0;
      }
      if (this is act1Block)
      {
        this.type = 2;
      }
      else if (this is act2Block)
      {
        this.type = 3;
      }
      else if (this is act3Block)
      {
        this.type = 4;
      }
      else if (this is act4Block)
      {
        this.type = 5;
      }
      else if (this is act5Block)
      {
        this.type = 6;
      }
      else if (this is act6Block)
      {
        this.type = 7;
      }
      else if (this is act7Block)
      {
        this.type = 8;
      }
      else if (this is act8Block)
      {
        this.type = 9;
      }
      else if (this is act9Block)
      {
        this.type = 10;
      }
      else if (this is act10Block)
      {
        this.type = 11;
      }
    }

    private function displayTimes():void
    {
      var _loc1_:int = int(main.savedTimes[this.type]);
      this.timeText.text = main.displayTime(_loc1_);
      var _loc2_:Array = rankTimes["act" + this.type + "Ranks"];
      if (_loc1_ <= _loc2_[0])
      {
        if (main.savedDeaths[this.type] == 0)
        {
          this.rankText.text = "Perfect";
          this.rankText.textColor = 8847359;
        }
        else
        {
          this.rankText.text = "Gold";
          this.rankText.textColor = 16764057;
        }
      }
      else if (_loc1_ <= _loc2_[1])
      {
        this.rankText.text = "Silver";
        this.rankText.textColor = 13421772;
      }
      else if (_loc1_ <= _loc2_[2])
      {
        this.rankText.text = "Bronze";
        this.rankText.textColor = 9391159;
      }
      else
      {
        this.rankText.text = "Cleared";
        this.rankText.textColor = 7274350;
      }
      if (_loc1_ == 0)
      {
        this.fastestTimeText.text = "";
        this.rankText.text = "";
        this.timeText.text = "";
      }
    }

    private function getStars():void
    {
      var _loc3_:int = 0;
      var _loc4_:* = undefined;
      var _loc1_:int = int(rankTimes["act" + this.type + "Stars"]);
      var _loc2_:int = 0;
      _loc3_ = 0;
      while (_loc3_ < main["savedAct" + this.type + "Stars"].length)
      {
        if (main["savedAct" + this.type + "Stars"][_loc3_])
        {
          _loc2_++;
        }
        _loc3_++;
      }
      _loc3_ = 0;
      while (_loc3_ < _loc1_)
      {
        _loc4_ = new starGraphic();
        _loc4_.x = _loc3_ * _loc4_.width - _loc1_ * _loc4_.width * 0.5 + _loc4_.width * 0.5 + width * 0.5 - _loc4_.width * 0.5;
        _loc4_.y = 40;
        if (this.type == 11)
        {
          _loc4_.y = 120;
        }
        addChild(_loc4_);
        this.stars.push(_loc4_);
        if (_loc2_ == 0)
        {
          _loc4_.filters = [];
          _loc4_.star.filters = [];
          adjustColour.colourChange(_loc4_, 0, -100, -100, -100);
        }
        else
        {
          _loc2_--;
        }
        _loc3_++;
      }
    }

    public function createTimeline():void
    {
      this.timeline = new actTimeline();
      this.timeline.x = x;
      this.timeline.y = y + height;
      this.timeline.alpha = 0;
      parent.addChild(this.timeline);
      var _loc1_:int = parent.getChildIndex(this) - 1;
      parent.setChildIndex(this.timeline, _loc1_);
      var _loc2_:* = this.timeline.timelineColour;
      var _loc3_:int = 0;
      while (_loc3_ < 2)
      {
        if (this.type == 0)
        {
          adjustColour.colourChange(_loc2_, 0, -100, 0, 0);
        }
        else if (this.type == 2)
        {
          adjustColour.colourChange(_loc2_, 0, -40, 0, 0);
        }
        else if (this.type == 3)
        {
          adjustColour.colourChange(_loc2_, 45, 0, 75, 0);
        }
        else if (this.type == 4)
        {
          adjustColour.colourChange(_loc2_, 60, 0, 80, 40);
        }
        else if (this.type == 5)
        {
          adjustColour.colourChange(_loc2_, 100, -10, 100, 25);
        }
        else if (this.type == 6)
        {
          adjustColour.colourChange(_loc2_, 140, 0, 65, 0);
        }
        else if (this.type == 7)
        {
          adjustColour.colourChange(_loc2_, 180, 25, 50, 0);
        }
        else if (this.type == 8)
        {
          adjustColour.colourChange(_loc2_, -135, 0, 0, 0);
        }
        else if (this.type == 9)
        {
          adjustColour.colourChange(_loc2_, -85, 0, 0, 0);
        }
        else if (this.type == 10)
        {
          adjustColour.colourChange(_loc2_, -65, 0, 0, 0);
        }
        else if (this.type == 11)
        {
          adjustColour.colourChange(_loc2_, -45, 0, 0, 0);
        }
        _loc2_ = this.timeline.yourTime;
        _loc3_++;
      }
      var _loc4_:int = int(main.savedTimes[this.type]);
      var _loc5_:Array = rankTimes["act" + this.type + "Ranks"];
      this.timeline.goldTime.gold.text = "Gold: " + main.displayTime(_loc5_[0]);
      this.timeline.silverTime.silver.text = "Silver: " + main.displayTime(_loc5_[1]);
      this.timeline.bronzeTime.bronze.text = "Bronze: " + main.displayTime(_loc5_[2]);
      if (_loc4_ == 0)
      {
        this.timeline.removeChild(this.timeline.yourTime);
        this.timeline.bronzeTime.y = -66;
        this.timeline.silverTime.y = -141;
        this.timeline.goldTime.y = -216;
      }
      else
      {
        this.timeline.yourTime.yourTime.text = "Your time: " + main.displayTime(_loc4_);
        if (_loc4_ <= _loc5_[0])
        {
          this.timeline.bronzeTime.y = -66;
          this.timeline.silverTime.y = -84;
          this.timeline.goldTime.y = -102;
          this.timeline.yourTime.y = -216;
        }
        else if (_loc4_ <= _loc5_[1])
        {
          this.timeline.bronzeTime.y = -66;
          this.timeline.silverTime.y = -84;
          this.timeline.yourTime.y = -102;
          this.timeline.goldTime.y = -216;
        }
        else if (_loc4_ <= _loc5_[2])
        {
          this.timeline.bronzeTime.y = -66;
          this.timeline.yourTime.y = -84;
          this.timeline.silverTime.y = -150;
          this.timeline.goldTime.y = -216;
        }
      }
    }

    internal function frame1():*
    {
      stop();
    }
  }
}
