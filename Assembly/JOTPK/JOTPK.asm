ideal

SCREEN_WIDTH=320  
BulletsSpeed = 2
model small
stack 0100h
p386

 

dataseg
	time db "00:00:00:00"
	space db "         ","$"
	MySong1 dw  NoteE2,NoteF_D2,NoteG2,NoteG2,NoteF_D2,NoteE2,NoteD_D2,NoteD_D2,NoteE2,NoteF_D2,NoteB1,NoteB1,NoteC_D2,NoteD_D2,NoteE2,NoteE2,NoteD2,NoteC2,NoteB1,NoteB1,NoteA1,NoteG1,NoteF_D1,NoteF_D1,NoteG1,NoteA1,NoteB1,NoteA1,NoteG1,NoteF_D1,NoteE1,NoteE1,NoteE1,NoteE1
	MySong2 dw  NoteC4,NoteB3,NoteA_D3,NoteA3,NoteG_D3,NoteG3,NoteF_D3,NoteF3,NoteE3,NoteD_D3,NoteD3,NoteC_D3,NoteC3
;Note 	Frequency 1-> 64k -1  Real Frequency Hz #
NoteC1 			equ 9121      ;130.81 	
NoteC_D1 		equ 8609      ;138.59 	
NoteD1 			equ 8126      ;146.83 	
NoteD_D1 		equ 7670      ;155.56 	
NoteE1 			equ 7239      ;164.81 	
NoteF1 			equ 6833      ;174.61 	
NoteF_D1 		equ 6449      ;185.00 	
NoteG1 			equ 6087      ;196.00 	
NoteG_D1 		equ 5746      ;207.65 	
NoteA1 			equ 5423      ;220.00 	
NoteA_D1 		equ 5119      ;233.08 	
NoteB1 			equ 4831      ;246.94 	
NoteC2	    	equ 4560      ;261.63 	; Mid C 
NoteC_D2 		equ 4304      ;277.18 	
NoteD2 			equ 4063      ;293.66 	
NoteD_D2 		equ 3834      ;311.13 	
NoteE2 			equ 3619      ;329.63 	
NoteF2 			equ 3416      ;349.23 	
NoteF_D2 		equ 3224      ;369.99 	
NoteG2 			equ 3043      ;391.00 	
NoteG_D2 		equ 2873      ;415.30 	
NoteA2 			equ 2711      ;440.00 	
NoteA_D2 		equ 2559      ;466.16 	
NoteB2 			equ 2415      ;493.88 	
NoteC3 			equ 2280      ;523.25 	
NoteC_D3 		equ 2152      ;554.37 	
NoteD3 			equ 2031      ;587.33 	
NoteD_D3 		equ 1917      ;622.25 	
NoteE3 			equ 1809      ;659.26 	
NoteF3 			equ 1715      ;698.46 	
NoteF_D3 		equ 1612      ;739.99 	
NoteG3 			equ 1521      ;783.99 	
NoteG_D3 		equ 1436      ;830.61 	
NoteA3 			equ 1355      ;880.00 	
NoteA_D3 		equ 1292      ;923.33 	
NoteB3		 	equ 1207      ;987.77 	
NoteC4      	equ 1140      ;1046.50 

	WaveNum dw 0
	huandredth db 0
	sec db 0
	minits db 0
	hours db 0
	NumLength dw 0
	NumX dw 160
	NumY dw 150
	
;numbers
	num0BMP db "E:\tasm\work\artWork\nums\0.bmp",0
	num1BMP db "E:\tasm\work\artWork\nums\1.bmp",0
	num2BMP db "E:\tasm\work\artWork\nums\2.bmp",0
	num3BMP db "E:\tasm\work\artWork\nums\3.bmp",0
	num4BMP db "E:\tasm\work\artWork\nums\4.bmp",0					   
	num5BMP db "E:\tasm\work\artWork\nums\5.bmp",0
	num6BMP db "E:\tasm\work\artWork\nums\6.bmp",0
	num7BMP db "E:\tasm\work\artWork\nums\7.bmp",0
	num8BMP db "E:\tasm\work\artWork\nums\8.bmp",0					   
	num9BMP db "E:\tasm\work\artWork\nums\9.bmp",0
	nextBMP db "E:\tasm\work\artWork\nums\next.bmp",0
	
	NumsArr dw offset num0BMP, offset num1BMP, offset num2BMP, offset num3BMP, offset num4BMP, offset num5BMP, offset num6BMP, offset num7BMP, offset num8BMP, offset num9BMP
	
