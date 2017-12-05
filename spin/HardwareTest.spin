CON
  _clkmode        = xtal1 + pll16x
  _xinfreq        = 5_000_000

CON

' MicroUSB
    pinDO   = 27
    pinSCLK = 26
    pinDI   = 25
    pinCS   = 24

' Serial Sync
    pinTX   = 6 ' Blue
    pinRX   = 7 ' Green



' NeoPixel
' The foam-seam is in the center of the right side of the hat.
' That makes the panels UpperFront, UpperBack, LowerFront,
' and LowerBack as follows: 
'
'   UpperFront       UpperBack
' ***************  ***************
' * ┌┐       ┌┐ *  * ┌┐       ┌┐ *
' * ││       ││ *  * ││       ││ *
' * │       ││ *  * │       ││ *
' * │        │ *  * │        │ *
' * │        ││ *  * │        ││ *
' * │       ││ *  * │       ││ *
' *        ││ *  *        ││ *
' * 255     └┘0 *  * 255     └┘0 *
' ***************  ***************
' ***************  ***************
' * ┌┐       ┌┐ *  * ┌┐       ┌┐ *
' * ││       ││ *  * ││       ││ *
' * │       ││ *  * │       ││ *
' * │        │ *  * │        │ *
' * │        ││ *  * │        ││ *
' * │       ││ *  * │       ││ *
' *        ││ *  *        ││ *
' * 255     └┘0 *  * 255     └┘0 *
' ***************  ***************
'   LowerFront       LowerBack
'
    pinD1   = 19 ' Purple   ' D5  UpperBack
    pinD2   = 20 ' White    ' D6  LowerBack
    pinD3   = 21 ' Yellow   ' D7  LowerFront
    pinD4   = 22 ' Gray     ' D8  UpperFront


'  1 2 9 4 5 6 7 8 9  arrows on right of hat (with the foam seam)
'
'
'
'
'
'

' Button (CPU 1 only)
    pinBT   = 10

OBJ    
    STRIP    : "NeoPixelStrip"    
    PST      : "Parallax Serial Terminal"
    SD       : "SDCard"      

VAR

    byte sectorBuffer[2048]


pub StripTest 

  ' Go ahead and drive the pixel data lines low.
  dira[pinD1] := 1
  outa[pinD1] := 0

  dira[pinD2] := 1
  outa[pinD2] := 0

  dira[pinD3] := 1
  outa[pinD3] := 0

  dira[pinD4] := 1
  outa[pinD4] := 0

  STRIP.init

  PauseMSec(1000)

'  STRIP.draw(2, @colors, @pixelsEdge, pinD1,  27)
 ' STRIP.draw(2, @colors, @pixelsCir,  pinD2, 271)

  STRIP.draw(2, @colors2, @pixelsColorful,  pinD1,  27)
  STRIP.draw(2, @colors2, @pixelsColorful,  pinD2, 271)
  
  'STRIP.draw(2, @colors, @pixels1, pinD1, 256)    ' UpperBack  BLUE   
  'STRIP.draw(2, @colors, @pixels2, pinD2, 256)    ' LowerBack  RED
  'STRIP.draw(2, @colors, @pixels3, pinD3, 256)    ' LowerFront GREEN
  'STRIP.draw(2, @colors, @pixels4, pinD4, 256)    ' UpperFront WHITE  

  repeat
    PauseMSec(5000)

pri ButtonTest | i

  dira[10] := 0

  PauseMSec(2000) 
  PST.start(115200)

  repeat
    i := ina[10]
    PST.hex(i,2)
    PauseMSec(500)

  

pri PinTest | i
    
  pulsePin(pinRX)
  

pri MainNEOSpeedTest | i

  STRIP.init

  PauseMSec(2000)

  PST.start(115200)

  ' 1000 updates of 256 took 10 seconds             100 refreshes/second     (25_600 pixels per second)
  ' 2000 updates of 256 took 17 seconds
  ' 6000 updates of 256 took 53 seconds

  ' 3000 updates of 512 took 53 seconds              50 refreshes/second     (25,600 pixels per second

  ' The longest strand of 288 pixels can be refreshed nearly 100 times/second
  ' 2 sectors per update (1/2 the hat takes 947.5 bytes)

  ' 10 refreshes per second would take 20 sectors per second
  ' The pixel driver can handle 100 refrehses per second ... NO PROBLEM
  ' The SD driver can handle 1000 sectors per second ... NO PROBLEM

  ' Test these numbers with a short repeated animation

  PST.str(string("START ..."))
  repeat i from 1 to 3000
    STRIP.draw(2, @sectorBuffer, @sectorBuffer, 19, 288)
  PST.str(string("DONE ..."))    
  
  'STRIP.draw(2, @colors, @pixels, PIN_D1, 256)
 
