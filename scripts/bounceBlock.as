package
{
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;

   [Embed(source="/_assets/assets.swf", symbol="symbol1604")]
   public class bounceBlock extends block
   {

      private var animation:MovieClip = null;

      private var animationMask:Sprite = null;

      private var bouncing:Boolean = false;

      private var startYScale:Number;

      private var startHeight:Number;

      private var startXScale:Number;

      private var startWidth:Number;

      public function bounceBlock()
      {
         super();
      }

      override protected function pushArray(param1:Event) : void
      {
         if(this)
         {
            main = MovieClip(root);
            player = MovieClip(parent).player;
            MovieClip(root).blocks.push(this);
            startX = x;
            startY = y;
            createBounds();
            this.startYScale = scaleY;
            this.startHeight = height;
            this.startXScale = scaleX;
            this.startWidth = width;
            if(this.animation == null)
            {
               this.animation = new arrowAnimation();
               this.animation.x = x;
               this.animation.y = y;
               trace(scaleX,scaleY);
               this.animation.scaleX = scaleX;
               this.animation.scaleY = scaleY;
               parent.addChild(this.animation);
               parent.setChildIndex(this.animation,parent.getChildIndex(this) + 1);
               this.newMask();
            }
            removeEventListener(Event.ADDED_TO_STAGE,this.pushArray);
         }
      }

      override public function update() : void
      {
         player = MovieClip(root).level.player;
         if(this.bouncing)
         {
            player.gotoAndStop(7);
            scaleY -= 0.05;
            scaleX += 0.05;
            y = startY + (this.startHeight - height);
            x = startX - (width - this.startHeight) * 0.5;
            player.y = y;
            player.xSpeed = 0;
            if(scaleY < this.startYScale * 0.2)
            {
               this.fullBounce();
            }
         }
         else
         {
            if(scaleY <= this.startYScale)
            {
               scaleY += 0.05;
               if(scaleY > this.startYScale)
               {
                  scaleY = this.startYScale;
                  y = startY;
               }
            }
            if(scaleX >= this.startXScale)
            {
               scaleX -= 0.05;
               if(scaleX < this.startXScale)
               {
                  scaleX = this.startXScale;
                  x = startX;
               }
            }
            y = startY + (this.startHeight - height);
            x = startX - (width - this.startHeight) * 0.5;
         }
         this.newMask();
         checkRender();
         removeBounds();
         createBounds();
      }

      override public function landed() : void
      {
        if (ExternalInterface.call("canUseMove","bounce")){
         this.bouncing = true;
         }else{
MovieClip(root).level.player.kill(9);
         }
      }

      override public function respawn() : void
      {
         this.bouncing = false;
      }

      private function fullBounce() : void
      {
         player = MovieClip(root).level.player;
         player.ySpeed = -18 * (this.startHeight / 50);
         player.gotoAndStop(2);
         player.falling = true;
         this.bouncing = false;
         var _loc1_:Number = Math.random();
         if(_loc1_ < 0.33)
         {
            main.playSound("Bounce",false);
         }
         else if(_loc1_ < 0.66)
         {
            main.playSound("bounce1",false);
         }
         else
         {
            main.playSound("bounce2",false);
         }
      }

      private function newMask() : void
      {
         if(this.animationMask)
         {
            parent.removeChild(this.animationMask);
         }
         this.animationMask = new Sprite();
         parent.addChild(this.animationMask);
         this.animationMask.graphics.beginFill(255);
         this.animationMask.graphics.drawRect(0,0,width,height);
         this.animationMask.graphics.endFill();
         this.animationMask.x = x;
         this.animationMask.y = y;
         this.animation.mask = this.animationMask;
      }
   }
}