;keyboard
	key_pressed db ?
	up_pressed dw 0
	down_pressed dw 0
	left_pressed dw 0
	right_pressed dw 0
	W_pressed dw 0
	S_pressed dw 0
	A_pressed dw 0
	D_pressed dw 0
	extendedKey db 0
	
	OldKeyboardInterruptOffset  dw ?   ; Old keaboard interrupt offset
	OldKeyboardInterruptSegment dw ?   ; Old keaboard interrupt Segment 
	
	CurrentOldInterruptOffset   dw ?   ; The currnet Old interrupt offset
	CurrentOldInterruptSegment  dw ?   ; The currnet Old interrupt
		
	keyboardInterruptPOS    equ 9*4    ; The position of the keaborad interrupt in the interrupt vector table
	currentInterruptPOS     db ?       ; The cuurent interrupt position in the interrupt vector table
	currentInterruptOFFSET  dw ?       ; The cuurent interrupt offset
	
	;BMP
	ErrorFile db 0
	ScrLine db SCREEN_WIDTH dup (0)  ; One Color line read buffer
	BmpLeft dw ?
	BmpTop dw ?
	BmpWidth dw ?
	BmpHeight dw ?
	FileHandle dw ?
	Header db 54 dup(0)
	Palette db 400h dup (0)
	
	gameOver db 0
	Win db 0
	
	
	backGroundBMP db "artWork\map.bmp",0
	LifeBMP db "artWork\Icons\life.bmp",0
	
	StartBMP db "artWork\start.bmp",0
	EndBMP db "artWork\end.bmp",0
	GamwOverBMP db "artWork\g_o.bmp",0
	
	;bullet
	BulletBMP db "artWork\bullet.bmp",0
	B_BMP db 4*4 dup(?)
	
	BulletsOnScreen db 13 dup(0)
	BulletsX dw 13 dup(?)
	BulletsY dw 13 dup(?)
	BulletsShadowX dw 13 dup(?)
	BulletsShadowY dw 13 dup(?)
	BulletsDiractionX dw 13 dup(?)
	BulletsDiractionY dw 13 dup(?)
	
	BulletShadowArr dw offset BulletShadow1, offset BulletShadow2, offset BulletShadow3, offset BulletShadow4, BulletShadow5, offset BulletShadow6, offset BulletShadow7, offset BulletShadow8, BulletShadow9, offset BulletShadow10, offset BulletShadow11, offset BulletShadow12, offset BulletShadow13
	
	BulletShadow1 db 4*4 dup(?)
	BulletShadow2 db 4*4 dup(?)
	BulletShadow3 db 4*4 dup(?)
	BulletShadow4 db 4*4 dup(?)
	BulletShadow5 db 4*4 dup(?)
	BulletShadow6 db 4*4 dup(?)
	BulletShadow7 db 4*4 dup(?)
	BulletShadow8 db 4*4 dup(?)
	BulletShadow9 db 4*4 dup(?)
	BulletShadow10 db 4*4 dup(?)
	BulletShadow11 db 4*4 dup(?)
	BulletShadow12 db 4*4 dup(?)
	BulletShadow13 db 4*4 dup(?)


	
	;player
	playerAnimationFrame dw 0
	playerX dw 152
	playerY dw 92
	playerShadowX dw 152
	playerShadowY dw 92
	playerDiraction db ? ; 0 = Up, 1 = Right, 2 = Down, 3 = Left, 4 = Idle
	playerDiractionArr0 dw offset p_Up0BMP,offset p_Right0BMP,offset p_Down0BMP,offset p_Left0BMP, offset p_IdleBMP
	playerDiractionArr1 dw offset p_Up1BMP,offset p_Right1BMP,offset p_Down1BMP,offset p_Left1BMP, offset p_IdleBMP
	playerDiractionArr2 dw offset p_Up2BMP,offset p_Right2BMP,offset p_Down2BMP,offset p_Left2BMP, offset p_IdleBMP
	playerDiractionArr3 dw offset p_Up3BMP,offset p_Right3BMP,offset p_Down3BMP,offset p_Left3BMP, offset p_IdleBMP

	AnimationArr dw offset playerDiractionArr0, offset playerDiractionArr1, offset playerDiractionArr2, offset playerDiractionArr3
	playerIdleBMP db "artWork\player\p_idle.bmp",0
	playerUp0BMP db "artWork\player\p_u0.bmp",0
	playerUp1BMP db "artWork\player\p_u1.bmp",0
	playerUp2BMP db "artWork\player\p_u2.bmp",0
	playerUp3BMP db "artWork\player\p_u3.bmp",0

	playerDown0BMP db "artWork\player\p_d0.bmp",0
	playerDown1BMP db "artWork\player\p_d1.bmp",0
	playerDown2BMP db "artWork\player\p_d2.bmp",0
	playerDown3BMP db "artWork\player\p_d3.bmp",0
							   
	playerLeft0BMP db "artWork\player\p_l0.bmp",0
	playerLeft1BMP db "artWork\player\p_l1.bmp",0
	playerLeft2BMP db "artWork\player\p_l2.bmp",0
	playerLeft3BMP db "artWork\player\p_l3.bmp",0
							   
	playerRight0BMP db "artWork\player\p_r0.bmp",0
	playerRight1BMP db "artWork\player\p_r1.bmp",0
	playerRight2BMP db "artWork\player\p_r2.bmp",0
	playerRight3BMP db "artWork\player\p_r3.bmp",0
	
	playerDeath db "artWork\player\p_death.bmp",0
	
	p_IdleBMP db 16*16 dup(?)
	p_Up0BMP db  16*16 dup(?)
	p_Up1BMP db  16*16 dup(?)
	p_Up2BMP db  16*16 dup(?)
	p_Up3BMP db  16*16 dup(?)
	 
	p_Down0BMP db  16*16 dup(?)
	p_Down1BMP db  16*16 dup(?)
	p_Down2BMP db  16*16 dup(?)
	p_Down3BMP db  16*16 dup(?)
	
	p_Left0BMP db  16*16 dup(?)
	p_Left1BMP db  16*16 dup(?)
	p_Left2BMP db  16*16 dup(?)
	p_Left3BMP db  16*16 dup(?)
	
	p_Right0BMP db 16*16 dup(?)
	p_Right1BMP db 16*16 dup(?)
	p_Right2BMP db 16*16 dup(?)
	p_Right3BMP db 16*16 dup(?)

	playerShadow db 16*16 dup(?)
	

	
	;Zomb
	Zomb0BMP db "artWork\mobs\m1_0.bmp",0
	Zomb1BMP db "artWork\mobs\m1_1.bmp",0
	Z_0 db 16*16 dup(?)
	Z_1 db 16*16 dup(?)
	
	
	ZombAnimationFrame dw 0
	
	ZombOnScreen dw 8 dup(0)
	ZombX dw 16,288,160,144,16,288,144,160
	ZombY dw 84,100,4,164,100,84,4,164
	ZombShadowX dw 16,288,160,144,16,288,144,160 
	ZombShadowY dw 84,100,4,164,100,84,4,164 
	
	ZombStartX dw 16,288,160,144,16,288,144,160
	ZombStartY dw 84,100,4,164,100,84,4,164

	ZombShadowArr dw offset ZombShadow1, offset ZombShadow2, offset ZombShadow3, offset ZombShadow4, offset ZombShadow5, offset ZombShadow6, offset ZombShadow7, offset ZombShadow8
	
	ZombShadow1 db 16*16 dup(?)
	ZombShadow2 db 16*16 dup(?)
	ZombShadow3 db 16*16 dup(?)
	ZombShadow4 db 16*16 dup(?)
	ZombShadow5 db 16*16 dup(?)
	ZombShadow6 db 16*16 dup(?)
	ZombShadow7 db 16*16 dup(?)
	ZombShadow8 db 16*16 dup(?)

	EnterNameMsg db "High Score! Enter your name: $"
	HSHolder db "the high score holder is : $"
	PlayerName db "XX         X"
	HighScoreFile db "HS\HS.txt",0

	playerHP dw 3
	PlayerIsHit db 0
	
	
codeseg
    
start:
	  mov ax,@data
	  mov ds,ax

	mov es,ax
   	call near setKeyboradInterrupt

    mov ax,0013h
    int 10h
	
    mov ax,0a000h
    mov es,ax
	mov dx, offset StartBMP
	mov [BmpLeft],113
	mov [BmpTop],46
	mov [BmpWidth], 94
	mov [BmpHeight] ,108
	call OpenShowBmp
	
	call PlaySong1
	
WaitForSpace:
	cmp [key_pressed],58
	jnz WaitForSpace
	
	call near MovFilesToDs
	
	mov ah,2ch
	int 21h
	mov [huandredth], dl
	mov [sec], dh
	mov [minits], cl
	mov [hours], ch
	
NextWave:
	mov [Win],0
	inc [WaveNum]
	cmp [WaveNum],9
	jnz StartWaveSetUp
	mov [Win],1
	jmp exit
StartWaveSetUp:
	call near WaveSetUp
	
	xor cx,cx
MainLoop:
	push cx
	
	cmp [key_pressed],1
	jz exit
	
	call near UpdatePlayer
	call near ZombAI
	call near UpdateBullets
	
 	;Chacks if the loop cnt is in 4 multiplications
 	pop ax ;ax = loop cnt
 	push ax
 	test ax, 03h
	jnz MainLoopEnd
	
	call near CreatNewBullet
	

MainLoopEnd:
	call near CheckBulletsCollision
	call near CheckPlayerCollision
	cmp [PlayerIsHit],1
	jnz gameNotOver
	call RemoveHP
	cmp [gameOver],1
	jz exit
	jmp NextWave
gameNotOver:
	cmp [Win],1
	jz NextWave
	call near MovPlayer
	call near MovZomb
	call near MovBullets
	call near _50MiliSecDelay
	 pop cx
	 inc cx
	 jmp MainLoop
	
exit:
	call clear
	cmp [Win],0
	jz ShowEnd
	jmp ShowWin
ShowEnd:
	mov dx, offset GamwOverBMP
	mov [BmpLeft],110
	mov [BmpTop],53
	mov [BmpWidth], 100
	mov [BmpHeight] ,94
	call OpenShowBmp
	jmp EndLoop
ShowWin:
	mov dx, offset EndBMP
	mov [BmpLeft],128
	mov [BmpTop],76
	mov [BmpWidth], 64
	mov [BmpHeight] ,48
	call OpenShowBmp
	call CalcTime
	call ShowTime
	call CheckHighScore
	jz SetHighScore
	call ShowHighScore
	jmp SetHighScoreEnd
SetHighScore:
	call near restoreKeyboradInterrupt
	call EnterScore
	call setKeyboradInterrupt
SetHighScoreEnd:
EndLoop:	
	cmp [key_pressed],1
	jnz EndLoop
	call near restoreKeyboradInterrupt
	mov ax,2h
    int 10h
	

    mov ax,4c00h ; returns control to dos
    int 21h
	
proc WaveSetUp
	mov [BmpLeft],16
	mov [BmpTop],4
	mov [BmpWidth], 288
	mov [BmpHeight] ,192
	mov dx, offset backGroundBMP
	call near OpenShowBmp
	
	mov [playerX],152
	mov [playerY],92
	mov [playerShadowX],152
	mov [playerShadowY],92
	mov [BmpLeft],152
	mov [BmpTop],92
	mov [BmpWidth], 16
	mov [BmpHeight] ,16
	mov dx, offset playerShadow
    call near CopyFromScreen
	mov dx, offset p_IdleBMP
    call near PasteToScreen
	
	call WaveSetZomb
	call WaveSetHP
	call WaveSetBullets
	ret
endp WaveSetUp

proc WaveSetZomb
	mov cx,[WaveNum]
