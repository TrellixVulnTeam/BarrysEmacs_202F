'''
 ====================================================================
 Copyright (c) 2009 Barry A Scott.  All rights reserved.

 This software is licensed as described in the file LICENSE.txt,
 which you should have received as part of this distribution.

 ====================================================================

    wb_editor.py

    

'''
import time
import threading

import _bemacs


class BEmacs(_bemacs.BemacsEditor):
    def __init__( self, app ):
        _bemacs.BemacsEditor.__init__( self )

        self.app = app
        self.log = app.log

        self.window = None

        self.__event_queue = Queue()

    def initEmacsProfile( self, window ):
        self.log.debug( 'BEmacs.initEmacsProfile()' )
        assert window is not None
        self.window = window

        # initEditor will start calling termXxx functions - must have windows setup first
        self.initEditor()
        self.log.debug( 'BEmacs.initEmacsProfile() geometryChange %r %r' % (self.window.term_width, self.window.term_length) )
        self.geometryChange( self.window.term_width, self.window.term_length )
        self.log.debug( 'BEmacs.initEmacsProfile() emacs_profile.ml' )
        _bemacs.function.execute_mlisp_file( 'emacs_library:emacs_profile.ml' )

    def guiEventChar( self, ch, shift ):
        self.__event_queue.put( (self.inputChar, (ch, shift)) )

    def guiGeometryChange( self, width, length ):
        self.__event_queue.put( (self.geometryChange, (width, length)) )

    def termCheckForInput( self ):
        pass

    def termWaitForActivity( self ):
        try:
            while True:
                event_hander_and_args = self.__event_queue.get()

                while event_hander_and_args is not None:
                    handler, args = event_hander_and_args
                    handler( *args )

                    event_hander_and_args = self.__event_queue.getNoWait()

                return 0

        except Exception, e:
            print 'Error: waitForActivity %s' % (str(e),)
            self.app.debugShowCallers( 5 )
            return -1

    def termTopos( self, x, y ):
        self.app.onGuiThread( self.window.termTopos, (x, y) )

    def termReset( self ):
        self.app.onGuiThread( self.window.termReset, () )

    def termInit( self ):
        self.log.debug( 'BEmacs.termInit() window %r' % (self.window,) )
        self.app.onGuiThread( self.window.termInit, () )

    def termBeep( self ):
        self.app.onGuiThread( self.window.termBeep, () )

    def termUpdateBegin( self ):
        self.app.onGuiThread( self.window.termUpdateBegin, () )
        return True

    def termUpdateEnd( self ):
        self.app.onGuiThread( self.window.termUpdateEnd, () )

    def termUpdateLine( self, old, new, line_num ):
        self.app.onGuiThread( self.window.termUpdateLine, (old, new, line_num) )

    def termWindow( self, size ):
        self.app.onGuiThread( self.window.termWindow, (size,) )

    def termInsertMode( self, mode ):
        self.app.onGuiThread( self.window.termInsertMode, (mode,) )

    def termHighlightMode( self, mode ):
        self.app.onGuiThread( self.window.termHighlightMode, (mode,) )

    def termInsertLines( self, num_lines ):
        self.app.onGuiThread( self.window.termInsertLines, (num_lines,) )

    def termDeleteLines( self, num_lines ):
        self.app.onGuiThread( self.window.termDeleteLines, (num_lines,) )

    def termDisplayActivity( self, ch ):
        self.app.onGuiThread( self.window.termDisplayActivity, (ch,) )

class Queue:
    def __init__( self ):
        self.__all_items = []
        self.__lock = threading.RLock()
        self.__condition = threading.Condition( self.__lock )

    def getNoWait( self ):
        with self.__lock:
            if len( self.__all_items ) > 0:
                return self.get()

        return None

    def get( self ):
        with self.__condition:
            while len( self.__all_items ) == 0:
                self.__condition.wait()

            return self.__all_items.pop( 0 )

    def put( self, item ):
        with self.__condition:
            self.__all_items.append( item )
            self.__condition.notify()
