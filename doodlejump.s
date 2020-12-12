#####################################################################
#
# CSC258H5S Fall 2020 Assembly Final Project
# University of Toronto, St. George
#
# Student: Haoran Zhao, 1005839078
#
# Bitmap Display Configuration:
# - Unit width in pixels: 8
# - Unit height in pixels: 8
# - Display width in pixels: 256
# - Display height in pixels: 256
# - Base Address for Display: 0x10008000 ($gp)
#

# - Milestone 1 & 2 & 3

# - Milestone 4
# 1. score count
# 2. Game over/Retry
# 3. Dynamic increase in game difficulty as game progresses

# - Milestone 5
# 1. Fancier Graphics (doodler character)
# 2. Sound Effect
# 3. Input Player Name


#####################################################################

.data

#Game Core Information
gameSpeed:	  .word 100
displayAddress:	  .word 0x10008000
userInput:	  .space 1
counter:	  .word 0
lostMessage:	  .asciiz "You have died.... Your score was: "
restartMessage:	  .asciiz "Would you like to replay?"
helloMessage:	  .asciiz "Your name: "
userName:	  .asciiz ""
enterNameMessage: .asciiz "Please enter your name: "
buffer:		  .space 20
#Screen
screenWidth:      .word 64
screenHeight:     .word 64

#Colors
doodlerBodyColor: .word 0xFF9999	# pink
doodlerNoseColor: .word 0xE55151	#dark pink
black:		  .word 0x000000	# black
white:		  .word 0xffffff	# white
platformColor:    .word 0xDBEFF6	# light blue
backgroundColor:  .word 0x5C94FC	# skyblue


#Score Variable
score:            .word 0		# stores how many points are retrieved based on the height
scoreGain:        .word 7		# changes based on how high a jump is made
scoreMilestones:  .word 100, 250, 500, 1000, 5000, 10000

#Doodler Information
doodlerDirection: .word 2		# 0 -> left, 1 -> right, 2 -> normal
doodlerPositionX: .word 0       
doodlerPositionY: .word 23
maxJumpingHeight: .word 11
direction:	  .word 0
# direction variable
# 106 - move left - j
# 107 - move right - k
# numbers are selected due to ASCII characters


#Platform Information
firstPfX:  		 .word 0		# Position of the platform, it will be generated randomly.
secondPfX:		 .word 0
thirdPfX:		 .word 0
newPfX:			 .word 4
firstPfY:		 .word 24
secondPfY:		 .word 16
thirdPfY:		 .word 8
newPfY:			 .word 0
.text
.globl _main

_main:
	jal InputName
	jal ResetScore
	jal ResetGamespeed
	jal ResetBackground
	jal InitPlatforms
	jal CreateDoodler
	jal Update
	j Exit
Update:	
	jal ErasePlatforms
	jal EraseDoodler
	jal InputCheck
	jal Jump
	jal UpdateMap
	jal CreatePlatforms
	jal DrawDoodler
	jal GameSpeed
	jal Pause
	lw $t0, doodlerPositionY
	beq $t0, 32, Exit
	j Update
	
#####################################################################
# Fill Screen to white, for reset
#####################################################################
ErasePlatforms:	
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	lw $t8, backgroundColor	# $t8 stores background color
	# Erase the first platform
	lw $a0, firstPfX
	lw $a1, firstPfY
	jal CoordinateToAddress
	sw $t8, 0($v0)
	sw $t8, 4($v0)
	sw $t8, 8($v0)
	sw $t8, 12($v0)
	sw $t8, 16($v0)
	sw $t8, 20($v0)
	sw $t8, 24($v0)
	sw $t8, 28($v0)
	
	# Erase the second platform
	lw $a0, secondPfX
	lw $a1, secondPfY
	jal CoordinateToAddress
	sw $t8, 0($v0)
	sw $t8, 4($v0)
	sw $t8, 8($v0)
	sw $t8, 12($v0)
	sw $t8, 16($v0)
	sw $t8, 20($v0)
	sw $t8, 24($v0)
	sw $t8, 28($v0)
	
	# Erase the third platform
	lw $a0, thirdPfX
	lw $a1, thirdPfY
	jal CoordinateToAddress
	sw $t8, 0($v0)
	sw $t8, 4($v0)
	sw $t8, 8($v0)
	sw $t8, 12($v0)
	sw $t8, 16($v0)
	sw $t8, 20($v0)
	sw $t8, 24($v0)
	sw $t8, 28($v0)
	
	# Erase the fourth platform
	lw $a0, newPfX
	lw $a1, newPfY
	jal CoordinateToAddress
	sw $t8, 0($v0)
	sw $t8, 4($v0)
	sw $t8, 8($v0)
	sw $t8, 12($v0)
	sw $t8, 16($v0)
	sw $t8, 20($v0)
	sw $t8, 24($v0)
	sw $t8, 28($v0)
	
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra	
	