ZombSetUpLoop:
	push cx
	mov si,cx
	dec si
	shl si,1
	mov dx, [ZombStartX + si]
	mov [ZombX+si],dx
	mov [ZombShadowX+si],dx
	mov dx, [ZombStartY + si]
	mov [ZombY+si],dx
	mov [ZombShadowY+si],dx
	mov [ZombOnScreen+si],1
	mov dx,[ZombShadowX + si]
	mov [BmpLeft],dx
	mov dx,[ZombShadowY + si]
	mov [BmpTop],dx
	mov dx,[ZombShadowArr + si]
	call near CopyFromScreen
	mov dx, offset Z_0
    call near PasteToScreen
	pop cx
	loop ZombSetUpLoop
	ret
endp WaveSetZomb

proc WaveSetHP
	mov [BmpLeft],1
	mov [BmpTop],4
	mov [BmpWidth], 14
	mov [BmpHeight] ,11
	mov cx,[playerHP]
HpSetUpLoop:
	push cx
	mov dx, offset LifeBMP
	call near OpenShowBmp
	add [BmpTop],15
	pop cx
	loop HpSetUpLoop
	ret
endp WaveSetHP

proc WaveSetBullets
	mov cx,13
BulletsSetUpLoop:
	push cx
	mov si,cx
	dec si
	mov [BulletsOnScreen + si],0
	pop cx
	loop BulletsSetUpLoop
	ret
endp WaveSetBullets

proc ZombVector
	mov dx, [ZombX + si] ;in dx distance X, in bx wich one is right
	cmp dx,[playerX]
	jg ZombRight
	jmp ZombLeft
ZombRight:
	sub dx,[playerX]
	mov bx,-1
	jmp CheckY
ZombLeft:
	mov dx, [playerX]
	sub dx,[ZombX + si]
	mov bx,1
CheckY:
	mov cx, [ZombY + si] ;in cx distance Y, in ax wich one is up
	cmp cx,[playerY]
	jg ZombDown
	jmp ZombUp
ZombUp:
	mov cx, [playerY]
	sub cx,[ZombY + si]
	mov ax,1
	ret
ZombDown:
	sub cx,[playerY]
	mov ax,-1
	ret
endp ZombVector

proc ZombAI
	mov cx,[WaveNum]
ZombAILoop:
	push cx
	mov si,cx
	dec si
	shl si,1
	cmp [ZombOnScreen + si],0
	jz ZombAIEnd
	
	call ZombVector
ZombDicission:
	cmp cx,dx
	jg ZombUpDown
	jmp ZombRightLeft
	
ZombUpDown:
	add [ZombY + si],ax
	jmp ZombAIEnd
	
ZombRightLeft:
	add [ZombX + si],bx
	
ZombAIEnd:
	pop cx
	loop ZombAILoop
	ret
endp ZombAI

proc MovFilesToDs
	
	mov dx, offset BulletBMP
	mov [BmpLeft],16
	mov [BmpTop],4
	mov [BmpWidth], 4
	mov [BmpHeight] ,4
	
	mov ax, offset B_BMP
	push ax
    call near OpenReadBmp


	mov [BmpWidth], 16
	mov [BmpHeight] ,16
	
	mov dx, offset Zomb0BMP
	
	mov ax, offset Z_0 
	push ax
    call near OpenReadBmp
	
	mov dx, offset Zomb1BMP
	
	mov ax, offset Z_1
	push ax
    call near OpenReadBmp
	
	mov dx, offset playerIdleBMP
	
	mov ax, offset p_IdleBMP 
	push ax
    call near OpenReadBmp
	
	mov dx, offset playerDown0BMP
	
	mov ax, offset p_Down0BMP
	push ax
    call near OpenReadBmp
	
	mov dx, offset playerDown1BMP
	
	mov ax, offset p_Down1BMP 
	push ax
    call near OpenReadBmp
	
	mov dx, offset playerDown2BMP
	
	mov ax, offset p_Down2BMP 
	push ax
    call near OpenReadBmp
	
	mov dx, offset playerDown3BMP
	
	mov ax, offset p_Down3BMP 
	push ax
    call near OpenReadBmp
	
	mov dx, offset playerUp0BMP
	
	mov ax, offset p_Up0BMP 
	push ax
    call near OpenReadBmp
	
	mov dx, offset playerUp1BMP
	
	mov ax, offset p_Up1BMP 
	push ax
    call near OpenReadBmp
	
	mov dx, offset playerUp2BMP
	
	mov ax, offset p_Up2BMP 
	push ax
    call near OpenReadBmp
	
	mov dx, offset playerUp3BMP
	
	mov ax, offset p_Up3BMP 
	push ax
    call near OpenReadBmp
	
	mov dx, offset playerLeft0BMP
	
	mov ax, offset p_Left0BMP 
	push ax
    call near OpenReadBmp
	
	mov dx, offset playerLeft1BMP
	
	mov ax, offset p_Left1BMP 
	push ax
    call near OpenReadBmp
	
	mov dx, offset playerLeft2BMP
	
	mov ax, offset p_Left2BMP 
	push ax
    call near OpenReadBmp
	
	mov dx, offset playerLeft3BMP
	
	mov ax, offset p_Left3BMP 
	push ax
    call near OpenReadBmp
	
	mov dx, offset playerRight0BMP
	
	mov ax, offset p_Right0BMP 
	push ax
    call near OpenReadBmp
	
	mov dx, offset playerRight1BMP
	
	mov ax, offset p_Right1BMP 
	push ax
    call near OpenReadBmp
	
	mov dx, offset playerRight2BMP
	
	mov ax, offset p_Right2BMP 
	push ax
    call near OpenReadBmp
	
	mov dx, offset playerRight3BMP
	
	mov ax, offset p_Right3BMP 
	push ax
    call near OpenReadBmp
	

	
	ret
endp MovFilesToDs


proc CheckBulletsCollision
	call near CheckBulletsZombCollision
	call near CheckBulletsWallCollision
	ret
endp CheckBulletsCollision

proc CheckBulletsZombCollision ;O(N*K) , N = bullets , K = Zomb
	mov cx,13
CheckBulletsZombCollisionLoop1:
	push cx
	mov si,cx
	dec si
	cmp [BulletsOnScreen+si],0
	jz CheckBulletsZombCollisionLoopEnd1
	shl si,1
	mov cx , [WaveNum]
CheckBulletsZombCollisionLoop2:
	push si
	mov ax, [BulletsX + si]
	mov bx, [BulletsY + si]	
	mov si,cx
	dec si
	shl si,1
	cmp [ZombOnScreen+si],0
	jz CheckBulletsZombCollisionLoopEnd2
	sub ax,[ZombX + si]
	cmp ax,16
	jg CheckBulletsZombCollisionLoopEnd2
	cmp ax,-4
	jl CheckBulletsZombCollisionLoopEnd2
	sub bx,[ZombY + si]
	cmp bx,16
	jg CheckBulletsZombCollisionLoopEnd2
	cmp bx,-4
	jl CheckBulletsZombCollisionLoopEnd2
	call near KillZomb
	pop si
	call near DestroyBullet
	push si
	call near CheckWin
CheckBulletsZombCollisionLoopEnd2:
	pop si
	loop CheckBulletsZombCollisionLoop2
	

CheckBulletsZombCollisionLoopEnd1:
	pop cx
	loop CheckBulletsZombCollisionLoop1
	ret
endp CheckBulletsZombCollision

proc CheckBulletsWallCollision
	mov cx,13
CheckBulletsWallCollisionLoop:
	push cx
	mov si,cx
	dec si
	cmp [BulletsOnScreen+si],0
	jz CheckBulletsWallCollisionLoopEnd
	shl si,1
	cmp [BulletsX+si],16
	jl CheckBulletsWallCollisionDestroy
	cmp [BulletsX+si],300
	jg CheckBulletsWallCollisionDestroy
	cmp [BulletsY+si],4
	jl CheckBulletsWallCollisionDestroy
	cmp [BulletsY+si],192
	jg CheckBulletsWallCollisionDestroy
	jmp CheckBulletsWallCollisionLoopEnd
CheckBulletsWallCollisionDestroy:
	call near DestroyBullet
CheckBulletsWallCollisionLoopEnd:
	pop cx
	loop CheckBulletsWallCollisionLoop
	ret
endp CheckBulletsWallCollision

