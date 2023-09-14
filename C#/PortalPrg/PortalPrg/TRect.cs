using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PortalPrg
{
    class TRect
    {
        // Auther - Yossi Zahavi 2014

        // x location
        int x;

        // y loc 
        int y;

        double width;

        double height;

        ConsoleColor Fcolor;



        public TRect(int x, int y, double width, double height, ConsoleColor c)
        {
            this.x = x;
            this.y = y;
            this.width = width;
            this.height = height;
            this.Fcolor = c;
        }




        public TRect()
        {
            this.x = 10;
            this.y = 10;
            this.width = 10;
            this.height = 20;
            this.Fcolor = ConsoleColor.White;
        }


        public void SetX(int x)
        {
            this.x = x;
        }

        public int GetX()
        {
            return x;
        }

        public void SetY(int y)
        {
            this.y = y;
        }

        public int GetY()
        {
            return y;
        }

        public void SetWidth(double w)
        {
            this.width = w;
        }

        public double GetWidth()
        {
            return this.width;
        }

        public void SetHeight(double h)
        {
            this.height = h;
        }

        public double Getheight()
        {
            return this.height;
        }



        public void SetFcolor(ConsoleColor Fcolor)
        {
            this.Fcolor = Fcolor;
        }

        public ConsoleColor GetFcolor()
        {
            return this.Fcolor;
        }


        public double GetArea()
        {
            return this.height * this.width;
        }

        public double GetPerimeter()
        {
            return 2 * this.height + 2 * this.width;
        }

        public double GetDiagonal()
        {
            return Math.Sqrt(this.width * this.width + this.height * this.height);
        }


        public void Draw()
        {
            this.DrawRectPath(this.Fcolor);
        }

        public void Undraw()
        {
            this.DrawRectPath(ConsoleColor.Black);
        }

        private void DrawRectPath(ConsoleColor color)
        {
            ConsoleColor hold = Console.ForegroundColor;

            Console.ForegroundColor = color;
            Console.SetCursorPosition(this.x, this.y);
            int line = this.y;
            int width = (int)this.width;
            int height = (int)this.height;

            if (width > 0 && height > 0)
            {
                Console.Write('╔');
                for (int i = 1; i < width - 1; i++)
                    Console.Write('═');
                if (this.width >= 2)
                    Console.Write('╗');
                for (int i = 1; i < height - 1; i++)
                {
                    line++;
                    Console.SetCursorPosition(this.x, line);
                    Console.Write('║');
                    Console.SetCursorPosition(this.x + width - 1, line);
                    Console.Write('║');
                }
                if (height >= 2)
                {
                    line++;
                    Console.SetCursorPosition(this.x, line);

                    Console.Write('╚');
                    for (int i = 1; i < width - 1; i++)
                        Console.Write('═');
                    if (width >= 2)
                        Console.Write('╝');
                }

            }
            Console.ForegroundColor = hold;
        }


        public bool InTrectX(int x)//check if an x is insaide a Trect (gets x gives bool)
        {

            
            return x > this.GetX() + 1 && x < this.GetX() + this.GetWidth() - 2;

        }


        public bool InTrectY(int y)//check if an y is insaide a Trect (gets y gives bool)
        {
            return y > this.GetY()+1  && y < this.GetY() + this.Getheight() - 2;
        }

        public bool TouchTRectInside(int x,int y)
        {
            return (x == this.GetX() + this.GetWidth() - 2 || x == this.GetX() + 1) || (y == this.GetY() + this.Getheight() - 2 || y == this.GetY() + 1);
        }








        public override string ToString()
        {
            return "X:" + x + " Y:" + y + " Width:" + width + " Height:" + height + " Color:" + Fcolor;
        }
    }
}
