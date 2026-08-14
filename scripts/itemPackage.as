package
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import flash.utils.getDefinitionByName;
   import flash.utils.getQualifiedClassName;

   public class itemPackage extends button
   {

      private var packageName:String;

      private var readyToUnlock:Boolean = false;

      private var unlocked:Boolean = false;

      private var flashing:int = 3;

      private var brightness:int = -75;

      private var achievement:Array = [];

      public function itemPackage()
      {
         super();
      }

      override protected function init(param1:Event) : void
      {
         startY = y;
         main = MovieClip(root);
         this.findAchievementLinkage();
         this.findAlreadyUnlocked();
      }

      private function findAlreadyUnlocked() : void
      {
         var _loc3_:Class = null;
         var _loc1_:Array = MovieClip(root).savedItemPacks;
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_.length)
         {
            _loc3_ = getDefinitionByName(String("itemPackage" + _loc2_)) as Class;
            if(this is _loc3_)
            {
               if(_loc1_[_loc2_])
               {
                  this.unlocked = true;
                  break;
               }
            }
            _loc2_++;
         }
         if(!this.unlocked)
         {
            adjustColour.colourChange(this,0,0,this.brightness,0);
         }
      }

      private function findAchievementLinkage() : void
      {
         if(this is itemPackage0)
         {
            this.readyToUnlock = true;
            this.packageName = "Starter Pack";
            return;
         }
         if(this is itemPackage1)
         {
            this.packageName = "Tutorial Pack";
            this.achievement = achievementsLog.achievement1;
         }
         if(this is itemPackage2)
         {
            this.packageName = "Act 1 Pack";
            this.achievement = achievementsLog.achievement2;
         }
         if(this is itemPackage3)
         {
            this.packageName = "Act 2 Pack";
            this.achievement = achievementsLog.achievement3;
         }
         if(this is itemPackage4)
         {
            this.packageName = "Act 3 Pack";
            this.achievement = achievementsLog.achievement4;
         }
         if(this is itemPackage5)
         {
            this.packageName = "Act 4 Pack";
            this.achievement = achievementsLog.achievement5;
         }
         if(this is itemPackage6)
         {
            this.packageName = "Act 5 Pack";
            this.achievement = achievementsLog.achievement6;
         }
         if(this is itemPackage7)
         {
            this.packageName = "Act 6 Pack";
            this.achievement = achievementsLog.achievement7;
         }
         if(this is itemPackage8)
         {
            this.packageName = "Act 7 Pack";
            this.achievement = achievementsLog.achievement8;
         }
         if(this is itemPackage9)
         {
            this.packageName = "Act 8 Pack";
            this.achievement = achievementsLog.achievement9;
         }
         if(this is itemPackage10)
         {
            this.packageName = "Act 9 Pack";
            this.achievement = achievementsLog.achievement10;
         }
         if(this is itemPackage11)
         {
            this.packageName = "Microwave Pack";
            this.achievement = achievementsLog.achievement30;
         }
         if(this is itemPackage12)
         {
            this.packageName = "1st Place Pack";
            this.achievement = achievementsLog.achievement22;
         }
         if(this.achievement[2] == this.achievement[3])
         {
            this.readyToUnlock = true;
         }
      }

      override protected function update(param1:Event) : void
      {
         if(x + parent.x + 305 < -width || x + parent.x + 305 > 640)
         {
            visible = false;
         }
         else
         {
            visible = true;
         }
         if(y > startY)
         {
            y += gravity;
            gravity -= 0.25;
            if(y < startY)
            {
               gravity = 0;
               y = startY;
            }
         }
         else if(y < startY)
         {
            y -= gravity;
            gravity -= 0.25;
            if(y > startY)
            {
               gravity = 0;
               y = startY;
            }
         }
         if(this.readyToUnlock)
         {
            if(!this.unlocked)
            {
               this.brightness += this.flashing;
               if(this.brightness >= 0)
               {
                  this.flashing *= -1;
                  this.brightness = 0;
               }
               if(this.brightness <= -75)
               {
                  this.flashing *= -1;
                  this.brightness = -75;
               }
               if(visible)
               {
                  adjustColour.colourChange(this,0,0,this.brightness,0);
               }
            }
         }
      }

      override protected function rollOver(param1:MouseEvent) : void
      {
         if(this.unlocked)
         {
            main.window.itemPackageDesc.text = this.packageName + " - Unlocked!";
         }
         else if(this.readyToUnlock)
         {
            main.window.itemPackageDesc.text = this.packageName + " - Click to unlock.";
         }
         else
         {
            main.window.itemPackageDesc.text = this.packageName + " - " + this.achievement[1];
         }
         if(y == startY)
         {
            gravity = 1.5;
            y -= gravity;
         }
      }

      override protected function rollOut(param1:MouseEvent) : void
      {
         main.window.itemPackageDesc.text = "roll over an item package to see how to unlock its contents.";
      }

      override protected function click(param1:MouseEvent) : void
      {
         if(this.readyToUnlock)
         {
            if(!this.unlocked)
            {
               this.unlock();
               return;
            }
         }
         if(!this.readyToUnlock)
         {
            if(this is itemPackage11)
            {
               main.incAchievement(30);
               if(!this.readyToUnlock)
               {
                  this.readyToUnlock = true;
               }
            }
         }
      }

      protected function unlock() : void
      {
         main.window.itemPackageDesc.text = this.packageName + " - Unlocked!";
         this.unlocked = true;
         this.brightness = 0;
         adjustColour.colourChange(this,0,0,this.brightness,0);
         if(y == startY)
         {
            gravity = 1.5;
            y -= gravity;
         }
         var _loc1_:String = getQualifiedClassName(this);
         var _loc2_:String = _loc1_.substr(_loc1_.length - 1,1);
         if(this is itemPackage10)
         {
            _loc2_ = "10";
         }
         if(this is itemPackage11)
         {
            _loc2_ = "11";
         }
         if(this is itemPackage12)
         {
            _loc2_ = "12";
         }
         trace(_loc2_);
         main.savedItemPacks[int(_loc2_)] = true;
         main.window.refreshPacks();
      }
   }
}

