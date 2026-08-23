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

  [Embed(source="/_assets/assets.swf", symbol="symbol808")]
  public dynamic class spawnMask_224 extends MovieClip
  {

    public function spawnMask_224()
    {
      super();
      addFrameScript(59, this.frame60);
      gotoAndPlay(59);
      this.frame60();
    }

    internal function frame60():*
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