;si = bulletNum*2
proc DestroyBullet
	shr si,1
	mov [BulletsOnScreen+si],0
	shl si,1
	mov dx, [BulletsShadowX + si]
	mov [BmpLeft],dx
	mov dx, [BulletsShadowY + si]
	mov [BmpTop],dx
	mov [BmpWidth], 4
	mov [BmpHeight] ,4
	mov dx, [BulletShadowArr + si]
    call near PasteToScreen
	ret
endp DestroyBullet 


proc CheckWin
	push cx
	push si
	mov [Win],1
	mov cx,[WaveNum]
CheckWinLoop:
	mov si,cx
	dec si
	shl si,1
	cmp [ZombOnScreen + si],1
	jz CheckWinLoopStop
	loop CheckWinLoop
	jmp CheckWinEnd
CheckWinLoopStop:
	mov [Win],0
CheckWinEnd:
	pop si
	pop cx
	ret
endp CheckWin

proc RemoveHP
	mov [PlayerIsHit],0
	dec [WaveNum]
	call clear
	mov [BmpHeight],32
	mov [BmpWidth],16
	mov dx,[playerX]
	mov [BmpLeft],dx
	mov dx,[playerY]
	mov [BmpTop],dx
	mov dx , offset playerDeath
	call near OpenShowBmp
	call PlaySong2
	dec [playerHP]
	jng GameIsOver
	jmp  RemoveHPEnd
GameIsOver:
	mov [gameOver],1
RemoveHPEnd:
	ret
endp RemoveHP

;si = ZombNum*2
proc KillZomb
	mov dx, [ZombShadowX + si]
	mov [BmpLeft],dx
	mov dx, [ZombShadowY + si]
	mov [BmpTop],dx
	mov [BmpWidth], 16
	mov [BmpHeight] ,16
	mov dx, [ZombShadowArr + si]
	push si
    call near PasteToScreen
	pop si
	mov [ZombOnScreen+si],0
	ret
endp KillZomb

proc CheckPlayerCollision
	call near CheckPlayerCollisionWalls
	call near CheckPlayerCollisionZomb
	ret
endp CheckPlayerCollision

proc CheckPlayerCollisionWalls
	cmp [playerX],32
	jl FixWallLeft
	cmp [playerX],272
	jg FixWallRight
	jmp FixUpDownWalls
FixWallLeft:
	mov [playerX],32
	jmp FixUpDownWalls
FixWallRight:
	mov [playerX],272

FixUpDownWalls:
	cmp [playerY],20
	jl FixWallUp
	cmp [playerY],164
	jg FixWallDown
	jmp CheckPlayerCollisionWallsEnd
FixWallUp:
	mov [playerY],20
	jmp CheckPlayerCollisionWallsEnd
FixWallDown:
	mov [playerY],164
CheckPlayerCollisionWallsEnd:
	ret
endp CheckPlayerCollisionWalls

proc CheckPlayerCollisionZomb
	mov cx,[WaveNum]
CheckPlayerCollisionLoop:
	push cx
	mov si,cx
	dec si
	shl si,1
	cmp [ZombOnScreen + si],0
	jz CheckPlayerCollisionLoopEnd
	
	mov dx,[ZombX + si]
	sub dx,[playerX]
	cmp dx,16
	jg CheckPlayerCollisionLoopEnd
	cmp dx,-16
	jl CheckPlayerCollisionLoopEnd
	mov dx,[ZombY + si]
	sub dx,[playerY]
	cmp dx,16
	jg CheckPlayerCollisionLoopEnd
	cmp dx,-16
	jl CheckPlayerCollisionLoopEnd
	
	mov [PlayerIsHit],1
	
CheckPlayerCollisionLoopEnd:
	pop cx
	loop CheckPlayerCollisionLoop
	ret
endp CheckPlayerCollisionZomb

proc UpdatePlayer
	call near UpdatePlayerLocation
	call near UpdatePlayerDiraction
	ret
endp UpdatePlayer

proc UpdatePlayerDiraction
	call near UpdatePlayerDiraction1 ;for WASD
	call near UpdatePlayerDiraction2 ;for Arrows
	;(for diraction prioraty)
	ret
endp UpdatePlayerDiraction

proc UpdatePlayerDiraction1
	push dx
	
	mov dx,[S_pressed]
	sub dx,[W_pressed]
	mov ax,[D_pressed]
	sub ax,[A_pressed]
	cmp ax,0
	jg UpdatePlayerDiraction1Right
	jl UpdatePlayerDiraction1Left
	jmp UpdatePlayerDiraction1UpOrDown
UpdatePlayerDiraction1Right:
	mov [playerDiraction],1
	jmp UpdatePlayerDiraction1End
UpdatePlayerDiraction1Left:
	mov [playerDiraction],3
	jmp UpdatePlayerDiraction1End
UpdatePlayerDiraction1UpOrDown:
	cmp dx,0
	jg UpdatePlayerDiraction1Down
	jl UpdatePlayerDiraction1Up
	jmp UpdatePlayerDiraction1Idle
UpdatePlayerDiraction1Up:
	mov [playerDiraction],0
	jmp UpdatePlayerDiraction1End
UpdatePlayerDiraction1Down:
	mov [playerDiraction],2
	jmp UpdatePlayerDiraction1End
UpdatePlayerDiraction1Idle:
	mov [playerDiraction],4
UpdatePlayerDiraction1End:	
	pop dx
	ret
endp UpdatePlayerDiraction1

proc UpdatePlayerDiraction2
	push dx
	
	mov dx,[down_pressed]
	sub dx,[up_pressed]
	mov ax,[right_pressed]
	sub ax,[left_pressed]
	cmp ax,0
	jg UpdatePlayerDiraction2Right
	jl UpdatePlayerDiraction2Left
	jmp UpdatePlayerDiraction2UpOrDown
UpdatePlayerDiraction2Right:
	mov [playerDiraction],1
	jmp UpdatePlayerDiraction2End
UpdatePlayerDiraction2Left:
	mov [playerDiraction],3
	jmp UpdatePlayerDiraction2End
UpdatePlayerDiraction2UpOrDown:
	cmp dx,0
	jg UpdatePlayerDiraction2Down
	jl UpdatePlayerDiraction2Up
	jmp UpdatePlayerDiraction2End
UpdatePlayerDiraction2Up:
	mov [playerDiraction],0
	jmp UpdatePlayerDiraction2End
UpdatePlayerDiraction2Down:
	mov [playerDiraction],2
UpdatePlayerDiraction2End:	
	pop dx
	ret
endp UpdatePlayerDiraction2

proc UpdatePlayerLocation
	push dx
	
	mov dx,[S_pressed]
	sub dx,[W_pressed]
	mov ax,[D_pressed]
	sub ax,[A_pressed]
	cmp ax,0
	jg UpdatePlayerLocationRight
	jl UpdatePlayerLocationLeft
	jmp UpdatePlayerLocationUpOrDown
UpdatePlayerLocationRight:
	inc [playerX]
	add [playerY],dx
	jmp UpdatePlayerLocationEnd
UpdatePlayerLocationLeft:
	dec [playerX]
	add [playerY],dx
	jmp UpdatePlayerLocationEnd
UpdatePlayerLocationUpOrDown:
	cmp dx,0
	jg UpdatePlayerLocationDown
	jl UpdatePlayerLocationUp
	jmp UpdatePlayerLocationEnd
UpdatePlayerLocationUp:
	dec [playerY]
	jmp UpdatePlayerLocationEnd
UpdatePlayerLocationDown:
	inc [playerY]
UpdatePlayerLocationEnd:	
	pop dx
	ret
endp UpdatePlayerLocation

proc MovPlayer
	mov dx, [playerShadowX]
	mov [BmpLeft],dx
	mov dx, [playerShadowY]
	mov [BmpTop],dx
	mov [BmpWidth], 16
	mov [BmpHeight] ,16
	mov dx, offset playerShadow
    call near PasteToScreen
	mov dx, [playerX]
	mov [playerShadowX],dx
	mov [BmpLeft],dx
	mov dx, [playerY]
	mov [playerShadowY],dx
	mov [BmpTop],dx
	mov dx, offset playerShadow
    call near CopyFromScreen
	
	mov bl, [playerDiraction]
	xor bh,bh
	shl bx,1
	mov si,[playerAnimationFrame]
	shr si,2
	shl si,1
	add bx,[AnimationArr+si]
	mov dx, [bx]
    call near PasteToScreen
	inc [playerAnimationFrame]
	cmp [playerAnimationFrame],16
	jnz MovPlayerEnd
	mov [playerAnimationFrame],0
	
