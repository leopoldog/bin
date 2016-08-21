#include <string>
#include <fstream>
#include <cstdio>

static char buffer[100000];

int main (int    argc,
	  char** argv)
{
  if (argc == 1)
    return 1;
  
  if (argv[1][0] == '1')
    {
      int      number = 0;
      ofstream f;
      bool     open = false;
      
      for(;;)
	{
	  cin.getline(buffer, sizeof(buffer));
	  
	  if (!cin)
	    break;
	  
	  if (strcmp(buffer, "From aaa@aaa Mon Jan 01 00:00:00 1997") == 0)
	    {
	      if (open)
		f.close();
	      
	      char name[20];
	      
	      sprintf(name, "mail_%04d.msg", number++);
	      
	      f.open(name);
	      open = true;
	    }
	  
	  f << buffer << endl;
	}
      
      if (open)
	f.close();
    }
  else if (argv[1][0] == '2')
    {
      char md5[100];
      char file[500];
      char oldmd5[100];
      
      oldmd5[0] = '\0';
      
      for (;;)
	{
	  cin.getline(buffer, sizeof(buffer));
	  
	  if (!cin)
	    break;
	  
	  sscanf(buffer, "%s %s", &md5, &file);
	  
	  if (strcmp(md5, oldmd5) == 0)
	    cout << file << ' ';
	  else
	    strcpy(oldmd5, md5);
	}
      
      cout << endl;
    }
  else
    return 1;
  
  return 0;
}
