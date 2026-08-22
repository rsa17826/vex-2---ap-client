package com.newgrounds.components
{
   import adobe.utils.*;
   import flash.accessibility.*;
   import flash.desktop.*;
   import flash.display.*;
   import flash.errors.*;
   import flash.events.*;
   import flash.external.*;
   import flash.filters.*;
   import flash.geom.*;
   import flash.globalization.*;
   import flash.media.*;
   import flash.net.*;
   import flash.net.drm.*;
   import flash.printing.*;
   import flash.profiler.*;
   import flash.sampler.*;
   import flash.sensors.*;
   import flash.system.*;
   import flash.text.*;
   import flash.text.engine.*;
   import flash.text.ime.*;
   import flash.ui.*;
   import flash.utils.*;
   import flash.xml.*;

   [Embed(source="/_assets/assets.swf", symbol="symbol1766")]
   public dynamic class FlashAd extends FlashAdBase
   {

      public var newgroundsButton:SimpleButton;

      public var playButton:MovieClip;

      public var adContainer:MovieClip;

      public function FlashAd()
      {
        return
        //  super();
         addFrameScript(0,this.frame1,1,this.frame2,9,this.frame10,19,this.frame20);
      }

      public function initPlayButton() : *
      {
         if(this["playButton"])
         {
            // this["playButton"].addEventListener(MouseEvent.CLICK,this.onPlayClick);
            if(!this["showPlayButton"])
            {
               this["playButton"].visible = false;
            }
         }
      }

      public function onPlayClick(param1:MouseEvent) : void
      {
         removeAd();
         if(parent)
         {
            parent.removeChild(this);
         }
      }

      internal function frame1() : *
      {
         stop();
      }

      internal function frame2() : *
      {
         this.initPlayButton();
      }

      internal function frame10() : *
      {
         this.initPlayButton();
      }

      internal function frame20() : *
      {
         this.initPlayButton();
      }
   }
}