MovPlayerEnd:
	ret
endp MovPlayer

proc CreatNewBullet
	;Check if there is a diraction for the bullet
	mov cx,[down_pressed]
	sub cx,[up_pressed]
	jnz CreatNewBulletStart
	mov cx,[right_pressed]
	sub cx,[left_pressed]
	jz CreatNewBulletEnd
CreatNewBulletStart:
	;search if there is space in ds for a new bullet
	mov cx, 13
CreatNewBulletLoop:
	mov si , cx
	dec si
	mov dl, [BulletsOnScreen+ si]
	cmp dl,0
	jz CreatNewBulletLoopStop
	loop CreatNewBulletLoop
	jmp CreatNewBulletEnd
	
CreatNewBulletLoopStop:
	mov [BulletsOnScreen+ si],1
	shl si,1
	mov dx, [playerX] ; center of player
	add dx,8
	mov ax, [playerY]
	add ax,8
	
	mov bx,[down_pressed]
	sub bx,[up_pressed]
	mov [BulletsDiractionY + si],bx
	shl bx,4
	add ax ,bx
	mov [BulletsY + si],ax
	mov [BulletsShadowY + si],ax
	mov [BmpTop],ax
	mov cx,[right_pressed]
	sub cx,[left_pressed]
	mov [BulletsDiractionX + si],cx
	shl cx,4
	add dx ,cx
	mov [BulletsX + si],dx
	mov [BulletsShadowX + si],dx
	mov [BmpLeft],dx
	mov [BmpHeight],4
	mov [BmpWidth],4
	mov dx,[BulletShadowArr + si]
	call near CopyFromScreen

CreatNewBulletEnd:
	ret
endp CreatNewBullet

proc UpdateBullets
	mov cx, 13
UpdateBulletsLoop:
	push cx
	mov si , cx
	dec si
	mov dl, [BulletsOnScreen+ si]
	cmp dl,0
	jz UpdateBulletsLoopEnd
	shl si,1
	mov dx,[BulletsDiractionX+si]
	shl dx,BulletsSpeed
	add [BulletsX+si],dx
	mov dx,[BulletsDiractionY+si]
	shl dx,BulletsSpeed
	add [BulletsY+si],dx
UpdateBulletsLoopEnd:
	pop cx
	loop UpdateBulletsLoop
	
	ret
endp UpdateBullets


proc MovBullets
	mov cx,13
MovBulletsLoop:
	push cx
	mov si,cx
	dec si
	cmp [BulletsOnScreen + si],0
	jz MovBulletsLoopEnd
	
	shl si,1
	mov dx, [BulletsShadowX + si]
	mov [BmpLeft],dx
	mov dx, [BulletsShadowY + si]
	mov [BmpTop],dx
	mov [BmpWidth], 4
	mov [BmpHeight] ,4
	mov dx, [BulletShadowArr + si]
	push si
    call near PasteToScreen
	pop si
	mov dx, [BulletsX + si]
	mov [BulletsShadowX + si],dx
	mov [BmpLeft],dx
	mov dx, [BulletsY + si]
	mov [BulletsShadowY + si],dx
	mov [BmpTop],dx
	mov dx, [BulletShadowArr + si]
    call near CopyFromScreen
	
	mov dx, offset B_BMP
    call near PasteToScreen
MovBulletsLoopEnd:
	pop cx
	loop MovBulletsLoop
	
	
MovBulletsEnd:
	ret
endp MovBullets

proc MovZomb
	call PasteZombShadow
	call CopyZombShadow
	call PasteZomb
	ret
endp MovZomb

proc PasteZombShadow
	mov cx,[WaveNum]
PasteZombShadowLoop:
	push cx
	mov si,cx
	dec si
	shl si,1
	cmp [ZombOnScreen + si],0
	jz PasteZombShadowLoopEnd
	
	mov dx, [ZombShadowX + si]
	mov [BmpLeft],dx
	mov dx, [ZombShadowY + si]
	mov [BmpTop],dx
	mov [BmpWidth], 16
	mov [BmpHeight] ,16
	mov dx, [ZombShadowArr + si]
	push si
    call near PasteToScreen
	pop si
PasteZombShadowLoopEnd:
	pop cx
	loop PasteZombShadowLoop
	
PasteZombShadowEnd:
	ret
endp PasteZombShadow

proc CopyZombShadow
	mov cx,[WaveNum]
CopyZombShadowLoop:
	push cx
	mov si,cx
	dec si
	shl si,1
	cmp [ZombOnScreen + si],0
	jz CopyZombShadowLoopEnd
	
	mov dx, [ZombX + si]
	mov [ZombShadowX + si],dx
	mov [BmpLeft],dx
	mov dx, [ZombY + si]
	mov [ZombShadowY + si],dx
	mov [BmpTop],dx
	mov dx, [ZombShadowArr + si]
    call near CopyFromScreen
CopyZombShadowLoopEnd:
	pop cx
	loop CopyZombShadowLoop
	
CopyZombShadowEnd:
	ret
endp CopyZombShadow

proc PasteZomb
	mov cx,[WaveNum]
PasteZombLoop:
	push cx
	mov si,cx
	dec si
	shl si,1
	cmp [ZombOnScreen + si],0
	jz PasteZombLoopEnd

	mov dx, [ZombX + si]
	mov [BmpLeft],dx
	mov dx, [ZombY + si]
	mov [BmpTop],dx
	
	mov si,[ZombAnimationFrame]
	cmp si,3
	jg ZombFrame2
	jmp ZombFrame1
ZombFrame1:
	lea dx,[Z_0]
	jmp FrameSelected
ZombFrame2:
	lea dx,[Z_1]
FrameSelected:
    call near PasteToScreen
PasteZombLoopEnd:
	pop cx
	loop PasteZombLoop
	
	inc [ZombAnimationFrame]
	cmp [ZombAnimationFrame],8
	jnz PasteZombEnd
	mov [ZombAnimationFrame],0
	
PasteZombEnd:
	ret
endp PasteZomb

proc clear
push cx
push si
	mov cx,0FA00h
	xor si,si
clr:

	mov [word ptr es:si],0
	add si,2
	loop clr
pop si
pop cx
	ret
endp clear

proc _50MiliSecDelay
	push cx
	
	mov cx ,500 
@@Self1:
	
	push cx
	mov cx,300 

@@Self2:	
	loop @@Self2
	
	pop cx
	loop @@Self1
	
	pop cx
	ret
endp _50MiliSecDelay





;push offset bufferTo
proc ReadBMP
; BMP graphics are saved upside-down.
; Read the graphic line by line (BmpHeight lines in VGA format),
; displaying the lines from bottom to top.
	push bp
	mov bp, sp
	push cx
	
	mov ax, 0A000h
	mov es, ax
	
 
	mov ax,[BmpWidth] ; row size must dived by 4 so if it less we must calculate the extra padding bytes
	mov si, 0
	and ax, 3
	jz @@row_ok
	mov si,4
	sub si,ax

@@row_ok:	
	mov cx,[BmpHeight]
    dec cx
	add cx,[BmpTop] ; add the Y on entire screen
	; next 5 lines  di will be  = cx*320 + dx , point to the correct screen line
	mov di,cx
	shl cx,6
	shl di,8
	add di,cx
	add di,[BmpLeft]
	cld ; Clear direction flag, for movsb forward
	
	mov cx, [BmpHeight]
@@NextLine:
	push cx
 
	; small Read one line
	mov ah,3fh
	mov cx,[BmpWidth]  
	add cx,si  ; extra  bytes to each row must be divided by 4
	mov dx,offset ScrLine
	int 21h
	; Copy one line into video memory es:di
	mov cx,[BmpWidth]  
	push si
	mov si,offset ScrLine
	rep movsb ; Copy line to the screen
	sub di,[BmpWidth]            ; return to left bmp
	sub di,SCREEN_WIDTH  ; jump one screen line up
	pop si
	
	pop cx
	loop @@NextLine
	
	
	mov cx,[BmpHeight]
    dec cx
	add cx,[BmpTop] ; add the Y on entire screen
	; next 5 lines  di will be  = cx*320 + dx , point to the correct screen line
	mov di,cx
	shl cx,6
	shl di,8
	add di,cx
	add di,[BmpLeft]
	cld ; Clear direction flag, for movsb forward
	mov si,di ; si = start of bmp on screen
	mov cx, [BmpHeight]
	mov di,[word ptr bp + 4] ;di = buffer to
	

