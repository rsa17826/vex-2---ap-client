package
{
  import flash.external.ExternalInterface;
   import flash.display.MovieClip;
   import flash.events.Event;

   [Embed(source="/_assets/assets.swf", symbol="symbol1425")]
   public class iceBlock extends block
   {

      public var heightMask:MovieClip;

      private var startHeight:int;

      private var depletionRate:Number;

      public var melted:Boolean = false;

      public function iceBlock()
      {
         super();
         addEventListener(Event.ADDED_TO_STAGE,this.addedToStage,false,0,true);
      }

      override public function update() : void
      {
         var _loc1_:int = 0;
         var _loc2_:* = undefined;
         checkRender();
         if(visible)
         {
            if(!this.melted)
            {
               _loc1_ = int(Math.floor(Math.random() * 100));
               if(_loc1_ >= 96)
               {
                  _loc2_ = new particle(3394815,4,true,true);
                  _loc2_.x = x + int(Math.random() * width);
                  _loc2_.y = y + this.startHeight * (this.heightMask.height / 100) + 10;
                  _loc2_.xSpeed = 0;
                  _loc2_.ySpeed = 0;
                  parent.addChild(_loc2_);
               }
            }
            this.heightMask.height -= this.depletionRate;
            if(this.heightMask.height <= 3)
            {
               this.melted = true;
               visible = false;
            }
            this.refreshBounds();
         }
      }

      private function addedToStage(param1:Event) : void
      {
        // NOTE make that one ice block in level 5 smaller so star not annoying to get but still allow enough so main route is possible deathless
         if (this.x==-343&&this.y==-685)height=50
         this.startHeight = height;
         this.depletionRate = 100 / this.startHeight * 0.2;
            // ExternalInterface.call("log", "aaaaaaaa", this.startHeight, this.x, this.y)
         removeEventListener(Event.ADDED_TO_STAGE,this.addedToStage);
      }

      override public function respawn() : void
      {
         visible = true;
         this.heightMask.height = 100;
         this.melted = false;
         this.refreshBounds();
      }

      override public function snapBottom(param1:Object) : void
      {
         param1.y = y + this.startHeight * (this.heightMask.height / 100) + param1.height + ySpeed;
      }

      override protected function refreshBounds() : void
      {
         topBound.x = x;
         topBound.y = y;
         topBound.height = 12;
         leftHangBound.x = x;
         leftHangBound.y = y;
         rightHangBound.x = x + width * 0.5;
         rightHangBound.y = y;
         leftBound.x = x;
         leftBound.y = y + topBound.height;
         leftBound.height = this.startHeight * (this.heightMask.height / 100) - topBound.height;
         rightBound.x = x + leftBound.width;
         rightBound.y = leftBound.y;
         rightBound.height = leftBound.height;
         bottomBound.x = x;
         bottomBound.y = y + leftBound.height;
      }
   }
}

