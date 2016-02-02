#include <stdio.h>

int main()
{
  __block int i = 100;
  void (^block2)(void) = ^{
	printf("%d\n", i);
	i = 1023;
  };
  block2();

  return 0;
}
