''##### 2G LIMIT #####
''
'' This bit-bang works for cards 2G or less. Cards larger than 2G use
'' a different hardware protocol and require a different driver.
''
''##### TRAVERSING THE FAT #####
''
'' A full-blown FAT-traversing filesystem library can be quite resource
'' intensive. If you just need to persist data in a single file and exchange
'' it with a computer then there is a much lighter way.
''
'' First, format your SD card (FAT or FAT32) in your computer so it is nice
'' and clean. Then create the one file you want to access from the propeller.
'' The name doesn't matter. Pad the file with blanks on the end if your
'' application will be adding data.
''
'' A single file on a freshly formatted card will always be arranged in
'' contiguous sectors beginning with the card's first data-sector. Once you
'' know the card's first data-sector, you can access the file in 512-byte
'' sectors relative to the first sector. 
''
'' Finding the first data-sector requires some computation with values from
'' the card's Master Boot Record and the Boot Sector.
'' 
''##### HARDWARE #####
''
'' I found various opinions about SPI pullup resistors. Some projects on the web work
'' fine with none. Some projects use a sprinkling of resistors on certain pins. The
'' parallax SD Card Adapter includes 8 10K pullups -- one for every signal.
''
'' I used a 10K pullup on the chip select pin. This keeps the signal unasserted while
'' the propeller is powering up and configuring its I/O pins.
''
'' I used a 10K pullup on the DO signal from the SD card. This is the only input to
'' the propeller, and I don't want it to float if there is no card plugged in.
''
'' I used a 220 current limiting resisor on the input line to protect the propeller.
''
''              3.3V
''                           
''      220Ω       10KΩ        
'' Pn ───────┻──┼─── DO                 
'' Pn ────────────┼─── SCLK 
'' Pn ────────────┼─── DI                      
'' Pn ────────────┻─── CS   
''
''##### SPI #####
''
'' The SD SPI communications code was taken from Tomas Rokicki's work
'' available on the Parallax Propeller Object Exchange in the object:
'' "FAT16 routines with secure digital card layer"
''
''##### SPEEDS #####
'' I tested a card with a read loop. I got exactly 1000 sectors per second.

VAR 
  ' Parameter block shared with the assembly driver
  long sd_command
  long sd_sectorAddress
  long sd_memoryAddress

  ' First sector of the first file of the clean SD card
  long firstSector
  
pub start(mountBuffer, pinDO, pinSCLK, pinDI, pinCS) | err, numReserved, sectorsPerFat, numRootDirSectors
'' Mount the SD card and find the first data-sector on the card
'' The "pin" parameters define the hardware connection. The "mountBuffer" is a 512 byte buffer
'' used to load the MBR and Boot Sector
'' This method returns 0 if all is well or an error code if something is wrong. Error code
'' 100 means the card is badly formatted.

' Copy to the assembly code
   do   := pinDO
   clk  := pinSCLK
   di   := pinDI          
   cs   := pinCS  

   cognew(@SDCard,@sd_command)

   ' Mount the card
   sd_memoryAddress := mountBuffer
   sd_command := 1
   repeat while sd_command<>0      
      
   ' Get the Master Boot Record
   readSectors(mountBuffer,0,1)
   err := waitForDone
      
   if err<>0
     return err  
   if byte[mountBuffer+510]<>$55 OR byte[mountBuffer+511]<>$AA
     return $100   
                              
   ' Get the Boot Sector
   firstSector := byte[mountBuffer+$1C6]    ' 0087
   readSectors(mountBuffer,firstSector,1)
   err := waitForDone
   if err<>0
     return err   
   if byte[mountBuffer+510]<>$55 OR byte[mountBuffer+511]<>$AA
     return $100

   firstSector := 0

   ' Look for the file signature
   
   repeat
     firstSector := firstSector + 1
     readSectors(mountBuffer,firstSector,1)
     err := waitForDone
     if err<>0
       return err
     if byte[mountBuffer]==$32 and byte[mountBuffer+1]==$30 and byte[mountBuffer+2]==$31 and byte[mountBuffer+3]==$38
       return 0
      
  

{{
   numReserved := byte[mountBuffer+14] + byte[mountBuffer+15]<<8          ' 029E (my card in testing)
   ' This is zero for FAT32 (then we get it another way)
   sectorsPerFat := byte[mountBuffer+$16] + byte[mountBuffer+$17]<<8      ' 0000
   
   if sectorsPerFat <> 0
     ' FAT16
     numRootDirSectors := (byte[mountBuffer+$11] + byte[mountBuffer+$12]<<8)>>4   ' 
   else
     'FAT32
     sectorsPerFat :=  byte[mountBuffer+36] + byte[mountBuffer+37]<<8 + byte[mountBuffer+38]<<16 + byte[mountBuffer+39]<<24  ' 0EB1
     numRootDirSectors := byte[mountBuffer+13] * 3 'Clusters for root directory TODO Need to figure out where 3 comes from :-)

   ' Skip to the first data sector
   ' 209F           0087             029E               02                 0EB1             18 (FAT32)
   firstSector := firstSector + numReserved + byte[mountBuffer+16] * sectorsPerFat + numRootDirSectors

   ' TODO figure all this out
   
   'firstSector := $2E0
   firstSector := 0
   return 0
}}

