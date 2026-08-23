package vex2_fla
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

  [Embed(source="/_assets/assets.swf", symbol="symbol810")]
  public dynamic class spawnMaskFast_226 extends MovieClip
  {

    public function spawnMaskFast_226()
    {
      super();
      addFrameScript(19, this.frame20);
      gotoAndPlay(19);
      this.frame20();
    }

    internal function frame20():*
    {
      if (parent)
      {
        if (this)
        {
          if (root)
          {
            if (MovieClip(root).level)
            {
              MovieClip(root).level.player.decideSpawnFrame();
            }
          }
        }
      }
    }
  }
}