pri MainSDSpeedTest | i

  PauseMSec(2000)

  PST.start(115200)
  
  i := SD.start(@sectorBuffer, pinDO, pinSCLK, pinDI, pinCS)   
  PST.hex(i,8)
  PST.char(13)

  i := SD.getFirstFileSector
  PST.hex(i,8)
  PST.char(13)

  ' Reading 1000 sectors per second
  ' Wow. Seems too fast.

  PST.str(string("START ..."))
  repeat i from 1 to 60000
    SD.readFileSectors(@sectorBuffer,i,1)
  PST.str(string("DONE ..."))        
  
  repeat



pri SimpleReadTest    | i
  PauseMSec(2000)

  PST.start(115200)
  
  i := SD.start(@sectorBuffer, pinDO, pinSCLK, pinDI, pinCS)   
  
  i := SD.getFirstFileSector
  PST.hex(i,8)
  PST.char(13)

  SD.readFileSectors(@sectorBuffer,0,1)
  dumpSector(@sectorBuffer)      
 
PUB MainPulse

  pulsePin(22)    
      
PRI PauseMSec(Duration)
  waitcnt(((clkfreq / 1_000 * Duration - 3932) #> 381) + cnt)

pri dumpSector(address) | i,j,t
    t:=0
    repeat i from 0 to 31
      PST.hex(t,4)
      PST.char(" ")
      repeat j from 0 to 15
        PST.hex(byte[address],2)
        PST.char(" ")
        address += 1
        t+=1
      PST.char(13)
      ' TODO ASCII

pri pulsePin(p)
    dira[p] := 1 
    repeat
        outa[p] := 1
        PauseMSec(5000)
        outa[p] := 0
        PauseMSec(5000)
        
DAT

colors
         '   GG RR BB
    long $00_00_00_00  ' 0
    long $00_00_00_05  ' 1
    long $00_00_05_00  ' 2
    long $00_05_00_00  ' 3
    long $00_05_05_05  ' 4

colors2
         '   GG RR BB
    long $00_00_00_00  ' 0
    long $00_00_00_85  ' 1
    long $00_00_85_00  ' 2
    long $00_85_00_00  ' 3
    long $00_85_85_85  ' 4

pixelsEdge1
    byte 4
    byte 4
    byte 4,4
    byte 4,4
    byte 4,4,4
    byte 4,4,4
    byte 4,4,4
    byte 4,4,4
    byte 4,4,4
    byte 4,4
    byte 4,4
    byte 4
    byte 4
    
pixelsEdge
    byte 1
    byte 1
    byte 1,2
    byte 2,1
    byte 1,2,3
    byte 3,2,1
    byte 1,2,3
    byte 3,2,1
    byte 1,2,3
    byte 2,1
    byte 1,2
    byte 1
    byte 1
    

pixelsCir 
    byte 1                      ' Inner dot
    byte 2,0,0,0,0,0,0,2        ' Inner ring -- follow arrows
    
    byte 3,0,0,0,0,0,0,0,0,0,0,3
    byte 4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,4
    byte 1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1
    byte 2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2
    byte 3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3
    byte 4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,4
    byte 1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1

pixels1 
    byte 1,1,0,0,0,0,0,1
    byte 1,0,0,0,0,0,0,0    
    byte 0,0,0,0,0,0,0,0
    byte 0,0,0,0,0,0,0,0    
    byte 0,0,0,0,0,0,0,0
    byte 0,0,0,0,0,0,0,0
    byte 0,0,0,0,0,0,0,0
    byte 0,0,0,0,0,0,0,0
    byte 0,0,0,0,0,0,0,0
    byte 0,0,0,0,0,0,0,0
    byte 0,0,0,0,0,0,0,0
    byte 0,0,0,0,0,0,0,0
    byte 0,0,0,0,0,0,0,0
    byte 0,0,0,0,0,0,0,0
    byte 0,0,0,0,0,0,0,0
    byte 0,0,0,0,0,0,0,0 
    byte 0,0,0,0,0,0,0,0
    byte 0,0,0,0,0,0,0,0
    byte 0,0,0,0,0,0,0,0
    byte 0,0,0,0,0,0,0,0
    byte 0,0,0,0,0,0,0,0
    byte 0,0,0,0,0,0,0,0
    byte 0,0,0,0,0,0,0,0
    byte 0,0,0,0,0,0,0,0
    byte 0,0,0,0,0,0,0,0
    byte 0,0,0,0,0,0,0,0
    byte 0,0,0,0,0,0,0,0
    byte 0,0,0,0,0,0,0,0
    byte 0,0,0,0,0,0,0,0
    byte 0,0,0,0,0,0,0,0
    byte 0,0,0,0,0,0,0,1
    byte 1,0,0,0,1,1,1,1

pixels2 
    byte 2,2,0,0,0,0,0,2
    byte 2,0,0,0,0,0,0,0    
    byte 0,0,0,0,0,0,0,0
    byte 0,0,0,0,0,0,0,0    
    byte 0,0,0,0,0,0,0,0
    byte 0,0,0,0,0,0,0,0
    byte 0,0,0,0,0,0,0,0
    byte 0,0,0,0,0,0,0,0
    byte 0,0,0,0,0,0,0,0
    byte 0,0,0,0,0,0,0,0
    byte 0,0,0,0,0,0,0,0
    byte 0,0,0,0,0,0,0,0
    byte 0,0,0,0,0,0,0,0
    byte 0,0,0,0,0,0,0,0
    byte 0,0,0,0,0,0,0,0
    byte 0,0,0,0,0,0,0,0 
    byte 0,0,0,0,0,0,0,0
    byte 0,0,0,0,0,0,0,0
    byte 0,0,0,0,0,0,0,0
    byte 0,0,0,0,0,0,0,0
    byte 0,0,0,0,0,0,0,0
    byte 0,0,0,0,0,0,0,0
    byte 0,0,0,0,0,0,0,0
    byte 0,0,0,0,0,0,0,0
    byte 0,0,0,0,0,0,0,0
    byte 0,0,0,0,0,0,0,0
    byte 0,0,0,0,0,0,0,0
    byte 0,0,0,0,0,0,0,0
    byte 0,0,0,0,0,0,0,0
    byte 0,0,0,0,0,0,0,0
    byte 0,0,0,0,0,0,0,2
    byte 2,0,0,0,2,2,2,2

pixels3 
    byte 3,3,0,0,0,0,0,3
    byte 3,0,0,0,0,0,0,0    
    byte 0,0,0,0,0,0,0,0
    byte 0,0,0,0,0,0,0,0    
    byte 0,0,0,0,0,0,0,0
    byte 0,0,0,0,0,0,0,0
    byte 0,0,0,0,0,0,0,0
    byte 0,0,0,0,0,0,0,0
    byte 0,0,0,0,0,0,0,0
    byte 0,0,0,0,0,0,0,0
    byte 0,0,0,0,0,0,0,0
    byte 0,0,0,0,0,0,0,0
    byte 0,0,0,0,0,0,0,0
    byte 0,0,0,0,0,0,0,0
    byte 0,0,0,0,0,0,0,0
    byte 0,0,0,0,0,0,0,0 
    byte 0,0,0,0,0,0,0,0
    byte 0,0,0,0,0,0,0,0
    byte 0,0,0,0,0,0,0,0
    byte 0,0,0,0,0,0,0,0
    byte 0,0,0,0,0,0,0,0
    byte 0,0,0,0,0,0,0,0
    byte 0,0,0,0,0,0,0,0
    byte 0,0,0,0,0,0,0,0
    byte 0,0,0,0,0,0,0,0
    byte 0,0,0,0,0,0,0,0
    byte 0,0,0,0,0,0,0,0
    byte 0,0,0,0,0,0,0,0
    byte 0,0,0,0,0,0,0,0
    byte 0,0,0,0,0,0,0,0
    byte 0,0,0,0,0,0,0,3
    byte 3,0,0,0,3,3,3,3

pixels4 
    byte 4,4,0,0,0,0,0,4
    byte 4,0,0,0,0,0,0,0    
    byte 0,0,0,0,0,0,0,0
    byte 0,0,0,0,0,0,0,0    
    byte 0,0,0,0,0,0,0,0
    byte 0,0,0,0,0,0,0,0
    byte 0,0,0,0,0,0,0,0
    byte 0,0,0,0,0,0,0,0
    byte 0,0,0,0,0,0,0,0
    byte 0,0,0,0,0,0,0,0
    byte 0,0,0,0,0,0,0,0
    byte 0,0,0,0,0,0,0,0
    byte 0,0,0,0,0,0,0,0
    byte 0,0,0,0,0,0,0,0
    byte 0,0,0,0,0,0,0,0
    byte 0,0,0,0,0,0,0,0 
    byte 0,0,0,0,0,0,0,0
    byte 0,0,0,0,0,0,0,0
    byte 0,0,0,0,0,0,0,0
    byte 0,0,0,0,0,0,0,0
    byte 0,0,0,0,0,0,0,0
    byte 0,0,0,0,0,0,0,0
    byte 0,0,0,0,0,0,0,0
    byte 0,0,0,0,0,0,0,0
    byte 0,0,0,0,0,0,0,0
    byte 0,0,0,0,0,0,0,0
    byte 0,0,0,0,0,0,0,0
    byte 0,0,0,0,0,0,0,0
    byte 0,0,0,0,0,0,0,0
    byte 0,0,0,0,0,0,0,0
    byte 0,0,0,0,0,0,0,4
    byte 4,0,0,0,4,4,4,4

pixelsColorful
    byte 1,2,3,4,1,2,3,4
    byte 1,2,3,4,1,2,3,4
    byte 1,2,3,4,1,2,3,4
    byte 1,2,3,4,1,2,3,4
    byte 1,2,3,4,1,2,3,4
    byte 1,2,3,4,1,2,3,4
    byte 1,2,3,4,1,2,3,4
    byte 1,2,3,4,1,2,3,4
    byte 1,2,3,4,1,2,3,4
    byte 1,2,3,4,1,2,3,4
    byte 1,2,3,4,1,2,3,4
    byte 1,2,3,4,1,2,3,4
    byte 1,2,3,4,1,2,3,4
    byte 1,2,3,4,1,2,3,4
    byte 1,2,3,4,1,2,3,4
    byte 1,2,3,4,1,2,3,4
    byte 1,2,3,4,1,2,3,4
    byte 1,2,3,4,1,2,3,4
    byte 1,2,3,4,1,2,3,4
    byte 1,2,3,4,1,2,3,4
    byte 1,2,3,4,1,2,3,4
    byte 1,2,3,4,1,2,3,4
    byte 1,2,3,4,1,2,3,4
    byte 1,2,3,4,1,2,3,4
    byte 1,2,3,4,1,2,3,4
    byte 1,2,3,4,1,2,3,4
    byte 1,2,3,4,1,2,3,4
    byte 1,2,3,4,1,2,3,4
    byte 1,2,3,4,1,2,3,4
    byte 1,2,3,4,1,2,3,4
    byte 1,2,3,4,1,2,3,4
    byte 1,2,3,4,1,2,3,4
    byte 1,2,3,4,1,2,3,4
    byte 1,2,3,4,1,2,3,4
    byte 1,2,3,4,1,2,3,4
    byte 1,2,3,4,1,2,3,4
    byte 1,2,3,4,1,2,3,4
    byte 1,2,3,4,1,2,3,4
    byte 1,2,3,4,1,2,3,4
    byte 1,2,3,4,1,2,3,4
    byte 1,2,3,4,1,2,3,4
    byte 1,2,3,4,1,2,3,4
    byte 1,2,3,4,1,2,3,4
    byte 1,2,3,4,1,2,3,4
    byte 1,2,3,4,1,2,3,4
    byte 1,2,3,4,1,2,3,4
    byte 1,2,3,4,1,2,3,4
    byte 1,2,3,4,1,2,3,4
    byte 1,2,3,4,1,2,3,4
    byte 1,2,3,4,1,2,3,4
    byte 1,2,3,4,1,2,3,4
    byte 1,2,3,4,1,2,3,4
    byte 1,2,3,4,1,2,3,4
    byte 1,2,3,4,1,2,3,4
    byte 1,2,3,4,1,2,3,4
    byte 1,2,3,4,1,2,3,4
    byte 1,2,3,4,1,2,3,4
    byte 1,2,3,4,1,2,3,4
    byte 1,2,3,4,1,2,3,4
    byte 1,2,3,4,1,2,3,4
    byte 1,2,3,4,1,2,3,4
    byte 1,2,3,4,1,2,3,4
    byte 1,2,3,4,1,2,3,4
    byte 1,2,3,4,1,2,3,4
    byte 1,2,3,4,1,2,3,4
    byte 1,2,3,4,1,2,3,4
    byte 1,2,3,4,1,2,3,4
    byte 1,2,3,4,1,2,3,4
    byte 1,2,3,4,1,2,3,4
    byte 1,2,3,4,1,2,3,4
    byte 1,2,3,4,1,2,3,4
    byte 1,2,3,4,1,2,3,4
    byte 1,2,3,4,1,2,3,4
    byte 1,2,3,4,1,2,3,4
    byte 1,2,3,4,1,2,3,4
    byte 1,2,3,4,1,2,3,4
    byte 1,2,3,4,1,2,3,4
    byte 1,2,3,4,1,2,3,4
    byte 1,2,3,4,1,2,3,4
    byte 1,2,3,4,1,2,3,4
    byte 1,2,3,4,1,2,3,4
    byte 1,2,3,4,1,2,3,4
    byte 1,2,3,4,1,2,3,4
    byte 1,2,3,4,1,2,3,4
    byte 1,2,3,4,1,2,3,4
    byte 1,2,3,4,1,2,3,4
    byte 1,2,3,4,1,2,3,4
    byte 1,2,3,4,1,2,3,4
    byte 1,2,3,4,1,2,3,4
    byte 1,2,3,4,1,2,3,4 
    