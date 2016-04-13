import inspect
import os
import sys

root = lambda x: os.path.join(os.path.dirname(inspect.currentframe().f_code.co_filename), x)
sys.path.append(root('.'))

c = get_config()

c.IPKernelApp.pylab = "inline"

c.NotebookApp.ip = "*"
c.NotebookApp.open_browser = False
c.NotebookApp.port = 8888
