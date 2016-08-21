#include <iostream>
#include <string>
#include <cstring>
#include <cstdio>

int main (void)
{
  char   buffer[1000];
  char*  data = NULL;
  int    number = 0;
  int    old_number = 0;
  string old_title;
  
  while (!!cin)
    {
      cin.getline(buffer, sizeof(buffer), '\n');
      
      if (strncmp(buffer, "TTITLE", 6) == 0)
	{
	  number = int(strtol(&(buffer[6]), &data, 10));
	  
	  if (number == old_number)
	    old_title += &(data[1]);
	  else
	    {
	      if (!old_title.empty())
		{
		  while(isspace(old_title[0]))
		    old_title = old_title.substr(1);
		  
		  while(isspace(old_title[old_title.length() - 1]))
		    old_title = old_title.substr(0, old_title.length() - 1);
		  
		  cout << old_title << endl;
		}
	      
	      old_title = &(data[1]);
	    }
	  
	  old_number = number;
	}
    }
  
  if (!old_title.empty())
    {
      while(isspace(old_title[0]))
	old_title = old_title.substr(1);
      
      while(isspace(old_title[old_title.length() - 1]))
	old_title = old_title.substr(0, old_title.length() - 1);
      
      cout << old_title << endl;
    }
  
  return 0;
}
