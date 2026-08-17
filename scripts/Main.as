package
{
  import flash.external.ExternalInterface;
  import com.newgrounds.*;
  import com.newgrounds.components.APIConnector;
  import flash.display.MovieClip;
  import flash.events.Event;
  import flash.events.MouseEvent;
  import flash.events.TimerEvent;
  import flash.geom.Point;
  import flash.media.Sound;
  import flash.media.SoundChannel;
  import flash.media.SoundTransform;
  import flash.net.SharedObject;
  import flash.net.URLRequest;
  import flash.net.navigateToURL;
  import flash.text.TextField;
  import flash.utils.*;
  import mochi.as3.*;
  import flash.display.Stage;

  public dynamic class Main extends MovieClip
  {

    public var __id0_:APIConnector;

    public var __setPropDict:Dictionary = new Dictionary(true);

    public var advert:Boolean;

    public var menuDestination:int = 0;

    public var logo:MovieClip;

    public var parallax:MovieClip;

    public var level:MovieClip;

    public var guiColours:MovieClip;

    public var resetStageButton:MovieClip;

    public var levelButton:MovieClip;

    public var achievementButton:MovieClip;

    public var optionButton:MovieClip;

    public var mainTime:TextField;

    public var smallTime:TextField;

    public var levelName:TextField;

    public var fpsTxt:TextField;

    public var player:MovieClip = null;

    public var rankTimeBar:MovieClip;

    public var guiText:MovieClip;

    public var transitionOut:MovieClip = null;

    public var transitionIn:MovieClip = null;

    public var window:MovieClip = null;

    public var closingWindow:MovieClip = null;

    public var playerBreathe:MovieClip = null;

    public var dark:MovieClip = null;
    public var darkBG:MovieClip = null;

    public var playerBubbles:Array = [];

    public var stageBuilderGUI:MovieClip;

    public var blocks:Array = [];

    public var slopes:Array = [];

    public var pools:Array = [];

    public var texts:Array = [];

    public var checkpoints:Array = [];

    public var obstacles:Array = [];

    public var particles:Array = [];

    public var death:Array = [];

    public var stars:Array = [];

    public var projectiles:Array = [];

    public var effects:Array = [];

    public var others:Array = [];

    private var parallaxBackgroundX:int = 0;

    private var parallaxBackgroundY:int = 0;

    private var milliseconds:int = 0;

    private var seconds:int = 0;

    private var minutes:int = 0;

    private var actTimes:Array = [];

    public var act:int = -1;

    public var deaths:int = 0;

    private var deathExplanationTimer:int = 0;

    protected var gameTimer:Timer = new Timer(1000, 1);

    protected var secondsPlayed:int = 0;

    protected var minutesPlayed:int = 0;

    protected var hoursPlayed:int = 0;

    public const stageWidth:int = 640;

    public const stageHeight:int = 560;

    public var savedTimes:Array = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];

    public var savedDeaths:Array = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];

    public var savedAct0Stars:Array = [false];

    public var savedAct1Stars:Array = [];

    public var savedAct2Stars:Array = [false];

    public var savedAct3Stars:Array = [false];

    public var savedAct4Stars:Array = [false];

    public var savedAct5Stars:Array = [false];

    public var savedAct6Stars:Array = [false];

    public var savedAct7Stars:Array = [false];

    public var savedAct8Stars:Array = [false];

    public var savedAct9Stars:Array = [false];

    public var savedAct10Stars:Array = [false];

    public var savedAct11Stars:Array = [false];

    public var frameDestination:int = 0;

    public var levelDestination:int = 0;

    public var levelCleared:Boolean = false;

    public var savedItemPacks:Array = [false, false, false, false, false, false, false, false, false, false, false, false, false];

    public var localMap:Array = [];

    public var stageSelected:int;

    public var savedStages:Array = [];

    public var savedStagesNames:Array = [];

    private var backgroundTrackChannel:SoundChannel = new SoundChannel();

    private var soundEffectsChannel:SoundChannel = new SoundChannel();

    private var NESoundEffectsChannel:SoundChannel = new SoundChannel();

    private var bgVolume:SoundTransform = new SoundTransform();

    private var sfxVolume:SoundTransform = new SoundTransform();

    private var nesfxVolume:SoundTransform = new SoundTransform();

    private var bgPlaying:Boolean = false;

    private var faded:Number = 1;

    public var fadingIn:Boolean = true;

    public var particleLimit:int = 50;

    public var qualitySetting:String = "high";

    public var blendModes:Boolean = true;

    public var audioBGM:int = 100;

    public var audioSFX:int = 100;

    public var resetWarning:Boolean = true;

    public var autoReset:Boolean = false;

    public var stats:Array = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];

    public var introAnimation:MovieClip;

    public var facebook:MovieClip;

    public var twitter:MovieClip;

    public var menuSponsor:MovieClip;

    public var sponsorMan:MovieClip = null;

    public var vexButton:MovieClip;

    public var kongregate:*;

    protected var FPS:int;

    protected var lastFrame:int;

    public function Main()
    {
      super();
      addFrameScript(0, this.frame1, 1, this.frame2, 2, this.frame3);
      addEventListener(Event.ADDED_TO_STAGE, this.init, false, 0, true);
      addEventListener(Event.ENTER_FRAME, this.update, false, 0, true);
      addEventListener(Event.DEACTIVATE, this.deactivate, false, 0, true);
      this.loadGame();
      this.refreshSounds();
      addEventListener(Event.ADDED_TO_STAGE, this.__setPerspectiveProjection_);
    }

    public function __setPerspectiveProjection_(param1:Event):void
    {
      root.transform.perspectiveProjection.fieldOfView = 62.410833;
      root.transform.perspectiveProjection.projectionCenter = new Point(275, 200);
    }

    public function linkToSponsor(param1:MouseEvent):void
    {
      // var _loc2_:String = null;
      // switch (getQualifiedClassName(param1.currentTarget))
      // {
      // case "shape04":
      // _loc2_ = "http://www.yepi.com/?utm_source=Vex2&utm_medium=loader&utm_campaign=game";
      // break;
      // case "menuSponsorIntro":
      // if (currentFrame == 2)
      // {
      // _loc2_ = "http://www.yepi.com/?utm_source=Vex2&utm_medium=loader&utm_campaign=game";
      // break;
      // }
      // _loc2_ = "http://www.yepi.com/?utm_source=Vex2&utm_medium=gameCompleted&utm_campaign=game";
      // break;
      // case "menuSponsor":
      // _loc2_ = "http://www.yepi.com/?utm_source=Vex2&utm_medium=logoMain&utm_campaign=game";
      // break;
      // case "moreGames":
      // _loc2_ = "http://www.yepi.com/?utm_source=Vex2&utm_medium=moreMain&utm_campaign=game";
      // break;
      // case "facebookButton":
      // _loc2_ = "https://www.facebook.com/sharer/sharer.php?u=http%3A%2F%2Fwww.yepi.com%2Fvex-2.html";
      // break;
      // case "twitterButton":
      // _loc2_ = "https://twitter.com/intent/tweet?source=webclient&text=Playing+Vex+2+on+http%3A%2F%2Fwww.yepi.com%2Fvex-2.html";
      // break;
      // case "vex1Button":
      // _loc2_ = "http://www.yepi.com/vex.html?utm_source=Vex2&utm_medium=moreMain&utm_campaign=game";
      // break;
      // case "sponsorButton":
      // _loc2_ = "http://www.yepi.com/?utm_source=Vex2&utm_medium=ingameLogo&utm_campaign=game";
      // break;
      // case "LHsponsor":
      // _loc2_ = "http://www.yepi.com/?utm_source=Vex2&utm_medium=HubMore&utm_campaign=game";
      // break;
      // case "stuckButton":
      // _loc2_ = "http://www.youtube.com/watch?v=lNqz1ijtuHg";
      // break;
      // case "pausedMoreGames":
      // _loc2_ = "http://www.yepi.com/?utm_source=Vex2&utm_medium=pause&utm_campaign=game";
      // }
      // navigateToURL(new URLRequest(_loc2_), "_blank");
    }

    private function refreshSounds():void
    {
      var _loc1_:Number = 0.02;
      var _loc2_:Number = 0.02;
      if (this.fadingIn)
      {
        if (this.faded < 1)
        {
          this.faded += _loc1_;
          if (this.faded > 1)
          {
            this.faded = 1;
          }
        }
      }
      if (!this.fadingIn)
      {
        if (this.faded > 0)
        {
          this.faded -= _loc2_;
          if (this.faded < 0)
          {
            this.faded = 0;
          }
        }
      }
      this.bgVolume.volume = this.audioBGM * 0.01 * this.faded;
      this.sfxVolume.volume = this.audioSFX * 0.01;
      this.nesfxVolume.volume = this.audioSFX * 0.01 * 0.5;
      this.backgroundTrackChannel.soundTransform = this.bgVolume;
      this.soundEffectsChannel.soundTransform = this.sfxVolume;
      this.NESoundEffectsChannel.soundTransform = this.nesfxVolume;
    }

    public function playSound(param1:String = "sound", param2:Boolean = true, param3:Boolean = false, param4:Boolean = false):void
    {
      var _loc5_:Class = Class(getDefinitionByName(String(param1 + "mp3"))) as Class;
      var _loc6_:Sound = new _loc5_();
      if (param2)
      {
        if (!param3)
        {
          this.backgroundTrackChannel = _loc6_.play();
        }
        else
        {
          this.backgroundTrackChannel = _loc6_.play(0, 9999);
        }
        if (_loc6_ is startFademp3)
        {
          this.backgroundTrackChannel.addEventListener(Event.SOUND_COMPLETE, this.startLoop);
        }
      }
      else if (param4)
      {
        if (!param3)
        {
          this.NESoundEffectsChannel = _loc6_.play();
        }
        else
        {
          this.NESoundEffectsChannel = _loc6_.play(0, 9999);
        }
      }
      else if (!param3)
      {
        this.soundEffectsChannel = _loc6_.play();
      }
      else
      {
        this.soundEffectsChannel = _loc6_.play(0, 9999);
      }
      this.refreshSounds();
    }

    private function startLoop(param1:Event):void
    {
      this.playSound("mainLoop", true, true);
    }

    private function stopBGM():void
    {
      this.backgroundTrackChannel.stop();
    }

    private function update(param1:Event):void
    {
      if (this.darkBG == null)
      {
        if (ExternalInterface.call("useDarkMode"))
        {
          this.playSound("nightVision", false);
          this.darkBG = new darkOverlay(true);
          this.darkBG.scaleX = 20;
          this.darkBG.scaleY = 20;
          this.darkBG.alpha = .9;
          this.addChild(this.darkBG);
          this.setChildIndex(this.darkBG, 1);
        }
        if (this.level === null)
        {
          trace("aaaaaaaaaaaaa");
        }
      }
      this.setChildIndex(this.darkBG, 1);
      this.refreshSounds();
      if (currentFrame == 2)
      {
        if (!this.introSkipped)
        {
          this.introSkipped = true;
          gotoAndStop(3);
          this.transitionIn = new gameTransitionIn();
          addChild(this.transitionIn);
          this.findColourChangeTransition(this.transitionIn);
          this.playGameFunction();
        }
        else if (this.introAnimation)
        {
          if (this.introAnimation.currentFrame == this.introAnimation.totalFrames)
          {
            gotoAndStop(3);
            this.transitionIn = new gameTransitionIn();
            addChild(this.transitionIn);
            this.findColourChangeTransition(this.transitionIn);
          }
        }
      }
      if (currentFrame == 3)
      {
        if (!this.bgPlaying)
        {
          this.playSound("startFade", true);
          this.bgPlaying = true;
        }
        if (this.parallax)
        {
          this.updateBackground(1, 1);
        }
        this.getMainMenu();
      }
      else if (currentFrame == 4)
      {
        this.updateLevel();
      }
      else if (currentFrame == 5)
      {
        this.stageBuilderGUI.update();
      }
      if (this.window)
      {
        additionalMaths.easeToPoint(this.window, this.stageWidth * 0.5, this.stageHeight * 0.5);
        if ("update" in this.window)
        {
          this.window.update();
        }
      }
      if (this.closingWindow)
      {
        additionalMaths.easeToPoint(this.closingWindow, this.stageWidth * 0.5, -this.closingWindow.height * 0.5 - 50);
        if (this.closingWindow.y <= -this.closingWindow.height * 0.5 - 48)
        {
          removeChild(this.closingWindow);
          this.closingWindow = null;
        }
      }
      if (Boolean(this.transitionOut) || Boolean(this.transitionIn))
      {
        this.checkTransitionDone();
      }
    }

    private function updateLevel():void
    {
      var _loc1_:* = undefined;
      var _loc2_:* = undefined;
      if (this.window == null)
      {
        if (this.level)
        {
          this.updateStage();
          this.updateParticles();
          if (this.player == null)
          {
            if (this.level.player)
            {
              this.player = this.level.player;
            }
          }
          else
          {
            if (this.deaths > 2)
            {
              additionalMaths.easeToPoint(this.guiColours.helpButton, this.guiColours.helpButton.x, 55);
            }
            else
            {
              additionalMaths.easeToPoint(this.guiColours.helpButton, this.guiColours.helpButton.x, -6);
            }
            this.player.update();
            this.getBreatheBar();
            this.updateDeaths();
            if (this.dark)
            {
              _loc1_ = this.level.x + this.player.x;
              _loc2_ = this.level.y + this.player.y;
              this.dark.x = _loc1_;
              this.dark.y = _loc2_ - this.player.height * 0.5;
              if (this.dark is flashOverlay && this.dark.currentFrame == this.dark.totalFrames)
              {
                removeChild(this.dark);
                this.dark = null;
              }
            }
          }
          this.updateGUI();
        }
      }
      else
      {
        this.player.checkHotkeys();
      }
    }

    private function updateStage():void
    {
      if (this.act == -1)
      {
        this.act = this.level.currentFrame - 1;
        this.actTimes = rankTimes["act" + this.act + "Ranks"];
      }
      var _loc1_:int = 0;
      while (_loc1_ < this.others.length)
      {
        this.others[_loc1_].update();
        _loc1_++;
      }
      var _loc2_:int = 0;
      while (_loc2_ < this.blocks.length)
      {
        this.blocks[_loc2_].update();
        _loc2_++;
      }
      var _loc3_:int = 0;
      while (_loc3_ < this.pools.length)
      {
        this.pools[_loc3_].update();
        _loc3_++;
      }
      var _loc4_:int = 0;
      while (_loc4_ < this.slopes.length)
      {
        this.slopes[_loc4_].update();
        _loc4_++;
      }
      var _loc5_:int = 0;
      while (_loc5_ < this.checkpoints.length)
      {
        this.checkpoints[_loc5_].update();
        _loc5_++;
      }
      var _loc6_:int = 0;
      while (_loc6_ < this.obstacles.length)
      {
        if ("update" in this.obstacles[_loc6_])
        {
          this.obstacles[_loc6_].update();
        }
        _loc6_++;
      }
      var _loc7_:int = 0;
      while (_loc7_ < this.texts.length)
      {
        this.texts[_loc7_].update();
        _loc7_++;
      }
      var _loc8_:int = 0;
      while (_loc8_ < this.projectiles.length)
      {
        this.projectiles[_loc8_].update();
        _loc8_++;
      }
      var _loc9_:int = 0;
      while (_loc9_ < this.stars.length)
      {
        if (this.stars[_loc9_].starNumber != _loc9_)
        {
          this.stars[_loc9_].starNumber = _loc9_;
        }
        this.stars[_loc9_].update();
        _loc9_++;
      }
      var _loc10_:int = 0;
      while (_loc10_ < this.effects.length)
      {
        this.effects[_loc10_].update();
        if (!this.effects[_loc10_])
        {
        }
        _loc10_++;
      }
    }

    private function deactivate(param1:Event):void
    {
      if (currentFrame == 4)
      {
        this.createWindow("deactivate");
      }
    }

    private function updateParticles():void
    {
      var _loc1_:int = 0;
      while (_loc1_ < this.particles.length)
      {
        this.particles[_loc1_].update();
        if (!this.particles[_loc1_])
        {
        }
        _loc1_++;
      }
    }

    private function getBreatheBar():void
    {
      var _loc1_:int = 0;
      var _loc2_:int = 0;
      var _loc3_:* = undefined;
      var _loc4_:* = undefined;
      if (this.player.swimming)
      {
        if (this.playerBreathe == null)
        {
          this.playerBreathe = new breatheBubbles();
          this.playerBreathe.x = this.level.x + this.player.x - (this.playerBreathe.width - 98) * 0.5;
          this.playerBreathe.y = this.level.y + this.player.y - this.player.height;
          this.playerBreathe.scaleX = 0.1;
          this.playerBreathe.scaleY = 0.1;
          this.playerBreathe.alpha = 0.1;
          addChild(this.playerBreathe);
        }
        else
        {
          if (this.playerBreathe.scaleX < 1)
          {
            this.playerBreathe.scaleX += 0.1;
            if (this.playerBreathe.scaleX > 1)
            {
              this.playerBreathe.scaleX = 1;
            }
          }
          this.playerBreathe.scaleY = this.playerBreathe.scaleX;
          this.playerBreathe.alpha = this.playerBreathe.scaleX;
          additionalMaths.easeToPoint(this.playerBreathe, this.level.x + this.player.x - (this.playerBreathe.width - 98) * 0.5, this.level.y + this.player.y - this.player.height, 3);
        }
        _loc1_ = 1;
        while (_loc1_ < this.playerBreathe.numChildren + 1)
        {
          if (_loc1_ > this.player.breathe)
          {
            _loc3_ = this.playerBreathe.getChildAt(_loc1_ - 1);
            if (_loc3_.visible)
            {
              _loc3_.y -= 0.5;
              _loc3_.alpha -= 0.1;
              if (_loc3_.alpha <= 0)
              {
                this.playerBreathe.removeChild(_loc3_);
              }
            }
          }
          else if (_loc1_ <= this.playerBreathe.numChildren)
          {
            _loc4_ = this.playerBreathe.getChildAt(_loc1_ - 1);
            if (_loc4_.alpha < 1)
            {
              _loc4_.alpha += 0.1;
              _loc4_.y -= 0.5;
              if (_loc4_.alpha > 1)
              {
                _loc4_.alpha = 1;
                _loc4_.y = -20;
              }
            }
          }
          _loc1_++;
        }
        _loc2_ = int(this.playerBreathe.numChildren);
        while (this.player.breathe > this.playerBreathe.numChildren)
        {
          _loc3_ = new breatheBubble();
          _loc3_.x = -48.5 + _loc2_ * 10;
          _loc3_.y = -15;
          _loc3_.alpha = 0;
          this.playerBreathe.addChild(_loc3_);
          _loc2_++;
        }
      }
      else if (this.playerBreathe != null)
      {
        if (this.playerBreathe.scaleX > 0)
        {
          this.playerBreathe.scaleX -= 0.1;
          if (this.playerBreathe.scaleX <= 0)
          {
            removeChild(this.playerBreathe);
            this.playerBreathe = null;
            return;
          }
        }
        this.playerBreathe.scaleY = this.playerBreathe.scaleX;
        this.playerBreathe.alpha = this.playerBreathe.scaleX;
        additionalMaths.easeToPoint(this.playerBreathe, this.level.x + this.player.x - (this.playerBreathe.width - 98) * 0.5, this.level.y + this.player.y - this.player.height, 3);
      }
    }

    private function updateDeaths():void
    {
      var _loc1_:int = 0;
      while (_loc1_ < this.death.length)
      {
        this.death[_loc1_].update(this.level.player);
        _loc1_++;
      }
    }

    public function updateBackground(param1:Number = 0, param2:Number = 0):void
    {
      var _loc3_:int = 140;
      this.parallax.x += param1;
      this.parallax.y += param2;
      if (this.parallax.x < this.parallaxBackgroundX - _loc3_)
      {
        this.parallax.x += _loc3_;
      }
      else if (this.parallax.x > this.parallaxBackgroundX + _loc3_)
      {
        this.parallax.x -= _loc3_;
      }
      if (this.parallax.y < this.parallaxBackgroundY - _loc3_)
      {
        this.parallax.y += _loc3_;
      }
      else if (this.parallax.y > this.parallaxBackgroundY + _loc3_)
      {
        this.parallax.y -= _loc3_;
      }
    }

    private function updateGUI():void
    {
      var _loc1_:TextField = this.guiText.deathsText;
      var _loc2_:TextField = this.guiText.deathExplanation;
      if (this.deaths > 0)
      {
        additionalMaths.easeToPoint(_loc1_, _loc1_.x, 0);
      }
      else
      {
        additionalMaths.easeToPoint(_loc1_, _loc1_.x, 37);
        additionalMaths.easeToPoint(_loc2_, _loc2_.x, 37);
      }
      if (this.deathExplanationTimer > 0)
      {
        additionalMaths.easeToPoint(_loc2_, _loc2_.x, 18);
        --this.deathExplanationTimer;
      }
      else
      {
        additionalMaths.easeToPoint(_loc2_, _loc2_.x, 37);
      }
      if (this.resetStageButton)
      {
        additionalMaths.easeToPoint(this.resetStageButton, 5, 510);
        additionalMaths.easeToPoint(this.levelButton, 55, 510);
        if (this.achievementButton)
        {
          additionalMaths.easeToPoint(this.achievementButton, 105, 510);
          additionalMaths.easeToPoint(this.optionButton, 155, 510);
        }
        else
        {
          additionalMaths.easeToPoint(this.optionButton, 105, 510);
        }
      }
      else
      {
        additionalMaths.easeToPoint(this.levelButton, 5, 510);
        additionalMaths.easeToPoint(this.achievementButton, 55, 510);
        additionalMaths.easeToPoint(this.optionButton, 105, 510);
      }
      if (this.level.currentFrame == 2)
      {
        this.updateStats();
      }
    }

    private function updateStats():void
    {
      this.level.totalDeaths.text = "Total Deaths: " + this.stats[0];
      this.level.totalActs.text = "Acts Completed: " + this.stats[1];
      this.level.totalRun.text = "Total Ran: " + this.stats[2] + "m";
      this.level.totalPoles.text = "Poles Used: " + this.stats[3];
      this.level.starsCollect.text = "Stars: " + this.stats[4] + "/26";
      this.level.totalCannons.text = "Cannons Fired: " + this.stats[5];
      this.level.totalJumps.text = "Total Jumps: " + this.stats[6];
      this.level.totalLevers.text = "Levers Pulled: " + this.stats[7];
      this.level.totalCheckpoints.text = "Checkpoints: " + this.stats[8];
      this.level.totalTime.text = "Time Played: " + this.stats[11] + ":" + this.displayTime(this.stats[9] + this.stats[10] * 60);
    }

    public function incDeath(param1:int = 0):void
    {
      ++this.deaths;
      ++this.stats[0];
      var _loc2_:TextField = this.guiText.deathsText;
      _loc2_.text = this.deaths + " Deaths";
      if (this.deaths == 1)
      {
        _loc2_.text = this.deaths + " Death";
      }
      this.findReason(param1);
      this.deathExplanationTimer = 60;
      if (param1 != 5)
      {
        if (Math.random() < 0.5)
        {
          this.playSound("Death", false);
        }
        else
        {
          this.playSound("death2", false);
        }
      }
      else
      {
        this.playSound("Fall", false);
      }
    }

    private function findReason(param1:int = 0):void
    {
      var _loc3_:Number = NaN;
      var _loc2_:TextField = this.guiText.deathExplanation;
      if (param1 == 0)
      {
        _loc2_.text = "Died of old age..";
      }
      else if (param1 == 1)
      {
        _loc3_ = Number(Math.random());
        if (_loc3_ < 0.5)
        {
          _loc2_.text = "Acupuncture!";
        }
        else
        {
          _loc2_.text = "Popped on a spike!";
        }
      }
      else if (param1 == 2)
      {
        _loc2_.text = "SPLAT!";
      }
      else if (param1 == 3)
      {
        _loc2_.text = "Tried breaking a ramp.";
        this.incAchievement(27);
      }
      else if (param1 == 4)
      {
        _loc2_.text = "Surprise spiked!";
      }
      else if (param1 == 5)
      {
        _loc3_ = Number(Math.random());
        if (_loc3_ < 0.33)
        {
          _loc2_.text = "Testing gravity?";
        }
        else if (_loc3_ < 0.66)
        {
          _loc2_.text = "Fell out the world.";
        }
        else
        {
          _loc2_.text = "Failed free-runner.";
        }
      }
      else if (param1 == 6)
      {
        _loc3_ = Number(Math.random());
        if (_loc3_ < 0.25)
        {
          _loc2_.text = "Sawed to pieces.";
        }
        else if (_loc3_ < 0.5)
        {
          _loc2_.text = "Skewered.";
        }
        else if (_loc3_ < 0.85)
        {
          _loc2_.text = "Shredded.";
        }
        else
        {
          _loc2_.text = "Death by buzzsaw.";
        }
      }
      else if (param1 == 7)
      {
        _loc3_ = Number(Math.random());
        if (_loc3_ < 0.5)
        {
          _loc2_.text = "Squashed.";
        }
        else
        {
          _loc2_.text = "Between a rock...";
        }
      }
      else if (param1 == 8)
      {
        _loc3_ = Number(Math.random());
        if (_loc3_ < 0.33)
        {
          _loc2_.text = "Drowned.";
        }
        else if (_loc3_ < 0.66)
        {
          _loc2_.text = "Collapsed lungs.";
        }
        else
        {
          _loc2_.text = "Sleeping with fishes.";
        }
      }
      else if (param1 == 9)
      {
        _loc3_ = Number(Math.random());
        if (_loc3_ < 0.5)
        {
          _loc2_.text = "Tried shurikenjutsu.";
        }
        else
        {
          _loc2_.text = "Sliced and diced.";
        }
      }
      else if (param1 == 10)
      {
        _loc3_ = Number(Math.random());
        if (_loc3_ < 0.5)
        {
          _loc2_.text = "Sliced.";
        }
        else
        {
          _loc2_.text = "Death four-ways.";
        }
      }
      else if (param1 == 11)
      {
        _loc3_ = Number(Math.random());
        if (_loc3_ < 0.5)
        {
          _loc2_.text = "Splattered.";
        }
        else
        {
          _loc2_.text = "Painting the wall?";
        }
      }
      else if (param1 == 12)
      {
        _loc3_ = Number(Math.random());
        if (_loc3_ < 0.25)
        {
          _loc2_.text = "\'Grim\' death.";
        }
        else if (_loc3_ < 0.5)
        {
          _loc2_.text = "Reaped";
        }
        else if (_loc3_ < 0.75)
        {
          _loc2_.text = "Scythed.";
        }
        else
        {
          _loc2_.text = "Tried agriculture.";
        }
      }
      else if (param1 == 13)
      {
        _loc3_ = Number(Math.random());
        if (_loc3_ < 0.5)
        {
          _loc2_.text = "Bounced on.";
        }
        else
        {
          _loc2_.text = "Stompy buzzsaw.";
        }
      }
      else if (param1 == 14)
      {
        _loc3_ = Number(Math.random());
        if (_loc3_ < 0.25)
        {
          _loc2_.text = "Fried vexman.";
        }
        else if (_loc3_ < 0.5)
        {
          _loc2_.text = "Splasered";
        }
        if (_loc3_ < 0.75)
        {
          _loc2_.text = "Melted.";
        }
        else
        {
          _loc2_.text = "Light amplification...";
        }
      }
      else if (param1 == 15)
      {
        _loc3_ = Number(Math.random());
        if (_loc3_ < 0.25)
        {
          _loc2_.text = "Fried vexman.";
        }
        else if (_loc3_ < 0.5)
        {
          _loc2_.text = "Shocking death.";
        }
        if (_loc3_ < 0.75)
        {
          _loc2_.text = "Executed.";
        }
        else
        {
          _loc2_.text = "Sparked differently.";
        }
      }
      else if (param1 == 16)
      {
        _loc2_.text = "Lost in space.";
      }
    }

    private function init(param1:Event):void
    {
      this.gameTimer.addEventListener(TimerEvent.TIMER_COMPLETE, this.incGameSecond, false, 0, true);
      this.gameTimer.start();
    }

    private function incGameSecond(param1:TimerEvent):void
    {
      ++this.secondsPlayed;
      if (this.secondsPlayed >= 60)
      {
        this.secondsPlayed = 0;
        ++this.minutesPlayed;
        this.incAchievement(19, 1);
        if (this.minutesPlayed >= 60)
        {
          ++this.hoursPlayed;
          this.minutesPlayed = 0;
        }
      }
      this.stats[9] = this.secondsPlayed;
      this.stats[10] = this.minutesPlayed;
      this.stats[11] = this.hoursPlayed;
      this.gameTimer.reset();
      this.gameTimer.start();
    }

    public function incMilliseconds(param1:Number = 0):void
    {
      var _loc2_:String = null;
      var _loc3_:String = null;
      var _loc4_:String = null;
      var _loc6_:Number = NaN;
      var _loc7_:* = undefined;
      this.milliseconds += param1;
      if (int(this.milliseconds) >= 100)
      {
        this.milliseconds = 0;
        ++this.seconds;
        if (this.seconds >= 60)
        {
          this.seconds = 0;
          ++this.minutes;
        }
        if (this.autoReset)
        {
          if (this.level.currentFrame != 13)
          {
            if (this.savedTimes[this.act] > 0)
            {
              if (this.savedTimes[this.act] < this.seconds + this.minutes * 60)
              {
                this.player.reset();
                return;
              }
            }
          }
        }
      }
      var _loc5_:TextField = this.guiText.rankOn;
      if (int(this.milliseconds) < 10)
      {
        _loc2_ = "0" + int(this.milliseconds);
      }
      else
      {
        _loc2_ = String(this.milliseconds);
      }
      this.smallTime.text = String(":" + _loc2_);
      this.mainTime.text = this.displayTime(this.seconds + this.minutes * 60);
      if (this.level.currentFrame != 13)
      {
        _loc6_ = this.minutes * 60 + this.seconds + this.milliseconds * 0.01;
        if (_loc6_ < this.actTimes[0])
        {
          if (this.deaths > 0)
          {
            if (_loc5_.text.substr(0, 4) == "Perf")
            {
              additionalMaths.easeToPoint(_loc5_, _loc5_.x, -8);
              if (_loc5_.y == -8)
              {
                _loc7_ = this.displayTime(this.actTimes[0]);
                _loc5_.text = "Gold - " + _loc7_;
                _loc5_.textColor = 16764057;
              }
            }
            else
            {
              additionalMaths.easeToPoint(_loc5_, _loc5_.x, 8);
            }
            this.rankTimeBar.gotoAndStop(2);
            this.rankTimeBar.scaleX = 1 - _loc6_ / this.actTimes[0];
          }
          else
          {
            _loc7_ = this.displayTime(this.actTimes[0]);
            _loc5_.text = "Perfect - " + _loc7_;
            _loc5_.textColor = 8847359;
            this.rankTimeBar.scaleX = 1 - _loc6_ / this.actTimes[0];
            additionalMaths.easeToPoint(_loc5_, _loc5_.x, 8);
            this.rankTimeBar.gotoAndStop(1);
          }
        }
        else if (_loc6_ < this.actTimes[1])
        {
          if (_loc5_.text.substr(0, 4) == "Gold" || _loc5_.text.substr(0, 4) == "Perf")
          {
            additionalMaths.easeToPoint(_loc5_, _loc5_.x, -8);
            if (_loc5_.y == -8)
            {
              _loc7_ = this.displayTime(this.actTimes[1]);
              _loc5_.text = "Silver - " + _loc7_;
              _loc5_.textColor = 13421772;
            }
          }
          else
          {
            additionalMaths.easeToPoint(_loc5_, _loc5_.x, 8);
          }
          this.rankTimeBar.gotoAndStop(3);
          this.rankTimeBar.scaleX = 1 - _loc6_ / this.actTimes[1];
        }
        else if (_loc6_ < this.actTimes[2])
        {
          if (_loc5_.text.substr(0, 6) == "Silver")
          {
            additionalMaths.easeToPoint(_loc5_, _loc5_.x, -8);
            if (_loc5_.y == -8)
            {
              _loc7_ = this.displayTime(this.actTimes[2]);
              _loc5_.text = "Bronze - " + _loc7_;
              _loc5_.textColor = 9391159;
            }
          }
          else
          {
            additionalMaths.easeToPoint(_loc5_, _loc5_.x, 8);
          }
          this.rankTimeBar.gotoAndStop(4);
          this.rankTimeBar.scaleX = 1 - _loc6_ / this.actTimes[2];
        }
        else
        {
          additionalMaths.easeToPoint(_loc5_, _loc5_.x, -12);
        }
      }
    }

    public function displayTime(param1:int = 0):String
    {
      var _loc2_:String = null;
      var _loc3_:String = null;
      if (param1 >= 60)
      {
        _loc2_ = String((param1 - param1 % 60) / 60);
        _loc3_ = String(param1 % 60);
        if (param1 % 60 < 10)
        {
          _loc3_ = "0" + _loc3_;
        }
        if (int(_loc2_) < 10)
        {
          return String("0" + _loc2_ + ":" + _loc3_);
        }
        return String(_loc2_ + ":" + _loc3_);
      }
      _loc3_ = String(param1 % 60);
      if (param1 % 60 < 10)
      {
        _loc3_ = "0" + _loc3_;
      }
      return String("00:" + _loc3_);
    }

    private function checkTransitionDone():void
    {
      var _loc1_:int = 0;
      if (this.transitionIn)
      {
        if (this.transitionIn.currentFrame == this.transitionIn.totalFrames)
        {
          removeChild(this.transitionIn);
          this.transitionIn = null;
        }
      }
      else if (this.transitionOut.currentFrame == this.transitionOut.totalFrames)
      {
        this.fadingIn = true;
        trace("fade in");
        removeChild(this.transitionOut);
        trace("removed");
        this.transitionOut = null;
        this.transitionIn = new gameTransitionIn();
        addChild(this.transitionIn);
        trace("transitionIn made");
        this.findColourChangeTransition(this.transitionIn);
        if (currentFrame == 1)
        {
          gotoAndStop(2);
          trace(currentFrame);
          return;
        }
        if (currentFrame == 4)
        {
          this.clearArrays();
          if (this.level.currentFrame != 2)
          {
            _loc1_ = int(this.level.currentFrame);
            if (_loc1_ == 13)
            {
              this.backToMenu(6);
              setChildIndex(this.transitionIn, numChildren - 1);
              return;
            }
            if (!this.levelCleared)
            {
              this.saveTimes(this.level.currentFrame);
              this.checkClearStageAchievements();
              ++this.stats[1];
              this.incAchievement(26);
            }
            this.level.gotoAndStop(2);
            this.changeColours();
            this.hideGUI();
            this.saveGame();
            this.stopBGM();
            this.playSound("levelHubLoop", true, true);
          }
          else
          {
            if (this.levelCleared)
            {
              this.backToMenu();
              return;
            }
            this.level.gotoAndStop(this.frameDestination);
            this.changeColours();
            this.showGUI();
            this.stopBGM();
            if (Math.random() < 0.5)
            {
              this.playSound("mainLoop", true, true);
            }
            else
            {
              this.playSound("mainLoop2", true, true);
            }
          }
          this.act = this.level.currentFrame - 1;
          this.actTimes = rankTimes["act" + this.act + "Ranks"];
          this.returnPlayer();
          this.resetStats();
          if (this.level.currentFrame == 2)
          {
            this.setPlayerDestination(_loc1_);
          }
          this.addButtons();
        }
        else
        {
          gotoAndStop(1);
          gotoAndStop(this.frameDestination);
          if (currentFrame == 4 || currentFrame == 6)
          {
            if (this.levelDestination != 1)
            {
              this.clearArrays();
              this.hideGUI();
            }
            if (this.levelDestination == 2)
            {
              this.stopBGM();
              this.playSound("levelHubLoop", true, true);
            }
            this.level.gotoAndStop(this.levelDestination);
            this.changeColours();
            this.addButtons();
            if (this.levelDestination == 13)
            {
              this.showGUI();
              this.renderStage();
            }
          }
          this.saveGame();
        }
        if (this.window)
        {
          removeChild(this.window);
          this.window = null;
        }
        setChildIndex(this.transitionIn, numChildren - 1);
      }
    }

    private function setPlayerDestination(param1:int):void
    {
      var _loc3_:* = null;
      var _loc4_:Class = null;
      var _loc5_:int = 0;
      var _loc2_:int = param1;
      _loc2_--;
      if (_loc2_ > 1)
      {
        _loc2_--;
        _loc3_ = "act" + _loc2_ + "Block";
        _loc4_ = getDefinitionByName(_loc3_) as Class;
        _loc5_ = 0;
        while (_loc5_ < this.blocks.length)
        {
          if (this.blocks[_loc5_] is _loc4_)
          {
            this.player.x = this.blocks[_loc5_].x + this.blocks[_loc5_].width * 0.5;
            this.player.y = this.blocks[_loc5_].y - 20;
            break;
          }
          _loc5_++;
        }
      }
      else
      {
        this.player.x = 0;
        this.player.y = 0;
      }
    }

    private function backToMenu(param1:int = 3):void
    {
      this.resetStage();
      this.act = -1;
      if (this.level)
      {
        this.level.removeChild(this.player);
        this.player = null;
        removeChild(this.level);
        this.level = null;
      }
      if (this.levelButton)
      {
        removeChild(this.levelButton);
        this.levelButton = null;
      }
      if (this.optionButton)
      {
        removeChild(this.optionButton);
        this.optionButton = null;
      }
      if (this.achievementButton)
      {
        removeChild(this.achievementButton);
        this.achievementButton = null;
      }
      if (this.resetStageButton)
      {
        removeChild(this.resetStageButton);
        this.resetStageButton = null;
      }
      if (this.sponsorMan)
      {
        removeChild(this.sponsorMan);
        this.sponsorMan = null;
      }
      this.menuDestination = 0;
      gotoAndStop(param1);
      this.stopBGM();
      if (Math.random() < 0.5)
      {
        this.playSound("mainLoop", true, true);
      }
      else
      {
        this.playSound("mainLoop2", true, true);
      }
    }

    public function findColourChangeTransition(param1:Object):void
    {
      if (currentFrame != 4)
      {
        adjustColour.colourChange(param1, -135, 0, 65, 0);
      }
      else if (this.level.currentFrame == 2)
      {
        if (param1.parent is gameButton || param1.parent is achievementsWindow || param1.parent is achievementUnlocked || param1.parent is optionsWindow || param1.parent is resetWindow)
        {
          adjustColour.colourChange(param1, -135, 0, 65, 0);
          return;
        }
        if (this.levelCleared)
        {
          adjustColour.colourChange(param1, -135, 0, 65, 0);
        }
        if (this.frameDestination == 0)
        {
          adjustColour.colourChange(param1, 0, -100, 0, 0);
        }
        else if (this.frameDestination == 3)
        {
          adjustColour.colourChange(param1, 0, -40, 0, 0);
        }
        else if (this.frameDestination == 4)
        {
          adjustColour.colourChange(param1, 45, 0, 75, 0);
        }
        else if (this.frameDestination == 5)
        {
          adjustColour.colourChange(param1, 60, 0, 80, 40);
        }
        else if (this.frameDestination == 6)
        {
          adjustColour.colourChange(param1, 100, -10, 100, 25);
        }
        else if (this.frameDestination == 7)
        {
          adjustColour.colourChange(param1, 140, 0, 65, 0);
        }
        else if (this.frameDestination == 8)
        {
          adjustColour.colourChange(param1, 180, 25, 50, 0);
        }
        else if (this.frameDestination == 9)
        {
          adjustColour.colourChange(param1, -135, 0, 0, 0);
        }
        else if (this.frameDestination == 10)
        {
          adjustColour.colourChange(param1, -85, 0, 0, 0);
        }
        else if (this.frameDestination == 11)
        {
          adjustColour.colourChange(param1, -65, 0, 0, 0);
        }
        else if (this.frameDestination == 12)
        {
          adjustColour.colourChange(param1, -45, 0, 0, 0);
        }
        else if (this.frameDestination == 13)
        {
          adjustColour.colourChange(param1, -135, 0, 65, 0);
        }
      }
      else if (this.level.currentFrame == 1)
      {
        adjustColour.colourChange(param1, 0, -100, 0, 0);
      }
      else if (this.level.currentFrame == 3)
      {
        adjustColour.colourChange(param1, 0, -40, 0, 0);
      }
      else if (this.level.currentFrame == 4)
      {
        adjustColour.colourChange(param1, 45, 0, 75, 0);
      }
      else if (this.level.currentFrame == 5)
      {
        adjustColour.colourChange(param1, 60, 0, 80, 40);
      }
      else if (this.level.currentFrame == 6)
      {
        adjustColour.colourChange(param1, 100, -10, 100, 25);
      }
      else if (this.level.currentFrame == 7)
      {
        adjustColour.colourChange(param1, 140, 0, 65, 0);
      }
      else if (this.level.currentFrame == 8)
      {
        adjustColour.colourChange(param1, 180, 25, 50, 0);
      }
      else if (this.level.currentFrame == 9)
      {
        adjustColour.colourChange(param1, -135, 0, 0, 0);
      }
      else if (this.level.currentFrame == 10)
      {
        adjustColour.colourChange(param1, -85, 0, 0, 0);
      }
      else if (this.level.currentFrame == 11)
      {
        adjustColour.colourChange(param1, -65, 0, 0, 0);
      }
      else if (this.level.currentFrame == 12)
      {
        adjustColour.colourChange(param1, -45, 0, 0, 0);
      }
      else if (this.level.currentFrame == 13)
      {
        adjustColour.colourChange(param1, -135, 0, 65, 0);
      }
    }

    private function changeColours():void
    {
      if (this.level.currentFrame == 1)
      {
        adjustColour.colourChange(this.guiColours, 0, -100, 0, 0);
        adjustColour.colourChange(this.parallax, 0, -100, 0, 0);
        this.levelName.text = "Tutorial";
      }
      else if (this.level.currentFrame == 2)
      {
        adjustColour.colourChange(this.guiColours, -130, 0, 65, 0);
        adjustColour.colourChange(this.parallax, -130, 0, 65, 0);
        this.levelName.text = "Level Hub";
      }
      else if (this.level.currentFrame == 3)
      {
        adjustColour.colourChange(this.guiColours, 0, -40, 0, 0);
        adjustColour.colourChange(this.parallax, 0, 0, 0, 0);
        this.levelName.text = "Act 1";
      }
      else if (this.level.currentFrame == 4)
      {
        adjustColour.colourChange(this.guiColours, 45, 0, 75, 0);
        adjustColour.colourChange(this.parallax, 45, 0, 75, 0);
        this.levelName.text = "Act 2";
      }
      else if (this.level.currentFrame == 5)
      {
        adjustColour.colourChange(this.guiColours, 60, 0, 80, 40);
        adjustColour.colourChange(this.parallax, 60, 0, 80, 40);
        this.levelName.text = "Act 3";
      }
      else if (this.level.currentFrame == 6)
      {
        adjustColour.colourChange(this.guiColours, 100, -10, 100, 25);
        adjustColour.colourChange(this.parallax, 100, -10, 100, 25);
        this.levelName.text = "Act 4";
      }
      else if (this.level.currentFrame == 7)
      {
        adjustColour.colourChange(this.guiColours, 140, 0, 65, 0);
        adjustColour.colourChange(this.parallax, 140, 0, 65, 0);
        this.levelName.text = "Act 5";
      }
      else if (this.level.currentFrame == 8)
      {
        adjustColour.colourChange(this.guiColours, 180, 25, 50, 0);
        adjustColour.colourChange(this.parallax, 180, 25, 50, 0);
        this.levelName.text = "Act 6";
      }
      else if (this.level.currentFrame == 9)
      {
        adjustColour.colourChange(this.guiColours, -135, 0, 0, 0);
        adjustColour.colourChange(this.parallax, -135, 0, 0, 0);
        this.levelName.text = "Act 7";
      }
      else if (this.level.currentFrame == 10)
      {
        adjustColour.colourChange(this.guiColours, -85, 0, 0, 0);
        adjustColour.colourChange(this.parallax, -85, 0, 0, 0);
        this.levelName.text = "Act 8";
      }
      else if (this.level.currentFrame == 11)
      {
        adjustColour.colourChange(this.guiColours, -65, 0, 0, 0);
        adjustColour.colourChange(this.parallax, -65, 0, 0, 0);
        this.levelName.text = "Act 9";
      }
      else if (this.level.currentFrame == 12)
      {
        adjustColour.colourChange(this.guiColours, -45, 0, 0, 0);
        adjustColour.colourChange(this.parallax, -45, 0, 0, 0);
        this.levelName.text = "Vexation";
      }
      else if (this.level.currentFrame == 13)
      {
        adjustColour.colourChange(this.guiColours, -130, 0, 65, 0);
        adjustColour.colourChange(this.parallax, -130, 0, 65, 0);
        this.levelName.text = "Testing";
      }
    }

    private function returnPlayer():void
    {
      this.player.startPoint.x = 0;
      this.player.startPoint.y = 0;
      this.player.checkPoint.x = 0;
      this.player.checkPoint.y = 0;
      this.player.respawn(true);
    }

    private function resetStats():void
    {
      var _loc1_:String = null;
      var _loc2_:* = undefined;
      var _loc3_:* = undefined;
      var _loc4_:int = 0;
      this.deaths = 0;
      this.seconds = 0;
      this.milliseconds = 0;
      this.minutes = 0;
      if (int(this.milliseconds) < 10)
      {
        _loc1_ = "0" + int(this.milliseconds);
      }
      else
      {
        _loc1_ = String(this.milliseconds);
      }
      this.smallTime.text = String(":" + _loc1_);
      this.mainTime.text = this.displayTime(this.seconds + this.minutes * 60);
      if (this.level.currentFrame < 13)
      {
        if (!this.guiText)
        {
          _loc4_ = 0;
          while (_loc4_ < numChildren)
          {
            if (getChildAt(_loc4_) is guiTextClass)
            {
              this.guiText = MovieClip(getChildAt(_loc4_));
              break;
            }
            _loc4_++;
          }
        }
        _loc2_ = this.guiText.rankOn;
        _loc3_ = this.displayTime(this.actTimes[0]);
        _loc2_.text = "Perfect - " + _loc3_;
        _loc2_.textColor = 8847359;
        this.rankTimeBar.scaleX = 1;
        this.rankTimeBar.gotoAndStop(1);
      }
    }

    private function saveTimes(param1:int = 0):void
    {
      if (this.level.currentFrame == 13)
      {
        return;
      }
      param1--;
      this.checkRankAchievements(new Array(this.savedTimes[param1], this.savedDeaths[param1]), this.minutes * 60 + this.seconds, this.deaths, rankTimes["act" + this.act + "Ranks"]);
      if (this.savedTimes[param1] > 0)
      {
        if (this.minutes * 60 + this.seconds < this.savedTimes[param1])
        {
          this.savedTimes[param1] = this.minutes * 60 + this.seconds;
          this.savedDeaths[param1] = this.deaths;
        }
      }
      else
      {
        this.savedTimes[param1] = this.minutes * 60 + this.seconds;
        this.savedDeaths[param1] = this.deaths;
        if (this.kongregate)
        {
          this.submitKongLevels(param1);
        }
      }
      if (this.kongregate)
      {
        this.submitKong(this.minutes * 60 + this.seconds, param1);
        if (param1 == 11)
        {
          this.kongregate.stats.submit("GameComplete", 1);
        }
      }
    }

    private function checkRankAchievements(param1:Array, param2:int, param3:int, param4:Array):void
    {
      var _loc5_:int = 1;
      if (param1[0] == 0)
      {
        _loc5_ = 5;
      }
      else if (param1[0] <= param4[0] && param1[1] == 0)
      {
        _loc5_ = 1;
      }
      else if (param1[0] <= param4[0] && param1[1] > 0)
      {
        _loc5_ = 2;
      }
      else if (param1[0] <= param4[1])
      {
        _loc5_ = 3;
      }
      else if (param1[0] <= param4[2])
      {
        _loc5_ = 4;
      }
      else
      {
        _loc5_ = 5;
      }
      var _loc6_:int = 1;
      if (param2 <= param4[0] && param3 == 0)
      {
        _loc6_ = 1;
      }
      else if (param2 <= param4[0] && param3 > 0)
      {
        _loc6_ = 2;
      }
      else if (param2 <= param4[1])
      {
        _loc6_ = 3;
      }
      else if (param2 <= param4[2])
      {
        _loc6_ = 4;
      }
      else
      {
        _loc6_ = 5;
      }
      if (_loc6_ < _loc5_)
      {
        if (_loc6_ == 3)
        {
          this.incAchievement(21);
        }
        else if (_loc6_ == 2)
        {
          if (_loc5_ > 3)
          {
            this.incAchievement(21);
          }
          this.incAchievement(22);
          this.incAchievement(24);
        }
        else if (_loc6_ == 1)
        {
          if (_loc5_ > 3)
          {
            this.incAchievement(21);
          }
          if (_loc5_ > 2)
          {
            this.incAchievement(22);
            this.incAchievement(24);
          }
          this.incAchievement(23);
          this.incAchievement(25);
        }
      }
    }

    private function hideGUI():void
    {
      this.guiColours.leftBox.visible = false;
      this.guiColours.leftBox2.visible = false;
      this.guiText.rankOn.visible = false;
      this.rankTimeBar.visible = false;
      this.mainTime.visible = false;
      this.smallTime.visible = false;
    }

    private function showGUI():void
    {
      this.guiColours.leftBox.visible = true;
      this.guiColours.leftBox2.visible = true;
      if (this.level.currentFrame != 13)
      {
        this.guiText.rankOn.visible = true;
        this.rankTimeBar.visible = true;
      }
      this.mainTime.visible = true;
      this.smallTime.visible = true;
    }

    private function clearArrays():void
    {
      var _loc1_:int = 0;
      this.blocks = [];
      this.death = [];
      this.obstacles = [];
      this.slopes = [];
      this.particles = [];
      this.texts = [];
      this.checkpoints = [];
      this.stars = [];
      this.others = [];
      this.projectiles = [];
      this.pools = [];
      trace(this.effects.length);
      this.effects = [];
      if (this.level)
      {
        _loc1_ = 0;
        while (_loc1_ < this.level.numChildren)
        {
          if (this.level.getChildAt(_loc1_) != this.level.player)
          {
            this.level.removeChild(this.level.getChildAt(_loc1_));
            _loc1_--;
          }
          _loc1_++;
        }
      }
      if (this.playerBreathe)
      {
        removeChild(this.playerBreathe);
        this.playerBreathe = null;
        this.level.player.breatheTimer.stop();
      }
    }

    public function levelComplete(param1:int = 2, param2:Boolean = false):void
    {
      this.frameDestination = param1;
      this.levelCleared = param2;
      if (param2)
      {
        this.fadingIn = false;
      }
      if (this.transitionOut == null)
      {
        this.transitionOut = new gameTransition();
        addChild(this.transitionOut);
        this.findColourChangeTransition(this.transitionOut);
      }
    }

    public function createWindow(param1:String):void
    {
      if (param1 == "reset")
      {
        if (this.level.currentFrame != 2)
        {
          if (this.window is resetWindow)
          {
            if (this.closingWindow != null)
            {
              removeChild(this.closingWindow);
              this.closingWindow = null;
            }
            this.closingWindow = this.window;
            this.window = null;
            return;
          }
          if (this.window != null)
          {
            if (this.closingWindow != null)
            {
              removeChild(this.closingWindow);
              this.closingWindow = null;
            }
            this.closingWindow = this.window;
            this.window = null;
          }
          this.window = new resetWindow();
          this.window.x = this.stageWidth * 0.5;
          this.window.y = this.stageHeight + this.window.height * 0.5;
          this.findColourChangeTransition(this.window.windowColour);
          addChild(this.window);
        }
      }
      else if (param1 == "achievements")
      {
        if (this.window is achievementsWindow)
        {
          if (this.closingWindow != null)
          {
            removeChild(this.closingWindow);
            this.closingWindow = null;
          }
          this.closingWindow = this.window;
          this.window = null;
          return;
        }
        if (this.window != null)
        {
          if (this.closingWindow != null)
          {
            removeChild(this.closingWindow);
            this.closingWindow = null;
          }
          this.closingWindow = this.window;
          this.window = null;
        }
        this.window = new achievementsWindow();
        this.window.x = this.stageWidth * 0.5;
        this.window.y = this.stageHeight + this.window.height * 0.5;
        this.findColourChangeTransition(this.window.windowColour);
        addChild(this.window);
      }
      else if (param1 == "options")
      {
        if (this.window is optionsWindow)
        {
          if (this.closingWindow != null)
          {
            removeChild(this.closingWindow);
            this.closingWindow = null;
          }
          this.closingWindow = this.window;
          this.window = null;
          return;
        }
        if (this.window != null)
        {
          if (this.closingWindow != null)
          {
            removeChild(this.closingWindow);
            this.closingWindow = null;
          }
          this.closingWindow = this.window;
          this.window = null;
        }
        this.window = new optionsWindow();
        this.window.x = this.stageWidth * 0.5;
        this.window.y = this.stageHeight + this.window.height * 0.5;
        this.findColourChangeTransition(this.window.windowColour);
        addChild(this.window);
      }
      else if (param1 == "optionsMenu")
      {
        if (this.window is optionsWindowMenu)
        {
          if (this.closingWindow != null)
          {
            removeChild(this.closingWindow);
            this.closingWindow = null;
          }
          this.closingWindow = this.window;
          this.window = null;
          return;
        }
        if (this.window != null)
        {
          if (this.closingWindow != null)
          {
            removeChild(this.closingWindow);
            this.closingWindow = null;
          }
          this.closingWindow = this.window;
          this.window = null;
        }
        this.window = new optionsWindowMenu();
        this.window.x = this.stageWidth * 0.5;
        this.window.y = this.stageHeight + this.window.height * 0.5;
        this.findColourChangeTransition(this.window.windowColour);
        addChild(this.window);
      }
      else if (param1 == "optionsSb")
      {
        if (this.window is optionsWindowSb)
        {
          if (this.closingWindow != null)
          {
            removeChild(this.closingWindow);
            this.closingWindow = null;
          }
          this.closingWindow = this.window;
          this.window = null;
          return;
        }
        if (this.window != null)
        {
          if (this.closingWindow != null)
          {
            removeChild(this.closingWindow);
            this.closingWindow = null;
          }
          this.closingWindow = this.window;
          this.window = null;
        }
        this.window = new optionsWindowSb();
        this.window.x = this.stageWidth * 0.5;
        this.window.y = this.stageHeight + this.window.height * 0.5;
        this.findColourChangeTransition(this.window.windowColour);
        addChild(this.window);
      }
      else if (param1 == "nameStage")
      {
        if (this.window is nameStageWindow)
        {
          if (this.closingWindow != null)
          {
            removeChild(this.closingWindow);
            this.closingWindow = null;
          }
          this.closingWindow = this.window;
          this.window = null;
          return;
        }
        if (this.window != null)
        {
          if (this.closingWindow != null)
          {
            removeChild(this.closingWindow);
            this.closingWindow = null;
          }
          this.closingWindow = this.window;
          this.window = null;
        }
        this.window = new nameStageWindow();
        this.window.x = this.stageWidth * 0.5;
        this.window.y = this.stageHeight + this.window.height * 0.5;
        this.findColourChangeTransition(this.window.windowColour);
        addChild(this.window);
      }
      else if (param1 == "quitStage")
      {
        if (this.window is quitStageWindow)
        {
          if (this.closingWindow != null)
          {
            removeChild(this.closingWindow);
            this.closingWindow = null;
          }
          this.closingWindow = this.window;
          this.window = null;
          return;
        }
        if (this.window != null)
        {
          if (this.closingWindow != null)
          {
            removeChild(this.closingWindow);
            this.closingWindow = null;
          }
          this.closingWindow = this.window;
          this.window = null;
        }
        this.window = new quitStageWindow();
        this.window.x = this.stageWidth * 0.5;
        this.window.y = this.stageHeight + this.window.height * 0.5;
        this.findColourChangeTransition(this.window.windowColour);
        addChild(this.window);
      }
      else if (param1 == "tutorial")
      {
        if (this.window is sbTutorialsWindow)
        {
          if (this.closingWindow != null)
          {
            removeChild(this.closingWindow);
            this.closingWindow = null;
          }
          this.closingWindow = this.window;
          this.window = null;
          return;
        }
        if (this.window != null)
        {
          if (this.closingWindow != null)
          {
            removeChild(this.closingWindow);
            this.closingWindow = null;
          }
          this.closingWindow = this.window;
          this.window = null;
        }
        this.window = new sbTutorialsWindow();
        this.window.x = this.stageWidth * 0.5;
        this.window.y = this.stageHeight + this.window.height * 0.5;
        this.findColourChangeTransition(this.window.windowColour);
        addChild(this.window);
      }
      else if (param1 == "stageBuilder")
      {
        if (this.window is stageBuilderWindow)
        {
          if (this.closingWindow != null)
          {
            removeChild(this.closingWindow);
            this.closingWindow = null;
          }
          this.closingWindow = this.window;
          this.window = null;
          return;
        }
        if (this.window != null)
        {
          if (this.closingWindow != null)
          {
            removeChild(this.closingWindow);
            this.closingWindow = null;
          }
          this.closingWindow = this.window;
          this.window = null;
        }
        this.window = new stageBuilderWindow();
        this.window.x = this.stageWidth * 0.5;
        this.window.y = this.stageHeight + this.window.height * 0.5;
        this.findColourChangeTransition(this.window.windowColour);
        addChild(this.window);
      }
      else if (param1 == "deactivate")
      {
        if (this.window is pauseWindow)
        {
          if (this.closingWindow != null)
          {
            removeChild(this.closingWindow);
            this.closingWindow = null;
          }
          this.closingWindow = this.window;
          this.window = null;
          return;
        }
        if (this.window != null)
        {
          if (this.closingWindow != null)
          {
            removeChild(this.closingWindow);
            this.closingWindow = null;
          }
          this.closingWindow = this.window;
          this.window = null;
        }
        this.window = new pauseWindow();
        this.window.x = this.stageWidth * 0.5;
        this.window.y = this.stageHeight + this.window.height * 0.5;
        addChild(this.window);
      }
    }

    public function resetStage():void
    {
      this.minutes = 0;
      this.seconds = 0;
      this.milliseconds = 0;
      this.deaths = 0;
      var _loc1_:int = 0;
      while (_loc1_ < this.checkpoints.length)
      {
        if (this.checkpoints[_loc1_] is checkpoint)
        {
          this.checkpoints[_loc1_].reset();
        }
        _loc1_++;
      }
    }

    private function getMainMenu():void
    {
      var _loc1_:int = 0;
      var _loc2_:Object = null;
      if (this.menuDestination == 0)
      {
        if (this.logo)
        {
          if (this.logo.currentFrame == this.logo.totalFrames)
          {
            additionalMaths.easeToPoint(this.logo, this.logo.x, -185);
            additionalMaths.easeToPoint(this.menuSponsor, this.menuSponsor.x, 490);
            additionalMaths.easeToPoint(this.facebook, this.facebook.x, 505);
            additionalMaths.easeToPoint(this.twitter, this.twitter.x, 505);
            additionalMaths.easeToPoint(this.vexButton, this.vexButton.x, 440);
            _loc1_ = 0;
            while (_loc1_ < numChildren)
            {
              _loc2_ = getChildAt(_loc1_);
              if (_loc2_ is button)
              {
                if (_loc2_ is playGame || _loc2_ is stageBuilder || _loc2_ is achievements || _loc2_ is options || _loc2_ is moreGames)
                {
                  if (_loc2_.buttonMask.currentFrame < _loc2_.buttonMask.totalFrames)
                  {
                    _loc2_.buttonMask.play();
                    _loc2_.buttonBG.gotoAndStop(_loc2_.buttonMask.currentFrame);
                  }
                }
              }
              _loc1_++;
            }
          }
        }
      }
      else
      {
        if (this.logo)
        {
          additionalMaths.easeToPoint(this.logo, this.logo.x, -370);
        }
        additionalMaths.easeToPoint(this.menuSponsor, this.menuSponsor.x, 575);
        additionalMaths.easeToPoint(this.facebook, this.facebook.x, 575);
        additionalMaths.easeToPoint(this.twitter, this.twitter.x, 575);
        additionalMaths.easeToPoint(this.vexButton, this.vexButton.x, 570);
        _loc1_ = 0;
        while (_loc1_ < numChildren)
        {
          _loc2_ = getChildAt(_loc1_);
          if (_loc2_ is button)
          {
            if (_loc2_.buttonMask.currentFrame > 1)
            {
              _loc2_.buttonMask.gotoAndStop(_loc2_.buttonMask.currentFrame - 1);
              _loc2_.buttonBG.gotoAndStop(_loc2_.buttonMask.currentFrame);
            }
            else if (this.menuDestination == -1)
            {
              this.playGameFunction();
              this.menuDestination = -2;
            }
          }
          _loc1_++;
        }
      }
      if (this.menuDestination == 1)
      {
        _loc1_ = 0;
        while (_loc1_ < numChildren)
        {
          _loc2_ = getChildAt(_loc1_);
          if (_loc2_ is playGame)
          {
            if (_loc2_.buttonMask.currentFrame == 1)
            {
              if (this.window == null)
              {
                this.createWindow("achievements");
              }
            }
          }
          _loc1_++;
        }
      }
      else if (this.window is achievementsWindow)
      {
        removeChild(this.window);
        this.window = null;
      }
      if (this.menuDestination == 2)
      {
        _loc1_ = 0;
        while (_loc1_ < numChildren)
        {
          _loc2_ = getChildAt(_loc1_);
          if (_loc2_ is playGame)
          {
            if (_loc2_.buttonMask.currentFrame == 1)
            {
              if (this.window == null)
              {
                this.createWindow("optionsMenu");
              }
            }
          }
          _loc1_++;
        }
      }
      else if (this.window is optionsWindowMenu)
      {
        removeChild(this.window);
        this.window = null;
      }
      if (this.menuDestination == 3)
      {
        _loc1_ = 0;
        while (_loc1_ < numChildren)
        {
          _loc2_ = getChildAt(_loc1_);
          if (_loc2_ is stageBuilder)
          {
            if (_loc2_.buttonMask.currentFrame == 1)
            {
              if (this.window == null)
              {
                this.createWindow("stageBuilder");
              }
            }
          }
          _loc1_++;
        }
      }
      else if (this.window is stageBuilderWindow)
      {
        removeChild(this.window);
        this.window = null;
      }
    }

    private function addButtons():void
    {
      if (this.level.currentFrame == 13)
      {
        if (!this.levelButton)
        {
          this.levelButton = new editButton();
          this.levelButton.x = 55;
          this.levelButton.y = 580;
          addChild(this.levelButton);
        }
        if (!this.resetStageButton)
        {
          this.resetStageButton = new resetButton();
          this.resetStageButton.x = 5;
          this.resetStageButton.y = 580;
          addChild(this.resetStageButton);
          this.findColourChangeTransition(this.resetStageButton.buttonBG);
        }
        if (!this.optionButton)
        {
          this.optionButton = new optionsButton();
          this.optionButton.x = 105;
          this.optionButton.y = 580;
          addChild(this.optionButton);
        }
      }
      else
      {
        if (!this.levelButton)
        {
          this.levelButton = new quitButton();
          this.levelButton.x = 55;
          this.levelButton.y = 580;
          addChild(this.levelButton);
        }
        if (!this.achievementButton)
        {
          this.achievementButton = new achievementsButton();
          this.achievementButton.x = 105;
          this.achievementButton.y = 580;
          addChild(this.achievementButton);
        }
        if (!this.optionButton)
        {
          this.optionButton = new optionsButton();
          this.optionButton.x = 155;
          this.optionButton.y = 580;
          addChild(this.optionButton);
        }
        if (this.level.currentFrame == 2)
        {
          if (this.sponsorMan)
          {
            removeChild(this.sponsorMan);
            this.sponsorMan = new LHsponsor();
            this.sponsorMan.x = 630;
            this.sponsorMan.y = 495;
            addChild(this.sponsorMan);
            this.sponsorMan.addEventListener(MouseEvent.MOUSE_OVER, this.sponsorHover);
            this.sponsorMan.addEventListener(MouseEvent.MOUSE_OUT, this.sponsorOff);
            this.sponsorMan.addEventListener(MouseEvent.MOUSE_DOWN, this.sponsorClick);
          }
          else
          {
            this.sponsorMan = new LHsponsor();
            this.sponsorMan.x = 630;
            this.sponsorMan.y = 495;
            addChild(this.sponsorMan);
            this.sponsorMan.addEventListener(MouseEvent.MOUSE_OVER, this.sponsorHover);
            this.sponsorMan.addEventListener(MouseEvent.MOUSE_OUT, this.sponsorOff);
            this.sponsorMan.addEventListener(MouseEvent.MOUSE_DOWN, this.sponsorClick);
          }
          if (this.resetStageButton)
          {
            removeChild(this.resetStageButton);
            this.resetStageButton = null;
          }
        }
        else
        {
          if (!this.resetStageButton)
          {
            this.resetStageButton = new resetButton();
            this.resetStageButton.x = 5;
            this.resetStageButton.y = 580;
            addChild(this.resetStageButton);
            this.findColourChangeTransition(this.resetStageButton.buttonBG);
          }
          // if (this.sponsorMan)
          // {
          // removeChild(this.sponsorMan);
          // this.sponsorMan = new sponsorButton();
          // this.sponsorMan.x = 590;
          // this.sponsorMan.y = 490;
          // addChild(this.sponsorMan);
          // this.sponsorMan.addEventListener(MouseEvent.MOUSE_OVER, this.sponsorHover);
          // this.sponsorMan.addEventListener(MouseEvent.MOUSE_OUT, this.sponsorOff);
          // this.sponsorMan.addEventListener(MouseEvent.MOUSE_DOWN, this.sponsorClick);
          // }
          // else
          // {
          // this.sponsorMan = new sponsorButton();
          // this.sponsorMan.x = 590;
          // this.sponsorMan.y = 490;
          // addChild(this.sponsorMan);
          // this.sponsorMan.addEventListener(MouseEvent.MOUSE_OVER, this.sponsorHover);
          // this.sponsorMan.addEventListener(MouseEvent.MOUSE_OUT, this.sponsorOff);
          // this.sponsorMan.addEventListener(MouseEvent.MOUSE_DOWN, this.sponsorClick);
          // }
        }
      }
      if (this.optionButton)
      {
        this.findColourChangeTransition(this.optionButton.buttonBG);
      }
      if (this.achievementButton)
      {
        this.findColourChangeTransition(this.achievementButton.buttonBG);
      }
      if (this.levelButton)
      {
        this.findColourChangeTransition(this.levelButton.buttonBG);
      }
    }

    public function playGameFunction():void
    {
      this.transitionOut = new gameTransition();
      addChild(this.transitionOut);
      this.findColourChangeTransition(this.transitionOut);
      this.frameDestination = 4;
      this.levelDestination = 2;
      this.fadingIn = false;
    }

    public function newStageFunction():void
    {
      if (!this.transitionOut && !this.transitionIn)
      {
        this.transitionOut = new gameTransition();
        addChild(this.transitionOut);
        this.findColourChangeTransition(this.transitionOut);
        this.frameDestination = 5;
      }
    }

    public function incAchievement(param1:int, param2:int = 1):void
    {
      var _loc3_:Array = achievementsLog["achievement" + param1];
      if (_loc3_[2] < _loc3_[3])
      {
        _loc3_[2] += param2;
        if (_loc3_[2] >= _loc3_[3])
        {
          _loc3_[2] = _loc3_[3];
          this.unlockAchievement(param1);
          var map = {
              "1": "stage0 - achievement:1:TUTORIAL",
              "2": "stage1 - achievement:2:ACT 1",
              "3": "stage2 - achievement:3:ACT 2",
              "4": "stage3 - achievement:4:ACT 3",
              "5": "stage4 - achievement:5:ACT 4",
              "6": "stage5 - achievement:6:ACT 5",
              "7": "stage6 - achievement:7:ACT 6",
              "8": "stage7 - achievement:8:ACT 7",
              "9": "stage8 - achievement:9:ACT 8",
              "10": "stage9 - achievement:10:ACT 9",
              "11": "stage10 - achievement:11:VEXED MUCH?",
              "12": "stage0 - achievement:12:VEXIPHOBIA",
              "13": "hub - achievement:13:NOT A SCRATCH",
              "14": "hub - achievement:14 - STARGAZER",
              "15": "hub - achievement:15 - ASTRONAUT",
              "16": "hub - achievement:16:BUZZ LIGHTYEAR",
              "20": "hub - achievement:20:BLOWN AWAY!",
              "21": "hub - achievement:21:2ND PLACE",
              "22": "hub - achievement:22:1ST PLACE",
              "23": "hub - achievement:23:PERFECT",
              "24": "hub - achievement:24:OLYMPIAN",
              "25": "hub - achievement:25:PERFECTIONIST",
              "26": "hub - achievement:26:DOUBLE DOWN",
              "27": "hub - achievement:27:CURB STOMP",
              "28": "hub - achievement:28:LIFESAVER",
              "29": "hub - achievement:29:KEYLOGGER",
              "30": "hub - achievement:30:MICROWAVE"
            };

          ExternalInterface.call("newItem", map[param1]);
        }
      }
      else
      {
        _loc3_[2] = _loc3_[3];
      }
    }

    private function checkClearStageAchievements():void
    {
      // ExternalInterface.call("log", "this.level.currentFrame", this.level.currentFrame, this.player.checkpointsReached);
      if (this.level.currentFrame == 1)
      {
        this.incAchievement(1);
        if (this.player.checkpointsReached == 0)
        {
          this.incAchievement(12);
        }
      }
      else if (this.level.currentFrame > 2)
      {
        this.incAchievement(this.level.currentFrame - 1);
        if (this.level.currentFrame == 5 && this.player.checkpointsReached == 0)
        {
          ExternalInterface.call("newItem", "stage3 - achievement:-1:LEVEL 3 NO CHECKPOINTS");
        }
      }
      if (this.deaths == 0)
      {
        this.incAchievement(13);
      }
    }

    private function unlockAchievement(param1:int):void
    {
      // TODO
      var _loc2_:Array = achievementsLog["achievement" + param1];
      trace("Achievement " + param1 + " unlocked! - create window");
      var _loc3_:* = new achievementUnlocked();
      _loc3_.x = 640 + _loc3_.width;
      _loc3_.y = 100 + 100 * achievementUnlocked.achievementUnlocks;
      _loc3_.achievementName.text = _loc2_[0];
      addChild(_loc3_);
      this.findColourChangeTransition(_loc3_.bgColours);
      var _loc4_:* = "achievement" + param1 + "Button";
      _loc3_.icon = new (getDefinitionByName(_loc4_))();
      _loc3_.icon.x = 110;
      _loc3_.icon.y = 45;
      _loc3_.addChild(_loc3_.icon);
      // if (achievementsLog["achievement" + param1][0] != "Microwave")
      // {
      // this.unlockNewgroundsMedal(achievementsLog["achievement" + param1][0]);
      // }
    }

    private function unlockNewgroundsMedal(param1:String):void
    {
      API.unlockMedal(param1);
    }

    public function loadGame():void
    {
      var _loc1_:SharedObject = null;

      // 1. Fetch the complete save object from JS via window.getSaveData()
      var saveData:Object = ExternalInterface.call("getSaveData");

      if (saveData != null)
      {
        // Restore Times & Deaths
        if (saveData.actTimes != null)
          this.savedTimes = saveData.actTimes;
        if (saveData.actDeaths != null)
          this.savedDeaths = saveData.actDeaths;

        // Restore Stars
        if (saveData.stars != null)
        {
          var starData:Object = saveData.stars;
          var _loc2_:int = 0;
          while (("savedAct" + _loc2_ + "Stars") in this)
          {
            if (starData["act" + _loc2_] != null)
            {
              this["savedAct" + _loc2_ + "Stars"] = starData["act" + _loc2_];
            }
            _loc2_++;
          }
        }

        // Restore Achievements
        if (saveData.achievements != null)
        {
          var achData:Object = saveData.achievements;
          var _loc3_:int = 1;
          while (("achievement" + _loc3_) in achievementsLog)
          {
            if (achData["achievement" + _loc3_] != null)
            {
              achievementsLog["achievement" + _loc3_][2] = achData["achievement" + _loc3_];
            }
            _loc3_++;
          }
        }

        // Restore Stats & Custom Stages
        if (saveData.stats != null)
          this.stats = saveData.stats;
        if (saveData.itemPackages != null)
          this.savedItemPacks = saveData.itemPackages;
        if (saveData.stages != null)
          this.savedStages = saveData.stages;
        if (saveData.stageNames != null)
          this.savedStagesNames = saveData.stageNames;
        if (saveData.options != null)
        {
          var opts:Array = saveData.options as Array;
          if (opts != null)
          {
            if (opts[0] != null)
              this.particleLimit = opts[0];
            if (opts[1] != null)
              this.qualitySetting = opts[1];
            if (opts[2] != null)
              this.blendModes = opts[2];
            if (opts[3] != null)
              this.audioBGM = opts[3];
            if (opts[4] != null)
              this.audioSFX = opts[4];
            if (opts[5] != null)
              this.resetWarning = opts[5];
            if (opts[6] != null)
              this.autoReset = opts[6];
          }
        }
        // ExternalInterface.call("log", saveData.options, saveData);
        trace("Game successfully loaded via JS getSaveData!");
      }
    }

    public function saveGame():void
    {
      // ----------------------------------------------------
      // 1. Prepare Save Objects for External (JS) Storage
      // ----------------------------------------------------

      // Build object for Star data across acts
      var starData:Object = {};
      var _loc2_:int = 0;
      while (("savedAct" + _loc2_ + "Stars") in this)
      {
        starData["act" + _loc2_] = this["savedAct" + _loc2_ + "Stars"];
        _loc2_++;
      }

      // Build object for Achievement data
      var achievementData:Object = {};
      var _loc3_:int = 1;
      while (("achievement" + _loc3_) in achievementsLog)
      {
        achievementData["achievement" + _loc3_] = achievementsLog["achievement" + _loc3_][2];
        _loc3_++;
      }

      // ----------------------------------------------------
      // 2. Send Save Data to JavaScript (if available)
      // ----------------------------------------------------
      if (ExternalInterface.available)
      {
        // Combined payload containing all save fields
        var saveData:Object = {
            "actTimes": this.savedTimes,
            "actDeaths": this.savedDeaths,
            "stars": starData,
            "achievements": achievementData,
            "stats": this.stats,
            "itemPackages": this.savedItemPacks,
            "stages": this.savedStages,
            "stageNames": this.savedStagesNames,
            "options": [this.particleLimit, this.qualitySetting, this.blendModes, this.audioBGM, this.audioSFX, this.resetWarning, this.autoReset]
          };

        // Call JS save handler on window
        ExternalInterface.call("saveGame", saveData);
      }

      // // ----------------------------------------------------
      // // 3. (Optional) Save locally to SharedObject as a fallback
      // // ----------------------------------------------------
      // var _loc1_:SharedObject = SharedObject.getLocal("vex2");
      // _loc1_.data.actTimes = this.savedTimes;
      // _loc1_.data.actDeaths = this.savedDeaths;

      // for (var actKey:String in starData)
      // {
      // _loc1_.data[actKey + "Stars"] = starData[actKey];
      // }

      // for (var achKey:String in achievementData)
      // {
      // _loc1_.data[achKey] = achievementData[achKey];
      // }

      // _loc1_.data.stats = this.stats;
      // this.saveOptions();
      // _loc1_.data.itemPackages = this.savedItemPacks;
      // _loc1_.data.stages = this.savedStages;
      // _loc1_.data.stageNames = this.savedStagesNames;
      // _loc1_.flush(); // Flushes changes to memory/disk

      trace("Game successfully saved!");
    }
    public function saveOptions():void
    {
      this.saveGame();
      // var _loc1_:SharedObject = SharedObject.getLocal("vex2");
      // _loc1_.data.options = [this.particleLimit, this.qualitySetting, this.blendModes, this.audioBGM, this.audioSFX, this.resetWarning, this.autoReset];
    }

    public function clearAllData():void
    {
      var _loc1_:SharedObject = SharedObject.getLocal("vex2");
      this.savedTimes = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
      this.savedDeaths = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
      var _loc2_:int = 0;
      while (["savedAct" + _loc2_ + "Stars"] in this)
      {
        this["savedAct" + _loc2_ + "Stars"] = [false];
        _loc2_++;
      }
      var _loc3_:int = 1;
      while (["achievement" + _loc3_] in achievementsLog)
      {
        achievementsLog["achievement" + _loc3_][2] = 0;
        _loc3_++;
      }
      this.stats = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
      this.secondsPlayed = this.stats[9];
      this.minutesPlayed = this.stats[10];
      this.hoursPlayed = this.stats[11];
      this.savedStages = [];
      this.savedStagesNames = [];
      this.savedItemPacks = [false, false, false, false, false, false, false, false, false, false, false, false, false];
      trace("Game successfully cleared!");
      this.saveGame();
      this.loadGame();
    }

    private function renderStage():void
    {
      var _loc3_:* = undefined;
      var _loc4_:int = 0;
      trace(this.localMap);
      trace("Level: ", this.level);
      trace("Player: ", this.level.player);
      trace("Portal: ", this.level.finishPortal);
      this.level.player.x = this.localMap[0];
      this.level.player.y = this.localMap[1];
      this.level.player.checkPoint = new Point(this.localMap[0], this.localMap[1]);
      this.level.finishPortal.x = this.localMap[2];
      this.level.finishPortal.y = this.localMap[3];
      camera.snap(this.level.player, this.level, 320, 280);
      trace("Camera snapped.");
      var _loc1_:Array = [];
      var _loc2_:int = 4;
      while (_loc2_ < this.localMap.length - 1)
      {
        _loc1_ = this.getSCParameters(int(this.localMap[_loc2_]));
        if (_loc1_.length == 0)
        {
          break;
        }
        switch (int(this.localMap[_loc2_]))
        {
          case 0:
            _loc3_ = new basicBlock();
            break;
          case 1:
            _loc3_ = new leftSlope();
            break;
          case 2:
            _loc3_ = new rightSlope();
            break;
          case 3:
            _loc3_ = new fallingBlock();
            break;
          case 4:
            _loc3_ = new swimmingPool();
            break;
          case 5:
            _loc3_ = new checkpoint();
            break;
          case 6:
            _loc3_ = new spike();
            break;
          case 7:
            _loc3_ = new spikex10();
            break;
          case 8:
            _loc3_ = new bounceBlock();
            break;
          case 9:
            _loc3_ = new verticalDownBlock();
            break;
          case 10:
            _loc3_ = new verticalUpBlock();
            break;
          case 11:
            _loc3_ = new horizontalBlock();
            break;
          case 12:
            _loc3_ = new pendulum();
            break;
          case 13:
            _loc3_ = new iceBlock();
            break;
          case 14:
            _loc3_ = new lockBlock();
            break;
          case 15:
            _loc3_ = new pushBlock();
            break;
          case 16:
            _loc3_ = new enlargingBlock();
            break;
          case 17:
            _loc3_ = new darkBlock();
            break;
          case 18:
            _loc3_ = new invisBlock();
            break;
          case 19:
            _loc3_ = new spikeRaise();
            break;
          case 20:
            _loc3_ = new spinningBuzzsaw();
            break;
          case 21:
            _loc3_ = new shurikanSpawner();
            break;
          case 22:
            _loc3_ = new spiralRight();
            break;
          case 23:
            _loc3_ = new reaper();
            break;
          case 24:
            _loc3_ = new bouncingBuzzsaw();
            break;
          case 25:
            _loc3_ = new closingSpikes();
            break;
          case 26:
            _loc3_ = new laser();
            break;
          case 27:
            _loc3_ = new buzzsawOnStick();
            break;
          case 28:
            _loc3_ = new gravityUpLever();
            break;
          case 29:
            _loc3_ = new pole();
            break;
          case 30:
            _loc3_ = new cannon();
            break;
          case 31:
            _loc3_ = new breatheBlaster();
            break;
          case 32:
            _loc3_ = new windBlasterSmall();
            break;
          case 33:
            _loc3_ = new windBlaster();
            break;
          case 34:
            _loc3_ = new teleporter();
            break;
          case 35:
            _loc3_ = new teleporterReceiver();
            break;
          case 36:
            _loc3_ = new key();
            break;
          case 38:
            _loc3_ = new speedUpLever();
            break;
          case 39:
            _loc3_ = new lightSwitch();
            break;
          case 40:
            _loc3_ = new pulley();
            break;
          case 41:
            _loc3_ = new gravityDownLever();
            break;
          case 42:
            _loc3_ = new microwave();
            break;
          case 43:
            _loc3_ = new enlargingBuzzsaw();
            break;
          case 44:
            _loc3_ = new classicLaser();
            break;
          case 45:
            _loc3_ = new wiredBlock();
            break;
          case 46:
            _loc3_ = new poleQuadrant();
        }
        _loc4_ = 0;
        while (_loc4_ < _loc1_.length)
        {
          if (_loc1_[_loc4_] == "x")
          {
            _loc3_.x = int(this.localMap[_loc2_ + _loc4_ + 1]);
          }
          else if (_loc1_[_loc4_] == "y")
          {
            _loc3_.y = int(this.localMap[_loc2_ + _loc4_ + 1]);
          }
          else if (_loc1_[_loc4_] == "width")
          {
            _loc3_.width = int(this.localMap[_loc2_ + _loc4_ + 1]);
            _loc3_.height = int(this.localMap[_loc2_ + _loc4_ + 1]);
          }
          else if (_loc1_[_loc4_] == "height")
          {
            _loc3_.height = int(this.localMap[_loc2_ + _loc4_ + 1]);
          }
          else if (_loc1_[_loc4_] == "rotation")
          {
            _loc3_.rotation = int(this.localMap[_loc2_ + _loc4_ + 1]);
          }
          _loc4_++;
        }
        this.level.addChild(_loc3_);
        _loc2_ += _loc1_.length + 1;
      }
    }

    public function buildStage(param1:MovieClip):void
    {
      var _loc4_:* = undefined;
      var _loc5_:int = 0;
      param1.playerStart.x = this.localMap[0];
      param1.playerStart.y = this.localMap[1];
      param1.finishPortal.x = this.localMap[2];
      param1.finishPortal.y = this.localMap[3];
      var _loc2_:Array = [];
      var _loc3_:int = 4;
      while (_loc3_ < this.localMap.length - 3)
      {
        _loc2_ = this.getSCParameters(this.localMap[_loc3_]);
        if (_loc2_.length == 0)
        {
          break;
        }
        switch (this.localMap[_loc3_])
        {
          case 0:
            _loc4_ = new sbBasicBlock();
            break;
          case 1:
            _loc4_ = new sbLeftSlope();
            break;
          case 2:
            _loc4_ = new sbRightSlope();
            break;
          case 3:
            _loc4_ = new sbFallingBlock();
            break;
          case 4:
            _loc4_ = new sbSwimmingPool();
            break;
          case 5:
            _loc4_ = new sbCheckpoint();
            break;
          case 6:
            _loc4_ = new sbSpike();
            break;
          case 7:
            _loc4_ = new sbSpikex10();
            break;
          case 8:
            _loc4_ = new sbBounceBlock();
            break;
          case 9:
            _loc4_ = new sbVerticalDownBlock();
            break;
          case 10:
            _loc4_ = new sbVerticalUpBlock();
            break;
          case 11:
            _loc4_ = new sbHorizontalBlock();
            break;
          case 12:
            _loc4_ = new sbPendulum();
            break;
          case 13:
            _loc4_ = new sbIceBlock();
            break;
          case 14:
            _loc4_ = new sbLockBlock();
            break;
          case 15:
            _loc4_ = new sbPushBlock();
            break;
          case 16:
            _loc4_ = new sbEnlargingBlock();
            break;
          case 17:
            _loc4_ = new sbSolarBlock();
            break;
          case 18:
            _loc4_ = new sbInvisBlock();
            break;
          case 19:
            _loc4_ = new sbSurpriseSpike();
            break;
          case 20:
            _loc4_ = new sbBuzzsaw();
            break;
          case 21:
            _loc4_ = new sbShurikanSpawner();
            break;
          case 22:
            _loc4_ = new sbQuadrant();
            break;
          case 23:
            _loc4_ = new sbScythe();
            break;
          case 24:
            _loc4_ = new sbBouncingBuzzsaw();
            break;
          case 25:
            _loc4_ = new sbClosingSpikes();
            break;
          case 26:
            _loc4_ = new sbLaser();
            break;
          case 27:
            _loc4_ = new sbRotatingBuzzsaw();
            break;
          case 28:
            _loc4_ = new sbGravityUpLever();
            break;
          case 29:
            _loc4_ = new sbPole();
            break;
          case 30:
            _loc4_ = new sbCannon();
            break;
          case 31:
            _loc4_ = new sbBreatheBlaster();
            break;
          case 32:
            _loc4_ = new sbSmWindBlaster();
            break;
          case 33:
            _loc4_ = new sbWindBlaster();
            break;
          case 34:
            _loc4_ = new sbTeleporter();
            break;
          case 35:
            _loc4_ = new sbTeleporterReceiver();
            break;
          case 36:
            _loc4_ = new sbKey();
            break;
          case 38:
            _loc4_ = new sbSpeedUpLever();
            break;
          case 39:
            _loc4_ = new sbLightSwitch();
            break;
          case 40:
            _loc4_ = new sbPulley();
            break;
          case 41:
            _loc4_ = new sbGravityDownLever();
            break;
          case 42:
            _loc4_ = new sbMicrowave();
            break;
          case 43:
            _loc4_ = new sbEnlargingBuzzsaw();
            break;
          case 44:
            _loc4_ = new sbClassicLaser();
            break;
          case 45:
            _loc4_ = new sbWiredBlock();
            break;
          case 46:
            _loc4_ = new sbPoleQuadrant();
        }
        _loc5_ = 0;
        while (_loc5_ < _loc2_.length)
        {
          if (_loc2_[_loc5_] == "x")
          {
            _loc4_.x = this.localMap[_loc3_ + _loc5_ + 1];
          }
          else if (_loc2_[_loc5_] == "y")
          {
            _loc4_.y = this.localMap[_loc3_ + _loc5_ + 1];
          }
          else if (_loc2_[_loc5_] == "width")
          {
            _loc4_.width = this.localMap[_loc3_ + _loc5_ + 1];
            _loc4_.height = this.localMap[_loc3_ + _loc5_ + 1];
          }
          else if (_loc2_[_loc5_] == "height")
          {
            _loc4_.height = this.localMap[_loc3_ + _loc5_ + 1];
          }
          else if (_loc2_[_loc5_] == "rotation")
          {
            _loc4_.rotation = this.localMap[_loc3_ + _loc5_ + 1];
          }
          _loc5_++;
        }
        param1.addChild(_loc4_);
        _loc3_ += _loc2_.length + 1;
      }
    }

    public function getSCParameters(param1:int = 0):Array
    {
      var _loc2_:Array = [];
      if (param1 == 0)
      {
        _loc2_ = ["x", "y", "width", "height"];
      }
      if (param1 == 1)
      {
        _loc2_ = ["x", "y", "width"];
      }
      if (param1 == 2)
      {
        _loc2_ = ["x", "y", "width"];
      }
      if (param1 == 3)
      {
        _loc2_ = ["x", "y", "width", "height"];
      }
      if (param1 == 4)
      {
        _loc2_ = ["x", "y", "width", "height"];
      }
      if (param1 == 42)
      {
        _loc2_ = ["x", "y", "width", "height"];
      }
      if (param1 == 45)
      {
        _loc2_ = ["x", "y", "width", "height"];
      }
      if (param1 == 5)
      {
        _loc2_ = ["x", "y"];
      }
      if (param1 == 6)
      {
        _loc2_ = ["x", "y", "rotation"];
      }
      if (param1 == 7)
      {
        _loc2_ = ["x", "y", "rotation"];
      }
      if (param1 == 8)
      {
        _loc2_ = ["x", "y", "width"];
      }
      if (param1 > 8 && param1 < 12)
      {
        _loc2_ = ["x", "y", "width", "height"];
      }
      if (param1 == 12)
      {
        _loc2_ = ["x", "y"];
      }
      if (param1 >= 13 && param1 <= 18)
      {
        _loc2_ = ["x", "y", "width", "height"];
      }
      if (param1 == 19)
      {
        _loc2_ = ["x", "y", "rotation"];
      }
      if (param1 == 16)
      {
        _loc2_ = ["x", "y", "width"];
      }
      if (param1 == 20)
      {
        _loc2_ = ["x", "y", "width"];
      }
      if (param1 == 21)
      {
        _loc2_ = ["x", "y", "rotation"];
      }
      if (param1 == 22)
      {
        _loc2_ = ["x", "y", "width", "rotation"];
      }
      if (param1 == 23)
      {
        _loc2_ = ["x", "y", "rotation"];
      }
      if (param1 == 24)
      {
        _loc2_ = ["x", "y", "width"];
      }
      if (param1 == 25)
      {
        _loc2_ = ["x", "y", "rotation"];
      }
      if (param1 == 26)
      {
        _loc2_ = ["x", "y"];
      }
      if (param1 == 27)
      {
        _loc2_ = ["x", "y", "rotation"];
      }
      if (param1 == 28)
      {
        _loc2_ = ["x", "y"];
      }
      if (param1 == 29)
      {
        _loc2_ = ["x", "y"];
      }
      if (param1 == 30)
      {
        _loc2_ = ["x", "y"];
      }
      if (param1 >= 31 && param1 <= 33)
      {
        _loc2_ = ["x", "y", "rotation"];
      }
      if (param1 >= 34 && param1 <= 41)
      {
        _loc2_ = ["x", "y"];
      }
      if (param1 == 44)
      {
        _loc2_ = ["x", "y"];
      }
      if (param1 == 46)
      {
        _loc2_ = ["x", "y"];
      }
      if (param1 == 43)
      {
        _loc2_ = ["x", "y", "width"];
      }
      return _loc2_;
    }

    public function sponsorHover(param1:MouseEvent):void
    {
      // adjustColour.colourChange(param1.currentTarget, 0, 0, 20, 0);
    }

    public function sponsorOff(param1:MouseEvent):void
    {
      // adjustColour.colourChange(param1.currentTarget, 0, 0, 0, 0);
    }

    public function sponsorClick(param1:MouseEvent):void
    {
      // this.linkToSponsor(param1);
    }

    private function submitKong(param1:int, param2:int):void
    {
      // if (param2 == 0)
      // {
      // this.kongregate.stats.submit("Tutorial Time", param1);
      // }
      // else if (param2 == 11)
      // {
      // this.kongregate.stats.submit("Vexation Time", param1);
      // }
      // else
      // {
      // this.kongregate.stats.submit(String("Act " + (param2 - 1) + " Time"), param1);
      // }
    }

    private function submitKongLevels(param1:int):void
    {
      // if (param1 == 0)
      // {
      // this.kongregate.stats.submit("LevelsComplete", param1 + 1);
      // }
      // else
      // {
      // this.kongregate.stats.submit("LevelsComplete", param1);
      // }
    }

    public function submitKongStars():void
    {
      // if (this.kongregate)
      // {
      // this.kongregate.stats.submit("starsCollected", achievementsLog.achievement16[2]);
      // }
    }

    internal function __setProp___id0__Scene1_actions_0():*
    {
      // if (this.__setPropDict[this.__id0_] == undefined || int(this.__setPropDict[this.__id0_]) != 1)
      // {
      // this.__setPropDict[this.__id0_] = 1;
      // try
      // {
      // this.__id0_["componentInspectorSetting"] = true;
      // }
      // catch (e:Error)
      // {
      // }
      // this.__id0_.apiId = "32512:cCrsgJNu";
      // this.__id0_.encryptionKey = "7QKRwpi9DmtTe6NVQXLFpKKGF6qwC9l2";
      // this.__id0_.debugMode = "Simulate Logged-in User";
      // this.__id0_.movieVersion = "1";
      // this.__id0_.connectorType = "Invisible";
      // this.__id0_.redirectOnNewVersion = false;
      // this.__id0_.redirectOnHostBlocked = false;
      // this.__id0_.adType = "Video";
      // try
      // {
      // this.__id0_["componentInspectorSetting"] = false;
      // }
      // catch (e:Error)
      // {
      // }
      // }
    }

    internal function frame1():*
    {
      this.__setProp___id0__Scene1_actions_0();
      stop();
      this.advert = false;
      gotoAndStop(2);
    }

    internal function frame2():*
    {
      stop();
      this.introAnimation.menuSponsor.addEventListener(MouseEvent.MOUSE_OVER, this.sponsorHover);
      this.introAnimation.menuSponsor.addEventListener(MouseEvent.MOUSE_OUT, this.sponsorOff);
      this.introAnimation.menuSponsor.addEventListener(MouseEvent.MOUSE_DOWN, this.sponsorClick);
    }

    internal function frame3():*
    {
      stop();
      this.menuSponsor.addEventListener(MouseEvent.MOUSE_OVER, this.sponsorHover);
      this.menuSponsor.addEventListener(MouseEvent.MOUSE_OUT, this.sponsorOff);
      this.menuSponsor.addEventListener(MouseEvent.MOUSE_DOWN, this.sponsorClick);
      this.facebook.addEventListener(MouseEvent.MOUSE_OVER, this.sponsorHover);
      this.facebook.addEventListener(MouseEvent.MOUSE_OUT, this.sponsorOff);
      this.facebook.addEventListener(MouseEvent.MOUSE_DOWN, this.sponsorClick);
      this.twitter.addEventListener(MouseEvent.MOUSE_OVER, this.sponsorHover);
      this.twitter.addEventListener(MouseEvent.MOUSE_OUT, this.sponsorOff);
      this.twitter.addEventListener(MouseEvent.MOUSE_DOWN, this.sponsorClick);
      this.vexButton.addEventListener(MouseEvent.MOUSE_OVER, this.sponsorHover);
      this.vexButton.addEventListener(MouseEvent.MOUSE_OUT, this.sponsorOff);
      this.vexButton.addEventListener(MouseEvent.MOUSE_DOWN, this.sponsorClick);
    }
  }
}
