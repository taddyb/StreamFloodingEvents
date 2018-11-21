cufft1D <- function(x, inverse=FALSE)
{
  if(!is.loaded("cufft")) {
    dyn.load("C:/Users/maristuser/Desktop/cufft.so")
  }
  n <- length(x)
  rst <- .C("cufft",
            as.integer(n),
            as.integer(inverse),
            as.double(Re(z)),
            as.double(Im(z)),
            re=double(length=n),
            im=double(length=n))
  rst <- complex(real = rst[["re"]], imaginary = rst[["im"]])
  return(rst)
}
num <- 4
z <- complex(real = stats::rnorm(num), imaginary = stats::rnorm(num))
cpu <- fft(z)
cpu
gpu <- cufft1D(z)