pub readFileSectors(_memoryAddress, _sectorOffset, _count)
'' Read sectors from the first file on the card
  readSectors(_memoryAddress, _sectorOffset+firstSector, _count)

pub writeFileSectors(_memoryAddress, _sectorOffset, _count)
'' Write sectors to the first file on the card
  writeSectors(_memoryAddress, _sectorOffset+firstSector, _count)     

pub getFirstFileSector
'' First sector in the data area (basis for all "first-file" operations)
  return firstSector  

pub waitForDone
  repeat while sd_command<>0
  return sd_sectorAddress

pub readSectors(_memoryAddress, _sectorAddress, _count)
'' Read sectors from the card

  sd_memoryAddress := _memoryAddress
  sd_sectorAddress := _sectorAddress
  _count := _count | $1_00
  sd_command := _count

pub writeSectors(_memoryAddress, _sectorAddress, _count)
'' Write sectors to the card

  sd_memoryAddress := _memoryAddress
  sd_sectorAddress := _sectorAddress
  _count := _count | $2_00
  sd_command := _count
   
DAT      
         org 0

SDCard                                 '  Parameter block (aligned on LONG boundary): 
         mov       command,par         '  4 command 
         mov       sectorAddress,par   '    00_00000001   Mount SD card    
         add       sectorAddress,#4    '    01_nnnnnnnn   Read n 512-byte sectors from address to memory
         mov       memoryPtr,par       '    10_nnnnnnnn   Write n 512-byte from memory to address
         add       memoryPtr,#8        '  4 sectorAddress ,  4 memortyPtr              

main     rdlong    com,command wz      ' Wait on a ...
  if_z   jmp       #main               ' ... non-zero command

         mov       count,com           ' Get sector ...
         and       count,#$FF          ' ... count
         shr       com,#8 wz           ' Get command
                  
  if_z   jmp      #SD_Mount            ' 0 = MOUNT (memoryPtr is a scratch 512 byte buffer)
         cmp      com,#1 wz            ' 1 = ...             
  if_z   jmp      #SD_MultiRead        ' ... READ
         cmp      com,#2 wz            ' 2 = ...
  if_z   jmp      #SD_MultiWrite       ' ... WRITE

finalER2 mov     tmp, #$10F
         jmp     #finalN
         
finalERR mov      tmp,#$1F2            ' General FAIL
         jmp      #finalN              ' Send error code
         
finalOK  mov      tmp,#0               ' 0 is OK
finalN   wrlong   tmp, sectorAddress   ' Error status
         mov      com,#0               ' Clear command ...
         wrlong   com,command          ' ... (we are done)
         jmp      #main                ' Next command

SD_MultiWrite
        rdlong   parptr,memoryPtr      ' Get the memory pointer
        rdlong   parptr2,sectorAddress ' Get the sector number        
multiWrite
        call     #SD_Write             ' Write one sector
        add      parptr2,#1            ' Next sector
        add      parptr,sector         ' Next 512 bytes
        djnz     count,#multiWrite     ' Loop over all
        jmp      #finalOK              ' OK

SD_MultiRead
        rdlong   parptr,memoryPtr      ' Get the memory pointer
        rdlong   parptr2,sectorAddress ' Get the sector number          
multiRead
        call     #SD_Read              ' Read one sector
        add      parptr2,#1            ' Next sector
        add      parptr,sector         ' Next 512 bytes
        djnz     count,#multiRead      ' Loop over all
        jmp      #finalOK              ' OK
 
' ------------------------------------------------------------------------------------------------------
' ------------------------------------------------------------------------------------------------------
' ------------------------------------------------------------------------------------------------------

' Modified from sdspiqasm  "FAT16 routines with secure digital card layer"

SD_Mount

        mov acca,#1
        shl acca,di        
        or dira,acca
        mov acca,#1
        shl acca,clk
        or dira,acca
        mov acca,#1
        shl acca,do
        mov domask,acca
        mov acca,#1
        shl acca,cs
        or dira,acca
        mov csmask,acca
        neg phsb,#1
        mov frqb,#0
        mov acca,nco
        add acca,clk
        mov ctra,acca
        mov acca,nco
        add acca,di
        mov ctrb,acca  
            
        mov ctr2,onek
oneloop
        call #sendiohi 
        djnz ctr2,#oneloop   
        mov starttime,cnt
        mov cmdo,#0
        mov cmdp,#0        
        call #cmd
        or outa,csmask
        call #sendiohi   