EraseDoodler:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	lw $a0, doodlerPositionX
	lw $a1, doodlerPositionY
	jal CoordinateToAddress
	lw $t0, backgroundColor
	
	sw $t0, 0($v0)
	sw $t0, 4($v0)
	sw $t0, 8($v0)
	sw $t0, 12($v0)
	sw $t0, 16($v0)
	 
	sw $t0, -128($v0)
	sw $t0, -124($v0)
	sw $t0, -120($v0)
	sw $t0, -116($v0)
	sw $t0, -112($v0)
	
	sw $t0, -256($v0)
	sw $t0, -252($v0)
	sw $t0, -248($v0)
	sw $t0, -244($v0)
	sw $t0, -240($v0)
	
	sw $t0, -384($v0)
	sw $t0, -380($v0)
	sw $t0, -376($v0)
	sw $t0, -372($v0)
	sw $t0, -368($v0)
	
	sw $t0, -512($v0)
	sw $t0, -508($v0)
	sw $t0, -504($v0)
	sw $t0, -500($v0)
	sw $t0, -496($v0)
	
	sw $t0, -640($v0)
	sw $t0, -636($v0)
	sw $t0, -632($v0)
	sw $t0, -628($v0)
	sw $t0, -624($v0)
	
	sw $t0, -768($v0)
	sw $t0, -764($v0)
	sw $t0, -760($v0)
	sw $t0, -756($v0)
	sw $t0, -752($v0)
	
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra
	
ResetBackground:
	li $a0, 1024		# $a0 stores count
	lw $a1, backgroundColor	# $a1 stores background color
	add $t0, $zero, $zero	# $t0 is counter
	lw $t1, displayAddress	# $t1 stores current address
LOOP:
	beq $a0, $t0, END	# if the count reaches max, then END
	sw $a1, 0($t1) 		# store color
	addi $t0, $t0, 1 	# increment counter
	addi $t1, $t1, 4	# iterate to next address
	j LOOP			# next iteration
END:	jr $ra			# return


#####################################################################
# Draw Platforms
#####################################################################
DrawPlatform:
	# input $v0 is the address of the platform to draw
    	lw $t0, platformColor	# $t0 stores the color blue
    	sw $t0, 0($v0)		# draw the left most pixel of the platform
    	sw $t0, 4($v0)
    	sw $t0, 8($v0)
    	sw $t0, 12($v0)
    	sw $t0, 16($v0)
    	sw $t0, 20($v0)
    	sw $t0, 24($v0)
    	sw $t0, 28($v0)
    	jr $ra

NewPlatformX:
	# return $v0 -> the x coordinate of the first pixel

	li $v0, 42		# call service 42 for random integer generator
	li $a1, 21		# set the upper bound of the block end.
	syscall
	addi $v0, $a0, 3	# add 1 to the left make sure it does not land on the left side boundary.
	jr $ra

