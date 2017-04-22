
#include <sys/time.h>
#include <time.h>
#include <sys/types.h>
#include <stdio.h>
#include <unistd.h>

int main()
{
  struct timeval v;

  gettimeofday(&v, NULL);

  printf("%lld\n", v.tv_sec * 1000000LL+ v.tv_usec);

  return 0;
}
