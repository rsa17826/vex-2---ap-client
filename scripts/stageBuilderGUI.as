package
{
  import flash.display.MovieClip;
  import flash.display.Shape;
  import flash.events.Event;
  import flash.events.KeyboardEvent;
  import flash.events.MouseEvent;
  import flash.geom.Point;
  import flash.geom.Rectangle;
  import flash.text.TextField;
  import flash.utils.getDefinitionByName;

  [Embed(source="/_assets/assets.swf", symbol="symbol1357")]
  public class stageBuilderGUI extends MovieClip
  {

    public var stageContainer:MovieClip;
    public var itemPointerDest:Point;
    public var menuPointerDest:Point;
    public var itemDescDest:Point;
    public var itemCount:TextField;
    public var guideLine:Shape = null;
    public var itemMax:int = 10000;
    public var attachmentsOn:Boolean = true;
    public var snapOn:Boolean = true;
    public var guideLines:int = 50;
    private var itemsDisplaying:int = 0;
    public var itemsAdded:Array = [];
    public var selectedItems:Array = [];
    private var multiSelecting:Boolean = false;
    public var itemDescTimer:int;
    public var rolledOver:Boolean = false;
    private var itemSliderPos:int = 0;
    private var itemsSpawned:int = 0;
    private const itemSliderMax:int = 15;
    private var cDown:Boolean = false;
    private var cHold:Boolean = false;
    private var aDown:Boolean = false;
    private var aHold:Boolean = false;
    private var wDown:Boolean = false;
    private var wHold:Boolean = false;
    private var sDown:Boolean = false;
    private var sHold:Boolean = false;
    private var dDown:Boolean = false;
    private var dHold:Boolean = false;
    public var main:MovieClip;
    public var deleteBox:MovieClip = null;
    public var arrangeUpBox:MovieClip = null;
    public var arrangeDownBox:MovieClip = null;
    public var menuPointer:MovieClip;
    public var itemPointer:MovieClip;
    public var itemDesc:MovieClip;
    public var blocksButton:MovieClip;
    public var obstButton:MovieClip;
    public var othersButton:MovieClip;
    public var decorButton:MovieClip;
    public var itemSlider:MovieClip;
    public var itemsprev:MovieClip;
    public var itemsnext:MovieClip;
    public var testStage:MovieClip;
    public var optionsButton:MovieClip;
    public var saveButton:MovieClip;
    public var quitButton:MovieClip;
    public var tutorialButton:MovieClip;
    public function stageBuilderGUI()
    {
      super();
      addEventListener(Event.ADDED_TO_STAGE, this.init, false, 0, true);
      stage.addEventListener(KeyboardEvent.KEY_DOWN, this.keyPressed);
      stage.addEventListener(KeyboardEvent.KEY_UP, this.keyReleased);
    }

    private function init(param1:Event):void
    {
      this.addMouseListeners();
      this.main = MovieClip(root);
      this.itemPointerDest = new Point(this.itemPointer.x, this.itemPointer.y);
      this.menuPointerDest = new Point(this.menuPointer.x, this.menuPointer.y);
      this.itemDescDest = new Point(this.itemDesc.x, this.itemDesc.y);
      this.itemDescTimer = 30;
      this.updateLimit();
      this.itemsprev.visible = false;
      this.itemsnext.visible = false;
      if (this.main.localMap.length > 0)
      {
        this.main.buildStage(this.stageContainer);
        this.loadOptions();
        this.deselectAll();
      }
      removeEventListener(Event.ADDED_TO_STAGE, this.init);
    }

    private function loadOptions():void
    {
      if (this.main.localMap[this.main.localMap.length - 2] == 1)
      {
        this.snapOn = true;
        this.guideLines = this.main.localMap[this.main.localMap.length - 1];
        this.renderGuideLines();
      }
    }

    public function update():void
    {
      this.updateChildren();
      additionalMaths.easeToPoint(this.itemPointer, this.itemPointerDest.x, this.itemPointerDest.y, 5);
      additionalMaths.easeToPoint(this.menuPointer, this.menuPointerDest.x, this.menuPointerDest.y, 5);
      additionalMaths.easeToPoint(this.itemDesc, this.itemDescDest.x, this.itemDescDest.y, 5);
      additionalMaths.easeToPoint(this.itemSlider.container, -this.itemSliderPos * 35 - 530, 5, 5);
      if (stage.mouseY < 510 || ++this.itemDescTimer >= 30)
      {
        if (!this.rolledOver)
        {
          this.itemDescDest.x = -150;
          this.itemDescDest.y = 420;
        }
      }
      if (stage.mouseY > 50 || ++this.itemDescTimer >= 30)
      {
        if (!this.rolledOver)
        {
          this.menuPointerDest.x = -50;
        }
      }
      this.hotkeys();
      if (!this.snapOn)
      {
        if (this.guideLine)
        {
          this.guideLine.graphics.clear();
          this.stageContainer.removeChild(this.guideLine);
          this.guideLine = null;
        }
      }
    }

    private function hotkeys():void
    {
      var _loc1_:int = 0;
      if (this.main.window == null)
      {
        if (this.cDown)
        {
          if (!this.cHold)
          {
            this.duplicateItem();
          }
        }
        if (this.aDown)
        {
          if (!this.aHold)
          {
            this.aHold = true;
            _loc1_ = 0;
            while (_loc1_ < this.selectedItems.length)
            {
              this.selectedItems[_loc1_].x -= this.guideLines;
              _loc1_++;
            }
            if (this.selectedItems.length > 1)
            {
              this.createMultiBoxes();
            }
          }
        }
        if (this.dDown)
        {
          if (!this.dHold)
          {
            this.dHold = true;
            _loc1_ = 0;
            while (_loc1_ < this.selectedItems.length)
            {
              this.selectedItems[_loc1_].x += this.guideLines;
              _loc1_++;
            }
            if (this.selectedItems.length > 1)
            {
              this.createMultiBoxes();
            }
          }
        }
        if (this.wDown)
        {
          if (!this.wHold)
          {
            this.wHold = true;
            _loc1_ = 0;
            while (_loc1_ < this.selectedItems.length)
            {
              this.selectedItems[_loc1_].y -= this.guideLines;
              _loc1_++;
            }
            if (this.selectedItems.length > 1)
            {
              this.createMultiBoxes();
            }
          }
        }
        if (this.sDown)
        {
          if (!this.sHold)
          {
            this.sHold = true;
            _loc1_ = 0;
            while (_loc1_ < this.selectedItems.length)
            {
              this.selectedItems[_loc1_].y += this.guideLines;
              _loc1_++;
            }
            if (this.selectedItems.length > 1)
            {
              this.createMultiBoxes();
            }
          }
        }
      }
    }

    public function renderGuideLines():void
    {
      var _loc1_:int = 0;
      if (this.guideLine)
      {
        this.guideLine.graphics.clear();
      }
      this.guideLine = new Shape();
      this.guideLine.graphics.lineStyle(1, 10066329);
      if (this.guideLines < 10)
      {
        this.guideLines = 10;
      }
      if (this.guideLines > 100)
      {
        this.guideLines = 100;
      }
      _loc1_ = -2000;
      while (_loc1_ < 2000)
      {
        this.guideLine.graphics.moveTo(_loc1_, -2000);
        this.guideLine.graphics.lineTo(_loc1_, 2000);
        _loc1_ += this.guideLines;
      }
      _loc1_ = -2000;
      while (_loc1_ < 2000)
      {
        this.guideLine.graphics.moveTo(-2000, _loc1_);
        this.guideLine.graphics.lineTo(2000, _loc1_);
        _loc1_ += this.guideLines;
      }
      this.guideLine.cacheAsBitmap = true;
      this.stageContainer.addChild(this.guideLine);
      this.stageContainer.setChildIndex(this.guideLine, 0);
    }

    private function updateChildren():void
    {
      var _loc1_:int = 0;
      var _loc2_:* = undefined;
      _loc1_ = 0;
      while (_loc1_ < numChildren)
      {
        _loc2_ = getChildAt(_loc1_);
        if ("update" in _loc2_)
        {
          _loc2_.update();
        }
        _loc1_++;
      }
      _loc1_ = 0;
      while (_loc1_ < this.stageContainer.numChildren)
      {
        _loc2_ = this.stageContainer.getChildAt(_loc1_);
        if ("update" in _loc2_)
        {
          _loc2_.update();
        }
        _loc1_++;
      }
      if (this.multiSelecting)
      {
        this.createMultiBoxes();
      }
    }

    public function buildItems(param1:int):void
    {
      var _loc4_:int = 0;
      var _loc5_:* = null;
      var _loc6_:Class = null;
      var _loc7_:MovieClip = null;
      this.destroyItemMenu();
      this.itemsSpawned = 0;
      this.itemSliderPos = 0;
      var _loc2_:Array = this.main.savedItemPacks;
      var _loc3_:int = 0;
      while (["itemPackage" + _loc3_] in itemPackages)
      {
        if (_loc2_[_loc3_] || true)
        {
          _loc4_ = 0;
          while (_loc4_ < itemPackages["itemPackage" + _loc3_][param1].length)
          {
            _loc5_ = "sb" + itemPackages["itemPackage" + _loc3_][param1][_loc4_] + "Item";
            _loc6_ = getDefinitionByName(_loc5_) as Class;
            _loc7_ = new _loc6_();
            this.itemSlider.container.addChild(_loc7_);
            _loc7_.x = this.itemsSpawned * 35;
            ++this.itemsSpawned;
            _loc4_++;
          }
        }
        _loc3_++;
      }
      this.itemsprev.visible = false;
      this.itemsnext.visible = false;
      if (this.itemsSpawned >= this.itemSliderMax)
      {
        this.itemsnext.visible = true;
      }
    }

    protected function destroyItemMenu():void
    {
      var _loc2_:* = undefined;
      var _loc1_:int = 0;
      while (_loc1_ < this.itemSlider.container.numChildren)
      {
        _loc2_ = this.itemSlider.container.getChildAt(_loc1_);
        this.itemSlider.container.removeChild(_loc2_);
        _loc1_--;
        _loc1_++;
      }
    }

    public function deselectAll():void
    {
      var _loc2_:* = undefined;
      var _loc1_:int = 0;
      while (_loc1_ < this.stageContainer.numChildren)
      {
        _loc2_ = this.stageContainer.getChildAt(_loc1_);
        if ("deselect" in _loc2_)
        {
          _loc2_.deselect();
        }
        _loc1_++;
      }
      if (this.arrangeDownBox)
      {
        this.stageContainer.removeChild(this.arrangeDownBox);
        this.arrangeDownBox = null;
      }
      if (this.arrangeUpBox)
      {
        this.stageContainer.removeChild(this.arrangeUpBox);
        this.arrangeUpBox = null;
      }
      if (this.deleteBox)
      {
        this.stageContainer.removeChild(this.deleteBox);
        this.deleteBox = null;
      }
      this.selectedItems = [];
    }

    public function multiButtons():void
    {
      var _loc2_:* = undefined;
      var _loc1_:int = 0;
      while (_loc1_ < this.selectedItems.length)
      {
        _loc2_ = this.selectedItems[_loc1_];
        _loc2_.deleteButtons();
        _loc2_.addGlow(65535);
        _loc2_.startMultiDrag();
        _loc1_++;
      }
      this.multiSelecting = true;
    }

    public function createMultiBoxes():void
    {
      if (this.selectedItems.length < 2)
      {
        return;
      }
      var _loc1_:int = 0;
      var _loc2_:int = 0;
      var _loc3_:Boolean = false;
      var _loc4_:int = 0;
      while (_loc4_ < this.selectedItems.length)
      {
        if (this.selectedItems[_loc4_].mandetory)
        {
          _loc3_ = true;
        }
        if (_loc4_ == 0)
        {
          _loc1_ = this.selectedItems[_loc4_].x + this.selectedItems[_loc4_].width;
          _loc2_ = int(this.selectedItems[_loc4_].y);
        }
        else
        {
          if (this.selectedItems[_loc4_].x + this.selectedItems[_loc4_].width > _loc1_)
          {
            _loc1_ = this.selectedItems[_loc4_].x + this.selectedItems[_loc4_].width;
          }
          if (this.selectedItems[_loc4_].y < _loc2_)
          {
            _loc2_ = int(this.selectedItems[_loc4_].y);
          }
        }
        _loc4_++;
      }
      if (_loc3_)
      {
        if (this.deleteBox)
        {
          this.stageContainer.removeChild(this.deleteBox);
          this.deleteBox = null;
        }
      }
      if (this.arrangeDownBox == null)
      {
        this.arrangeDownBox = new depthDownBox();
        this.stageContainer.addChild(this.arrangeDownBox);
      }
      if (this.arrangeUpBox == null)
      {
        this.arrangeUpBox = new depthUpBox();
        this.stageContainer.addChild(this.arrangeUpBox);
      }
      if (this.deleteBox == null)
      {
        if (!_loc3_)
        {
          this.deleteBox = new binBox();
          this.stageContainer.addChild(this.deleteBox);
        }
      }
      this.arrangeDownBox.x = _loc1_ - this.arrangeDownBox.width;
      this.arrangeDownBox.y = _loc2_ - this.arrangeDownBox.height - 5;
      this.arrangeUpBox.x = this.arrangeDownBox.x;
      this.arrangeUpBox.y = this.arrangeDownBox.y - this.arrangeUpBox.height - 5;
      if (!_loc3_)
      {
        this.deleteBox.x = this.arrangeDownBox.x - this.deleteBox.width - 5;
        this.deleteBox.y = this.arrangeUpBox.y;
      }
      this.arrangeDownBox.addEventListener(MouseEvent.MOUSE_DOWN, this.parameterEdit);
      this.arrangeUpBox.addEventListener(MouseEvent.MOUSE_DOWN, this.parameterEdit);
      if (!_loc3_)
      {
        this.deleteBox.addEventListener(MouseEvent.MOUSE_DOWN, this.parameterEdit);
      }
    }

    protected function parameterEdit(param1:MouseEvent):void
    {
      var _loc2_:int = 0;
      if (param1.currentTarget == this.arrangeUpBox)
      {
        _loc2_ = 0;
        while (_loc2_ < this.selectedItems.length)
        {
          this.selectedItems[_loc2_].arrange("up");
          _loc2_++;
        }
      }
      else if (param1.currentTarget == this.arrangeDownBox)
      {
        _loc2_ = 0;
        while (_loc2_ < this.selectedItems.length)
        {
          this.selectedItems[_loc2_].arrange("down");
          _loc2_++;
        }
      }
      else if (param1.currentTarget == this.deleteBox)
      {
        _loc2_ = 0;
        while (_loc2_ < this.selectedItems.length)
        {
          this.selectedItems[_loc2_].remove();
          _loc2_++;
        }
        this.deselectAll();
      }
    }

    public function stopDragAll():void
    {
      var _loc2_:* = undefined;
      var _loc1_:int = 0;
      while (_loc1_ < this.stageContainer.numChildren)
      {
        _loc2_ = this.stageContainer.getChildAt(_loc1_);
        if ("stopDrag" in _loc2_)
        {
          _loc2_.stopDrag();
        }
        if ("stopMultiDrag" in _loc2_)
        {
          _loc2_.stopMultiDrag();
        }
        _loc1_++;
      }
      this.multiSelecting = false;
    }

    private function addMouseListeners():void
    {
      this.stageContainer.dragPlain.addEventListener(MouseEvent.MOUSE_DOWN, this.dragStage, false, 0, true);
      this.stageContainer.dragPlain.addEventListener(MouseEvent.MOUSE_UP, this.releaseStage, false, 0, true);
      this.testStage.addEventListener(MouseEvent.MOUSE_DOWN, this.menuButtonPress, false, 0, true);
      this.testStage.addEventListener(MouseEvent.MOUSE_OVER, this.menuButtonOver, false, 0, true);
      this.testStage.addEventListener(MouseEvent.MOUSE_OUT, this.menuButtonOut, false, 0, true);
      this.itemsnext.addEventListener(MouseEvent.MOUSE_DOWN, this.menuButtonPress, false, 0, true);
      this.itemsprev.addEventListener(MouseEvent.MOUSE_DOWN, this.menuButtonPress, false, 0, true);
      this.optionsButton.addEventListener(MouseEvent.MOUSE_DOWN, this.menuButtonPress, false, 0, true);
      this.optionsButton.addEventListener(MouseEvent.MOUSE_OVER, this.menuButtonOver, false, 0, true);
      this.optionsButton.addEventListener(MouseEvent.MOUSE_OUT, this.menuButtonOut, false, 0, true);
      this.saveButton.addEventListener(MouseEvent.MOUSE_DOWN, this.menuButtonPress, false, 0, true);
      this.saveButton.addEventListener(MouseEvent.MOUSE_OVER, this.menuButtonOver, false, 0, true);
      this.saveButton.addEventListener(MouseEvent.MOUSE_OUT, this.menuButtonOut, false, 0, true);
      this.quitButton.addEventListener(MouseEvent.MOUSE_DOWN, this.menuButtonPress, false, 0, true);
      this.quitButton.addEventListener(MouseEvent.MOUSE_OVER, this.menuButtonOver, false, 0, true);
      this.quitButton.addEventListener(MouseEvent.MOUSE_OUT, this.menuButtonOut, false, 0, true);
      this.tutorialButton.addEventListener(MouseEvent.MOUSE_DOWN, this.menuButtonPress, false, 0, true);
      this.tutorialButton.addEventListener(MouseEvent.MOUSE_OVER, this.menuButtonOver, false, 0, true);
      this.tutorialButton.addEventListener(MouseEvent.MOUSE_OUT, this.menuButtonOut, false, 0, true);
    }

    private function menuButtonOver(param1:MouseEvent):void
    {
      this.menuPointerDest.x = param1.currentTarget.x + param1.currentTarget.width * 0.5;
      if (param1.currentTarget == this.testStage)
      {
        this.menuPointer.Name.text = "Test Stage";
        this.menuPointerDest.x = param1.currentTarget.x + param1.currentTarget.width * 0.5 + 20;
      }
      if (param1.currentTarget == this.optionsButton)
      {
        this.menuPointer.Name.text = "Options";
      }
      if (param1.currentTarget == this.saveButton)
      {
        this.menuPointer.Name.text = "Save Stage";
      }
      if (param1.currentTarget == this.quitButton)
      {
        this.menuPointer.Name.text = "Quit";
      }
      if (param1.currentTarget == this.tutorialButton)
      {
        this.menuPointer.Name.text = "Help/Tips";
      }
      this.rolledOver = true;
    }

    private function menuButtonOut(param1:MouseEvent):void
    {
      this.rolledOver = false;
      this.itemDescTimer = 0;
    }

    private function menuButtonPress(param1:MouseEvent):void
    {
      if (param1.currentTarget == this.testStage)
      {
        this.getLocalStage();
        this.main.levelComplete(4);
        this.main.levelDestination = 13;
      }
      else if (param1.currentTarget == this.optionsButton)
      {
        this.main.createWindow("optionsSb");
      }
      else if (param1.currentTarget == this.saveButton)
      {
        this.saveStage();
      }
      else if (param1.currentTarget == this.quitButton)
      {
        this.main.createWindow("quitStage");
      }
      else if (param1.currentTarget == this.tutorialButton)
      {
        this.main.createWindow("tutorial");
      }
      else if (param1.currentTarget == this.itemsprev)
      {
        this.itemSliderPos -= this.itemSliderMax;
        this.itemsnext.visible = true;
        if (this.itemSliderPos < 0)
        {
          this.itemSliderPos = 0;
          this.itemsprev.visible = false;
        }
      }
      else if (param1.currentTarget == this.itemsnext)
      {
        this.itemSliderPos += this.itemSliderMax;
        this.itemsprev.visible = true;
        if (this.itemSliderPos >= this.itemsSpawned - (this.itemSliderMax - 1))
        {
          this.itemSliderPos = this.itemsSpawned - (this.itemSliderMax - 1);
          this.itemsnext.visible = false;
        }
      }
    }

    private function dragStage(param1:MouseEvent):void
    {
      if (this.main.window)
      {
        return;
      }
      if (!param1.shiftKey)
      {
        this.deselectAll();
      }
      this.stageContainer.startDrag(false, new Rectangle(-2000, -2000, 4000 - 640, 4000 - 560));
    }

    private function releaseStage(param1:MouseEvent):void
    {
      if (this.main.window)
      {
        return;
      }
      this.stageContainer.stopDrag();
      this.stageContainer.x = int(this.stageContainer.x);
      this.stageContainer.y = int(this.stageContainer.y);
      this.stageContainer.dragPlain.x = -this.stageContainer.x;
      this.stageContainer.dragPlain.y = -this.stageContainer.y;
    }

    public function updateLimit():void
    {
      this.itemCount.text = this.itemsAdded.length + "/" + this.itemMax;
    }

    private function getLocalStage():void
    {
      this.main.localMap = this.createCode();
    }

    private function duplicateItem():void
    {
      var _loc2_:String = null;
      var _loc3_:String = null;
      var _loc4_:Class = null;
      var _loc5_:* = undefined;
      this.cHold = true;
      var _loc1_:int = 0;
      while (_loc1_ < this.selectedItems.length)
      {
        if (this.itemsAdded.length >= this.itemMax)
        {
          break;
        }
        if (!this.selectedItems[_loc1_].mandetory)
        {
          _loc2_ = String(this.selectedItems[_loc1_]);
          _loc3_ = _loc2_.substr(8, _loc2_.length - 9);
          _loc4_ = getDefinitionByName(_loc3_) as Class;
          _loc5_ = new _loc4_();
          _loc5_.rotation = this.selectedItems[_loc1_].rotation;
          this.selectedItems[_loc1_].rotation = 0;
          _loc5_.x = this.selectedItems[_loc1_].x + this.selectedItems[_loc1_].width;
          this.selectedItems[_loc1_].rotation = _loc5_.rotation;
          _loc5_.y = this.selectedItems[_loc1_].y;
          _loc5_.width = this.selectedItems[_loc1_].width;
          _loc5_.height = this.selectedItems[_loc1_].height;
          this.stageContainer.addChild(_loc5_);
          this.updateLimit();
        }
        _loc1_++;
      }
    }

    private function findItemCode(param1:Object):int
    {
      if (param1 is sbBasicBlock)
      {
        if (param1 is sbFallingBlock)
        {
          return 3;
        }
        if (param1 is sbBounceBlock)
        {
          return 8;
        }
        if (param1 is sbVerticalDownBlock)
        {
          return 9;
        }
        if (param1 is sbVerticalUpBlock)
        {
          return 10;
        }
        if (param1 is sbHorizontalBlock)
        {
          return 11;
        }
        if (param1 is sbIceBlock)
        {
          return 13;
        }
        if (param1 is sbLockBlock)
        {
          return 14;
        }
        if (param1 is sbPushBlock)
        {
          return 15;
        }
        if (param1 is sbEnlargingBlock)
        {
          return 16;
        }
        if (param1 is sbSolarBlock)
        {
          return 17;
        }
        if (param1 is sbInvisBlock)
        {
          return 18;
        }
        if (param1 is sbSwimmingPool)
        {
          return 4;
        }
        if (param1 is sbMicrowave)
        {
          return 42;
        }
        if (param1 is sbWiredBlock)
        {
          return 45;
        }
        return 0;
      }
      if (param1 is sbLeftSlope)
      {
        if (param1 is sbRightSlope)
        {
          return 2;
        }
        return 1;
      }
      if (param1 is sbCheckpoint)
      {
        return 5;
      }
      if (param1 is sbSpike)
      {
        if (param1 is sbSpikex10)
        {
          return 7;
        }
        if (param1 is sbSurpriseSpike)
        {
          return 19;
        }
        if (param1 is sbClosingSpikes)
        {
          return 25;
        }
        if (param1 is sbRotatingBuzzsaw)
        {
          return 27;
        }
        if (param1 is sbBreatheBlaster)
        {
          return 31;
        }
        if (param1 is sbSmWindBlaster)
        {
          return 32;
        }
        if (param1 is sbWindBlaster)
        {
          return 33;
        }
        return 6;
      }
      if (param1 is sbPendulum)
      {
        return 12;
      }
      if (param1 is sbBuzzsaw)
      {
        if (param1 is sbBouncingBuzzsaw)
        {
          return 24;
        }
        if (param1 is sbEnlargingBuzzsaw)
        {
          return 43;
        }
        return 20;
      }
      if (param1 is sbShurikanSpawner)
      {
        return 21;
      }
      if (param1 is sbQuadrant)
      {
        return 22;
      }
      if (param1 is sbScythe)
      {
        return 23;
      }
      if (param1 is sbLaser)
      {
        return 26;
      }
      if (param1 is sbGravityDownLever)
      {
        return 41;
      }
      if (param1 is sbGravityUpLever)
      {
        return 28;
      }
      if (param1 is sbSpeedUpLever)
      {
        return 38;
      }
      if (param1 is sbPole)
      {
        return 29;
      }
      if (param1 is sbCannon)
      {
        return 30;
      }
      if (param1 is sbTeleporter)
      {
        return 34;
      }
      if (param1 is sbTeleporterReceiver)
      {
        return 35;
      }
      if (param1 is sbKey)
      {
        return 36;
      }
      if (param1 is sbLightSwitch)
      {
        return 39;
      }
      if (param1 is sbPulley)
      {
        return 40;
      }
      if (param1 is sbClassicLaser)
      {
        return 44;
      }
      if (param1 is sbPoleQuadrant)
      {
        return 46;
      }
      return 0;
    }

    public function createCode():Array
    {
      var _loc3_:Object = null;
      var _loc1_:Array = [];
      _loc1_.push("px", this.itemsAdded[0].x, "py", this.itemsAdded[0].y, "goalx", this.itemsAdded[1].x, "goaly", this.itemsAdded[1].y);
      var _loc2_:int = 2;
      while (_loc2_ < this.itemsAdded.length)
      {
        _loc3_ = this.itemsAdded[_loc2_];
        _loc1_.push("\nid", this.findItemCode(_loc3_));
        _loc1_.push("x", _loc3_.x, "y", _loc3_.y);
        var _savedRotation:Number = _loc3_.rotation;
        _loc3_.rotation = 0;
        if (_loc3_.editWidth)
        {
          _loc1_.push("w", _loc3_.width);
        }
        if (_loc3_.editHeight)
        {
          _loc1_.push("h", _loc3_.height);
        }
        _loc3_.rotation = _savedRotation;
        if (_loc3_.editRotation)
        {
          _loc1_.push("r", _loc3_.rotation);
        }
        _loc2_++;
      }
      if (this.attachmentsOn)
      {
        _loc1_.push("\nattachmentsOn", 1);
      }
      else
      {
        _loc1_.push("\nattachmentsOn", 0);
      }
      if (this.snapOn)
      {
        _loc1_.push("\nsnapOn", 1);
      }
      else
      {
        _loc1_.push("\nsnapOn", 0);
      }
      _loc1_.push("\nguideLines", this.guideLines, "\n");
      return _loc1_;
    }

    private function saveStage():void
    {
      if (this.main.stageSelected < 5)
      {
        if (!this.main.savedStages[this.main.stageSelected])
        {
          this.main.savedStages[this.main.stageSelected] = true;
          this.main.createWindow("nameStage");
        }
        else
        {
          this.main.savedStages[this.main.stageSelected] = this.createCode();
          this.saveButton.play();
          trace("Stage successfully saved");
        }
      }
      else
      {
        this.saveButton.gotoAndPlay("error");
      }
      this.main.saveGame();
    }

    private function keyPressed(param1:KeyboardEvent):*
    {
      var _loc2_:* = param1.keyCode;
      if (_loc2_ == 67)
      {
        this.cDown = true;
      }
      if (_loc2_ == 38)
      {
        this.wDown = true;
      }
      if (_loc2_ == 37)
      {
        this.aDown = true;
      }
      if (_loc2_ == 40)
      {
        this.sDown = true;
      }
      if (_loc2_ == 39)
      {
        this.dDown = true;
      }
    }

    private function keyReleased(param1:KeyboardEvent):*
    {
      var _loc2_:* = param1.keyCode;
      if (_loc2_ == 67)
      {
        this.cDown = false;
        this.cHold = false;
      }
      if (_loc2_ == 38)
      {
        this.wDown = false;
        this.wHold = false;
      }
      if (_loc2_ == 37)
      {
        this.aDown = false;
        this.aHold = false;
      }
      if (_loc2_ == 40)
      {
        this.sDown = false;
        this.sHold = false;
      }
      if (_loc2_ == 39)
      {
        this.dDown = false;
        this.dHold = false;
      }
    }
  }
}
