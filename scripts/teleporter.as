package
{
   import fl.motion.AdjustColor;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.external.ExternalInterface;
   import flash.filters.BlurFilter;
   import flash.filters.ColorMatrixFilter;
   import flash.filters.GlowFilter;

   [Embed(source="/_assets/assets.swf", symbol="symbol216")]
   public class teleporter extends finishPortal
   {

      public static var teleporters:int = 0;

      public var teleportID:int = 0;

      public function teleporter()
      {
         super();
         this.teleportID = teleporters;
         ++teleporters;
         addEventListener(Event.ADDED_TO_STAGE,this.addFilters);
      }

      private function addFilters(param1:Event) : void
      {
         var _loc6_:ColorMatrixFilter = null;
         var _loc2_:BlurFilter = new BlurFilter(8,8,3);
         var _loc3_:GlowFilter = new GlowFilter(65280,1,15,15,0.5,3);
         var _loc4_:GlowFilter = new GlowFilter(13369289,1,30,30,2,3);
         var _loc5_:AdjustColor = new AdjustColor();
         var _loc7_:Array = [];
         _loc5_.hue = 100;
         _loc5_.brightness = 0;
         _loc5_.saturation = 0;
         _loc5_.contrast = 0;
         _loc7_ = _loc5_.CalculateFinalFlatArray();
         _loc6_ = new ColorMatrixFilter(_loc7_);
         filters = [_loc2_,_loc3_,_loc4_,_loc6_];
         trace("filters added");
      }

      override public function update() : void
      {
         var _loc1_:int = 0;
         player = MovieClip(parent).player;
         if(ExternalInterface.call("canUseMove","portal") && hitbox.hitTestObject(player))
         {
            player.xSpeed = 0;
            player.ySpeed = 0;
            if(!player.teleporting)
            {
               main.playSound("Portal",false);
            }
            player.teleporting = true;
            teleportingToThis = true;
            additionalMaths.easeToPoint(player,x,y,10);
            if(additionalMaths.getDistance(player,this) <= 1)
            {
               this.teleport();
            }
            player.gotoAndStop(2);
            if(player.inner_animation.currentFrame < 28)
            {
               player.inner_animation.gotoAndPlay(28);
            }
            _loc1_ = 8;
            player.rotation += _loc1_ - Math.sqrt(player.scaleX * player.scaleX) * _loc1_;
            player.scaleX *= 0.95;
            if(player.scaleX > 0)
            {
               player.scaleY = player.scaleX;
            }
            else
            {
               player.scaleY = player.scaleX * -1;
            }
         }
         else if(player.teleporting)
         {
            if(teleportingToThis)
            {
               additionalMaths.easeToPoint(player,x,y,10);
            }
         }
         this.createParticles();
         this.suckParticles();
      }

      override protected function createParticles() : void
      {
         var _loc1_:int = 0;
         var _loc2_:* = undefined;
         ++particleTimer;
         if(particleTimer > particleSpawnRate)
         {
            _loc1_ = 100;
            _loc2_ = new particle(3407871,4,false);
            _loc2_.x = int(x + (Math.random() * (width + _loc1_) - width * 0.5 - _loc1_ * 0.5));
            _loc2_.y = int(y + (Math.random() * (hitbox.height + _loc1_) - hitbox.height * 0.5 - _loc1_ * 0.5));
            _loc2_.xSpeed = 0;
            _loc2_.ySpeed = 0;
            parent.addChild(_loc2_);
            particleTimer = 0;
         }
      }

      override protected function suckParticles() : void
      {
         var _loc3_:int = 0;
         var _loc1_:Array = main.particles;
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_.length)
         {
            _loc3_ = additionalMaths.getDistance(this,_loc1_[_loc2_]);
            if(_loc3_ < 250)
            {
               if(_loc3_ < 50)
               {
                  _loc1_[_loc2_].fadeTime = 150;
                  _loc1_[_loc2_].alpha *= 0.5;
               }
               if(_loc1_[_loc2_].y < y)
               {
                  _loc1_[_loc2_].ySpeed += 0.75;
               }
               else if(_loc1_[_loc2_].y > y)
               {
                  _loc1_[_loc2_].ySpeed -= 0.75;
               }
               if(_loc1_[_loc2_].x < x)
               {
                  _loc1_[_loc2_].xSpeed += 0.75;
               }
               else if(_loc1_[_loc2_].x > x)
               {
                  _loc1_[_loc2_].xSpeed -= 0.75;
               }
            }
            _loc2_++;
         }
      }

      protected function teleport() : void
      {
         var _loc2_:int = 0;
         var _loc3_:MovieClip = null;
         var _loc4_:int = 0;
         var _loc5_:* = undefined;
         var _loc6_:Boolean = false;
         var _loc1_:Array = main.checkpoints;
         _loc2_ = 0;
         while(_loc2_ < parent.numChildren)
         {
            if(parent.getChildAt(_loc2_) is teleporterReceiver)
            {
               _loc3_ = MovieClip(parent.getChildAt(_loc2_));
               if(_loc3_.teleportID == this.teleportID)
               {
                  trace("teleported");
                  player.teleporting = false;
                  teleportingToThis = false;
                  player.swimming = false;
                  player.currentPool = null;
                  player.x = _loc3_.x;
                  player.y = _loc3_.y;
                  camera.snap(player,parent,320,240);
                  player.ySpeed = -4;
                  player.xSpeed = 0;
                  player.scaleX = 1;
                  player.scaleY = 1;
                  player.inner_animation.gotoAndPlay(1);
                  player.falling = true;
                  _loc4_ = 0;
                  while(_loc4_ < 15)
                  {
                     if(Math.random() < 0.5)
                     {
                        _loc5_ = new particle(65535);
                     }
                     else
                     {
                        _loc5_ = new particle(3407871);
                     }
                     _loc5_.x = _loc3_.x;
                     _loc5_.y = _loc3_.y;
                     _loc5_.xSpeed = Math.random() * 16 - 8;
                     _loc5_.ySpeed = Math.random() * 16 - 8;
                     parent.addChild(_loc5_);
                     _loc4_++;
                  }
                  break;
               }
            }
            _loc2_++;
         }
         while(teleportingToThis)
         {
            trace("teleport didnt work");
            _loc6_ = false;
            _loc2_ = 0;
            while(_loc2_ < parent.numChildren)
            {
               if(parent.getChildAt(_loc2_) is teleporterReceiver)
               {
                  _loc6_ = true;
                  if(Math.random() < 0.25)
                  {
                     _loc3_ = MovieClip(parent.getChildAt(_loc2_));
                     player.teleporting = false;
                     teleportingToThis = false;
                     player.swimming = false;
                     player.currentPool = null;
                     player.x = _loc3_.x;
                     player.y = _loc3_.y;
                     camera.snap(player,parent,320,240);
                     player.ySpeed = -4;
                     player.xSpeed = 0;
                     player.scaleX = 1;
                     player.scaleY = 1;
                     player.inner_animation.gotoAndPlay(1);
                     player.falling = true;
                     _loc4_ = 0;
                     if(_loc4_ < 15)
                     {
                        if(Math.random() < 0.5)
                        {
                           _loc5_ = new particle(65535);
                        }
                        else
                        {
                           _loc5_ = new particle(3407871);
                        }
                        _loc5_.x = _loc3_.x;
                        _loc5_.y = _loc3_.y;
                        _loc5_.xSpeed = Math.random() * 16 - 8;
                        _loc5_.ySpeed = Math.random() * 16 - 8;
                        parent.addChild(_loc5_);
                     }
                  }
               }
               _loc2_++;
            }
            if(!_loc6_)
            {
               player.kill(16);
               break;
            }
         }
      }
   }
}