CopyToBuffer: ;copey from the screen into a buffer for later
	push cx

	mov cx,[BmpWidth]  
	push ds ;change thr segments for reverse movsb
	push es
	pop ds
	pop es
	rep movsb ; Copy line to the screen
	push ds ;change thr segments for reverse movsb
	push es
	pop ds
	pop es
	sub si,[BmpWidth]            ; return to left bmp
	sub si,SCREEN_WIDTH  ; jump one screen line up
	
	pop cx
	loop CopyToBuffer
	
	pop cx
	pop bp
	ret 2
endp ReadBMP

proc ShowBMP
; BMP graphics are saved upside-down.
; Read the graphic line by line (BmpHeight lines in VGA format),
; displaying the lines from bottom to top.
	push bp
	mov bp, sp
	push cx
	
	mov ax, 0A000h
	mov es, ax
	
 
	mov ax,[BmpWidth] ; row size must dived by 4 so if it less we must calculate the extra padding bytes
	mov si, 0
	and ax, 3
	jz @@row_ok
	mov si,4
	sub si,ax

@@row_ok:	
	mov cx,[BmpHeight]
    dec cx
	add cx,[BmpTop] ; add the Y on entire screen
	; next 5 lines  di will be  = cx*320 + dx , point to the correct screen line
	mov di,cx
	shl cx,6
	shl di,8
	add di,cx
	add di,[BmpLeft]
	cld ; Clear direction flag, for movsb forward
	
	mov cx, [BmpHeight]
@@NextLine:
	push cx
 
	; small Read one line
	mov ah,3fh
	mov cx,[BmpWidth]  
	add cx,si  ; extra  bytes to each row must be divided by 4
	mov dx,offset ScrLine
	int 21h
	; Copy one line into video memory es:di
	mov cx,[BmpWidth]  
	push si
	mov si,offset ScrLine
	rep movsb ; Copy line to the screen
	sub di,[BmpWidth]            ; return to left bmp
	sub di,SCREEN_WIDTH  ; jump one screen line up
	pop si
	
	pop cx
	loop @@NextLine
	
	pop cx
	pop bp
	ret
endp ShowBMP

proc OpenReadBmp near
	push bp
	mov bp,sp
	 
	call near OpenBmpFile
	cmp [ErrorFile],1
	je @@ExitProc
	
	call near ReadBmpHeader
	 
	call near ReadBmpPalette
	
	call near CopyBmpPalette
	
	push [word ptr bp + 4]
	call near ReadBMP
	
	 
	call near CloseBmpFile

@@ExitProc:
	pop bp
	ret 2
endp OpenReadBmp

proc OpenShowBmp near
	push ax
	push bx
	push dx
	push di
	push si
	 
	 
	call near OpenBmpFile
	cmp [ErrorFile],1
	je @@ExitProc
	
	call near ReadBmpHeader
	 
	call near ReadBmpPalette
	
	call near CopyBmpPalette
	

	call near ShowBMP
	
	 
	call near CloseBmpFile

@@ExitProc:
	pop si
	pop di
	pop dx
	pop bx
	pop ax
	ret 
endp OpenShowBmp

 
 
	
; input dx filename to open
proc OpenBmpFile	near						 
	mov ah, 3Dh
	mov al,2
	int 21h
	jc @@ErrorAtOpen
	mov [FileHandle], ax
	jmp @@ExitProc
	
@@ErrorAtOpen:
	mov [ErrorFile],1
@@ExitProc:	
	ret
endp OpenBmpFile
 
 
 



proc CloseBmpFile near
	mov ah,3Eh
	mov bx, [FileHandle]
	int 21h
	ret
endp CloseBmpFile




; Read 54 bytes the Header
proc ReadBmpHeader	near					
	push cx
	push dx
	
	mov ah,3fh
	mov bx, [FileHandle]
	mov cx,54
	mov dx,offset Header
	int 21h
	
	pop dx
	pop cx
	ret
endp ReadBmpHeader



proc ReadBmpPalette near ; Read BMP file color palette, 256 colors * 4 bytes (400h)
						 ; 4 bytes for each color BGR + null)			
	push cx
	push dx
	
	mov ah,3fh
	mov cx,400h
	mov dx,offset Palette
	int 21h
	
	pop dx
	pop cx
	
	ret
endp ReadBmpPalette


; Will move out to screen memory the colors
; video ports are 3C8h for number of first color
; and 3C9h for all rest
proc CopyBmpPalette		near					
										
	push cx
	push dx
	
	mov si,offset Palette
	mov cx,256
	mov dx,3C8h
	mov al,0  ; black first							
	out dx,al ;3C8h
	inc dx	  ;3C9h
CopyNextColor:
	mov al,[si+2] 		; Red				
	shr al,2 			; divide by 4 Max (cos max is 63 and we have here max 255 ) (loosing color resolution).				
	out dx,al 						
	mov al,[si+1] 		; Green.				
	shr al,2            
	out dx,al 							
	mov al,[si] 		; Blue.				
	shr al,2            
	out dx,al 							
	add si,4 			; Point to next color.  (4 bytes for each color BGR + null)				
								
	loop CopyNextColor
	
	pop dx
	pop cx
	
	ret
endp CopyBmpPalette




proc CopyFromScreen
; BMP graphics are saved upside-down.
; Read the graphic line by line (BmpHeight lines in VGA format),
; displaying the lines from bottom to top.
	push cx
	
	mov ax, 0A000h
	mov es, ax
	
 
	mov cx,[BmpHeight]
    dec cx
	add cx,[BmpTop] ; add the Y on entire screen
	; next 5 lines  di will be  = cx*320 + dx , point to the correct screen line
	mov si,cx
	shl cx,6
	shl si,8
	add si,cx
	add si,[BmpLeft]
	cld ; Clear playerDiraction flag, for movsb forward
	
	mov cx, [BmpHeight]
	mov di,dx
@@NextLine:
	push cx
 
	; Copy one line into video memory es:di
	mov cx,[BmpWidth]  
	push es
	push ds
	pop es
	pop ds
	rep movsb
	push es
	push ds
	pop es
	pop ds
	sub si,[BmpWidth]            ; return to left bmp
	sub si,SCREEN_WIDTH  ; jump one screen line up
	
	pop cx
	loop @@NextLine
	
	pop cx
	ret
endp CopyFromScreen

proc PasteToScreen
; BMP graphics are saved upside-down.
; Read the graphic line by line (BmpHeight lines in VGA format),
; displaying the lines from bottom to top.
	push cx
	
	mov ax, 0A000h
	mov es, ax
	
 
	mov cx,[BmpHeight]
    dec cx
	add cx,[BmpTop] ; add the Y on entire screen
	; next 5 lines  di will be  = cx*320 + dx , point to the correct screen line
	mov di,cx
	shl cx,6
	shl di,8
	add di,cx
	add di,[BmpLeft]
	cld ; Clear playerDiraction flag, for movsb forward
	
	mov cx, [BmpHeight]
	mov si,dx
@@NextLine:
	push cx

	; Copy one line into video memory es:di
	mov cx,[BmpWidth]  
movsbloop:
	cmp [byte ptr si],0ffh
	jz DontPrint
	movsb
	jmp movsbloopEnd
DontPrint:
	inc si
	inc di
movsbloopEnd:
	loop movsbloop
	sub di,[BmpWidth]            ; return to left bmp
	sub di,SCREEN_WIDTH  ; jump one screen line up
	
	pop cx
	loop @@NextLine
	
	pop cx
	ret
endp PasteToScreen

proc CopyFromScreenColom
; BMP graphics are saved upside-down.
; Read the graphic line by line (BmpHeight lines in VGA format),
; displaying the lines from bottom to top.
	push cx
	
	mov ax, 0A000h
	mov es, ax
	
 
	mov cx,[BmpHeight]
    dec cx
	add cx,[BmpTop] ; add the Y on entire screen
	; next 5 lines  di will be  = cx*320 + dx , point to the correct screen line
	mov si,cx
	shl cx,6
	shl si,8
	add si,cx
	add si,[BmpLeft]
	cld ; Clear playerDiraction flag, for movsb forward
	
	mov cx, [BmpHeight]
	mov di,dx