InitPlatforms:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	add $t7, $ra, $zero	# $t7 stores the address of the label where this get called
		
	# First Platform 
	lw $a2, firstPfX
	jal NewPlatformX	# returns $v0 -> the X coordinate
	la $t0, firstPfX
	sw $v0, ($t0)		# modify firstPfX to the first random generated value.
	add $a0, $v0, $zero	# $a0 stores the X coordinate
	li $a1, 24		# $a1 stores the Y coordinate
	jal CoordinateToAddress # returns $v0 -> address
	
	# Second Platform
	lw $a2, secondPfX
	jal NewPlatformX	# returns $v0 -> the X coordinate
	la $t0, secondPfX
	sw $v0, ($t0)		# modify secondPfX to the first random generated value.
	add $a0, $v0, $zero	# $a1 stores the X coordinate
	li $a1, 16		# $a1 stores the Y coordinate
	jal CoordinateToAddress # returns $v0 -> address
	
	# Thrid Platform
	lw $a2, thirdPfX
	jal NewPlatformX	# returns $v0 -> the X coordinate
	la $t0, thirdPfX
	sw $v0, ($t0)		# modify thirdPfX to the first random generated value.
	add $a0, $v0, $zero	# $a1 stores the X coordinate
	li $a1, 8		# $a1 stores the Y coordinate
	jal CoordinateToAddress # returns $v0 -> address
	
	# Fourth Platform
	lw $a2, newPfX
	jal NewPlatformX	# returns $v0 -> the X coordinate
	la $t0, thirdPfX
	sw $v0, ($t0)		# modify thirdPfX to the first random generated value.
	add $a0, $v0, $zero	# $a1 stores the X coordinate
	li $a1, 8		# $a1 stores the Y coordinate
	jal CoordinateToAddress # returns $v0 -> address

	add $ra, $t7, $zero	# restore the address of label called
		
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra			# return

#####################################################################
# Draw Doodler
#####################################################################

CreateDoodler:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	lw $a0, firstPfX
	addi $a0, $a0, 1
	li $a1, 23
	sw $a0, doodlerPositionX
	sw $a1, doodlerPositionY
	jal CoordinateToAddress
	jal DrawDoodler
	
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra
	
DrawDoodler:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
# Draw at position x -> $a0, y -> $a1
	lw $a0, doodlerPositionX
	lw $a1, doodlerPositionY
	jal CoordinateToAddress
	
	lw $t0, doodlerDirection	# load the directin of the doodler
	beq $t0, 1, DrawDoodlerRight	# if the direction value is 1, then draw the doodler to right
	beq $t0, 0, DrawDoodlerLeft	# if the directino value is 0, then draw the doodler to left
	lw $a2, doodlerBodyColor	# $a2 stores the doodler body color
	lw $t0, doodlerNoseColor	# $t0 stores the doodler nose color
	lw $t1, black
	sw $a2, 0($v0)
	sw $a2, 4($v0)
	sw $a2, 8($v0)
	sw $a2, 12($v0)
	sw $a2, 16($v0)
	 
	sw $a2, -128($v0)
	sw $t0, -124($v0)
	sw $t0, -120($v0)
	sw $t0, -116($v0)
	sw $a2, -112($v0)
	
	sw $a2, -256($v0)
	sw $a2, -252($v0)
	sw $a2, -248($v0)
	sw $a2, -244($v0)
	sw $a2, -240($v0)
	
	sw $a2, -384($v0)
	sw $t1, -380($v0)
	sw $a2, -376($v0)
	sw $t1, -372($v0)
	sw $a2, -368($v0)
	
	sw $a2, -512($v0)
	sw $a2, -508($v0)
	sw $a2, -504($v0)
	sw $a2, -500($v0)
	sw $a2, -496($v0)
	
	sw $a2, -636($v0)
	sw $a2, -628($v0)
	
	sw $a2, -764($v0)
	sw $a2, -756($v0)
	
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra	
	
