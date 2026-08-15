package
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;

   public class achievementButton extends button
   {

      public var achievement:Array;

      public function achievementButton()
      {
         super();
      }

      public function gameButton() : *
      {
      }

      override protected function init(param1:Event) : void
      {
         startY = y;
         main = MovieClip(root);
      }

      override protected function update(param1:Event) : void
      {
         if(parent is achievementContainer)
         {
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
         }
      }

      override protected function rollOver(param1:MouseEvent) : void
      {
         if(parent is achievementUnlocked)
         {
            return;
         }
         if(y == startY)
         {
            gravity = 1.5;
            y -= gravity;
         }
         var _loc2_:String = this.achievement[0] + " - " + this.achievement[1];
         if(this.achievement[2] != this.achievement[3])
         {
            _loc2_ = "Locked - " + this.achievement[1];
            if(this.achievement[3] > 1)
            {
               _loc2_ = _loc2_ + " " + this.achievement[2] + "/" + this.achievement[3];
            }
         }
         if(parent.name == "bronzeContainer")
         {
            MovieClip(root).window.bronzeText.text = _loc2_;
         }
         else if(parent.name == "silverContainer")
         {
            MovieClip(root).window.silverText.text = _loc2_;
         }
         else if(parent.name == "goldContainer")
         {
            MovieClip(root).window.goldText.text = _loc2_;
         }
      }

      override protected function rollOut(param1:MouseEvent) : void
      {
         if(parent is achievementContainer)
         {
            MovieClip(root).window.bronzeText.text = "";
            MovieClip(root).window.silverText.text = "";
            MovieClip(root).window.goldText.text = "";
         }
      }

      override protected function click(param1:MouseEvent) : void
      {
         if(this is achievement30Button)
         {
            if(achievementsLog.achievement30[2] == 0)
            {
               removeChild(getChildAt(numChildren - 1));
            }
            main.incAchievement(30);
         }
      }
   }
}

