#include <iostream>
#include <fstream>

int main (int argc, char** argv)
{
  const unsigned int zero  = 0;
  unsigned int       i;
  unsigned int       blank = 0;
  bool               first = true;
  unsigned int       count = 0;
  
  struct Header
  {
    char           name[4];
    unsigned int   size;
    char           type[8];
    unsigned short a;
    unsigned short b;
    unsigned short channels;
    unsigned short frequency;
    unsigned short d;
    unsigned short e;
    unsigned short f;
    unsigned short g;
    unsigned short h;
    char           data[4];
    unsigned int   length;
  };
  
  Header header;
  
  ifstream in(argv[1], ios::in|ios::binary);
  ofstream out(argv[2], ios::out|ios::binary);
  
  in.read(&header, sizeof(header));
  header.size   = 0;
  header.length = 0;
  out.write(&header, sizeof(header));
  
  for(;;)
    {
      in.read(&i, sizeof(i));
      
      if (!in)
        break;
      
      if (i == 0)
        blank++;
      else
	{
	  if (!first)
	    for (;
		 blank != 0;
		 blank--)
	      {
		out.write(&zero, sizeof(i));
		count++;
	      }
	  else
	    blank = 0;
	  
	  first = false;
	  out.write(&i, sizeof(i));
	  count++;
	}
    }
  
  header.length = count*sizeof(i);
  header.size   = header.length + sizeof(header) - sizeof(header.name) - sizeof(header.size);
  
  out.seekp(0, ios::beg);
  out.write(&header, sizeof(header));
  
  in.close();
  out.close();
  
  return 0;
}
