'''
 ====================================================================
 Copyright (c) 2003-2008 Barry A Scott.  All rights reserved.

 This software is licensed as described in the file LICENSE.txt,
 which you should have received as part of this distribution.

 ====================================================================

    be_platform_specific.py

'''

import sys

if sys.platform == 'win32':
    from be_platform_win32_specific import *

elif sys.platform == 'darwin':
    from be_platform_macosx_specific import *

else:
    from be_platform_unix_specific import *

def getPreferencesFilename():
    return os.path.join( getApplicationDir(), 'Bemacs.xml' )

def getOldPreferencesFilename():
    return os.path.join( getApplicationDir(), 'Bemacs.ini' )

def getLogFilename():
    return os.path.join( getApplicationDir(), 'Bemacs.log' )

def getLastCheckinMessageFilename():
    return os.path.join( getApplicationDir(), 'log_message.txt' )

def setupPlatform():
    app_dir = getApplicationDir()
    if not os.path.exists( app_dir ):
        os.makedirs( app_dir )
