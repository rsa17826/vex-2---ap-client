package
{
   import flash.geom.Point;
    import flash.external.ExternalInterface;

   [Embed(source="/_assets/assets.swf", symbol="symbol1407")]
   public class pushBlock extends block
   {

      public var pushed:Boolean = false;

      protected var playerLock:Boolean = false;

      public var saveUse:Boolean = false;

      public function pushBlock()
      {
         super();
         addFrameScript(0,this.frame1);
      }

      override public function update() : void
      {
         x += xSpeed;
         y += ySpeed;
         this.checkCollisions();
         refreshBounds();
         ySpeed += player.gravity;
         if(ySpeed > 30)
         {
            this.respawn();
         }
         checkRender();
      }

      protected function checkCollisions() : void
      {
         var _loc1_:Array = null;
         var _loc3_:* = undefined;
         _loc1_ = main.blocks;
         var _loc2_:Boolean = true;
         _loc3_ = 0;
         for(; _loc3_ < _loc1_.length; _loc3_++)
         {
            if(_loc1_[_loc3_] != this)
            {
               if(_loc1_[_loc3_] is iceBlock)
               {
                  if(_loc1_[_loc3_].melted)
                  {
                     continue;
                  }
               }
               if(_loc1_[_loc3_] is lockBlock)
               {
                  if(_loc1_[_loc3_].unlocked)
                  {
                     continue;
                  }
               }
               if(_loc1_[_loc3_] is darkBlock)
               {
                  if(main.dark is darkOverlay)
                  {
                     continue;
                  }
               }
               if(bottomBound.hitTestObject(_loc1_[_loc3_].topBound))
               {
                  _loc2_ = false;
                  y = _loc1_[_loc3_].y - height;
                  ySpeed = _loc1_[_loc3_].ySpeed;
                  if(_loc1_[_loc3_] is iceBlock)
                  {
                     xSpeed *= 0.98;
                  }
                  else if(_loc1_[_loc3_] is pushBlock)
                  {
                     xSpeed = _loc1_[_loc3_].xSpeed;
                  }
                  else if(xSpeed != _loc1_[_loc3_].xSpeed)
                  {
                     if(xSpeed > _loc1_[_loc3_].xSpeed)
                     {
                        xSpeed -= 3.5;
                        if(xSpeed < _loc1_[_loc3_].xSpeed)
                        {
                           xSpeed = _loc1_[_loc3_].xSpeed;
                        }
                     }
                     else if(xSpeed < _loc1_[_loc3_].xSpeed)
                     {
                        xSpeed += 3.5;
                        if(xSpeed > _loc1_[_loc3_].xSpeed)
                        {
                           xSpeed = _loc1_[_loc3_].xSpeed;
                        }
                     }
                  }
               }
               else if(this.hitTestObject(_loc1_[_loc3_].leftBound))
               {
                  if(!topBound.hitTestObject(_loc1_[_loc3_].bottomBound))
                  {
                     x = _loc1_[_loc3_].x - width;
                     if(_loc1_[_loc3_] is lockBlock)
                     {
                        _loc1_[_loc3_].xSpeed = xSpeed;
                        _loc1_[_loc3_].x += xSpeed;
                        xSpeed = 0;
                     }
                     else
                     {
                        xSpeed = _loc1_[_loc3_].xSpeed;
                     }
                  }
               }
               else if(this.hitTestObject(_loc1_[_loc3_].rightBound))
               {
                  if(!topBound.hitTestObject(_loc1_[_loc3_].bottomBound))
                  {
                     x = _loc1_[_loc3_].x + _loc1_[_loc3_].width;
                     if(_loc1_[_loc3_] is lockBlock)
                     {
                        _loc1_[_loc3_].xSpeed = xSpeed;
                        xSpeed = 0;
                     }
                     else
                     {
                        xSpeed = _loc1_[_loc3_].xSpeed;
                     }
                  }
               }
            }
         }
         if(_loc2_)
         {
            xSpeed *= 0.8;
         }
      }

      override public function landed() : void
      {
         var _loc1_:Array = null;
         var _loc2_:int = 0;
         var _loc3_:Point = null;
         var _loc4_:* = undefined;
         if(Boolean(player.crouching) || this.playerLock)
         {
            _loc1_ = main.blocks;
            _loc2_ = 0;
            while(_loc2_ < _loc1_.length)
            {
               if(_loc1_[_loc2_].visible)
               {
                  if(_loc1_[_loc2_] is basicBlock)
                  {
                     _loc3_ = new Point(x - 5,y - 1);
                     _loc4_ = parent.localToGlobal(_loc3_);
                     if(_loc1_[_loc2_].hitTestPoint(_loc4_.x,_loc4_.y) && ExternalInterface.call("canUseMove", "kick"))
                     {
                        this.rightKick();
                     }
                     else
                     {
                        _loc3_ = new Point(x + width + 5,y - 1);
                        _loc4_ = parent.localToGlobal(_loc3_);
                        if(_loc1_[_loc2_].hitTestPoint(_loc4_.x,_loc4_.y) && ExternalInterface.call("canUseMove", "kick"))
                        {
                           this.leftKick();
                        }
                     }
                  }
               }
               _loc2_++;
            }
         }
      }

      protected function rightKick() : void
      {
         this.playerLock = true;
         player.crouching = false;
         player.kicking = true;
         player.gotoAndStop(1);
         if(player.scaleX < 0)
         {
            player.scaleX *= -1;
         }
         if(player.inner_animation.currentFrame < 57)
         {
            additionalMaths.easeToPoint(player,x + 4,y);
            if(player.x <= x + 10)
            {
               if(player.inner_animation.currentFrame < 46)
               {
                  player.gotoAndStop(1);
                  player.inner_animation.gotoAndPlay(46);
               }
            }
         }
         else if(player.inner_animation.currentFrame == 57)
         {
            player.ySpeed = -4;
            xSpeed = 20 * player.scaleX;
            this.playerLock = false;
            player.kicking = false;
         }
      }

      protected function leftKick() : void
      {
         this.playerLock = true;
         player.kicking = true;
         player.crouching = false;
         player.gotoAndStop(1);
         if(player.scaleX > 0)
         {
            player.scaleX *= -1;
         }
         if(player.inner_animation.currentFrame < 57)
         {
            additionalMaths.easeToPoint(player,x + width - 4,y);
            if(player.x >= x + width - 10)
            {
               if(player.inner_animation.currentFrame < 46)
               {
                  player.gotoAndStop(1);
                  player.inner_animation.gotoAndPlay(46);
               }
            }
         }
         else if(player.inner_animation.currentFrame == 57)
         {
            player.ySpeed = -4;
            xSpeed = 20 * player.scaleX;
            this.playerLock = false;
            player.kicking = false;
         }
      }

      override public function respawn() : void
      {
         if(!this.saveUse)
         {
            x = startX;
            y = startY;
            refreshBounds();
            xSpeed = 0;
            ySpeed = 0;
            this.pushed = false;
            this.playerLock = false;
         }
      }

      internal function frame1() : *
      {
         stop();
      }
   }
}

