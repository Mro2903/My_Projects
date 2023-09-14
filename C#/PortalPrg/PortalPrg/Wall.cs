using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PortalPrg
{
    class Wall
    {
        // x location
        int x;

        // y loc 
        int y;

        //if the wall is facing up or to the side
        bool up;

        //how long is the wall
        int length;

        //the color of the wall
        ConsoleColor Fcolor;


        public Wall(int x, int y, bool up, int length, ConsoleColor Fcolor)
        {
            this.x = x;
            this.y = y;
            this.up = up;
            this.length = length;
            this.Fcolor = Fcolor;
        }


        //set get for everything
        public void SetX(int x)
        {
            this.x = x;
        }

        public int GetX()
        {
            return this.x;
        }

        public void SetY(int y)
        {
            this.y = y;
        }

        public int GetY()
        {
            return this.y;
        }

        public void SetUp(bool up)
        {
            this.up = up;
        }

        public bool GetUp()
        {
            return this.up;
        }

        public void SetLength(int length)
        {
            this.length = length;
        }

        public int GetLength()
        {
            return this.length;
        }

        public void SetFcolor(ConsoleColor Fcolor)
        {
            this.Fcolor = Fcolor;
        }

        public ConsoleColor GetFcolor()
        {
            return this.Fcolor;
        }


        public void Draw() //draw the wall
        {
            this.DrawWallPath(this.Fcolor);
        }

        public void Undraw()//undraw the wall
        {
            this.DrawWallPath(ConsoleColor.Black);
        }

        private void DrawWallPath(ConsoleColor color)//helps the last 2 functions
        {

            Console.ForegroundColor = color;
            if (this.up)
            {
                for (int i = 0; i < length; i++)
                {
                    Console.SetCursorPosition(this.x, this.y + i);
                    Console.Write('║');

                }
            }
            else
            {
                for (int i = 0; i < length; i++)
                {
                    Console.SetCursorPosition(this.x + i , this.y);
                    Console.Write('═');
                }
            }

        }

        public bool WillColid(MTP mtp)//checks if an MTP is going to colid with a wall (gets an MTP gives bool)
        {
            if (!this.up)
            {
                return (this.y + 1 == mtp.GetY() && mtp.GetDirection() == 0) || (this.y - 1 == mtp.GetY() && mtp.GetDirection() == 4);
            }
            else
            {
                return (this.x + 1 == mtp.GetX() && mtp.GetDirection() == 6) || (this.x - 1 == mtp.GetX() && mtp.GetDirection() == 2);
            }
            
        }

        public override string ToString()
        {
            return "X:" + x + " Y:" + y + " length:" + length + " up?:" + up + " Color:" + Fcolor;
        }
    }
}
