package
{
  import flash.display.MovieClip;
  import flash.events.Event;
  import flash.events.MouseEvent;
  import flash.filters.GlowFilter;
  import flash.geom.Point;
  import flash.geom.Rectangle;
  import flash.text.*;

  public class sbItem extends MovieClip
  {

    public var arrayIndex:int;

    protected var heightDragging:Boolean = false;

    protected var widthDragging:Boolean = false;

    public var selected:Boolean = false;

    protected var glow:GlowFilter;

    protected var innerGlow:GlowFilter;

    protected var distanceFromMouse:Point;

    protected var dragging:Boolean = false;

    public var centered:Boolean = false;

    public var editWidth:int = 4000;

    public var editHeight:int = 4000;

    public var editRotation:int = 1;

    public var mandetory:Boolean = false;

    public var main:MovieClip = null;

    public var stageBuilder:MovieClip = null;

    public var widthText:TextField = null;

    public var heightText:TextField = null;

    public var className:Class;

    public var widthPlusBox:MovieClip = null;

    public var heightPlusBox:MovieClip = null;

    public var deleteBox:MovieClip = null;

    public var rotateBox:MovieClip = null;

    public var arrangeUpBox:MovieClip = null;

    public var arrangeDownBox:MovieClip = null;

    public function sbItem()
    {
      super();
      addEventListener(Event.ADDED_TO_STAGE, this.init, false, 0, true);
    }

    protected function init(param1:Event):void
    {
      this.main = MovieClip(root);
      this.stageBuilder = MovieClip(parent.parent);
      if (parent.name == "stageContainer")
      {
        this.snapToGuide();
        this.arrayIndex = this.stageBuilder.itemsAdded.length;
        this.stageBuilder.itemsAdded.push(this);
        if (!(this is sbPlayerStart) && !(this is sbFinishPortal))
        {
          this.stageBuilder.deselectAll();
          this.selected = true;
          this.stageBuilder.selectedItems.push(this);
          if (this.stageBuilder.selectedItems.length == 1)
          {
            this.addGlow();
            this.createButtons();
          }
        }
      }
      this.roundParameters();
      this.addMouseListeners();
    }

    public function update():void
    {
      if (this.dragging)
      {
        this.getMultiDrag();
      }
      if (this.heightDragging || this.widthDragging)
      {
        this.getScaling();
      }
      this.roundParameters();
      this.alignBoxes();
    }

    protected function getScaling():void
    {
      var _loc1_:Point = new Point(stage.mouseX - parent.x, stage.mouseY - parent.y);
      if (this.heightDragging)
      {
        height = _loc1_.y - y;
        if (height < 40)
        {
          height = 40;
        }
        if (height > this.editHeight)
        {
          height = this.editHeight;
        }
        height = additionalMaths.roundToNumber(height, 10);
        this.roundParameters();
        if (height < 60)
        {
          this.heightText.visible = false;
        }
        else
        {
          this.heightText.visible = true;
        }
        this.heightText.text = String(height);
      }
      if (this.widthDragging)
      {
        if (!this.editHeight)
        {
          width = _loc1_.x - x - 5;
          if (this.centered)
          {
            width = _loc1_.x - x + width * 0.5 - 5;
          }
        }
        else
        {
          width = _loc1_.x - x;
        }
        if (width < 40)
        {
          width = 40;
        }
        if (width > this.editWidth)
        {
          width = this.editWidth;
        }
        width = additionalMaths.roundToNumber(width, 10);
        this.roundParameters();
        if (width < 60)
        {
          this.widthText.visible = false;
        }
        else
        {
          this.widthText.visible = true;
        }
        this.widthText.text = String(width);
        if (!this.editHeight)
        {
          height = width;
        }
      }
      this.roundParameters();
    }

    protected function alignBoxes():void
    {
      if (!this.centered)
      {
        if (this.widthText)
        {
          this.widthText.x = x;
          this.widthText.width = width;
          this.widthText.y = y + height + 5;
        }
        if (this.heightText)
        {
          this.heightText.x = x + width + 5;
          this.heightText.y = y + height * 0.5 - 10;
        }
        if (this.widthPlusBox)
        {
          this.widthPlusBox.x = x + width - this.widthPlusBox.width;
          this.widthPlusBox.y = y + height + 5;
          if (!this.editHeight)
          {
            this.widthPlusBox.x = x + width + 5;
          }
        }
        if (this.heightPlusBox)
        {
          this.heightPlusBox.x = x + width + 5;
          this.heightPlusBox.y = y + height - this.heightPlusBox.height;
        }
        if (this.arrangeDownBox)
        {
          this.arrangeDownBox.x = x + width - this.arrangeDownBox.width;
          this.arrangeDownBox.y = y - 5 - this.arrangeDownBox.height;
        }
        if (this.arrangeUpBox)
        {
          this.arrangeUpBox.x = (this.arrangeDownBox ? this.arrangeDownBox.x : 0);
          this.arrangeUpBox.y = (this.arrangeDownBox ? this.arrangeDownBox.y : 0) - 4 - this.arrangeUpBox.height;
        }
        if (this.deleteBox)
        {
          this.deleteBox.x = (this.arrangeDownBox ? this.arrangeDownBox.x : 0) - 5 - this.deleteBox.width;
          this.deleteBox.y = (this.arrangeUpBox ? this.arrangeUpBox.y : 0);
        }
        if (this.rotateBox)
        {
          this.rotateBox.x = (this.deleteBox ? this.deleteBox.x : 0) - 5 - this.rotateBox.width;
          this.rotateBox.y = (this.arrangeUpBox ? this.arrangeUpBox.y : 0);
        }
      }
      else
      {
        if (this.widthText)
        {
          this.widthText.x = x - width * 0.5;
          this.widthText.width = width;
          this.widthText.y = y + height * 0.5 + 5;
        }
        if (this.heightText)
        {
          this.heightText.x = x + width * 0.5 + 5;
          this.heightText.y = y - 10;
        }
        if (this.widthPlusBox)
        {
          this.widthPlusBox.y = y + height * 0.5 + 5;
          if (!this.editHeight)
          {
            this.widthPlusBox.x = x + width * 0.5 + 5;
          }
        }
        if (this.arrangeDownBox)
        {
          this.arrangeDownBox.x = x + width * 0.5 - this.arrangeDownBox.width;
          this.arrangeDownBox.y = y - 5 - height * 0.5 - this.arrangeDownBox.height;
        }
        if (this.arrangeUpBox)
        {
          this.arrangeUpBox.x = (this.arrangeDownBox ? this.arrangeDownBox.x : 0);
          this.arrangeUpBox.y = (this.arrangeDownBox ? this.arrangeDownBox.y : 0) - 4 - this.arrangeUpBox.height;
        }
        if (this.deleteBox)
        {
          this.deleteBox.x = (this.arrangeDownBox ? this.arrangeDownBox.x : 0) - 5 - this.deleteBox.width;
          this.deleteBox.y = (this.arrangeUpBox ? this.arrangeUpBox.y : 0);
        }
        if (this.rotateBox)
        {
          this.rotateBox.x = (this.deleteBox ? this.deleteBox.x : 0) - 5 - this.rotateBox.width;
          this.rotateBox.y = (this.arrangeUpBox ? this.arrangeUpBox.y : 0);
        }
      }
    }

    protected function getMultiDrag():void
    {
      x = stage.mouseX + this.distanceFromMouse.x;
      y = stage.mouseY + this.distanceFromMouse.y;
    }

    public function startMultiDrag():void
    {
      this.dragging = true;
      this.distanceFromMouse = new Point(x - stage.mouseX, y - stage.mouseY);
    }

    public function stopMultiDrag():void
    {
      this.dragging = false;
    }

    private function addMouseListeners():void
    {
      addEventListener(MouseEvent.MOUSE_OVER, this.rollOver, false, 0, true);
      addEventListener(MouseEvent.MOUSE_OUT, this.rollOut, false, 0, true);
      addEventListener(MouseEvent.MOUSE_DOWN, this.select, false, 0, true);
      addEventListener(MouseEvent.MOUSE_UP, this.release, false, 0, true);
    }

    protected function rollOver(param1:MouseEvent):void
    {
      if (this.main.window)
      {
        return;
      }
      if (parent is stageBuilderGUI)
      {
        return;
      }
      if (!this.selected)
      {
        this.addGlow(16763904);
      }
    }

    protected function rollOut(param1:MouseEvent):void
    {
      if (this.main.window)
      {
        return;
      }
      if (parent is stageBuilderGUI)
      {
        return;
      }
      if (!this.selected)
      {
        this.deselect();
      }
    }

    protected function select(param1:MouseEvent):void
    {
      var _loc2_:int = 0;
      if (this.main.window)
      {
        return;
      }
      if (!this.selected)
      {
        if (!param1.shiftKey)
        {
          this.stageBuilder.deselectAll();
        }
        this.selected = true;
        this.stageBuilder.selectedItems.push(this);
        if (this.stageBuilder.selectedItems.length == 1)
        {
          this.addGlow();
          this.createButtons();
          startDrag(false, new Rectangle(-2000, -2000, 4000, 4000));
        }
        else
        {
          this.stageBuilder.multiButtons();
        }
      }
      else if (this.stageBuilder.selectedItems.length == 1)
      {
        startDrag(false, new Rectangle(-2000, -2000, 4000, 4000));
      }
      else
      {
        if (param1.ctrlKey)
        {
          _loc2_ = 0;
          while (_loc2_ < this.stageBuilder.selectedItems.length)
          {
            if (this.stageBuilder.selectedItems[_loc2_] == this)
            {
              trace(_loc2_);
              this.stageBuilder.selectedItems.splice(_loc2_, 1);
              break;
            }
            _loc2_++;
          }
          if (this.stageBuilder.selectedItems.length == 1)
          {
            this.stageBuilder.deselectAll();
          }
          else
          {
            this.deselect();
            this.stageBuilder.createMultiBoxes();
          }
          return;
        }
        startDrag(false, new Rectangle(-2000, -2000, 4000, 4000));
        this.stageBuilder.multiButtons();
      }
    }

    protected function release(param1:MouseEvent):void
    {
      var _loc2_:MovieClip = null;
      var _loc3_:MovieClip = null;
      if (this.main.window)
      {
        return;
      }
      if (parent is stageBuilderGUI)
      {
        if (stage.mouseY >= 510)
        {
          parent.removeChild(this);
          return;
        }
        _loc2_ = new this.className();
        _loc2_.x = x - MovieClip(parent).stageContainer.x;
        _loc2_.y = y - MovieClip(parent).stageContainer.y;
        MovieClip(parent).stageContainer.addChild(_loc2_);
        if (this is sbTeleporter)
        {
          _loc3_ = new sbTeleporterReceiver();
          _loc3_.x = x - MovieClip(parent).stageContainer.x + 150;
          _loc3_.y = y - MovieClip(parent).stageContainer.y;
          MovieClip(parent).stageContainer.addChild(_loc3_);
        }
        MovieClip(parent).updateLimit();
        parent.removeChild(this);
        return;
      }
      if (this.stageBuilder.selectedItems.length == 1)
      {
        stopDrag();
        x = int(x);
        y = int(y);
        this.snapToGuide();
      }
      else if (this.selected)
      {
        this.stageBuilder.stopDragAll();
      }
    }

    public function deselect():void
    {
      this.selected = false;
      this.dragging = false;
      filters = [];
      this.deleteButtons();
    }

    public function addGlow(param1:uint = 65280, param2:uint = 0):void
    {
      if (!param2)
      {
        param2 = param1;
      }
      this.glow = new GlowFilter(param1);
      this.innerGlow = new GlowFilter(param2, 0.5, 12, 12, 2, 1, true);
      filters = [this.glow, this.innerGlow];
    }

    protected function createButtons():void
    {
      this.editRotation = 5;
      this.editHeight = 4000;
      this.editWidth = 4000;
      if (this.editWidth)
      {
        this.createWidth();
      }
      if (this.editHeight)
      {
        this.createHeight();
      }
      if (this.editRotation)
      {
        this.createRotation();
      }
      this.createDepth();
      if (!this.mandetory)
      {
        this.createDelete();
      }
    }

    public function deleteButtons():void
    {
      if (this.widthText)
      {
        parent.removeChild(this.widthText);
        this.widthText = null;
      }
      if (this.heightText)
      {
        parent.removeChild(this.heightText);
        this.heightText = null;
      }
      if (this.widthPlusBox)
      {
        parent.removeChild(this.widthPlusBox);
        this.widthPlusBox = null;
      }
      if (this.heightPlusBox)
      {
        parent.removeChild(this.heightPlusBox);
        this.heightPlusBox = null;
      }
      if (this.arrangeUpBox)
      {
        parent.removeChild(this.arrangeUpBox);
        this.arrangeUpBox = null;
      }
      if (this.arrangeDownBox)
      {
        parent.removeChild(this.arrangeDownBox);
        this.arrangeDownBox = null;
      }
      if (this.deleteBox)
      {
        parent.removeChild(this.deleteBox);
        this.deleteBox = null;
      }
      if (this.rotateBox)
      {
        parent.removeChild(this.rotateBox);
        this.rotateBox = null;
      }
    }

    protected function createDepth():void
    {
      this.arrangeDownBox = new depthDownBox();
      this.arrangeDownBox.x = x + width - this.arrangeDownBox.width;
      this.arrangeDownBox.y = y - this.arrangeDownBox.height - 5;
      parent.addChild(this.arrangeDownBox);
      this.arrangeDownBox.addEventListener(MouseEvent.MOUSE_DOWN, this.parameterEdit);
      this.arrangeUpBox = new depthUpBox();
      this.arrangeUpBox.x = this.arrangeDownBox.x;
      this.arrangeUpBox.y = this.arrangeDownBox.y - 4 - this.arrangeUpBox.height;
      parent.addChild(this.arrangeUpBox);
      this.arrangeUpBox.addEventListener(MouseEvent.MOUSE_DOWN, this.parameterEdit);
    }

    protected function createDelete():void
    {
      this.deleteBox = new binBox();
      this.deleteBox.x = this.arrangeUpBox.x - this.deleteBox.width - 5;
      this.deleteBox.y = this.arrangeUpBox.y;
      parent.addChild(this.deleteBox);
      this.deleteBox.addEventListener(MouseEvent.MOUSE_DOWN, this.parameterEdit);
    }

    protected function createWidth():void
    {
      this.widthText = new TextField();
      var _loc1_:* = new MarketDeco();
      var _loc2_:TextFormat = new TextFormat();
      _loc2_.size = 16;
      _loc2_.align = TextFormatAlign.CENTER;
      _loc2_.font = _loc1_.fontName;
      this.widthText = new TextField();
      this.widthText.defaultTextFormat = _loc2_;
      parent.addChild(this.widthText);
      this.widthText.text = String(width.toFixed(0));
      this.widthText.textColor = 3355443;
      this.widthText.embedFonts = true;
      this.widthText.antiAliasType = AntiAliasType.ADVANCED;
      this.widthText.width = width;
      this.widthText.height = 24;
      this.widthText.x = x;
      this.widthText.y = y + height + 5;
      this.widthText.wordWrap = true;
      this.widthText.selectable = false;
      this.widthText.blendMode = "invert";
      if (width < 60)
      {
        this.widthText.visible = false;
      }
      if (this.editHeight)
      {
        this.widthPlusBox = new plusBox();
        this.widthPlusBox.x = x + width - this.widthPlusBox.width;
      }
      else
      {
        this.widthPlusBox = new multiBox();
        this.widthPlusBox.x = x + width + 5;
      }
      this.widthPlusBox.y = y + height + 5;
      parent.addChild(this.widthPlusBox);
      this.widthPlusBox.addEventListener(MouseEvent.MOUSE_DOWN, this.parameterEdit);
      stage.addEventListener(MouseEvent.MOUSE_UP, this.stopParameterDrag);
    }

    protected function createHeight():void
    {
      this.heightText = new TextField();
      var _loc1_:* = new MarketDeco();
      var _loc2_:TextFormat = new TextFormat();
      _loc2_.size = 16;
      _loc2_.align = TextFormatAlign.LEFT;
      _loc2_.font = _loc1_.fontName;
      this.heightText = new TextField();
      this.heightText.defaultTextFormat = _loc2_;
      parent.addChild(this.heightText);
      this.heightText.text = String(height.toFixed(0));
      this.heightText.textColor = 3355443;
      this.heightText.embedFonts = true;
      this.heightText.antiAliasType = AntiAliasType.ADVANCED;
      this.heightText.width = 100;
      this.heightText.height = 24;
      this.heightText.x = x + width + 5;
      this.heightText.y = y + height * 0.5 - 10;
      this.heightText.wordWrap = true;
      this.heightText.selectable = false;
      this.heightText.blendMode = "invert";
      if (height < 60)
      {
        this.heightText.visible = false;
      }
      this.heightPlusBox = new minusBox();
      this.heightPlusBox.x = x + width + 5;
      this.heightPlusBox.y = y + height - this.heightPlusBox.height;
      parent.addChild(this.heightPlusBox);
      this.heightPlusBox.addEventListener(MouseEvent.MOUSE_DOWN, this.parameterEdit);
      stage.addEventListener(MouseEvent.MOUSE_UP, this.stopParameterDrag);
    }

    protected function createRotation():void
    {
      this.rotateBox = new rBox();
      parent.addChild(this.rotateBox);
      this.rotateBox.addEventListener(MouseEvent.MOUSE_DOWN, this.parameterEdit);
    }

    protected function parameterEdit(param1:MouseEvent):void
    {
      if (this.main.window)
      {
        return;
      }
      if (param1.currentTarget == this.widthPlusBox)
      {
        this.widthDragging = true;
      }
      else if (param1.currentTarget == this.heightPlusBox)
      {
        this.heightDragging = true;
      }
      else if (param1.currentTarget == this.arrangeUpBox)
      {
        this.arrange("up");
      }
      else if (param1.currentTarget == this.arrangeDownBox)
      {
        this.arrange("down");
      }
      else if (param1.currentTarget == this.deleteBox)
      {
        this.remove();
      }
      else if (param1.currentTarget == this.rotateBox)
      {
        rotation += this.editRotation;
        if (rotation >= 360)
        {
          rotation -= 360;
        }
        rotation = Math.round(rotation);
        rotation = int(rotation.toFixed(0));
      }
    }

    protected function stopParameterDrag(param1:MouseEvent):void
    {
      this.widthDragging = false;
      this.heightDragging = false;
    }

    public function arrange(param1:String = "down"):void
    {
      if (param1 == "down")
      {
        if (parent.getChildIndex(this) > 1)
        {
          parent.setChildIndex(this, parent.getChildIndex(this) - 1);
        }
      }
      else if (parent.getChildIndex(this) + 1 <= this.stageBuilder.itemsAdded.length)
      {
        parent.setChildIndex(this, parent.getChildIndex(this) + 1);
      }
    }

    private function snapToGuide():void
    {
      if (this.stageBuilder.snapOn)
      {
        trace(this.stageBuilder.guideLines);
        x = additionalMaths.roundToNumber(x, this.stageBuilder.guideLines);
        y = additionalMaths.roundToNumber(y, this.stageBuilder.guideLines);
      }
    }

    private function roundParameters():void
    {
      x = Math.round(x);
      x = int(x.toFixed(0));
      y = Math.round(y);
      y = int(y.toFixed(0));
      var _savedRotation:Number = rotation;
      rotation = 0;
      width = Math.round(width);
      width = int(width.toFixed(0));
      if (this.widthText)
      {
        this.widthText.text = width.toFixed(0);
      }
      height = Math.round(height);
      height = int(height.toFixed(0));
      rotation = _savedRotation;
      if (this.heightText)
      {
        this.heightText.text = height.toFixed(0);
      }
    }

    public function remove():void
    {
      this.deleteButtons();
      this.stageBuilder.itemsAdded.splice(this.arrayIndex, 1);
      var _loc1_:int = 0;
      while (_loc1_ < this.stageBuilder.itemsAdded.length)
      {
        if (this.stageBuilder.itemsAdded[_loc1_].arrayIndex > this.arrayIndex)
        {
          --this.stageBuilder.itemsAdded[_loc1_].arrayIndex;
        }
        _loc1_++;
      }
      this.stageBuilder.updateLimit();
      parent.removeChild(this);
    }
  }
}
