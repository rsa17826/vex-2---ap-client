package
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.external.ExternalInterface;

   public class lever extends MovieClip
   {

      public var main:MovieClip;

      public var player:MovieClip;

      public var leverHandle:MovieClip;

      public var active:Boolean = false;

      public var leverTime:int = 0;

      public function lever()
      {
         super();
         addEventListener(Event.ADDED_TO_STAGE,this.pushArray);
         x = int(x);
         y = int(y);
      }

      public function update() : void
      {
         if(this.leverTime > 0)
         {
            --this.leverTime;
         }
         var _loc1_:int = 5;
         if(!this.active)
         {
            if(this.leverHandle.rotation > -45)
            {
               this.leverHandle.rotation -= _loc1_;
               if(this.leverHandle.rotation < -45)
               {
                  this.leverHandle.rotation = -45;
               }
            }
         }
         else if(this.leverHandle.rotation < 45)
         {
            this.leverHandle.rotation += _loc1_;
            if(this.leverHandle.rotation > 45)
            {
               this.leverHandle.rotation = 45;
            }
         }
      }

      public function activate() : void
      {
         if(!ExternalInterface.call("canUseMove","lever"))
         {
            return;
         }
         this.deactivateLevers();
         this.active = true;
         this.player = this.main.level.player;
         this.player.gravity = 0.25;
         var _loc1_:* = new gravityChange();
         _loc1_.x = 0;
         _loc1_.y = this.main.stageHeight;
         _loc1_.direction = "up";
         _loc1_.blendMode = "screen";
         this.main.addChild(_loc1_);
         this.main.setChildIndex(_loc1_,this.main.getChildIndex(this.main.level) + 1);
         this.player.filters = [];
         this.player.createGlow(39423);
         this.player.levelTintColour = 39423;
         this.player.levelTintStr = 0;
         this.player.destLevelTintStr = 50;
      }

      public function deactivate() : void
      {
         this.active = false;
         this.player = this.main.level.player;
         this.player.gravity = 0.5;
         var _loc1_:* = new gravityChange();
         _loc1_.x = 0;
         _loc1_.y = -_loc1_.height;
         _loc1_.direction = "down";
         _loc1_.blendMode = "screen";
         this.main.addChild(_loc1_);
         this.main.setChildIndex(_loc1_,this.main.getChildIndex(this.main.level) + 1);
         this.player.filters = [];
         this.player.destLevelTintStr = 0;
      }

      protected function deactivateLevers() : void
      {
         var _loc1_:Array = this.main.obstacles;
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_.length)
         {
            if(_loc1_[_loc2_] is lever)
            {
               _loc1_[_loc2_].active = false;
            }
            _loc2_++;
         }
      }

      protected function pushArray(param1:Event) : void
      {
         if(this)
         {
            this.main = MovieClip(root);
            this.main.obstacles.push(this);
            parent.setChildIndex(this,0);
            removeEventListener(Event.ADDED_TO_STAGE,this.pushArray);
         }
      }
   }
}

