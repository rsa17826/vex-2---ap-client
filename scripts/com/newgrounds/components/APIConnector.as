package com.newgrounds.components
{
   import adobe.utils.*;
   import com.newgrounds.API;
   import com.newgrounds.APIEvent;
   import com.newgrounds.Logger;
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

   [Embed(source="/_assets/assets.swf", symbol="symbol1767")]
   public dynamic class APIConnector extends MovieClip
   {

      public var loader:Preloader;

      public var ad:FlashAd;

      public var __setPropDict:Dictionary = new Dictionary(true);

      public var __lastFrameProp:int = -1;

      public var apiId:String;

      public var encryptionKey:String;

      public var movieVersion:String;

      public var debugMode:String;

      public var connectorType:String;

      public var redirectOnHostBlocked:Boolean;

      public var redirectOnNewVersion:Boolean;

      public var adType:String;

      public var className:String;

      public var _redirect:Boolean;

      public function APIConnector()
      {
        //  super();
        //  addFrameScript(0,this.frame1);
        //  addEventListener(Event.FRAME_CONSTRUCTED,this.__setProp_handler,false,0,true);
      }

      public function initAd(param1:Event) : void
      {
        return
         removeEventListener(Event.ENTER_FRAME,this.initAd);
         if(!this.adType)
         {
            this.adType = "Video";
         }
         if(this.ad)
         {
            this.ad.adType = this.adType;
         }
         switch(this.connectorType)
         {
            case "Flash Ad + Preloader":
               gotoAndStop("adPreloader");
               break;
            case "Flash Ad Only":
               gotoAndStop("ad");
               break;
            case "Invisible":
               gotoAndStop("invisible");
         }
      }

      public function _onLoaded() : void
      {
         var mainClass:Class = null;
         var main:* = undefined;
         gotoAndStop("invisible");
         if(this._redirect)
         {
            API.loadOfficialVersion();
            return;
         }
         if(this.className)
         {
            try
            {
               mainClass = getDefinitionByName(this.className) as Class;
               if(Boolean(mainClass) && Boolean(parent))
               {
                  main = new mainClass();
                  parent.addChild(main);
                  parent.removeChild(this);
               }
            }
            catch(error:*)
            {
               Logger.logError("Unable to create main class: " + className);
            }
         }
      }

      public function _apiConnect() : void
      {
         var _loc1_:* = API;
         if(_loc1_ && !_loc1_.connected)
         {
            if(!this.apiId)
            {
               Logger.logError("No API ID entered in the API Connector component.","You can create an API ID for this submission at http://newgrounds.com/account/flashapi","Enter your API ID into the API Connector using the Component Inspector (Window -> Component Inspector).");
               return;
            }
            switch(this.debugMode)
            {
               default:
               case "Off":
                  _loc1_.debugMode = _loc1_.RELEASE_MODE;
                  break;
               case "Simulate Logged-in User":
                  _loc1_.debugMode = _loc1_.DEBUG_MODE_LOGGED_IN;
                  break;
               case "Simulate Logged-out User":
                  _loc1_.debugMode = _loc1_.DEBUG_MODE_LOGGED_OUT;
                  break;
               case "Simulate New Version":
                  _loc1_.debugMode = _loc1_.DEBUG_MODE_NEW_VERSION;
                  break;
               case "Simulate Host Blocked":
                  _loc1_.debugMode = _loc1_.DEBUG_MODE_HOST_BLOCKED;
            }
            if(this.loader)
            {
               this.loader.haltComplete = true;
            }
            _loc1_.addEventListener(APIEvent.API_CONNECTED,this._onConnected);
            _loc1_.connect(root,this.apiId,this.encryptionKey,this.movieVersion);
         }
      }

      public function _onConnected(param1:APIEvent) : void
      {
         if(this.loader)
         {
            this.loader.haltComplete = false;
         }
         if(this.redirectOnNewVersion && param1.success && Boolean(param1.data.newVersion))
         {
            this._redirect = true;
         }
         if(this.redirectOnHostBlocked && !param1.success && param1.error == APIEvent.ERROR_HOST_BLOCKED)
         {
            this._redirect = true;
         }
         if(this._redirect)
         {
            gotoAndStop("adPreloader");
            this.forceAlwaysOnTop();
         }
      }

      public function forceAlwaysOnTop() : void
      {
         var _loc1_:uint = 0;
         if(parent)
         {
            _loc1_ = parent.numChildren - 1;
            if(parent.getChildIndex(this) != _loc1_)
            {
               parent.setChildIndex(this,_loc1_);
            }
         }
         if(stage)
         {
            x = (stage.stageWidth - width) / 2;
            y = (stage.stageHeight - height) / 2;
            visible = true;
         }
         if(Boolean(root) && root is MovieClip)
         {
            MovieClip(root).stop();
         }
      }

      internal function __setProp_ad_APIConnector_AD_0(param1:int) : *
      {
        return

         if(this.ad != null && param1 >= 1 && param1 <= 21 && (this.__setPropDict[this.ad] == undefined || !(int(this.__setPropDict[this.ad]) >= 1 && int(this.__setPropDict[this.ad]) <= 21)))
         {
            this.__setPropDict[this.ad] = param1;
            try
            {
               this.ad["componentInspectorSetting"] = true;
            }
            catch(e:Error)
            {
            }
            this.ad.apiId = "";
            this.ad.showBorder = true;
            this.ad.adType = "Video";
            try
            {
               this.ad["componentInspectorSetting"] = false;
            }
            catch(e:Error)
            {
            }
         }
      }

      internal function __setProp_handler(param1:Object) : *
      {
         var _loc2_:int = int(currentFrame);
         if(this.__lastFrameProp == _loc2_)
         {
            return;
         }
         this.__lastFrameProp = _loc2_;
         this.__setProp_ad_APIConnector_AD_0(_loc2_);
      }

      internal function frame1() : *
      {
         stop();
        return
         if(Boolean(root) && root is MovieClip)
         {
            MovieClip(root).stop();
         }
         x = int(x);
         y = int(y);
         if(!this.debugMode)
         {
            this.debugMode = "Simulate Logged-in User";
         }
         if(!this.connectorType)
         {
            this.connectorType = "Flash Ad + Preloader";
         }
         if(!this.adType)
         {
            this.adType = "Video";
         }
         if(this.ad)
         {
            this.ad.adType = this.adType;
         }
         addEventListener(Event.ENTER_FRAME,this.initAd);
         if(this.connectorType == "Invisible")
         {
            visible = false;
         }
         this._apiConnect();
      }
   }
}

