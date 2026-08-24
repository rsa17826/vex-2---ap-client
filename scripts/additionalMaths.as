package
{
  public class additionalMaths
  {

    public function additionalMaths()
    {
      super();
    }

    public static function easeToPoint(param1:Object, param2:int = 0, param3:int = 0, param4:int = 5, ...a):*
    {
      var _loc5_:Number = param2 - param1.x;
      var _loc6_:Number = param3 - param1.y;
      var _loc7_:Number = Math.atan2(_loc6_, _loc5_) / Math.PI * 180;
      var _loc8_:Number = Number(Math.round(Math.sqrt(_loc5_ * _loc5_ + _loc6_ * _loc6_)));
      param1.x += Math.cos(_loc7_ / 180 * Math.PI) * (_loc8_ / param4);
      param1.y += Math.sin(_loc7_ / 180 * Math.PI) * (_loc8_ / param4);
      if (_loc8_ <= 0.5 || !a[0])
      {
        param1.y = param3;
        param1.x = param2;
      }
    }

    public static function getDistance(param1:Object, param2:Object):int
    {
      var _loc3_:Number = param2.x - param1.x;
      var _loc4_:Number = param2.y - param1.y;
      return int(Math.round(Math.sqrt(_loc3_ * _loc3_ + _loc4_ * _loc4_)));
    }

    public static function getDistanceOffset(param1:Object, param2:Object, param3:int, param4:int):int
    {
      var _loc5_:Number = param2.x - (param1.x + param3);
      var _loc6_:Number = param2.y - (param1.y + param4);
      return int(Math.round(Math.sqrt(_loc5_ * _loc5_ + _loc6_ * _loc6_)));
    }

    public static function aimAt(param1:Object, param2:Object):int
    {
      var _loc3_:Number = param2.x - param1.x;
      var _loc4_:Number = param2.y - param1.y;
      return int(Math.atan2(_loc4_, _loc3_) / Math.PI * 180 - 90);
    }

    public static function aimAt2(param1:Object, param2:Object, param3:Number = 0, param4:Number = 0):int
    {
      var _loc5_:Number = param2.x + param3 - param1.x;
      var _loc6_:Number = param2.y + param4 - param1.y;
      return int(Math.atan2(_loc6_, _loc5_) / Math.PI * 180 - 90);
    }

    public static function roundToNumber(param1:Number = 0, param2:Number = 0):int
    {
      param1 = Number(Math.round(param1));
      if (param1 % param2 > 0)
      {
        if (param1 % param2 >= param2 / 2)
        {
          param1 += param2 - param1 % param2;
        }
        else
        {
          param1 -= param1 % param2;
        }
      }
      else if (param1 % param2 < 0)
      {
        if (param1 % param2 >= param2 / 2 - param2)
        {
          param1 += param2 - param1 % param2;
        }
        else
        {
          param1 -= param1 % param2;
        }
        param1 -= param2;
      }
      return param1;
    }

    public static function angleBetween(param1:Object, param2:Object):Number
    {
      var _loc3_:Number = param2.x - param1.x;
      var _loc4_:Number = param2.y - param1.y;
      return Math.atan2(_loc4_, _loc3_) / Math.PI * 180;
    }
  }
}