DrawDoodlerRight:
# Draw at position x -> $a0, y -> $a1
	lw $a0, doodlerPositionX
	lw $a1, doodlerPositionY
	jal CoordinateToAddress
	
	# Draw at position $v0
	lw $a2, doodlerBodyColor	# $a2 stores the doodler body color
	lw $t0, doodlerNoseColor	# $t0 stores the doodler nose color
	lw $t1, black
	sw $a2, 0($v0)
	sw $a2, 4($v0)
	sw $a2, 8($v0)
	sw $a2, 12($v0)
	sw $a2, 16($v0)
	 
	sw $a2, -128($v0)
	sw $t0, -124($v0)
	sw $t0, -120($v0)
	sw $t0, -116($v0)
	sw $a2, -112($v0)
	
	sw $a2, -256($v0)
	sw $a2, -252($v0)
	sw $a2, -248($v0)
	sw $a2, -244($v0)
	sw $a2, -240($v0)
	
	sw $a2, -384($v0)
	sw $t1, -380($v0)
	sw $a2, -376($v0)
	sw $t1, -372($v0)
	sw $a2, -368($v0)
	
	sw $a2, -512($v0)
	sw $a2, -508($v0)
	sw $a2, -504($v0)
	sw $a2, -500($v0)
	sw $a2, -496($v0)
	
	sw $a2, -636($v0)
	sw $a2, -628($v0)
	
	sw $a2, -768($v0)
	sw $a2, -760($v0)
	
	li $t0, 2
	sw $t0, doodlerDirection	# set it back to normal
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra	

DrawDoodlerLeft:
# Draw at position x -> $a0, y -> $a1
	lw $a0, doodlerPositionX
	lw $a1, doodlerPositionY
	jal CoordinateToAddress
	
	# Draw at position $v0
	lw $a2, doodlerBodyColor	# $a2 stores the doodler body color
	lw $t0, doodlerNoseColor	# $t0 stores the doodler nose color
	lw $t1, black
	sw $a2, 0($v0)
	sw $a2, 4($v0)
	sw $a2, 8($v0)
	sw $a2, 12($v0)
	sw $a2, 16($v0)
	 
	sw $a2, -128($v0)
	sw $t0, -124($v0)
	sw $t0, -120($v0)
	sw $t0, -116($v0)
	sw $a2, -112($v0)
	
	sw $a2, -256($v0)
	sw $a2, -252($v0)
	sw $a2, -248($v0)
	sw $a2, -244($v0)
	sw $a2, -240($v0)
	
	sw $a2, -384($v0)
	sw $t1, -380($v0)
	sw $a2, -376($v0)
	sw $t1, -372($v0)
	sw $a2, -368($v0)
	
	sw $a2, -512($v0)
	sw $a2, -508($v0)
	sw $a2, -504($v0)
	sw $a2, -500($v0)
	sw $a2, -496($v0)
	
	sw $a2, -636($v0)
	sw $a2, -628($v0)
	
	sw $a2, -760($v0)
	sw $a2, -752($v0)
	
	sw $t0, doodlerDirection	# set it back to normal
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra
	
#####################################################################
# Helper Method: CoordinateToAddress
# $a0 -> x coordinate
# $a1 -> y coordinate
# returns $v0 -> the address of the coordinates for bitmap display
#####################################################################
		
CoordinateToAddress:
	# $a0 -> x coordinate
	# $a1 -> y coordinate
	# returns $v0 -> the address of the coordinates for bitmap display
	li $v0, 32
	lw $t0, displayAddress	# $t0 stores address of first pixel
	mul $v0, $v0, $a1	# multiply by y position
	add $v0, $v0, $a0	# add the x position
	mul $v0, $v0, 4		# multiply by 4
	add $v0, $v0, $t0	# add global pointer from bitmap display
	jr $ra			#return $v0

##################################################################
# Pause Function
# $a0 - amount to pause
##################################################################
# no return values
##################################################################
Pause:
	li $v0, 32 # syscall value for sleep
	syscall
	jr $ra


#####################################################################
# Jumping Action
#####################################################################
		
MoveUp:	
	# Get the current position:
	lw $t1, doodlerPositionY	# if the position of the doodler reaches half the map
	beq $t1, 16, MoveDownPlatforms	# instead of moving up the doodler by 1, we move down the map by 1
	# Moving up by one:
	addiu $t1, $t1, -1
	sw $t1, doodlerPositionY	# update doodlerPositionY

	jr $ra

