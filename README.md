### Project Proposal:
Tadd Bindas
Intro to GPU Programming
Dr. Ron Coleman

### What is this project?
This project is a substitution for the Black Jack class project for Introduction to GPU Programming. What will be accomplished is speeding up a peak pick algorithm via running the algorithm on a GPU. A peak pick algorithm takes in one-dimensional data (a time series) and creates a matrix of data points corresponding to the peaks in the data. 

### What is the dataset?
The dataset on which we will run the peak-pick function on is a time-series data of the discharge of Wappingers Creek. Wappingers Creek is a local watershed, and tributary to the Hudson River, which has USGS data of discharge going back over 40 years. By using a peak-pick function, we will be able to see how many flooding events have happened over a specific span of time, and determine if as the climate around us changes, flooding events are happening more often or not. This project can also be built upon in the future by finding the severity of flood events (taking the derivative of the flood curves). 

### What are the codes/systems/libraries?
The following codes will be used:
-	R
-	C
-	Cuda C
R relies on C to run various packages. Much of the coding will be handmade C-interfaces which will be run through R. I will have to create the peak-pick algorithm in C to run it on the GPU.

### How to assess performance:
There exist various peak-pick functions in R which return different peaks in the time series data. Many can be sped up using different cores inside of the user’s machine. The performance of a GPU doing a peak-pick function can be tested through timing the amount of time it takes for a function to complete. Since there are working functions in R for finding function peaks, we will have a baseline time to compare the GPU time against. 

### Deliverables:
A report which details the project code, a plot which has the peaks highlighted via either a dot or a different color, and a discussion on what it means. All code will be uploaded to github and iLearn 

### Important Links:
- [How to create a C interface to R](http://www.biostat.jhsph.edu/~rpeng/docs/interface.pdf)
- [How to make a GPU application for R](https://devblogs.nvidia.com/accelerate-r-applications-cuda/)
