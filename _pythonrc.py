"""
Thanks to http://sontek.net/blog/detail/tips-and-tricks-for-the-python-interpreter

This file is executed when the Python interactive shell is started if
$PYTHONSTARTUP is in your environment and points to this file. It's just
regular Python commands, so do what you will. Your ~/.inputrc file can greatly
complement this file.
"""
import os

# readline tab and history support
#####
try:
    import readline
    import rlcompleter
except ImportError:
    print("You need readline and rlcompleter")


# Make this work properly in Darwin and Linux
if 'libedit' in readline.__doc__:
    readline.parse_and_bind("bind ^I rl_complete")
else:
    readline.parse_and_bind("tab: complete")


class Completer(object):
    def __init__(self):
        # Enable a History
        self.HISTFILE = os.path.expanduser("%s/.pyhistory" % os.environ["HOME"])

        # Read the existing history if there is one
        if os.path.exists(self.HISTFILE):
            readline.read_history_file(self.HISTFILE)

        # Set maximum number of items that will be written to the history file
        readline.set_history_length(300)

        try:
            import atexit
            atexit.register(self.savehist)
        except ImportError:
            pass

    def savehist(self):
        import readline
        # Only store a non-empty history since somehow reading an empty one fails!
        if readline.get_current_history_length():
            readline.write_history_file(self.HISTFILE)

c = Completer()


# prettyprinting
#####
import sys


def my_displayhook(value):
    if value is not None:
        try:
            import __builtin__
            __builtin__._ = value
        except ImportError:
            __builtins__._ = value

        import pprint
        pprint.pprint(value)
        del pprint

sys.displayhook = my_displayhook

# clean up namespace
del sys
