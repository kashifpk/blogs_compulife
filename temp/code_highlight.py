# A 'runner' for HTML output
# Accepts the input file and output file names as command line
# arguments. Loads docutils and pygments and runs the formatter.
#
# Based on:
#  rst2html - from the docutils distribution
#  external/rst-directive.py - from the pygments distribution
#
# This code is in the public domain
# Eli Bendersky
#

try:
    import locale
    locale.setlocale(locale.LC_ALL, '')
except:
    pass

##
## Configuring Pygments
##
from pygments.formatters import HtmlFormatter
from pygments import highlight
from pygments.lexers import get_lexer_by_name, TextLexer

from pygments.style import Style
from pygments.token import Keyword, Name, Comment, String, Error, \
     Number, Operator, Generic, Whitespace, Text

class SciteStyle(Style):
    default_style = ""

    styles = {
        Whitespace:                 '#bbbbbb',
        Text:                       '#000000',

        Comment:                    '#007f00',

        Keyword:                    'bold #00007f',

        Operator.Word:              '#0000aa',

        Name.Builtin:               '#00007f',
        Name.Function:              '#00007f',
        Name.Class:                 '#00007f',
        Name.Namespace:             '#00007f',

        String:                     '#7f007f',

        Number:                     '#007f7f',

        Generic:                    '#000000',
        Generic.Heading:            'bold #000080',
        Generic.Subheading:         'bold #800080',
        Generic.Deleted:            '#aa0000',
        Generic.Inserted:           '#00aa00',
        Generic.Error:              '#aa0000',
        Generic.Emph:               'italic',
        Generic.Strong:             'bold',
        Generic.Prompt:             '#555555',
        Generic.Output:             '#888888',
        Generic.Traceback:          '#aa0000',

        Error:                      '#F00 bg:#FAA'
    }

# Set to True if you want inline CSS styles instead of classes
inlinestyles = True

# The default formatter
DEFAULT = HtmlFormatter(noclasses=inlinestyles, linenos=False, style=SciteStyle)

# Add name -> formatter pairs for every variant you want to use
VARIANTS = {
     'linenos': HtmlFormatter(noclasses=inlinestyles, linenos=True, style=SciteStyle)
}


def pygments_directive(name, arguments, options, content, lineno,
                       content_offset, block_text, state, state_machine):
    """ Will process the highlighted source-code directive.
    """
    try:
        lexer = get_lexer_by_name(arguments[0])
    except ValueError:
        # no lexer found - use the text one instead of an exception
        lexer = TextLexer()
    # take an arbitrary option if more than one is given
    formatter = options and VARIANTS[options.keys()[0]] or DEFAULT
    parsed = highlight(u'\n'.join(content), lexer, formatter)
    return [nodes.raw('', parsed, format='html')]


##
## Loading docutils and registering the new directive
##
from docutils import nodes, io
from docutils.parsers.rst import directives
import docutils.core

pygments_directive.arguments = (1, 0, 1)
pygments_directive.content = 1
pygments_directive.options = dict([(key, directives.flag) for key in VARIANTS])
directives.register_directive('sourcecode', pygments_directive)


##
## Execution
##
import os, sys

infile = sys.argv[1]
outfile = os.path.splitext(infile)[0] + ".html"

print("Running HTML writer:\n-> %s" % outfile)

# Running publish_parts to get at the document body, without
# header, style specifications and footer
#
parts = docutils.core.publish_parts(
            source=open(infile, 'r'),
            source_class=io.FileInput,
            settings_overrides = {
                'doctitle_xform': 0,
                'initial_header_level': 3},
            writer_name='html')

open(outfile, 'w').write(parts['body'])
