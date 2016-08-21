#include <iostream>
#include <strstream>

const int mem   = 16*1024*1024;
const int depth = 32;
const int minh  = 29000;
const int maxh  = 82000;
const int minv  = 47;
const int maxv  = 90;
const int maxp  = 135000000;
const int minp  =  30000000;

int main(int argc, char** argv)
{
  if (argc != 2)
    {
      cout << "You must specify the x size" << endl;
      return -1;
    }

  int x = 0;

  {
    istrstream is(argv[1]);

    is >> x;
  }

  x = ((x + 3) >> 3) << 3;

  int y           = 3 * x / 4;
  int used_memory = x * y / 8 * depth;

  if (used_memory > mem)
    {
      cout << "Too many memory requirements" << endl;
      return -1;
    }

  int hfreq   = 0;
  int vfreq   = 0;
  int returnh = 0;
  int returnv = 0;
  int pixfreq = 0;

  for(pixfreq = maxp;
      pixfreq > minp;
      pixfreq -= 1000)
    {
      returnh     = ((x * 13 / 10 + 7) >> 3) << 3;
      returnv     = y * 26 / 25;

      hfreq = pixfreq / returnh;
      vfreq = hfreq   / returnv;

      if (!((hfreq < minh) || (hfreq > maxh) ||
            (vfreq < minv) || (vfreq > maxv)))
        break;

      returnh = 0;
      returnv = 0;
      hfreq   = 0;
      vfreq   = 0;
    }

  cout << "Used memory    : " << used_memory << endl;
  cout << "Horizontal Freq: " << hfreq << endl;
  cout << "Vertical   Freq: " << vfreq << endl;

  int xa = ((x * 21 / 20 + 3) >> 3) << 3;
  int xb = ((x * 28 / 25 + 3) >> 3) << 3;
  int ya = y + 4;
  int yb = y + 8;

  cout << '"' << x << 'x' << y << "\" " << double(pixfreq) / 1000000 << ' '
       << x << ' ' << xa << ' ' << xb << ' ' << returnh << "  "
       << y << ' ' << ya << ' ' << yb << ' ' << returnv << endl;
}
