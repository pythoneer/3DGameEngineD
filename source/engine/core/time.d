module engine.core.time;

import std.datetime;

class Time
{
	public static final double SECOND = 10000000L;

	public static double getTime()
	{
		return cast(double)Clock.currStdTime()/cast(double)SECOND;
	}
}

