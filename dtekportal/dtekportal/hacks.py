#######################################################################
# HACK ATTACK: this allows Django template tags to span multiple lines.
#######################################################################
import re
from django.template import base
base.tag_re = re.compile(base.tag_re.pattern, re.DOTALL)
