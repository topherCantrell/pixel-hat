"""
  - Use the sudo raspi-config to turn off the serial terminal but enable the serial hardware
  - Install pyserial (probably already installed)
  - Install tornado GLOBALLY like this: python -m pip install tornado
  - This file is in a directory named "web". Copy the entire directory (and subs) to the pi home
  - Add this line to /etc/rc.local (before the exit 0):
  -   /home/pi/ONBOOT.sh 2> /home/pi/ONBOOT.errors > /home/pi/ONBOOT.stdout &
  - Add the following ONBOOT.sh script to /home/pi and make it executable:
  
#!/bin/bash
cd /home/pi/web
/usr/bin/python server.py
  
"""
import tornado.ioloop
import tornado.web
import os
import serial
        
class CGIHandler(tornado.web.RequestHandler):
    def get(self,first):        
        first = first.lower()        
        self.write(":"+first+":")        
        
        ser.write(bytes(first+"\x0D"))        
        ' /r = CR 0x0D'
        ' /n = LF 0x0A'
        ' Windows sends 0x0D, 0x0A'
        ' Linux sends 0x0A'
        ' The ParallaxSerialTerminal is watching for 0x0D. Sigh. We send that manually.'

#ser = serial.Serial('COM9',115200)
ser = serial.Serial('/dev/serial0',115200)

root = os.path.join(os.path.dirname(__file__), "webroot")

handlers = [
    (r"/cgi/(.*)", CGIHandler),        
    (r"/(.*)", tornado.web.StaticFileHandler, {"path": root, "default_filename": "index.html"}),
    ]

app = tornado.web.Application(handlers)
app.listen(8888)
tornado.ioloop.IOLoop.current().start()