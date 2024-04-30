#include <stdio.h>
int main() 
{
int SMALLER;
int BIGGER;
int TEMP;
bool TEMP1;
{
int i; scanf("%d", &i);BIGGER = i;
}
{
int i; scanf("%d", &i);SMALLER = i;
}
if(SMALLER>BIGGER)
{
TEMP = SMALLER;
TEMP1 = -2147483648;
SMALLER = BIGGER;
BIGGER = TEMP;
}
else
{

}
while(SMALLER>0)
{
BIGGER = BIGGER-SMALLER;
if(SMALLER>BIGGER)
{
TEMP = SMALLER;
SMALLER = BIGGER;
BIGGER = TEMP;
}
else
{

}

}
printf("%d\n", BIGGER);
return 0;
}
