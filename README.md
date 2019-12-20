# Smartphone-Image-Denoising-Dataset
This is an unofficial implement of defective pixels detection in paper "A High-Quality Denoising Dataset for Smartphone Cameras".

## How to get the defective pixel mask
First, you should run the python script "getMeanBlack.py" to generate the mean image shot in very dark environment.

Then, you can run "getDefectLocation.m" in matlab to get the mask of defective pixels.

To generate a clean ground truth of a noise sequence image, you can run the official code from [SIDD](https://github.com/AbdoKamel/sidd-ground-truth-image-estimation)
