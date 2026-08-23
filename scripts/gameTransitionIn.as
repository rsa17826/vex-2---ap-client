package
{
  import adobe.utils.*;
  import fl.motion.AnimatorFactory3D;
  import fl.motion.MotionBase;
  import fl.motion.motion_internal;
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

  [Embed(source="/_assets/assets.swf", symbol="symbol1262")]
  public dynamic class gameTransitionIn extends MovieClip
  {

    public var __id1_:MovieClip;

    public var __animFactory___id1_af1:AnimatorFactory3D;

    public var __animArray___id1_af1:Array;

    public var ____motion___id1_af1_mat3DVec__:Vector.<Number>;

    public var ____motion___id1_af1_matArray__:Array;

    public var __motion___id1_af1:MotionBase;

    public function gameTransitionIn()
    {
      super();
      gotoAndStop(30);
      return;
      addFrameScript(29, this.frame30);
      if (this.__animFactory___id1_af1 == null)
      {
        this.__animArray___id1_af1 = new Array();
        this.__motion___id1_af1 = new MotionBase();
        this.__motion___id1_af1.duration = 3;
        this.__motion___id1_af1.overrideTargetTransform();
        this.__motion___id1_af1.addPropertyArray("visible", [true, true, true]);
        this.__motion___id1_af1.addPropertyArray("cacheAsBitmap", [false, false, false]);
        this.__motion___id1_af1.addPropertyArray("blendMode", ["normal", "normal", "normal"]);
        this.__motion___id1_af1.addPropertyArray("opaqueBackground", [null, null, null]);
        this.__motion___id1_af1.is3D = true;
        this.__motion___id1_af1.motion_internal::spanStart = 0;
        this.____motion___id1_af1_matArray__ = new Array();
        this.____motion___id1_af1_mat3DVec__ = new Vector.<Number>(16);
        this.____motion___id1_af1_mat3DVec__[0] = -0.9655;
        this.____motion___id1_af1_mat3DVec__[1] = 0;
        this.____motion___id1_af1_mat3DVec__[2] = 0;
        this.____motion___id1_af1_mat3DVec__[3] = 0;
        this.____motion___id1_af1_mat3DVec__[4] = 0;
        this.____motion___id1_af1_mat3DVec__[5] = 1;
        this.____motion___id1_af1_mat3DVec__[6] = 0;
        this.____motion___id1_af1_mat3DVec__[7] = 0;
        this.____motion___id1_af1_mat3DVec__[8] = 0;
        this.____motion___id1_af1_mat3DVec__[9] = 0;
        this.____motion___id1_af1_mat3DVec__[10] = -1;
        this.____motion___id1_af1_mat3DVec__[11] = 0;
        this.____motion___id1_af1_mat3DVec__[12] = 200.050003;
        this.____motion___id1_af1_mat3DVec__[13] = 0;
        this.____motion___id1_af1_mat3DVec__[14] = -0.000005;
        this.____motion___id1_af1_mat3DVec__[15] = 1;
        this.____motion___id1_af1_matArray__.push(new Matrix3D(this.____motion___id1_af1_mat3DVec__));
        this.____motion___id1_af1_matArray__.push(null);
        this.____motion___id1_af1_matArray__.push(null);
        this.__motion___id1_af1.addPropertyArray("matrix3D", this.____motion___id1_af1_matArray__);
        this.__animArray___id1_af1.push(this.__motion___id1_af1);
        this.__animFactory___id1_af1 = new AnimatorFactory3D(null, this.__animArray___id1_af1);
        this.__animFactory___id1_af1.addTargetInfo(this, "__id1_", 0, true, 0, true, null, -1);
      }
    }

    internal function frame30():*
    {
      stop();
    }
  }
}
