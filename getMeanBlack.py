#!/usr/bin/env python
#coding=utf-8


import os,sys
import h5py
import numpy as np
from scipy import io
import rawpy
from tqdm import tqdm

root = '/media/tcl2/darkshot/qiuchao/project/SIDD_code/T1'
subdirs = ['20191126_104924','20191126_105005','20191126_105046']
subdirs = [os.path.join(root,i) for i in subdirs]

k = 0
meanIm = np.zeros((3000,4000))
for sbdir in subdirs:
    names = os.listdir(sbdir)
    impaths = [os.path.join(sbdir,i) for i in names]
    for impath in tqdm(impaths):
        with rawpy.imread(impath) as raw:
            rawIm = raw.raw_image_visible.astype(np.float32)
        meanIm += rawIm
        k += 1
meanIm /= k*1.0
meanIm = np.transpose(meanIm)
io.savemat('meanBlack.mat',{'x':meanIm})



