package
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.utils.*;
  import flash.external.ExternalInterface;

   [Embed(source="/_assets/assets.swf", symbol="symbol1219")]
   public class achievementsWindow extends MovieClip
   {

      public var main:MovieClip;

      public var achievementRanks:MovieClip;

      public var windowColour:MovieClip;

      public var closeButton:MovieClip;

      public var bnext:MovieClip;

      public var snext:MovieClip;

      public var gnext:MovieClip;

      public var bprev:MovieClip;

      public var sprev:MovieClip;

      public var gprev:MovieClip;

      public var bronzeText:TextField;

      public var silverText:TextField;

      public var goldText:TextField;

      public var percentComplete:TextField;

      public var displayAllText:TextField;

      public var displayAllButton:MovieClip;

      public var displayingAll:Boolean = true;

      private var bronzeCreated:int = 0;

      private var silverCreated:int = 0;

      private var goldCreated:int = 0;

      private var totalAchievements:int;

      private var bronzePos:int = 0;

      private var silverPos:int = 0;

      private var goldPos:int = 0;

      public function achievementsWindow()
      {
         super();
         addEventListener(Event.ADDED_TO_STAGE,this.init,false,0,true);
         this.totalAchievements = 1;
         while(["achievement" + this.totalAchievements] in achievementsLog)
         {
            ++this.totalAchievements;
         }
      }

      private function init(param1:Event) : void
      {
         this.hideAndColourButtons();
         this.mouseEvents();
         this.resetText();
         this.getDisplay();
         this.buildAchievements();
         if(!this.displayingAll)
         {
            this.displayAllButton.addEventListener(MouseEvent.CLICK,this.toggleDisplay,false,0,true);
         }
         filters = this.bronzeText.filters;
      }

      public function update() : void
      {
         additionalMaths.easeToPoint(this.achievementRanks.bronzeContainer,-(-15 + this.bronzePos * 65),17);
         additionalMaths.easeToPoint(this.achievementRanks.silverContainer,-(-15 + this.silverPos * 65),120);
         additionalMaths.easeToPoint(this.achievementRanks.goldContainer,-(-15 + this.goldPos * 65),220);
      }

      private function mouseEvents() : void
      {
         this.bnext.addEventListener(MouseEvent.MOUSE_DOWN,this.moveContainer,false,0,true);
         this.bprev.addEventListener(MouseEvent.MOUSE_DOWN,this.moveContainer,false,0,true);
         this.snext.addEventListener(MouseEvent.MOUSE_DOWN,this.moveContainer,false,0,true);
         this.sprev.addEventListener(MouseEvent.MOUSE_DOWN,this.moveContainer,false,0,true);
         this.gnext.addEventListener(MouseEvent.MOUSE_DOWN,this.moveContainer,false,0,true);
         this.gprev.addEventListener(MouseEvent.MOUSE_DOWN,this.moveContainer,false,0,true);
         this.closeButton.addEventListener(MouseEvent.MOUSE_DOWN,this.moveContainer,false,0,true);
      }

      private function moveContainer(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Object = null;
         if(param1.currentTarget == this.closeButton)
         {
            if(this.main.currentFrame == 4)
            {
               if(this.main.closingWindow != null)
               {
                  this.main.removeChild(this.main.closingWindow);
                  this.main.closingWindow = null;
               }
               this.main.closingWindow = this.main.window;
               this.main.window = null;
               return;
            }
            this.main.menuDestination = 0;
            if(this.main.closingWindow != null)
            {
               this.main.removeChild(this.main.closingWindow);
               this.main.closingWindow = null;
            }
            this.main.closingWindow = this.main.window;
            this.main.window = null;
            _loc2_ = 0;
            while(_loc2_ < this.main.numChildren)
            {
               _loc3_ = this.main.getChildAt(_loc2_);
               if(_loc3_ is achievements)
               {
                  _loc3_.buttonBG.filters = [];
                  _loc3_.selected = false;
               }
               _loc2_++;
            }
            return;
         }
         if(param1.currentTarget == this.bnext)
         {
            this.bronzePos += 8;
            if(this.bronzePos >= this.bronzeCreated - 8)
            {
               this.bronzePos = this.bronzeCreated - 8;
               this.bnext.visible = false;
            }
            if(this.bronzePos > 0)
            {
               this.bprev.visible = true;
            }
         }
         else if(param1.currentTarget == this.bprev)
         {
            this.bronzePos -= 8;
            if(this.bronzePos <= 0)
            {
               this.bronzePos = 0;
               this.bprev.visible = false;
            }
            if(this.bronzePos < this.bronzeCreated - 8)
            {
               this.bnext.visible = true;
            }
         }
         else if(param1.currentTarget == this.snext)
         {
            this.silverPos += 8;
            if(this.silverPos >= this.silverCreated - 8)
            {
               this.silverPos = this.silverCreated - 8;
               this.snext.visible = false;
            }
            if(this.silverPos > 0)
            {
               this.sprev.visible = true;
            }
         }
         else if(param1.currentTarget == this.sprev)
         {
            this.silverPos -= 8;
            if(this.silverPos <= 0)
            {
               this.silverPos = 0;
               this.sprev.visible = false;
            }
            if(this.silverPos < this.silverCreated - 8)
            {
               this.snext.visible = true;
            }
         }
         else if(param1.currentTarget == this.gnext)
         {
            this.goldPos += 8;
            if(this.goldPos >= this.goldCreated - 8)
            {
               this.goldPos = this.goldCreated - 8;
               this.gnext.visible = false;
            }
            if(this.goldPos > 0)
            {
               this.gprev.visible = true;
            }
         }
         else if(param1.currentTarget == this.gprev)
         {
            this.goldPos -= 8;
            if(this.goldPos <= 0)
            {
               this.goldPos = 0;
               this.gprev.visible = false;
            }
            if(this.goldPos < this.goldCreated - 8)
            {
               this.gnext.visible = true;
            }
         }
      }

      private function hideAndColourButtons() : void
      {
         this.bnext.bg.filters = this.windowColour.filters;
         this.bprev.bg.filters = this.windowColour.filters;
         this.snext.bg.filters = this.windowColour.filters;
         this.sprev.bg.filters = this.windowColour.filters;
         this.gnext.bg.filters = this.windowColour.filters;
         this.gprev.bg.filters = this.windowColour.filters;
         this.bnext.visible = false;
         this.snext.visible = false;
         this.gnext.visible = false;
         this.bprev.visible = false;
         this.sprev.visible = false;
         this.gprev.visible = false;
      }

      private function getDisplay() : void
      {
         this.main = MovieClip(root);
         if(this.main.currentFrame == 4)
         {
            if(this.main.level.currentFrame != 2)
            {
               this.displayingAll = false;
            }
            else
            {
               removeChild(this.displayAllButton);
               this.displayAllText.text = "";
            }
         }
         else
         {
            removeChild(this.displayAllButton);
            this.displayAllText.text = "";
         }
      }

      private function buildAchievements() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         if(this.displayingAll)
         {
            this.bronzeCreated = 0;
            this.silverCreated = 0;
            this.goldCreated = 0;
            this.bronzePos = 0;
            this.silverPos = 0;
            this.goldPos = 0;
            _loc1_ = 1;
            while(_loc1_ < this.totalAchievements)
            {
               _loc3_ = achievementsLog["achievement" + _loc1_];
               if(_loc3_[2] == _loc3_[3])
               {
                  this.createAchievement(_loc3_,_loc1_);
               }
               _loc1_++;
            }
            _loc2_ = 1;
            while(_loc2_ < this.totalAchievements)
            {
               _loc3_ = achievementsLog["achievement" + _loc2_];
               if(_loc3_[2] != _loc3_[3])
               {
                  this.createAchievement(_loc3_,_loc2_);
               }
               _loc2_++;
            }
         }
         else
         {
            this.bronzeCreated = 0;
            this.silverCreated = 0;
            this.goldCreated = 0;
            this.bronzePos = 0;
            this.silverPos = 0;
            this.goldPos = 0;
            _loc1_ = 1;
            while(_loc1_ < this.totalAchievements)
            {
               _loc3_ = achievementsLog["achievement" + _loc1_];
               _loc2_ = 5;
               while(_loc2_ < _loc3_.length)
               {
                  if(_loc3_[2] == _loc3_[3])
                  {
                     if(this.main.level.currentFrame == _loc3_[_loc2_])
                     {
                        this.createAchievement(_loc3_,_loc1_);
                     }
                     else if(_loc3_[5] == 2 && _loc3_[6] == null)
                     {
                        this.createAchievement(_loc3_,_loc1_);
                     }
                  }
                  _loc2_++;
               }
               _loc1_++;
            }
            _loc4_ = 1;
            while(_loc4_ < this.totalAchievements)
            {
               _loc3_ = achievementsLog["achievement" + _loc4_];
               _loc5_ = 5;
               while(_loc5_ < _loc3_.length)
               {
                  if(_loc3_[2] != _loc3_[3])
                  {
                     if(this.main.level.currentFrame == _loc3_[_loc5_])
                     {
                        this.createAchievement(_loc3_,_loc4_);
                     }
                     else if(_loc3_[5] == 2 && _loc3_[6] == null)
                     {
                        this.createAchievement(_loc3_,_loc4_);
                     }
                  }
                  _loc5_++;
               }
               _loc4_++;
            }
         }
      }

      private function createAchievement(param1:Array, param2:int = 1) : void
      {
        if (param2==26||param2==19||param2==18){
          return
        }
        if (param2==17){
          param1 = ['VexiphobiaX3', 'Complete act 3 without touching any checkpoints.',
          // current
          param1[2]
          ,
          // max
           1,
          // y location 0/1/2
          2,
          // ??
          1]
          param2=12
        }
        ExternalInterface.call("log", "createAchievement", param1, param2);
         var _loc5_:* = undefined;
         var _loc3_:* = "achievement" + param2 + "Button";
         var _loc4_:* = new (getDefinitionByName(_loc3_))();
         _loc4_.achievement = param1;
         _loc4_.y = int(_loc4_.height * 0.4);
         if(param1[4] == 0)
         {
            this.achievementRanks.bronzeContainer.addChild(_loc4_);
            _loc4_.x = int(_loc4_.width * 0.5 + (50 + 15) * this.bronzeCreated);
            ++this.bronzeCreated;
            if(this.bronzeCreated == 9)
            {
               this.bnext.visible = true;
            }
         }
         else if(param1[4] == 1)
         {
            this.achievementRanks.silverContainer.addChild(_loc4_);
            _loc4_.x = int(_loc4_.width * 0.5 + (50 + 15) * this.silverCreated);
            ++this.silverCreated;
            if(this.silverCreated == 9)
            {
               this.snext.visible = true;
            }
         }
         else if(param1[4] == 2)
         {
            this.achievementRanks.goldContainer.addChild(_loc4_);
            _loc4_.x = int(_loc4_.width * 0.5 + (50 + 15) * this.goldCreated);
            ++this.goldCreated;
            if(this.goldCreated == 9)
            {
               this.gnext.visible = true;
            }
         }
         if(param1[2] != param1[3])
         {
            _loc5_ = new achievementLocked();
            _loc5_.x = -_loc5_.width * 0.5;
            _loc5_.y = -_loc5_.height * 0.5;
            _loc4_.addChild(_loc5_);
         }
      }

      private function resetText() : void
      {
         this.bronzeText.text = "";
         this.silverText.text = "";
         this.goldText.text = "";
         this.percentComplete.text = this.findPercent();
      }

      private function toggleDisplay(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < this.achievementRanks.bronzeContainer.numChildren)
         {
            this.achievementRanks.bronzeContainer.removeChild(this.achievementRanks.bronzeContainer.getChildAt(_loc2_));
            _loc2_--;
            _loc2_++;
         }
         var _loc3_:int = 0;
         while(_loc3_ < this.achievementRanks.silverContainer.numChildren)
         {
            this.achievementRanks.silverContainer.removeChild(this.achievementRanks.silverContainer.getChildAt(_loc3_));
            _loc3_--;
            _loc3_++;
         }
         var _loc4_:* = 0;
         while(_loc4_ < this.achievementRanks.goldContainer.numChildren)
         {
            this.achievementRanks.goldContainer.removeChild(this.achievementRanks.goldContainer.getChildAt(_loc4_));
            _loc4_ = --_loc4_ + 1;
         }
         if(this.displayingAll)
         {
            this.displayingAll = false;
            this.displayAllButton.gotoAndStop(1);
         }
         else
         {
            this.displayingAll = true;
            this.displayAllButton.gotoAndStop(2);
         }
         this.hideAndColourButtons();
         this.buildAchievements();
      }

      private function findPercent() : String
      {
         var _loc4_:Array = null;
         var _loc1_:int = 0;
         var _loc2_:int = 1;
         while(_loc2_ < this.totalAchievements)
         {
            _loc4_ = achievementsLog["achievement" + _loc2_];
            if(_loc4_[2] == _loc4_[3])
            {
               _loc1_++;
            }
            _loc2_++;
         }
         return int(_loc1_ / (this.totalAchievements - 1) * 100) + "%";
      }
   }
}

