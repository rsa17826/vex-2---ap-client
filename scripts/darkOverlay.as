package
{
  import flash.display.MovieClip;

  [Embed(source="/_assets/assets.swf", symbol="symbol1289")]
  public dynamic class darkOverlay extends MovieClip
  {

    public function darkOverlay(...a)
    {
      super();
      if (a[0] == true)
      {
        stop();
      }
      else
      {
        addFrameScript(29, this.frame30);
      }
    }

    internal function frame30():*
    {
      stop();
    }
  }
}
