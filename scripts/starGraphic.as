package
{
  import flash.display.MovieClip;
  import flash.events.Event;
  import flash.external.ExternalInterface;

  [Embed(source="/_assets/assets.swf", symbol="symbol1591")]
  public class starGraphic extends MovieClip
  {

    public var main:MovieClip;

    public var player:MovieClip;

    public var star:MovieClip;

    public var starNumber:int;

    public function starGraphic()
    {
      super();
      addEventListener(Event.ADDED_TO_STAGE, this.pushArray);
    }

    public function update():void
    {
      var _loc1_:int = 0;
      var _loc2_:* = undefined;
      if (parent is level)
      {
        if (!this.main["savedAct" + this.main.act + "Stars"][this.starNumber])
        {
          this.player = MovieClip(parent).player;
          if (this.hitTestObject(this.player))
          {
            if (visible)
            {
              this.main["savedAct" + this.main.act + "Stars"][this.starNumber] = true;
              _loc1_ = 0;
              while (_loc1_ < 15)
              {
                if (Math.random() < 0.5)
                {
                  _loc2_ = new particle(16763955);
                }
                else
                {
                  _loc2_ = new particle(16777113);
                }
                _loc2_.x = x;
                _loc2_.y = y;
                _loc2_.xSpeed = Math.random() * 16 - 8;
                _loc2_.ySpeed = Math.random() * 16 - 8;
                parent.addChild(_loc2_);
                _loc1_++;
              }
              visible = false;
              ++this.main.stats[4];
              this.main.incAchievement(14, 1);
              this.main.incAchievement(15, 1);
              this.main.incAchievement(16, 1);
              this.main.submitKongStars();
              this.main.playSound("starPickup", false);

              trace("STAR COLLECTED - about to call newItem");
              ExternalInterface.call("newItem", "stage" + (this.main.act == 0 ? 0 : this.main.act - 1) + " - star:" + this.starNumber);
            }
          }
        }
        else
        {
          visible = false;
        }
      }
    }

    private function pushArray(param1:Event):void
    {
      if (this)
      {
        this.main = MovieClip(root);
        MovieClip(root).stars.push(this);
        removeEventListener(Event.ADDED_TO_STAGE, this.pushArray);
      }
    }
  }
}