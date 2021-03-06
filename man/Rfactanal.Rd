\name{sla.factanal}
\alias{sla.factanal}
\alias{sla.factanal.fit.mle}
\title{Factor Analysis}
\description{
  Perform maximum-likelihood factor analysis on a covariance matrix or
  data matrix using ScaLAPACK.
}
\usage{
sla.factanal(x, factors, data = NULL, covmat = NULL, n.obs = NA, subset, na.action,
start = NULL, scores = c("none", "regression", "Bartlett"), rotation = "sla.varimax",
control = NULL, NPROWS = 0, NPCOLS = 0, MB = 16, \dots)
}
\arguments{
  \item{x}{Either a formula or a numeric matrix or an object that can be
    coerced to a numeric matrix.}
  \item{factors}{The number of factors to be fitted.}
  \item{data}{A data frame.}
  \item{covmat}{A covariance matrix, or a covariance list as returned by
    \code{\link{cov.wt}}. Of course, correlation matrices are covariance
    matrices.}
  \item{n.obs}{The number of observations, used if \code{covmat} is a
    covariance matrix.}
  \item{subset}{A specification of the cases to be used, if \code{x} is
    used as a matrix or formula.}
  \item{na.action}{The \code{na.action} to be used if \code{x} is
    used as a formula.}
  \item{start}{\code{NULL} or a matrix of starting values, each column
    giving an initial set of uniquenesses.}
  \item{scores}{Type of scores to produce, if any.  The default is none,
    \code{"regression"} gives Thompson's scores, \code{"Bartlett"} given
    Bartlett's weighted least-squares scores. Partial matching allows
    these names to be abbreviated.}
  \item{rotation}{character. \code{"none"} or the name of a function
    to be used to rotate the factors: it will be called with first
    argument the loadings matrix, and should return a list with component
    \code{loadings} giving the rotated loadings, or just the rotated loadings.}
  \item{control}{A list of control values,
    \describe{
      \item{nstart}{The number of starting values to be tried if
	\code{start = NULL}. Default 1.}
      \item{trace}{logical. Output tracing information? Default \code{FALSE}.}
      \item{lower}{The lower bound for uniquenesses during
	optimization. Should be > 0. Default 0.005.}
      \item{opt}{A list of control values to be passed to
	\code{\link{optim}}'s \code{control} argument.}
      \item{rotate}{a list of additional arguments for the rotation function.}
    }
  }
  \item{NPROWS}{Number of Process Rows in the Process Grid. }
  \item{NPCOLS}{Number of Process Cols in the Process Grid. }
  \item{MB}{Block Size. }
  \item{\dots}{Components of \code{control} can also be supplied as
    named arguments to \code{factanal}.}
}
\details{
  The factor analysis model is
  \deqn{x = \Lambda f + e}{ x = Lambda f + e}
  for a \eqn{p}--element row-vector \eqn{x}, a \eqn{p \times k}{p x k}
  matrix of \emph{loadings}, a \eqn{k}--element vector of \emph{scores}
  and a \eqn{p}--element vector of errors.  None of the components
  other than \eqn{x} is observed, but the major restriction is that the
  scores be uncorrelated and of unit variance, and that the errors be
  independent with variances \eqn{\Phi}{Phi}, the
  \emph{uniquenesses}.  Thus factor analysis is in essence a model for
  the covariance matrix of \eqn{x},
  \deqn{\Sigma = \Lambda^\prime\Lambda + \Psi}{Sigma = Lambda'Lambda + Psi}
  There is still some indeterminacy in the model for it is unchanged
  if \eqn{\Lambda}{Lambda} is replaced by \eqn{G\Lambda}{G Lambda} for
  any orthogonal matrix \eqn{G}.  Such matrices \eqn{G} are known as
  \emph{rotations} (although the term is applied also to non-orthogonal
  invertible matrices).
  
  If \code{covmat} is supplied it is used.  Otherwise \code{x} is used if
  it is a matrix, or a formula \code{x} is used with \code{data} to
  construct a model matrix, and that is used to construct a covariance
  matrix.  (It makes no sense for
  the formula to have a response.)  Once a covariance matrix is found or
  calculated from \code{x}, it is converted to a correlation matrix for
  analysis.  The correlation matrix is returned as component
  \code{correlation} of the result.

  The fit is done by optimizing the log likelihood assuming multivariate
  normality over the uniquenesses.  (The maximizing loadings for given
  uniquenesses can be found analytically: Lawley & Maxwell (1971,
  p. 27).)  All the starting values supplied in \code{start} are tried
  in turn and the best fit obtained is used.  If \code{start = NULL}
  then the first fit is started at the value suggested by Jreskog
  (1963) and given by Lawley & Maxwell (1971, p. 31), and then
  \code{control$nstart - 1} other values are tried, randomly selected
  as equal values of the uniquenesses.

  The uniquenesses are technically constrained to lie in \eqn{[0, 1]},
  but near-zero values are problematical, and the optimization is
  done with a lower bound of \code{control$lower}, default 0.005
  (Lawley & Maxwell, 1971, p. 32).

  Scores can only be produced if a data matrix is supplied and used.
  The first method is the regression method of Thomson (1951), the
  second the weighted least squares method of Bartlett (1937, 8).
  Both are estimates of the unobserved scores \eqn{f}.  Thomson's method
  regresses (in the population) the unknown \eqn{f} on \eqn{x} to yield
  \deqn{\hat f = \Lambda^\prime \Sigma^{-1} x}{hat f = Lambda' Sigma^-1 x}
  and then substitutes the sample estimates of the quantities on the
  right-hand side.  Bartlett's method minimizes the sum of squares of
  standardized errors over the choice of \eqn{f}, given (the fitted)
  \eqn{\Lambda}{Lambda}.

  If \code{x} is a formula then the standard NA-handling is applied to
  the scores (if requested): see \code{\link{napredict}}.
}
\value{
  An object of class \code{"factanal"} with components
  \item{loadings}{A matrix of loadings, one column for each factor.  The
    factors are ordered in decreasing order of sums of squares of
    loadings, and given the sign that will make the sum of the loadings
    positive.}
  \item{uniquenesses}{The uniquenesses computed.}
  \item{correlation}{The correlation matrix used.}
  \item{criteria}{The results of the optimization: the value of the
    negative log-likelihood and information on the iterations used.}
  \item{factors}{The argument \code{factors}.}
  \item{dof}{The number of degrees of freedom of the factor analysis model.}
  \item{method}{The method: always \code{"mle"}.}
  \item{scores}{If requested, a matrix of scores.}
  \item{n.obs}{The number of observations if available, or \code{NA}.}
  \item{call}{The matched call.}
  \item{na.action}{If relevant.}
  \item{STATISTIC, PVAL}{The significance-test statistic and P value, if
    if can be computed.}
}

\note{
	At the current time, this function appears to be slower than the normal factanal function.
}

\references{
  Bartlett, M. S. (1937) The statistical conception of mental factors.
  \emph{British Journal of Psychology}, \bold{28}, 97--104.

  Bartlett, M. S. (1938) Methods of estimating mental
  factors. \emph{Nature}, \bold{141}, 609--610.
  
  Jreskog, K. G. (1963) \emph{Statistical Estimation in Factor
    Analysis.}  Almqvist and Wicksell.
  
  Lawley, D. N. and Maxwell, A. E. (1971) \emph{Factor Analysis as a
    Statistical Method.} Second edition. Butterworths.

  Thomson, G. H. (1951) \emph{The Factorial Analysis of Human Ability.}
  London University Press.
}

\seealso{
  \code{\link{factanal}} for the regular factanal function,
  \code{\link{print.loadings}},
  \code{\link{varimax}}, \code{\link{sla.princomp}},
  \code{\link{ability.cov}}, \code{\link{Harman23.cor}},
  \code{\link{Harman74.cor}}
}

\examples{
# A little demonstration, v2 is just v1 with noise,
# and same for v4 vs. v3 and v6 vs. v5
# Last four cases are there to add noise
# and introduce a positive manifold (g factor)
v1 <- c(1,1,1,1,1,1,1,1,1,1,3,3,3,3,3,4,5,6)
v2 <- c(1,2,1,1,1,1,2,1,2,1,3,4,3,3,3,4,6,5)
v3 <- c(3,3,3,3,3,1,1,1,1,1,1,1,1,1,1,5,4,6)
v4 <- c(3,3,4,3,3,1,1,2,1,1,1,1,2,1,1,5,6,4)
v5 <- c(1,1,1,1,1,3,3,3,3,3,1,1,1,1,1,6,4,5)
v6 <- c(1,1,1,2,1,3,3,3,4,3,1,1,1,2,1,6,5,4)
m1 <- cbind(v1,v2,v3,v4,v5,v6)
cor(m1)
sla.factanal(m1, factors=3, rotation="sla.promax", NPROWS=2, NPCOLS=2, MB=2 )
}
\author{Nagiza Samatova (\email{samatovan@ornl.gov}), Guruprasad Kora (\email{koragh@ornl.gov}), Srikanth Yoginath (\email{yoginathsb@ornl.gov}), David Bauer (\email{bauerda@ornl.gov})}
\concept{parallel}
\keyword{multivariate}
