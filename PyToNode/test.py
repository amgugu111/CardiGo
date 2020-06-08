import os
import tkinter as tk
from tkinter import filedialog as fd

dir_name = fd.askdirectory()
print(dir_name)
directry='live'
path = os.path.join(dir_name,directry)
print(path)