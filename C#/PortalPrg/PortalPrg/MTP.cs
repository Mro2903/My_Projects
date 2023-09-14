using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PortalPrg
{
    class MTP // Moving Text Point
    {
        // Auther - Yossi Zahavi 2014
        // the char that will be on the screen 
        private char ch;

        // x y of the char
        private int x;
        private int y;

        // colors :  char and background
        private ConsoleColor Fcolor;
        private ConsoleColor Bcolor;

        // step size when the char move 
        private int speed;

        private Random rnd = new Random();

        // 8 directions (up is 0 up left is 1 lef is 2  till 8 )
        private int direction;

        // screen size
        int MAX_X = 79;
        int MAX_Y = 24;

        public MTP(int x, int y, int speed)
        {
            this.x = x;
            this.y = y;
            Fcolor = ConsoleColor.Black;
            Bcolor = ConsoleColor.White;
            this.direction = 2;
            this.speed = speed;
            ch = '?';
        }


        public MTP(int x, int y, char ch, ConsoleColor Fcolor, ConsoleColor Bcolor, int speed)
        {
            this.x = x;
            this.y = y;
            this.ch = ch;
            this.Fcolor = Fcolor;
            this.Bcolor = Bcolor;

            this.direction = rnd.Next(8);

            this.speed = speed;

            int MAX_X = Console.WindowWidth - 1;
            int MAX_Y = Console.WindowHeight - 1;
        }

        #region SetGet
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
        public void SetCh(char ch)
        {
            this.ch = ch;
        }
        public char GetCh()
        {
            return this.ch;
        }
        public void SetFcolor(ConsoleColor Fcolor)
        {
            this.Fcolor = Fcolor;
        }
        public ConsoleColor GetFcolor()
        {
            return this.Fcolor;
        }
        public void SetBcolor(ConsoleColor Bcolor)
        {
            this.Bcolor = Bcolor;
        }
        public ConsoleColor GetBcolor()
        {
            return this.Bcolor;
        }
        public void SetSpeed(int speed)
        {
            this.speed = speed;
        }
        public int GetSpeed()
        {
            return speed;
        }
        public void SetDirection(int direction)
        {
            this.direction = direction;
        }
        public int GetDirection()
        {
            return direction;
        }
        #endregion SetGet

        public void Draw()
        {
            Console.SetCursorPosition(this.x, this.y);

            Console.BackgroundColor = this.Bcolor;
            Console.ForegroundColor = this.Fcolor;

            Console.Write(this.ch);
            Console.SetCursorPosition(this.x, this.y);
        }

        public void Undraw()
        {
            Console.SetCursorPosition(this.x, this.y);
            Console.BackgroundColor = ConsoleColor.Black;
            Console.ForegroundColor = ConsoleColor.Black;
            Console.Write(' ');
        }



        public void RndMove(int chanceToChangeDirection)
        {
            int to_move = rnd.Next(100);

            if (to_move > 100 - chanceToChangeDirection)
            {
                direction = rnd.Next(8);

            }
            MoveOneStep();
        }



        public void MoveOneStep()
        {

            if (direction == 0)
                MoveUp();
            else if (direction == 1)
                MoveUpRight();
            else if (direction == 2)
                MoveRight();
            else if (direction == 3)
                MoveDownRight();
            else if (direction == 4)
                MoveDown();
            else if (direction == 5)
                MoveDownLeft();
            else if (direction == 6)
                MoveLeft();
            else if (direction == 7)
                MoveUpLeft();
        }

        #region  8 move methods 
        public void MoveUp()
        {
            if (this.y - this.speed >= 0)
                this.y -= this.speed;
            else
                OppositeDirection();
        }

        public void MoveDown()
        {
            if (this.y + this.speed <= MAX_Y)
                this.y += this.speed;
            else
                OppositeDirection();
        }

        public void MoveLeft()
        {
            if (x - this.speed >= 0)
                this.x -= this.speed;
            else
                OppositeDirection();
        }

        public void MoveRight()
        {
            if (x + this.speed <= MAX_X)
                this.x += this.speed;
            else
                OppositeDirection();
        }

        public void MoveUpLeft()
        {
            if (this.y - this.speed >= 0 && this.x - this.speed >= 0)
            {
                this.MoveUp();
                this.MoveLeft();
            }
            else
                OppositeDirection();
        }

        public void MoveDownRight()
        {
            if (this.y + this.speed <= MAX_Y && this.x + this.speed <= MAX_X)
            {
                this.MoveDown();
                this.MoveRight();
            }
            else
                OppositeDirection();
        }

        public void MoveUpRight()
        {
            if (this.y - this.speed >= 0 && this.x + this.speed <= MAX_X)
            {
                this.MoveUp();
                this.MoveRight();
            }
            else
                OppositeDirection();
        }

        public void MoveDownLeft()
        {
            if (this.y + this.speed <= MAX_Y && x - this.speed >= 0)
            {
                this.MoveDown();
                this.MoveLeft();
            }
            else
                OppositeDirection();
        }
        #endregion



        public void OppositeDirection()
        {

            /*
             * 
             * if (directin == 0)
             *      direction = 4;
             * else if ((directin == 1)
             *      direction = 5;
            * else if ((directin == 2)
             *      direction = 6;
            * else if ((directin == 3)
             *      direction = 7;
            * else if ((directin == 4)
             *      direction = 0;
            * else if ((directin == 5)
             *      direction = 1;
            * else if ((directin == 6)
             *      direction = 2;
             * else if ((directin == 7)
             *      direction = 3;
             * 
             */

            this.direction = (this.direction + 4) % 8;
        }

        public bool WillColid(MTP mtp)//checks if an MTP is going to colid with an MTP (gets an MTP gives bool)
        {
            return (this.y  == mtp.GetY() && this.x + 1 == mtp.GetX() && mtp.GetDirection() == 6) || (this.y == mtp.GetY() && this.x - 1 == mtp.GetX() && mtp.GetDirection() == 2) || (this.x == mtp.GetX() && this.y + 1 == mtp.GetY() && mtp.GetDirection() == 0) || (this.x == mtp.GetX() && this.y - 1 == mtp.GetY() && mtp.GetDirection() == 4);
        }

        


        public override string ToString()
        {
            string s = "";
            s += " x:" + x;
            s += " y:" + y;
            s += " Fcolor:" + Fcolor;
            s += " Bcolor:" + Bcolor;
            s += " speed:" + speed;
            s += " direction:" + direction;
            return s;
        }

    }
}
