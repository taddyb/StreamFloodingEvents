### What is dispersion:
Dispersion is the extent to which the distribution is stretched or spread.

The following are measures of dispersion:

- Standard Deviation
- Range

To find peaks in the dataset, we will be using `findPeaks()`, a function from the `pracma` package to find the larger peaks in the dataset. I will be recreatng `findPeaks()` in C on the GPU to speed it up.

### R packages used:
- `readxl` to read in the file
- `pracma` for finding peaks

### Filtering data:
Since the dataset has a lot of noise, we need to filter out the smaller storm events in order to find the big frequencies.

###### Key words:
- Detrend: Removing a trend from a time series which may be causing noise.

###### Cool Sites:
- https://anomaly.io/seasonal-trend-decomposition-in-r/