@@NextLine:
	push cx
 
	; Copy one line into video memory es:di 
	push es
	push ds
	pop es
	pop ds
	movsb
	push es
	push ds
	pop es
	pop ds
	dec si       ; return to left bmp
	sub si,SCREEN_WIDTH  ; jump one screen line up
	dec di
	add di,[BmpWidth]
	pop cx
	loop @@NextLine
	
	pop cx
	ret
endp CopyFromScreenColom


proc setKeyboradInterrupt
	mov ax,keyboardInterruptPOS
	mov bx,offset currentInterruptPOS
	mov [word ptr bx],ax
	mov bx,offset currentInterruptOFFSET
	mov ax,offset KeyboardInterrupt
	mov [word ptr bx],ax
	
	call near SetInterrupt          
	
	mov bx,offset CurrentOldInterruptOffset
	mov ax,[word ptr bx]
	mov bx,offset OldKeyboardInterruptOffset
	mov [word ptr bx],ax
	mov bx,offset CurrentOldInterruptSegment
	mov ax,[word ptr bx]
	mov bx,offset OldKeyboardInterruptSegment
	mov [word ptr bx],ax 
	ret 
endp 	setKeyboradInterrupt



proc restoreKeyboradInterrupt
	mov bx,offset OldKeyboardInterruptOffset
	mov ax,[word ptr bx]
	mov bx,offset CurrentOldInterruptOffset
	mov [word ptr bx],ax
	mov bx,offset OldKeyboardInterruptSegment
	mov ax,[word ptr bx]
	mov bx,offset CurrentOldInterruptSegment
	mov [word ptr bx],ax 
	mov ax,keyboardInterruptPOS
	mov bx,offset currentInterruptPOS
	mov [word ptr bx],ax
	call near RestoreOldInterrupt	
	ret
endp 	restoreKeyboradInterrupt
	
	
proc SetInterrupt
	pusha
	push es
	push si
	mov ax,0
	mov es,ax
	
	xor ax,ax
	mov bx,offset currentInterruptPOS 
	mov al,[byte ptr bx]
	mov si,ax
	mov dx,[word ptr es:si]
	mov cx,[word ptr es:si+2]
	
	mov bx,offset CurrentOldInterruptOffset
	mov [word ptr bx],dx       
	mov bx,offset CurrentOldInterruptSegment  
	mov [word ptr bx],cx       
	cli       
	mov bx,offset currentInterruptOFFSET	       
	mov ax,[word ptr bx]
	mov cx,0
	mov es,cx	
	mov [word ptr es:si],ax
	mov ax,cs
	mov [word ptr es:si+2],ax
	pop si
	pop es
	sti                ; set interrupt flag        
	popa
ret
endp SetInterrupt

proc RestoreOldInterrupt
	pusha
	push es
	mov ax,0
	mov es,ax
	
	cli     ; clear interupt flag
	mov bx,offset CurrentOldInterruptOffset    
	mov ax,[word ptr bx]
	mov bx,offset currentInterruptPOS 	
	xor cx,cx
	mov cl,[byte ptr bx]
	mov si,cx
	mov [word ptr es: si],ax
	mov bx,offset CurrentOldInterruptSegment     
	mov ax,[word ptr bx]
	mov [word ptr es: si+2],ax
	sti     ; set interrupt flag
	pop es
	popa
 ret
endp RestoreOldInterrupt
 
  
proc KeyboardInterrupt  far
	pusha
	push ds
	;mov ax,@data
	;mov ds,ax
	in al,60h
	
	
	cmp al, 0E0h
	jnz @@cont
	mov [byte extendedKey],1
@@cont:
	cmp al,1
	je c1
	inc al
c1:	
	mov [key_pressed],al
	
	
 ; do somthing with the key
	call near Arrows_Check
	call near Wasd_Check
	cmp [byte key_pressed], 0E0h
	jz @@cont2
	mov [byte extendedKey],0

@@cont2:	
	jmp exitKeyboardInt
	  
	  
	  
exitKeyboardInt:
	push ax        
	mov al,20h  ; EOI end  of interupt
	out 20h,AL                
	pop ax
	sti	
	pop ds
	popa
	iret
endp KeyboardInterrupt

proc Wasd_Check
	push ax
	mov ah,[key_pressed]
	
	  cmp ah,31
	  jnz prsW
	  mov [byte ptr A_pressed],1
	  jmp Wasd_CheckEnd
prsW:
	  cmp ah,18
	  jnz prsD
	  mov [byte ptr W_pressed],1
	  jmp Wasd_CheckEnd
prsD:
	  cmp ah,33
	  jnz prsS
	  mov [byte ptr D_pressed],1
	  jmp Wasd_CheckEnd
prsS:
	  cmp ah,32
	  jnz rlsA
	  mov [byte ptr S_pressed],1
	  jmp Wasd_CheckEnd
rlsA:

	  cmp ah,159
	  jnz rlsW
	  mov [byte ptr A_pressed],0
	  jmp Wasd_CheckEnd
rlsW:
     cmp ah,146
     jnz rlsD
     mov [byte ptr W_pressed],0
     jmp Wasd_CheckEnd
rlsD:
     cmp ah,161
     jnz rlsS
     mov [byte ptr D_pressed],0
     jmp Wasd_CheckEnd
rlsS:
	  cmp ah,160
	  jnz Wasd_CheckEnd
	  mov [byte ptr S_pressed],0

Wasd_CheckEnd:
	pop ax
	ret
	
endp Wasd_Check

proc Arrows_Check
	push ax
	mov ah,[key_pressed]
	
	  cmp ah,76
	  jnz prs1
	  mov [byte ptr left_pressed],1
	  jmp Arrows_CheckEnd
prs1:
	  cmp ah,73
	  jnz prs2
	  mov [byte ptr up_pressed],1
	  jmp Arrows_CheckEnd
prs2:
	  cmp ah,78
	  jnz prs3
	  mov [byte ptr right_pressed],1
	  jmp Arrows_CheckEnd
prs3:
	  cmp ah,81
	  jnz rls
	  mov [byte ptr down_pressed],1
	  jmp Arrows_CheckEnd
rls:

	  cmp ah,204
	  jnz rls1
	  mov [byte ptr left_pressed],0
	  jmp Arrows_CheckEnd
rls1:
     cmp ah,201
     jnz rls2
     mov [byte ptr up_pressed],0
     jmp Arrows_CheckEnd
rls2:
     cmp ah,206
     jnz rls3
     mov [byte ptr right_pressed],0
     jmp Arrows_CheckEnd
rls3:
	  cmp ah,209
	  jnz Arrows_CheckEnd
	  mov [byte ptr down_pressed],0

Arrows_CheckEnd:
	pop ax
	ret
	
endp Arrows_Check

proc CheckZombCollision ;O(N) for N Zomb					returns to dx collision or not 
	push ax
	push bx
	mov cx,[WaveNum]
CheckZombCollisionLoop:
	push cx
	mov ax, [ZombX + si]
	mov bx, [Zomby + si]
	push si
	mov si,cx
	dec si
	shl si,1
	pop di
	push di
	cmp di,si
	jz CheckZombCollisionLoopEnd
	shr si,1
	cmp [ZombOnScreen+si],0
	jz CheckZombCollisionLoopEnd
	shl si,1	
	sub ax,[ZombX + si]
	cmp ax,16
	jnl CheckZombCollisionLoopEnd
	cmp ax,-16
	jng CheckZombCollisionLoopEnd
	sub bx,[ZombY + si]
	cmp bx,16
	jnl CheckZombCollisionLoopEnd
	cmp bx,-16
	jng CheckZombCollisionLoopEnd
	pop si
	pop cx
	pop bx
	pop ax
	mov dx,1
	ret
CheckZombCollisionLoopEnd:
	pop si
	pop cx
	loop CheckZombCollisionLoop
	mov dx,0
	pop bx
	pop ax
	ret
endp CheckZombCollision



proc PlaySong1
	mov cx, 34
	 
	lea si,[MySong1]

