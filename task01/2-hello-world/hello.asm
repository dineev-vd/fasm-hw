format  pe gui 4.0
         entry   start
         include 'win32a.inc'

 start:
         invoke  MessageBox,NULL,message,message,MB_OK
         invoke  ExitProcess,0

 message db 'Hello, World!',0
  
         data    import
         library kernel32,'kernel32.dll',\
                 user32,'user32.dll'
         include 'api/kernel32.inc'
         include 'api/user32.inc'
         end     data