MoveDownPlatforms:
	# Accesss each Y coordinates
	lw $t0, firstPfY
	lw $t1, secondPfY
	lw $t2, thirdPfY
	lw $t3, newPfY
	
	addi $t0, $t0, 1
	sw $t0, firstPfY
	
	addi $t1, $t1, 1
	sw $t1, secondPfY
	
	addi $t2, $t2, 1
	sw $t2, thirdPfY
	
	addi $t3, $t3, 1
	sw $t3, newPfY
	
	jr $ra

MoveDown:
	# Get the current position:
	lw $t1, doodlerPositionY
	# Moving up by one:
	addiu $t1, $t1, 1
	sw $t1, doodlerPositionY	# update doodlerPositionY
	jr $ra
	
ResetDoodlerPosition0:
	li $t0, 0
	sw $t0, doodlerPositionX
	jr $ra	

ResetDoodlerPosition32:
	li $t0, 32
	sw $t0, doodlerPositionX
	jr $ra	
		
Jump:
	# Record the starting position
	lw $t1, maxJumpingHeight
	lw $t0, counter			# Initiate a counter
	addi $t0, $t0, 1		# increment the counter by 1
	sw $t0, counter			# update the counter
	blt $t0, $t1, MoveUp		# if the counter is not the max jumping height then keep moving up
		
	lw $t6, secondPfY
	lw $t7, doodlerPositionY
	addi $t6, $t6, -1		# check to see if doodler reaches the height of the second platform
	lw $a0, secondPfX
	lw $a1, doodlerPositionX
	beq $t6, $t7, CheckLandX
	
	lw $t6, firstPfY
	lw $t7, doodlerPositionY
	addi $t6, $t6, -1		# check to see if doodler reaches the height of the first platform
	lw $a0, firstPfX
	lw $a1, doodlerPositionX
	beq $t6, $t7, CheckLandX
	
	j MoveDown			# else: move down


CheckLandX:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	# $a0 -> the platform X whether the doodler can land
	# $a1 -> doodler position X
	
	# Right side of the doodler cannot land on the platform
	addi $a1, $a1, 4		
	blt $a1, $a0, MoveDown		# branch if $a1 + 12 < $a0, the doodler keeps falling
	
	# Left side of the doodler cannot land on the platform
	addi $a0, $a0, 10		
	bgt $a1, $a0, MoveDown		# branch if $a1 > $a0 + 24, the doodler keeps falling 
	
	sw $zero, counter		# reset the counter back to 0
	
	jal LandingSoundEffect
	
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	j MoveUp

UpdateMap:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	# Update the map:
	lw $t0, firstPfY	# if the first platform hasn't reach the end of the screen
	blt $t0, 32, END	# then we don't want to update
	
	lw $t0, secondPfX
	sw $t0, firstPfX	# set the second platform to be the first on X coord
	
	lw $t0, secondPfY
	sw $t0, firstPfY	# set the second platform to be the first on Y coord
	
	lw $t0, thirdPfX
	sw $t0, secondPfX	# set the third to be the second on X coord
	
	lw $t0, thirdPfY
	sw $t0, secondPfY	# set the third to be the second on Y coord
	
	lw $t0, newPfX
	sw $t0, thirdPfX	# set the fourth to be the third on X coord
	
	lw $t0, newPfY
	sw $t0, thirdPfY	# set the fourth to be the third on Y coord
	
	jal NewPlatformX
	sw $v0, newPfX		# randomly generate a new platform and place on top of the screen
	li $t0, 0
	sw $t0, newPfY
	
	jal UpdateScore		# update the score
	jal CheckIncreaseGamespeed	# increase the game speed
	
	lw $ra, 0($sp)
	addi $sp, $sp, 4	
	jr $ra