NextNote1:
	push cx
	
	mov     bx,[word ptr si]             
	mov     al, 10110110b    ; 10110110b  
	out     43h, al          ;  
    
	 

	mov     ax, bx            
	out     42h, al           
	mov     al, ah           
	out     42h, al        
	 
	in      al, 61h           
	or      al, 00000011b   
	out     61h, al          
 

	rep call _50MiliSecDelay
	rep call _50MiliSecDelay
	rep call _50MiliSecDelay
	rep call _50MiliSecDelay
	
	inc si
	inc si
	
	pop cx
	loop NextNote1
	               
	   

	in      al,61h           
	and     al,11111100b     
	out     61h,al           
	
 
	
	ret
endp PlaySong1

proc PlaySong2
	mov cx, 12
	 
	lea si,[MySong2]

NextNote2:
	push cx
	
	mov     bx,[word ptr si]             
	mov     al, 10110110b    ; 10110110b  
	out     43h, al          ;  
    
	 

	mov     ax, bx            
	out     42h, al           
	mov     al, ah           
	out     42h, al        
	 
	in      al, 61h           
	or      al, 00000011b   
	out     61h, al          
 

	rep call _50MiliSecDelay

	
	inc si
	inc si
	
	pop cx
	loop NextNote2
	               
	   

	in      al,61h           
	and     al,11111100b     
	out     61h,al           
	
 
	
	ret
endp PlaySong2

proc AxToScreen
	mov cx, [NumLength]
	mov [BmpHeight],7
	mov [BmpWidth],6
	mov dx,[NumX]
	mov [BmpLeft], dx
	mov dx,[NumY]
	mov [BmpTop], dx
AxToScreenLoop:
	sub [BmpLeft], 6
	xor dx,dx
	mov bx,10
	div bx
	mov bx,dx
	shl bx,1
	mov dx, [NumsArr + bx]
	call OpenShowBmp
	loop AxToScreenLoop
	ret
endp AxToScreen

proc ShowTime
	mov [BmpHeight],7
	mov [BmpWidth],6
	mov dx,[NumX]
	mov [NumX], dx
	mov dx,[NumY]
	mov [BmpTop], dx
	
	mov al,[huandredth]
	xor ah,ah
	mov [NumLength],2
	call AxToScreen
	
	sub [BmpLeft],2
	mov [BmpWidth],2
	mov dx, offset nextBMP
	call OpenShowBmp
	mov dx, [BmpLeft]
	dec dx
	mov [NumX],dx
	mov [BmpWidth],6
	
	mov al,[sec]
	xor ah,ah
	mov [NumLength],2
	call AxToScreen
	
	sub [BmpLeft],2
	mov [BmpWidth],2
	mov dx, offset nextBMP
	call OpenShowBmp
	mov dx, [BmpLeft]
	dec dx
	mov [NumX],dx
	mov [BmpWidth],6
	
	mov al,[minits]
	xor ah,ah
	mov [NumLength],2
	call AxToScreen
	
	sub [BmpLeft],2
	mov [BmpWidth],2
	mov dx, offset nextBMP
	call OpenShowBmp
	mov dx, [BmpLeft]
	dec dx
	mov [NumX],dx
	mov [BmpWidth],6
	
	mov al,[hours]
	xor ah,ah
	mov [NumLength],2
	call AxToScreen
	ret
endp ShowTime

proc CalcTime
	mov ah,2ch
	int 21h
	
	add dl,100 ;sub huandredths
	sub dl,[huandredth]
	mov al,dl
	xor ah,ah
	mov bl,100
	div bl
	mov [huandredth],ah
	dec dh
	add dh,al
	
	add dh,60 ;sub sec
	sub dh,[sec]
	mov al,dh
	xor ah,ah
	mov bl,60
	div bl
	mov [sec],ah
	dec dh
	add dh,al	
	
	add cl,60 ;sub sec
	sub cl,[minits]
	mov al,cl
	xor ah,ah
	mov bl,60
	div bl
	mov [minits],ah
	dec dh
	add dh,al
	
	sub ch,[hours] ;sub hours
	mov [hours],ch
	ret
endp CalcTime

proc EnterScore
	mov ah,9
	mov dx, offset EnterNameMsg
	int 21h
	
	mov [byte PlayerName],10
    mov dx, offset PlayerName
    mov ah, 0Ah 
    int 21h
	
	mov ah,42h
	mov al,0
	mov bx, [FileHandle]
	mov cx,0
	mov dx,0
	int 21h
	
	mov ah,40h
	mov bx, [FileHandle]
	xor ch,ch
	mov cl,[PlayerName+1]
	mov dx,offset PlayerName + 2
	int 21h
	mov ah,40h
	mov dx,10
	sub dx,cx
	mov cx,dx
	mov dx, offset space
	int 21h
	
	mov dx, offset hours
	call ToString2DigitsToAx
	mov [word ptr time],ax
	mov dx, offset minits
	call ToString2DigitsToAx
	mov [word ptr time + 3],ax
	mov dx, offset sec
	call ToString2DigitsToAx
	mov [word ptr time + 6],ax
	mov dx, offset huandredth
	call ToString2DigitsToAx
	mov [word ptr time + 9],ax
	mov ah,40h
	mov bx, [FileHandle]
	mov cx,11
	mov dx,offset time
	int 21h

	ret
endp EnterScore

proc CheckHighScore
	mov dx , offset HighScoreFile
	call near OpenBmpFile
	cmp [ErrorFile],1
	jz CheckHighScoreEnd
	call GetLastScore
CheckH:
	mov dx,offset time
	call Parse2DigitsToAx
	cmp [hours], al
	jg  CheckHEnd
	je CheckM
	sub ax,ax
CheckHEnd:
	jmp CheckHighScoreEnd
CheckM:
	mov dx,offset time
	add dx,3
	call Parse2DigitsToAx
	cmp [minits], al
	jg  CheckMEnd
	je CheckS
	sub ax,ax
CheckMEnd:
	jmp CheckHighScoreEnd
CheckS:
	mov dx,offset time
	add dx,6
	call Parse2DigitsToAx
	cmp [sec], al
	jg  CheckHighScoreEnd
	je CheckHS
	sub ax,ax
CheckSEnd:
	jmp CheckHighScoreEnd
CheckHS:
	mov dx,offset time
	add dx,9
	call Parse2DigitsToAx
	cmp [huandredth], al
	jg  CheckHighScoreEnd
	sub ax,ax
CheckHighScoreEnd:
	ret
endp CheckHighScore

proc GetLastScore
	mov ah,42h
	mov al,0
	mov bx, [FileHandle]
	mov cx,0
	mov dx,10
	int 21h
	
	mov ah,3fh
	mov bx, [FileHandle]
	mov cx,11
	mov dx, offset time
	int 21h
GetLastScoreEnd:
	ret
endp GetLastScore

;dx = offset ToParse
proc Parse2DigitsToAx
	mov bx, dx
	mov al, [byte ptr bx]
	sub al,'0'
	mov dl,10
	mul dl
	add al , [byte ptr bx + 1]
	sub al,'0'

	ret
endp Parse2DigitsToAx

;dx = offset ToString
proc ToString2DigitsToAx
	mov bx, dx
	mov al, [byte ptr bx]
	xor ah,ah
	mov bx,10
	div bl
	add al,'0'
	add ah,'0'
	ret
endp ToString2DigitsToAx


proc ShowHighScore
	mov ah,9
	mov dx, offset HSHolder
	int 21h
	
	mov ah,42h
	mov al,0
	mov bx, [FileHandle]
	mov cx,0
	mov dx,0
	int 21h
	
	mov ah,3fh
	mov bx, [FileHandle]
	mov cx,9
	mov dx, offset space
	int 21h
	
	mov ah,9
	mov dx, offset space
	int 21h
	
	mov dx , offset time
	call Parse2DigitsToAx
	mov [hours], al
	
	mov dx , offset time + 3
	call Parse2DigitsToAx
	mov [minits], al
	
	mov dx , offset time + 6
	call Parse2DigitsToAx
	mov [sec], al
	
	mov dx , offset time + 9
	call Parse2DigitsToAx
	mov [huandredth], al
	mov [NumY],2
	mov [NumX],0
	call ShowTime
	
	ret
endp ShowHighScore
end start