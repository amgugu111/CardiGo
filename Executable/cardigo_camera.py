import cv2
import time
import os
import tkinter as tk
from tkinter import filedialog, Text
import requests
from PIL import Image, ImageTk
from urllib.request import urlopen
from io import BytesIO
import base64
import json

#SelectPath method to browse and select path to store live image 
def selectPath():
	dir_name = filedialog.askdirectory(title='Select Path')
	directry='live'
	path = os.path.join(dir_name,directry)
	try:
	    os.makedirs(path)
	    print('Dir created'+path)
	    return path
	except OSError as error:
	    print('Dir already exists'+path)
	    return path

#runApp method which captures frames and send it to NodeRed
def runApp():
	path = selectPath()
	delId = delIdText.get().strip()
	print(delId)
	i=0
	for i in range (960):
		videoCaptureObject = cv2.VideoCapture(0)
		ret,frame = videoCaptureObject.read()
		final_path = os.path.join(path,"picture.jpeg")
		cv2.imwrite(final_path,frame)
		image_file_descriptor = open(final_path, 'rb')
		files = {'image/jpeg': image_file_descriptor}
		imgUrl = 'https://node-red-vlxgg.eu-gb.mybluemix.net/mns'
		r=requests.post(imgUrl, files=files)
		print('Photo Status Code'+str(r.status_code))
		image_file_descriptor.close()
		delIdUrl = 'https://node-red-vlxgg.eu-gb.mybluemix.net/Id'
		empId = {'Id':delId}
		rId=requests.post(delIdUrl,json=empId)
		print('ID status Code'+str(rId.status_code))
		i+=1
		print(i)
		videoCaptureObject.release()
		cv2.destroyAllWindows()
		time.sleep(30)

root = tk.Tk()
root.title('CardiGo')

#icon
raw_datax = urlopen('https://i.ibb.co/Lzt1mPZ/cg-logo.png').read()
imx = Image.open(BytesIO(raw_datax))
photox = ImageTk.PhotoImage(imx)
root.tk.call('wm', 'iconphoto', root._w, photox)

alertLabel = tk.Label(root, text="Please keep this window running in background")
alertLabel.pack()

closeLabel = tk.Label(root, text="Don't close this window!")
closeLabel.pack()

canvas= tk.Canvas(root, height=200, width=600)
canvas.pack()

#Deloitte Logo
logo_url ="https://i.ibb.co/dJgNSwv/Deloitte-Logo.png"
u = urlopen(logo_url)
raw_data = u.read()
u.close()
im = Image.open(BytesIO(raw_data))
photo = ImageTk.PhotoImage(im)
canvas.create_image(155,50, anchor='nw', image=photo)

idLabel = tk.Label(root, text='Enter Deloitte ID')
idLabel.pack()

delIdText = tk.Entry(root, width=50)
delIdText.pack()

sizedcanvas1= tk.Canvas(root, height=8)
sizedcanvas1.pack()


#Run App Button
runAppBtn = tk.Button(root,text="Run App", bg="#86BC24",fg="black",
	padx=10, pady=5, command=runApp)
runAppBtn.pack()


sizedcanvas2= tk.Canvas(root, height=8)
sizedcanvas2.pack()

quitBtn = tk.Button(root,text="Quit", bg="black",fg="white",
	padx=10, pady=5, command=root.destroy)
quitBtn.pack()

sizedcanvas3= tk.Canvas(root, height=15)
sizedcanvas3.pack()

root.mainloop()