CreatePlatforms:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	# Draw platforms
	lw $a0, firstPfX
	lw $a1, firstPfY
	jal CoordinateToAddress
	jal DrawPlatform
	
	lw $a0, secondPfX
	lw $a1, secondPfY
	jal CoordinateToAddress
	jal DrawPlatform
	
	lw $a0, thirdPfX
	lw $a1, thirdPfY
	jal CoordinateToAddress
	jal DrawPlatform
	
	lw $a0, thirdPfX
	lw $a1, thirdPfY
	jal CoordinateToAddress
	jal DrawPlatform
	
	lw $a0, newPfX
	lw $a1, newPfY	
	jal CoordinateToAddress
	jal DrawPlatform
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra

#####################################################################
# Update Score
#####################################################################
UpdateScore:
	lw $t0, score
	lw $t1, scoreGain
	add $t0, $t0, $t1
	sw $t0, score
	jr $ra	

ResetScore:
	sw $zero, score
	jr $ra

#####################################################################
# Sound Effect
#####################################################################
LandingSoundEffect:
	# play sound to signify jumping
	li $v0, 31
	li $a0, 50
	li $a1, 200
	li $a2, 9
	li $a3, 78
	syscall

	li $a0, 50
	li $a1, 200
	li $a2, 9
	li $a3, 78
	syscall
	jr $ra	

#####################################################################
# Increase Difficulty
#####################################################################

GameSpeed:
	li $v0, 32
	lw $a0, gameSpeed
	syscall
	jr $ra
	
IncreaseGamespeed:
	lw $t0, gameSpeed
	beq $t0, 20, END	# check if the game speed is 20, then stop increasing
	addi $t0, $t0, -20
	sw $t0, gameSpeed
	jr $ra

CheckIncreaseGamespeed:
	lw $t0, score	
	li $t1, 35		# game speed increases for each 35 points of score
	div $t0, $t1
	mfhi $t0
	beq $t0, 0, IncreaseGamespeed	
	jr $ra	

ResetGamespeed:
	li $t0, 100
	sw $t0, gameSpeed
	jr $ra
		
#####################################################################
# Input Check
#####################################################################
		
InputCheck:
	lw $t8, 0xffff0000
	beq $t8, 1, CheckInput
	jr $ra
	
CheckInput:	
	lw $t2, 0xffff0004
	beq $t2, 0x6a, MoveLeft		# if the input is j then move left
	beq $t2, 0x6b, MoveRight	# if the input is k then move right
	jr $ra

MoveRight:
	li $t1, 1
	sw $t1, doodlerDirection	# set the direction to 1	
	lw $t0, doodlerPositionX	# Access doodlerPositionX
	addi $t0, $t0, 2		# Move it to the right by 1
	bge $t0, 32, ResetDoodlerPosition0
	sw $t0, doodlerPositionX
	jr $ra

MoveLeft:
	li $t1, 0
	sw $t1, doodlerDirection	# set the direction to 0	
	lw $t0, doodlerPositionX	# Access doodlerPositionX
	addi $t0, $t0, -2		# Move it to the left by 1
	ble $t0, -1, ResetDoodlerPosition32
	sw $t0, doodlerPositionX
	jr $ra
	

InputName:
	li $v0, 54
	la $a0, enterNameMessage	# display the enter name instruction
	la $a1, buffer			# save the entered string to buffer
	li $a2, 20			# max number of characters to read
	syscall
	jr $ra
    		
Exit:	
	#play a sound tune to signify game over
	li $v0, 31
	li $a0, 28
	li $a1, 250
	li $a2, 32
	li $a3, 127
	syscall

	li $a0, 45
	li $a1, 250
	li $a2, 32
	li $a3, 127
	syscall

	li $a0, 20
	li $a1, 1000
	li $a2, 32
	li $a3, 127
	syscall
	
	li $v0, 59
	la $a0, helloMessage	# Your name:
	la $a1, buffer		# The name you entered at the beginning
	syscall

	li $v0, 56 		# syscall value for dialog
	la $a0, lostMessage 	# get message
	lw $a1, score		# get score
	syscall

	li $v0, 50 		# syscall for yes/no dialog
	la $a0, restartMessage	# get message
	syscall

	beqz $a0, _main 	# j ump back to start of program
	# end program
	li $v0, 10
	syscall
	


