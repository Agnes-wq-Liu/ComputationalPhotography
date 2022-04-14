import numpy as np
import math
import matplotlib.pyplot as plt
import matplotlib.image as mim
import time
import cv2
from torchvision import models
from PIL import Image 
import torch
import torchvision.transforms as T
#from google.colab import files
def decode_segmap(image,foreground,background, nc=21):
  label_colors = np.array([(0, 0, 0),  # 0=background
          # 1=aeroplane, 2=bicycle, 3=bird, 4=boat, 5=bottle
          (0, 0, 0), (0, 0, 0), (1,1,1), (0, 0, 0), (0, 0, 0),
          # 6=bus, 7=car, 8=cat, 9=chair, 10=cow
          (0, 0, 0), (0, 0, 0), (0, 0, 0), (0, 0, 0), (0, 0, 0),
          # 11=dining table, 12=dog, 13=horse, 14=motorbike, 15=person
          (0, 0, 0), (0, 0, 0), (0, 0, 0), (0, 0, 0), (0, 0, 0),
          # 16=potted plant, 17=sheep, 18=sofa, 19=train, 20=tv/monitor
          (0,0,0), (0, 0, 0), (0, 0, 0), (0, 0, 0), (0, 0, 0)])
  r = np.zeros_like(image).astype(np.uint8)
  g = np.zeros_like(image).astype(np.uint8)
  b = np.zeros_like(image).astype(np.uint8)
  for l in range(0, nc):
    idx = image == l
    r[idx] = label_colors[l, 0]
    g[idx] = label_colors[l, 1]
    b[idx] = label_colors[l, 2]
  rgb = np.stack([r, g, b], axis=2)
  print("rgb mask generated")
  background = cv2.resize(background,(r.shape[1],r.shape[0]))
  foreground = cv2.resize(foreground,(r.shape[1],r.shape[0]))
  foreground = foreground.astype(float)
  background = background.astype(float)
  plt.imshow(foreground/255); plt.axis('off'); plt.show()
  plt.imshow(background/255); plt.axis('off'); plt.show()
  th, alpha = cv2.threshold(np.array(rgb),0,255, cv2.THRESH_BINARY)
  # alpha = cv2.erode(alpha, np.ones((1,1)), iterations=8)
  alpha = cv2.GaussianBlur(alpha, (15,15),0)
  alpha = alpha.astype(float)/255
  foreground = cv2.multiply(alpha, foreground)
  background = cv2.multiply(1.0 - alpha, background)
  outImage = cv2.add(foreground, background)
  plt.imshow(outImage/255); plt.axis('off'); plt.show()
  return outImage/255

def segment(net,fg,bg):
  fore = Image.open(fg)
  back = Image.open(bg)
  # resize to bg height
  left = (back.size[0]-fore.size[0])//2
  right = math.ceil(back.size[0]-fore.size[0])
  wpercent = (float(fore.size[0])/float(fore.size[1]))
  hsize = int((float(back.size[1])*float(wpercent)))
  fore = fore.resize((hsize,back.size[1]), Image.ANTIALIAS)
  # padd with bg
  fore_new = Image.new("RGB", (back.size[0], back.size[1]), "white")
  fore_new.paste(back, (0, 0))
  fore_new.paste(fore, (left, 0))
  fore_new.paste(back, (back.size[0]-right, 0))
  print("reshape done")
  # plt.imshow(fore_new); plt.axis('off'); plt.show()
  # aapply transformation
  trf = T.Compose([T.Resize(1440),
          T.ToTensor(),
          T.Normalize(mean = [0.485, 0.456, 0.406],
          std = [0.229, 0.224, 0.225])])
  inp = trf(fore_new).unsqueeze(0)
  print("runing model")
  out = net(inp)['out']
  om = torch.argmax(out.squeeze(), dim=0).detach().cpu().numpy()
  fg = np.asarray(fore_new)
  bg = np.asarray(back)
  print("calling decoding")
  rgb = decode_segmap(om,fg,bg)
  plt.imshow(rgb); plt.axis('off'); plt.show()
  return rgb

def main():
  dlab = models.segmentation.deeplabv3_resnet101(pretrained=1).eval()
  generated = segment(dlab, 'flamingo.jpg','snow.jpg')
  mim.imsave('flamingo_CP3.jpg', generated)


if __name__ == '__main__':
  main()
