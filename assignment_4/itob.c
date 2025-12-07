// itob.c
void itob(int x, char* itob_str)
{
  itob_str[0]='0';
  itob_str[1]='b';
  int i;
  for (i=0; i<32; i++) {
    itob_str[i+2] = '0' + ((x & 0b10000000000000000000000000000000) >> 31);
    x <<= 1;
  }
}