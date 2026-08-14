package
{
   import flash.display.MovieClip;

   [Embed(source="/_assets/assets.swf", symbol="symbol1284")]
   public dynamic class gameTransition extends MovieClip
   {

      public function gameTransition()
      {
         super();
         addFrameScript(29,this.frame30);
         gotoAndPlay(29);
      }

      internal function frame30() : *
      {
         stop();
      }
   }
}

