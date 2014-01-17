#include <math.h>
#include <stdio.h>

#define SAMPLINGFREQUENCY 1000000
#define SPEEDOFSOUNDINWATER 343.2
#define pi 3.141592

/*

Take SinHertz, distanceFromPinger(m), pulseTime(s), arrayLength, timeBetweenPulses(s) and an array c.

Let timeDelay = distanceFromPinger / SPEEDOFSOUNDINWATER

Until i = arrayLength:

	Put zero into c until i = timeDelay*SAMPLINGFREQUENCY.

	Then put in pulseTime*SAMPLINGFREQUENCY data entries that vary depending on SinHertz, and distanceFromPinger 
	c[i]= sin(2piSinHertz(i-(timeDelay+n*timeBetweenPulses*SAMPLEINGFREQUENCY))) / (distanceFromPinger*distanceFromPinger)
	where n=number of pulses found

	(We are using Inverse Squared Law as found on http://en.wikipedia.org/wiki/Underwater_acoustics#Propagation_of_sound 
	and http://en.wikipedia.org/wiki/Near_and_far_field.)

	When we get out of pulseTime, add n by 1.


*/

int main (void)
{
	double SinHertz = 22000, distanceFromPinger = 1, pulseTime = 1.3e-3, timeBetweenPulses = 2;
	int arrayLength = 30000;
	
	int i = 0;
	int n = 0;
	
	double timeDelay = distanceFromPinger / SPEEDOFSOUNDINWATER * SAMPLINGFREQUENCY;
	
	for ( ; i < arrayLength; i++)
	{
		double masterShift = timeDelay + n*timeBetweenPulses*SAMPLEINGFREQUENCY;
		if (i < masterShift)
		{
			c[i] = 0.0;
		}
		else
		{
			for( ; (i - mastershift) < (pulseTime*SAMPLINGFREQUENCY) ; )
			{
				c[i] = ( sin(2*pi*SinHertz(i - masterShift)) / (distance * distance) );
			}
			n++;
		}
		
		printf("%d) %g", i, c[i]);
	}
	
	return 0;
}
