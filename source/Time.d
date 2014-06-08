module time;

import std.datetime;

class Time
{
	this()
	{
		// Constructor code
	}


	public static final long SECOND = 10000000L;
	
	private static double delta;
	
	public static long getTime()
	{
		return Clock.currStdTime();
	}
	
	public static double getDelta()
	{
		return delta;
	}
	
	public static void setDelta(double delta)
	{
		Time.delta = delta;
	}

}