initloop
        mov cmdo,#55
        call #cmd
        mov cmdo,#41
        call #cmd
        or outa,csmask
        cmp accb,#1 wz
   if_z jmp #initloop  
         
' reset frqa and the clock
'finished
        mov frqa,#0
        or outa,csmask
        neg phsb,#1
        call #sendiohi
'pause
        mov acca,#511
        add acca,cnt
        waitcnt acca,#0          

         jmp  #finalOK
 

SD_Write                  
' parptr2   = block address
' parptr    = RAM pointer
        mov starttime,cnt
        mov cmdo,#24
        mov cmdp,parptr2
        call #cmd
        mov phsb,#$fe
        call #sendio
        mov accb,parptr
        neg frqa,#1
        mov ctr2,sector
wbyte
        rdbyte phsb,accb
        shl phsb,#23
        add accb,#1
        mov ctr,#8
wbit    mov phsa,#8
        shl phsb,#1
        djnz ctr,#wbit
        djnz ctr2,#wbyte        
        neg phsb,#1
        call #sendiohi
        call #sendiohi
        call #readresp
        and accb,#$1f
        sub accb,#5
        mov rw_status,accb
        call #busy 
        mov frqa,#0 
        or outa,csmask
        neg phsb,#1
        call #sendiohi
'pause
        mov acca,#511
        add acca,cnt
        waitcnt acca,#0
SD_Write_ret
        ret     
        
SD_Read
' parptr2 = block address
' parptr  = RAM pointer
        mov starttime,cnt
        mov cmdo,#17
        mov cmdp,parptr2
        call #cmd
        call #readresp
        mov accb,parptr
        sub accb,#1
        mov ctr2,sector
rbyte
        mov phsa,hifreq
        mov frqa,freq
        add accb,#1
        test domask,ina wc
        addx acca,acca
        test domask,ina wc
        addx acca,acca
        test domask,ina wc
        addx acca,acca
        test domask,ina wc
        addx acca,acca
        test domask,ina wc
        addx acca,acca
        test domask,ina wc
        addx acca,acca
        test domask,ina wc
        addx acca,acca
        mov frqa,#0
        test domask,ina wc
        addx acca,acca
        wrbyte acca,accb
        djnz ctr2,#rbyte        
        mov frqa,#0
        neg phsb,#1
        call #sendiohi
        call #sendiohi
        or outa,csmask
        mov rw_status,ctr2        
        mov frqa,#0 
        or outa,csmask
        neg phsb,#1
        call #sendiohi
'pause
        mov acca,#511
        add acca,cnt
        waitcnt acca,#0
SD_Read_ret
        ret          

sendio
        rol phsb,#24
sendiohi
        mov ctr,#8
        neg frqa,#1
        mov accb,#0
bit     mov phsa,#8
        test domask,ina wc
        addx accb,accb        
        rol phsb,#1
        djnz ctr,#bit
sendio_ret
sendiohi_ret
        ret
checktime
        mov duration,cnt
        sub duration,starttime
        cmp duration,clockfreq wc
checktime_ret
  if_c  ret             
        neg duration,#13
        and duration,C_FFFF
        or  duration,#1
        'wrlong duration,boxDat1Ret         
        
        mov frqa,#0        
        or outa,csmask
        neg phsb,#1
        call #sendiohi
'pause
        mov acca,#511
        add acca,cnt
        waitcnt acca,#0
        jmp #finalER2
        
cmd
        andn outa,csmask
        neg phsb,#1
        call #sendiohi
        mov phsb,cmdo
        add phsb,#$40
        call #sendio
        mov phsb,cmdp
        shl phsb,#9
        call #sendiohi
        call #sendiohi
        call #sendiohi
        call #sendiohi
        mov phsb,#$95
        call #sendio
readresp
        neg phsb,#1
        call #sendiohi
        call #checktime
        cmp accb,#$ff wz
   if_z jmp #readresp 
cmd_ret
readresp_ret
        ret
busy
        neg phsb,#1
        call #sendiohi
        call #checktime
        cmp accb,#$0 wz
   if_z jmp #busy
busy_ret
        ret
               
' These are set before spinning up
do        long   0
clk       long   0
di        long   0
cs        long   0

rw_status long   0  
nco       long   $1000_0000
hifreq    long   $e0_00_00_00
freq      long   $20_00_00_00
clockfreq long   80_000_000
onek      long   1000
sector    long   512
domask    long   0
csmask    long   0
acca      long   0
accb      long   0
cmdo      long   0
cmdp      long   0
parptr    long   0
parptr2   long   0
ctr       long   0
ctr2      long   0
starttime long   0
duration  long   0

command            long 0
sectorAddress      long 0
memoryPtr          long 0
com                long 0
count              long 0
tmp                long 0
C_FFFF             long $FFFF

lastAdr  fit
        