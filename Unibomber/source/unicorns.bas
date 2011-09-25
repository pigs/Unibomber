 rem ******************************
 rem  VARIABLES
 rem ******************************

 rem a = 0 if player0 has the ball, 1 if player1 has the ball
 
 rem b = the pointer for the music
 rem c = the timer for the music
 rem d = variable for transferring while manipulating the other sound variables
 
 rem x = player0x
 rem y = player0y
 rem v = player1x
 rem w = player1y
 
 rem s = p0 speed
 rem p = p1 speed
 rem m keeps track of direction for p0
 rem n keeps track of directon for p1
 rem q is for gravity 
 rem t is for controlling jump height p0
 rem u is for controlling jump height for p1
 rem z = score (timer)

 rem h = who randomly starts with bomb

 
 rem ******************************
 rem main game screen
 rem ******************************

gamescreen

 playfield:
 ................................
 ................................
 ................................
 ................................
 ................................
 ................................
 ................................
 .............XXXXXX.............
 ...XXXXX................XXXXX...
 ................................
 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
end

 rem ******************************
 rem initializers
 rem ******************************
init
 

 rem RETARDED SCORING
 dim sc1 = score
 dim sc2 = score+1
 dim sc3 = score+2

 rem INITIAL STARTING POSITIONS
 v=95:w=79
 x=50:y=79

 rem randomly decide who starts with the bomb
 h=(rand&1)
 if h=0 then ballx=x+7:bally=y-1
 if h=1 then ballx=v+7:bally=w-1
 ballheight=5 


 COLUPF=$60
 CTRLPF=$33
 COLUBK=$00
 
  rem set up variables
 a = 2
 m = 2
 n = 2
 s = 1
 p = 1

 rem use score as a timer to count down from 1000
 score = 1000
 
 rem gives names to the variables needed for music
 
 dim musicStart=b
 dim musTimeStart=c
 dim tempaudv=d
 
rem sets distortion values for the music and sets the initial volume to zero
 AUDV0=0
 AUDC0=12

 rem provides a starting point for the pointers and timers
 musicStart=$FF
 musTimeStart=0

draw_loop

 rem tells the program when the next notes and beats happen
 if musTimeStart = 0 then gosub changeMusicNote
 musTimeStart = musTimeStart - 1
 
 COLUP0 = $5C
 COLUP1 = $BA
 
 rem LET'S KEEP IT ON SCREEN
 if x <= 2 then x = 2
 if v <= 2 then v = 2
 if x >= 154 then x = 153
 if v >= 154 then v = 153
 
 rem UPDATE SPRITES
 if m = 2 then gosub unicorn1right
 if m = 3 then gosub unicorn1left

 if n = 2 then gosub unicorn2right
 if n = 3 then gosub unicorn2left
 
 rem count down 
 score = score - 1

 rem gravity and collision between players and platforms
 t = 1
 if q > 0 then y = y - 1 : q = q - 1 : t = 0
 if q = 0 && !collision(player0, playfield) then y = y + 1 : t = 0
 
 u = 1
 if h > 0 then w = w - 1 : h = h - 1 : u = 0
 if h = 0 && !collision(player1, playfield) then w = w + 1 : u = 0

 player0x = x:player0y = y
 player1x = v:player1y = w
 

 m = 1: gosub fieldschecka
 n = 1: gosub fieldscheckb	
 
 rem bomb possession

 if a = 0 then gosub player0bomb
 if a = 1 then gosub player1bomb

 rem collision between players

 if a=0&& collision(player0,player1) then gosub player1bomb
 if a=1&& collision(player1,player0) then gosub player0bomb

 rem controls + collision detection between players and playfield


 if joy0up && t >0 then m=0:q = 10
 if joy0down then m = 1: y = y + s : gosub fieldschecka
 if joy0left then m = 2 : x = x - s : gosub fieldschecka
 if joy0right then m = 3 : x = x + s : gosub fieldschecka

 if joy1up && u > 0 then n = 0 : h = 10 : gosub fieldscheckb
 if joy1down then n = 1 : w = w + p : gosub fieldscheckb
 if joy1left then n = 2 : v = v - p : gosub fieldscheckb
 if joy1right then n = 3 : v = v + p : gosub fieldscheckb

 if collision(player0,ball) then a = 0
 if collision(player1,ball) then a = 1
 


 drawscreen
 
 goto timer

