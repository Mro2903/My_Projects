using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace PortalPrg
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.SetCursorPosition(0, 25);
            Console.WriteLine("a game by omri bareket");




            TRect Frame = new TRect(0,0, 50, 20, ConsoleColor.Gray); //lines 20-30 static objects for the game
            Frame.Draw();

            Wall Window1 = new Wall(79, 1, true, (int)Frame.Getheight() - 2, ConsoleColor.DarkYellow);
            Wall Window2 = new Wall(1, 25, false, (int)Frame.GetWidth() - 2, ConsoleColor.DarkYellow);

            Wall Door1 = new Wall(79, 1, true, (int)Frame.Getheight() - 2, ConsoleColor.DarkRed);
            MTP open1 = new MTP(79, 25, '█', ConsoleColor.DarkRed, ConsoleColor.Black, 0);

            Wall Door2 = new Wall(1, 25, false, (int)Frame.GetWidth() - 2, ConsoleColor.DarkGreen);
            MTP open2 = new MTP(79, 25, '█', ConsoleColor.DarkGreen, ConsoleColor.Black, 0);


            Console.SetCursorPosition(50, 0);//lines 33-46 the first rules (rules are added in lines 67 and 80 )
            Console.WriteLine("b - blue portal");
            Console.SetCursorPosition(50, 1);
            Console.WriteLine("o - orange portal");
            Console.SetCursorPosition(50, 2);
            Console.WriteLine("Up Arrow/Left Arrow/Down Arrow/Right Arrow - move the player");
            Console.SetCursorPosition(50, 3);
            Console.WriteLine("Rules: ");
            Console.SetCursorPosition(50, 4);
            Console.WriteLine("1) in order to win levels your player have to step on the green spot");
            Console.SetCursorPosition(50, 5);
            Console.WriteLine("2) you can't shoot portals next to walls(corner portals are imposible)");
            Console.SetCursorPosition(50, 9);
            Console.WriteLine("if you will win all levels I will grant you a prize");
            Console.CursorVisible = false;


            MTP Player = new MTP(1, 1, '█', ConsoleColor.White, ConsoleColor.Black, 1); //lines 50-55 are the main objects of the game

            MTP BluePortal = new MTP(79, 25, '█', ConsoleColor.Blue, ConsoleColor.Black, 1);
            MTP OrangePortal = new MTP(79, 25, '█', ConsoleColor.Red, ConsoleColor.Black, 1);

            MTP EndLevel = new MTP(48, 18, '█', ConsoleColor.Green, ConsoleColor.Black, 1);


            for (int i = 1; i <= 7; i++)//7 levles
            {
                bool LevelComplete = false;

                EndLevel.Draw();                //for every levle diffrent objects on the screen (unused object arenwt in the frame)
                if (i == 2)
                {
                    Console.SetCursorPosition(50, 6);
                    Console.ForegroundColor = ConsoleColor.White;
                    Console.WriteLine("3) you can't walk throught windows but you can shoot throught them");
                    Window1.SetX(25);
                    Window1.Draw();

                }
                else if(i == 3)
                {
                    Window2.SetY(10);
                    Window2.Draw();
                }else if(i == 4)
                {
                    Console.SetCursorPosition(50, 7);
                    Console.ForegroundColor = ConsoleColor.White;
                    Console.WriteLine("4) you can't walk throught Doors, press the buttons to open them");
                    Window1.Undraw();
                    Window1.SetX(79);
                    Window2.Undraw();
                    Window2.SetY(25);
                    Door1.SetX(25);
                    Door1.Draw();
                    open1.SetX(12);
                    open1.SetY(15);
                    open1.Draw();
                }
                else if(i == 5)
                {
                    Door1.SetX(25);
                    Door1.Draw();
                    open1.SetX(12);
                    open1.SetY(15);
                    open1.Draw();
                    Door2.SetY(17);
                    Door2.Draw();
                    open2.SetX(48);
                    open2.SetY(1);
                    open2.Draw();
                }
                else if(i == 6)
                {
                    Window2.SetY(10);
                    Window2.Draw();
                    Door1.SetX(25);
                    Door1.Draw();
                    open1.SetX(12);
                    open1.SetY(15);
                    open1.Draw();
                }
                else if(i == 7)
                {
                    Window1.SetX(25);
                    Window1.Draw();
                    Door1.SetX(40);
                    Door1.Draw();
                    open1.SetX(12);
                    open1.SetY(15);
                    open1.Draw();
                    Door2.SetY(17);
                    Door2.Draw();
                    open2.SetX(48);
                    open2.SetY(1);
                    open2.Draw();
                }
                Frame.Draw();
                
                Console.SetCursorPosition(79,25);//makes sure that when u press a key it will not override the object u just drew
                while (!LevelComplete)//keeps playing while the level is not completed
                {
                    Player.Draw();//draws palyer every frame
                    if (Console.KeyAvailable)//gets player's input 
                    {
                        ConsoleKeyInfo k = Console.ReadKey();

                        Player.Undraw();
                        if (k.Key == ConsoleKey.UpArrow && Player.GetY() > Frame.GetY() + 1 ) //cheks if the player can move up (nothing is blocking him and if he is going to colid with a portal)
                        {
                            Player.SetDirection(0);
                            if (OrangePortal.WillColid(Player)  )
                            {
                                if (BluePortal.GetY() == 25)//in case the blue portal isn't on the screen and the player is going to colid with the orange one
                                {
                                    continue;
                                }
                                else
                                {
                                    Player.SetDirection(BluePortal.GetDirection());
                                    Player.SetX(BluePortal.GetX());
                                    Player.SetY(BluePortal.GetY());
                                    Player.MoveOneStep();
                                }
                            }
                            else if (BluePortal.WillColid(Player))
                            {
                                if(OrangePortal.GetY() == 25)//in case the orange portal isn't on the screen and the player is going to colid with the blue one
                                {
                                    continue;
                                }
                                else
                                {
                                    Player.SetDirection(OrangePortal.GetDirection());
                                    Player.SetX(OrangePortal.GetX());
                                    Player.SetY(OrangePortal.GetY());
                                    Player.MoveOneStep();
                                }

                            }
                            else if (!Window2.WillColid(Player) && !Door2.WillColid(Player))//chacks if the player is going to colid with a door
                            {
                                Player.MoveUp();
                            }
                        }//the same of all of the other directions
                        else if (k.Key == ConsoleKey.LeftArrow && Player.GetX() > Frame.GetX() + 1 )
                        {
                            Player.SetDirection(6);
                            if (OrangePortal.WillColid(Player))
                            {
                                if (BluePortal.GetY() == 25)
                                {
                                    continue;
                                }
                                else
                                {
                                    Player.SetDirection(BluePortal.GetDirection());
                                    Player.SetX(BluePortal.GetX());
                                    Player.SetY(BluePortal.GetY());
                                    Player.MoveOneStep();
                                }
                            }
                            else if (BluePortal.WillColid(Player))
                            {
                                if (OrangePortal.GetY() == 25)
                                {
                                    continue;
                                }
                                else
                                {
                                    Player.SetDirection(OrangePortal.GetDirection());
                                    Player.SetX(OrangePortal.GetX());
                                    Player.SetY(OrangePortal.GetY());
                                    Player.MoveOneStep();
                                }

                            }
                            else if (!Window1.WillColid(Player) && !Door1.WillColid(Player))
                            {
                                Player.MoveLeft();
                            }
                        }
                        else if (k.Key == ConsoleKey.DownArrow && Player.GetY() < Frame.GetY() + Frame.Getheight() - 2)
                        {
                            Player.SetDirection(4);

                            if (OrangePortal.WillColid(Player))
                            {
                                if (BluePortal.GetY() == 25)
                                {
                                    continue;
                                }
                                else
                                {
                                    Player.SetDirection(BluePortal.GetDirection());
                                    Player.SetX(BluePortal.GetX());
                                    Player.SetY(BluePortal.GetY());
                                    Player.MoveOneStep();
                                }
                            }
                            else if (BluePortal.WillColid(Player))
                            {
                                if (OrangePortal.GetY() == 25)
                                {
                                    continue;
                                }
                                else
                                {
                                    Player.SetDirection(OrangePortal.GetDirection());
                                    Player.SetX(OrangePortal.GetX());
                                    Player.SetY(OrangePortal.GetY());
                                    Player.MoveOneStep();
                                }

                            }
                            else if (!Window2.WillColid(Player) && !Door2.WillColid(Player))
                            {
                                Player.MoveDown();
                            }
                        }
                        else if (k.Key == ConsoleKey.RightArrow && Player.GetX() < Frame.GetX() + Frame.GetWidth() - 2 )
                        {
                            Player.SetDirection(2);
                            if (OrangePortal.WillColid(Player))
                            {
                                if (BluePortal.GetY() == 25)
                                {
                                    continue;
                                }
                                else
                                {
                                    Player.SetDirection(BluePortal.GetDirection());
                                    Player.SetX(BluePortal.GetX());
                                    Player.SetY(BluePortal.GetY());
                                    Player.MoveOneStep();
                                }
                            }
                            else if (BluePortal.WillColid(Player))
                            {
                                if (OrangePortal.GetY() == 25)
                                {
                                    continue;
                                }
                                else
                                {
                                    Player.SetDirection(OrangePortal.GetDirection());
                                    Player.SetX(OrangePortal.GetX());
                                    Player.SetY(OrangePortal.GetY());
                                    Player.MoveOneStep();
                                }

                            }
                            else if (!Window1.WillColid(Player) && !Door1.WillColid(Player))
                            {
                                Player.MoveRight();
                            }
                        }
                        else if (k.Key == ConsoleKey.B && !Frame.TouchTRectInside(Player.GetX(), Player.GetY()))//if player shoots the blue portal
                        {
                            BluePortal.Undraw();
                            BluePortal.SetDirection(Player.GetDirection()); //gets the portal to the players location and sets his direction to the one of the player
                            BluePortal.SetX(Player.GetX());
                            BluePortal.SetY(Player.GetY()); 
                            BluePortal.MoveOneStep();
                            Player.Draw();
                            while (Frame.InTrectX(BluePortal.GetX()) && Frame.InTrectY(BluePortal.GetY()) && !Door1.WillColid(BluePortal) && !Door2.WillColid(BluePortal))//an animation of the portal untile he is going to colid with the frame/wall/
                            {
                                BluePortal.Undraw();
                                BluePortal.MoveOneStep();
                                BluePortal.Draw();
                                if (i == 2) //for every level draws againg the objects in the frame (because the portal can override them)
                                {
                                    Window1.Draw();
                                }
                                else if (i == 3)
                                {
                                    Window2.Draw();
                                    Window1.Draw();
                                }
                                else if (i == 4)
                                {
                                    if (open1.GetX() != 79)
                                    {
                                        open1.Draw();
                                    }
                                }
                                else if (i == 5)
                                {
                                    if (open1.GetX() != 79)
                                    {
                                        open1.Draw();
                                    }
                                    if (open2.GetX() != 79)
                                    {
                                        open2.Draw();
                                    }
                                }else if(i == 6)
                                {
                                    Window2.Draw();
                                    if (open1.GetX() != 79)
                                    {
                                        open1.Draw();
                                    }
                                }else if(i == 7)
                                {
                                    Window2.Draw();
                                    Window1.Draw();
                                    if (open1.GetX() != 79)
                                    {
                                        open1.Draw();
                                    }
                                    if (open2.GetX() != 79)
                                    {
                                        open2.Draw();
                                    }
                                }

                                Thread.Sleep(20);
                            }
                            if (BluePortal.GetY() == OrangePortal.GetY() && BluePortal.GetX() == OrangePortal.GetX())//check if the blue portal overrode the orange one
                            {
                                OrangePortal.SetX(79);//puts the orange portal out of frame
                                OrangePortal.SetY(25);
                            }
                            BluePortal.OppositeDirection();
                            BluePortal.Draw();

                        }//same for the orange portal
                        else if (k.Key == ConsoleKey.O && !Frame.TouchTRectInside(Player.GetX(),Player.GetY()))
                        {
                            OrangePortal.Undraw();
                            OrangePortal.SetDirection(Player.GetDirection());
                            OrangePortal.SetX(Player.GetX());
                            OrangePortal.SetY(Player.GetY());
                            OrangePortal.MoveOneStep();
                            Player.Draw();
                            while (Frame.InTrectX(OrangePortal.GetX()) && Frame.InTrectY(OrangePortal.GetY())&& !Door1.WillColid(OrangePortal) && !Door2.WillColid(OrangePortal))
                            {
                                OrangePortal.Undraw();
                                OrangePortal.MoveOneStep();
                                OrangePortal.Draw();
                                if (i == 2)
                                {
                                    Window1.Draw();
                                }
                                else if (i == 3)
                                {
                                    Window2.Draw();
                                    Window1.Draw();
                                }
                                else if (i == 4)
                                {
                                    if (open1.GetX() != 79)
                                    {
                                        open1.Draw();
                                    }
                                }
                                else if (i == 5)
                                {
                                    if (open1.GetX() != 79)
                                    {
                                        open1.Draw();
                                    }
                                    if (open2.GetX() != 79)
                                    {
                                        open2.Draw();
                                    }
                                }
                                else if (i == 6)
                                {
                                    Window2.Draw();
                                    if (open1.GetX() != 79)
                                    {
                                        open1.Draw();
                                    }
                                }
                                else if (i == 7)
                                {
                                    Window2.Draw();
                                    Window1.Draw();
                                    if (open1.GetX() != 79)
                                    {
                                        open1.Draw();
                                    }
                                    if (open2.GetX() != 79)
                                    {
                                        open2.Draw();
                                    }
                                }
                                Thread.Sleep(20);
                            }
                            if (BluePortal.GetY() == OrangePortal.GetY() && BluePortal.GetX() == OrangePortal.GetX())
                            {
                                BluePortal.SetX(79);
                                BluePortal.SetY(25);
                            }
                            OrangePortal.OppositeDirection();
                            OrangePortal.Draw();


                        }

                        if (Player.GetX() == EndLevel.GetX() && Player.GetY() == EndLevel.GetY())//check if you steps on the EndLevel MTP
                        {
                            LevelComplete = true;

                        }
                        else if (Player.GetX() == open1.GetX() && Player.GetY() == open1.GetY())//check if you steps on the first door open
                        {
                            Door1.Undraw();
                            if (Window2.GetY() != 25)//draws what the door might overrode
                            {
                                Window2.Draw();
                            }
                            if (Door2.GetY() != 25)
                            {
                                Door2.Draw();
                            }
                            Door1.SetX(79);//puts the door and its opener out of the frame
                            open1.SetX(79);
                        }
                        else if(Player.GetX() == open2.GetX() && Player.GetY() == open2.GetY())//check if you steps on the second door open
                        {
                            Door2.Undraw();
                            if (Window1.GetX() != 79)//draws what the door might overrode
                            {
                                Window1.Draw();
                            }
                            if (Door1.GetX() != 79)
                            {
                                Door1.Draw();
                            }
                            Door2.SetY(25);//puts the door and its opener out of the frame
                            open2.SetX(79);
                        }
                        Player.Draw();

                    }
                    Thread.Sleep(20);
                }
                Console.SetCursorPosition(60, 10);//writes the player which levle he completed
                Console.WriteLine("Level {0} complete!",i);

                Thread.Sleep(500);//resets the main objects at the start of every level
                Player.SetX(1);
                Player.SetY(1);
                OrangePortal.Undraw();
                BluePortal.Undraw();
                OrangePortal.SetX(79);
                OrangePortal.SetY(25);
                BluePortal.SetX(79);
                BluePortal.SetY(25);
            }


            Console.Clear();//after you finished the game I print your prize
            Console.SetCursorPosition(0, 0);
            Console.ForegroundColor = ConsoleColor.White;
            Console.WriteLine("you won the game!");
            Thread.Sleep(1000);
            Console.WriteLine("here is your prize");
            Thread.Sleep(1000);
            DrawCake();
            Console.SetCursorPosition(0, 20);

        }
        public static void DrawCake()//draws a cake on the screen
        {
            Console.SetCursorPosition(11, 10);
            Console.ForegroundColor = ConsoleColor.Red;
            Console.Write("████");
            Console.SetCursorPosition(9, 11);
            Console.Write("██    ██");
            Console.SetCursorPosition(13, 12);
            Console.Write("██");
            Console.ForegroundColor = ConsoleColor.DarkRed;
            Console.Write("██");
            Console.ForegroundColor = ConsoleColor.Yellow;
            for (int i = 0; i < 3; i++)
            {
                Console.SetCursorPosition(13, 14+i);
                for (int j = 0; j < 4; j++)
                {
                    Console.Write("██");
                }
                
            }
            Console.ForegroundColor = ConsoleColor.DarkYellow;
            Console.SetCursorPosition(17, 11);
            Console.Write("██");
            Console.SetCursorPosition(19, 12);
            Console.Write("██");
            Console.SetCursorPosition(11, 13);
            Console.Write("████████████");
            for (int i = 0; i < 3; i++)
            {
                Console.SetCursorPosition(11,14 +i);
                Console.Write("██");
                Console.SetCursorPosition(21, 14 + i);
                Console.Write("██");
            }
            Console.SetCursorPosition(15, 14);
            Console.Write("████");
            Console.ForegroundColor = ConsoleColor.Gray;
            Console.SetCursorPosition(9, 17);
            Console.Write("████████████████");
            Console.SetCursorPosition(11, 18);
            Console.Write("████████████");
            Console.ForegroundColor = ConsoleColor.DarkGray;
            Console.SetCursorPosition(25, 17);
            Console.Write("██");
            Console.SetCursorPosition(19, 18);
            Console.Write("████");
            Console.ForegroundColor = ConsoleColor.White;
            Console.SetCursorPosition(17, 12);
            Console.Write("██"); 
            Console.SetCursorPosition(13, 16);
            Console.Write("██");
        }
    }
}
