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
	double SinHertz = 22000, distanceFromPinger = 10.5, pulseTime = 0.0013, timeBetweenPulses = 2;
	int arrayLength = 70000;
        
        double c[arrayLength];
	
	int i = 0;
	int n = 0;
        
        FILE* OutputToMatLab = fopen( "MatLabOutput.csv", "w");
	
	double timeDelay = distanceFromPinger / SPEEDOFSOUNDINWATER * SAMPLINGFREQUENCY;
	
	for ( ; i < arrayLength; i++)
	{
		double masterShift = (timeDelay + n*timeBetweenPulses*SAMPLINGFREQUENCY);
		if (i < (int)masterShift)
		{
			c[i] = 0.0;
		}
		else
		{
			for( ; (i - (int)masterShift) <= (int)(pulseTime*SAMPLINGFREQUENCY) ; i++)
			{
				c[i] = ( sin(2*pi*SinHertz*(i - masterShift)) / (distanceFromPinger * distanceFromPinger) );
                                //printf("%d) %g ", i, c[i]);
                                fprintf(OutputToMatLab, "%d, %g\n", i, c[i]);
			}
			n++;
		}
		
		//printf("%d) %g ", i, c[i]);
                fprintf(OutputToMatLab, "%d, %g\n", i, c[i]);
	}
	
	return 0;
}