fieldscheckb 
 on n goto 10 11 12 13
10 if collision(playfield,player1) then w = w + p : goto 14
11 if collision(playfield,player1) then w = w - p : goto 14
12 if collision(playfield,player1) then v = v + p: goto 14 
13 if collision(playfield,player1) then v = v - p : goto 14
14 player1x = v : player1y = w
end
 return

fieldschecka
 on m goto 5 6 7 8
5 if collision(playfield,player0) then y = y+s : goto 9
6 if collision(playfield,player0) then y = y-s  : goto 9
7 if collision(playfield,player0) then x = x+s : goto 9
8 if collision(playfield,player0) then x = x-s : goto 9
9 if 1 <> 0 then player0x = x : player0y = y 
end
 return


 rem srites and directions
unicorn1left
 player0:
 %01000100
 %11000100
 %01111100
 %00111100
 %00001111
 %00000110
 %00000010
 %00000001
end
 return

unicorn2left
 player1:
 %01000100
 %11000100
 %01111100
 %00111100
 %00001111
 %00000110
 %00000010
 %00000001
end
 return

unicorn1right
 player0:
 %00100010
 %00100011
 %00111110
 %00111100
 %11110000
 %01100000
 %01000000
 %10000000
end
 return

unicorn2right
 player1:
 %00100010
 %00100011
 %00111110
 %00111100
 %11110000
 %01100000
 %01000000
 %10000000
end
 return
 
player0bomb
 ballx= x+7
 bally=y-1
 a=0
 return

player1bomb
 ballx=v+7
 bally=w-1
 a=1
 return

 rem determines winner

timer
 if a=0&&sc1 = $00 && sc2 = $00 && sc3 < $01 then goto player2win
 if a=1&&sc1 = $00 && sc2 = $00 && sc3 < $01 then goto player1win


 goto draw_loop

 rem win screens and reset 

player1win

 COLUBK =$44
 playfield:
 XXX.X..XXX.X.X.XX.XXX....X......
 X.X.X..X.X.X.X.X..X.X...XX......
 XXX.X..XXX.XXX.XX.XXX....X......
 X...X..X.X..X..X..XX.....X......
 X...XX.X.X..X..XX.X.X...XXX.....
 ................................
 ...............X...X.X.X..X.XX.X
 ...............X...X.X.X..X.X..X
 ...............X.X.X.X.XX.X.XX.X
 ...............X.X.X.X.X.XX..X..
 ...............XXXXX.X.X..X.XX.X
end
 drawscreen
 if joy0fire then goto gamescreen
 goto player1win
 
player2win

 COLUBK =$44
 playfield:
 XXX.X..XXX.X.X.XX.XXX...XX......
 X.X.X..X.X.X.X.X..X.X....X......
 XXX.X..XXX.XXX.XX.XXX...XX......
 X...X..X.X..X..X..XX....X.......
 X...XX.X.X..X..XX.X.X...XX......
 ................................
 ...............X...X.X.X..X.XX.X
 ...............X...X.X.X..X.X..X
 ...............X.X.X.X.XX.X.XX.X
 ...............X.X.X.X.X.XX..X..
 ...............XXXXX.X.X..X.XX.X
end
 drawscreen
 if joy0fire then goto gamescreen
 goto player2win

 rem this is the engine that runs the music using a pointer and a timer

changeMusicNote
  musicStart = musicStart + 1
  AUDF0 = musicData[musicStart]

  tempaudv = 8
  if musicData[musicStart] = $FF then tempaudv = 0
  AUDV0 = tempaudv

  musicStart = musicStart + 1
  musTimeStart = musicData[musicStart]
  rem value is (2 * NUMBER_OF_NOTES) - 1 (39)
  if musicStart > 77 then musicStart = #-1

 return
 
 data musicData
	-1,40,26,20,25,40,26,20,22,40,
	-1,40,26,20,25,40,19,20,25,40,
	-1,40,26,20,25,40,26,20,22,40,
	-1,40,26,20,25,40,26,20,29,40,
	-1,40,22,20,16,40,22,20,19,40,
	-1,40,22,20,28,40,22,20,26,40,
	-1,40,22,20,16,40,22,20,19,40,
	-1,40,26,20,22,40,25,20,16,40
	
end





