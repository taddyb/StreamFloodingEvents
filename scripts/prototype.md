### What is this:

This file outlines the steps which I took to apply the computational power of a GPU to an R machine learning script.

### Steps:

1. See R packages which exist already.
- The following GPU package already exists in R:
	- cudaBayesreg

###### cudaBayesreg
- https://cran.r-project.org/web/packages/cudaBayesreg/index.html
- This package is a CUDA implementation of a Bayesian Model for analysis of brain fMRI data
- NOT what I need

2. Since nothing currently exists, I will have to build my own package to satisfy the requirements of my project
- Use tutorial from source 1
- compile the interface using the following command:
```
nvcc -O3 -arch=sm_50 -G -I C:/"Program Files"/"NVIDIA GPU Computing Toolkit"/CUDA/v9.2/include/ -I C:/"Program Files"/R/R-3.5.1/include/ -L C:/"Program Files"/"NVIDIA GPU Computing Toolkit"/CUDA/v9.2/x64/ -l cufft  --shared -Xcompiler -fPIC -o cufft.so cufft-R.cu -ccbin C:/"Program Files (x86)"/"Microsoft Visual Studio"/2017/Professional/VC/Tools/MSVC/14.15.26726/bin/Hostx64/x64/
```

- `-arch` is the architecture of my system. Since these GPUs in the lab have a compute capacity of 5, I put down sm_50
- `-G` generates debug code
- `-I` means include path for the `cufft.h` and `R.h` files
- `-L` sets a search path for a system library
- `l` sets a specific library path
- `ccbin` specifies where the C compiler is

**Note: To run this commmand, there must not be old files of the same name in the directory or else the command will fail**

3. Open R studio and follow the tutorial to run the package


### Sources:

1. https://devblogs.nvidia.com/accelerate-r-applications-cuda/
