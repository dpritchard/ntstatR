\name{mstat_weight_spp}
\alias{mstat_weight_spp}

\title{Species Weightings for NT-STAT Marine Assesment}
\description{Provides a weighting vector for species in the NT-STAT Marine Assesment.}
\usage{
mstat_weight_spp(nspp)
}

\arguments{
  \item{nspp }{An integer. The number of species.}
}

\details{
At the moment this is a simple exponential decay, such that each sequential species has a 20 percent reduction in relative importance over the previous one.
}

\value{
Returns a vector of length \code{nspp} describing the relative importance of each species.
}

\author{
Daniel Pritchard
}

\seealso{
\code{\link{mstat_weight_spp}}
}
\examples{
# An example with five species, the current limit
fivespp <- mstat_weight_spp(5)
plot(1:5, fivespp, ylab="Relative Importance", xlab="Species Rank", ylim=c(0,1))

# An exmaple with fifty species, for illustration
manyspp <- mstat_weight_spp(50)
plot(1:50, manyspp, ylab="Relative Importance", xlab="Species Rank", ylim=c(0,1))
}
