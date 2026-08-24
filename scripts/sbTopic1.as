package
{
  import flash.display.MovieClip;
  import flash.events.MouseEvent;
  import flash.system.System;
  import flash.text.TextField;

  [Embed(source="/_assets/assets.swf", symbol="symbol967")]
  public class sbTopic1 extends button
  {

    public var clipboardInfo:MovieClip;

    public function sbTopic1()
    {
      super();
      addFrameScript(0, this.frame1);
    }

    override protected function click(param1:MouseEvent):void
    {
      var _loc2_:int = 0;
      var _loc3_:* = undefined;
      var _loc4_:TextField = null;
      var _loc5_:* = undefined;
      if (!selected)
      {
        _loc2_ = 0;
        while (_loc2_ < parent.numChildren)
        {
          _loc3_ = parent.getChildAt(_loc2_);
          if (_loc3_ is sbTopic1)
          {
            _loc3_.selected = false;
            adjustColour.colourChange(_loc3_.buttonBG, 0, 0, 0, 0);
          }
          _loc2_++;
        }
        selected = true;
        adjustColour.colourChange(buttonBG, -150, 0, 75, 0);
        gravity = 2.5;
        y -= gravity;
        if (this is buildStageButton)
        {
          // TODO where level loaded in stage builder!!!
          _loc4_ = MovieClip(parent).inputStageCode;
          if (_loc4_.length == 0)
          {
            adjustColour.colourChange(buttonBG, 0, 0, 0, 0);
            return;
          }
          main.localMap = _loc4_.text.split(",").filter(main.fm);

          _loc2_ = 0;
          while (_loc2_ < main.localMap.length)
          {
            main.localMap[_loc2_] = int(main.localMap[_loc2_]);
            _loc2_++;
          }
          main.levelComplete(4);
          main.levelDestination = 13;
          main.stageSelected = main.savedStages.length;
          return;
        }
        if (this is playStageButton)
        {
          main.levelComplete(4);
          main.levelDestination = 13;
          main.localMap = main.savedStages[main.stageSelected];
          return;
        }
        if (this is editStageButton)
        {
          main.levelComplete(5);
          main.localMap = main.savedStages[main.stageSelected];
          return;
        }
        if (this is shareStageButton)
        {
          main.localMap = main.savedStages[main.stageSelected];
          System.setClipboard(String(main.localMap));
          this.clipboardInfo.visible = true;
          return;
        }
        if (this is deleteStageButton)
        {
          main.savedStages.splice(main.stageSelected, 1);
          main.savedStagesNames.splice(main.stageSelected, 1);
          _loc5_ = MovieClip(parent);
          _loc2_ = 0;
          while (_loc2_ < _loc5_.stageButtons.length)
          {
            _loc5_.removeChild(_loc5_.stageButtons[_loc2_]);
            _loc5_.stageButtons[_loc2_].removeListeners();
            _loc5_.stageButtons.splice(_loc2_, 1);
            _loc2_--;
            _loc2_++;
          }
          _loc5_.stageButtons = [];
          _loc5_.createStageButtons();
          return;
        }
        if (this is sbTopic1)
        {
          MovieClip(parent).tutorials.gotoAndStop(2);
        }
        if (this is sbTopic2)
        {
          MovieClip(parent).tutorials.gotoAndStop(3);
        }
        if (this is sbTopic3)
        {
          MovieClip(parent).tutorials.gotoAndStop(4);
        }
        if (this is sbTopic4)
        {
          MovieClip(parent).tutorials.gotoAndStop(5);
        }
        if (this is sbTopic5)
        {
          MovieClip(parent).tutorials.gotoAndStop(6);
        }
      }
    }

    internal function frame1():*
    {
      stop();
    }
  }
}
