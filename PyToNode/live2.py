#!/usr/bin/env python
# coding: utf-8

# In[5]:


import cv2
import time
import os


# In[8]:


import requests


# In[12]:


my_path="C:\\Users\\Anwesha\\Desktop\\New pics"
directry='live'
path = os.path.join(my_path,directry)
try:
    os.makedirs(path)
    print('dir created')
except OSError as error:
    print('dir already exists')

videoCaptureObject = cv2.VideoCapture(0)
result = True
i=1
while(result):
    ret,frame = videoCaptureObject.read()
    cv2.imwrite(r"C:\Users\Anwesha\Desktop\New pics\live\Picture"+".jpg",frame)
    image_file_descriptor = open(r"C:\Users\Anwesha\Desktop\New pics\live\Picture.jpg", 'rb')
    files = {'image/jpeg': image_file_descriptor}
    url = 'https://node-red-vlxgg.eu-gb.mybluemix.net/mns'
    r=requests.post(url, files=files)
    print(r.status_code)
    image_file_descriptor.close()
    time.sleep(30)
    i=i+1
    
    if i==6:
        result = False
videoCaptureObject.release()
cv2.destroyAllWindows()


# In[20]:




