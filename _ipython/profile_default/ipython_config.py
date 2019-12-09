#from powerline.bindings.ipython.since_5 import PowerlinePrompts
#c = get_config()
#c.TerminalInteractiveShell.simple_prompt = False
#c.TerminalInteractiveShell.prompts_class = PowerlinePrompts

# Autoreload imports
c.InteractiveShellApp.extensions = ['autoreload']
c.TerminalIPythonApp.exec_lines = ['%autoreload 2']
