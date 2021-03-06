% Generated by roxygen2 (4.1.0): do not edit by hand
% Please edit documentation in R/cobra_validate.r
\name{cobra_validate}
\alias{cobra_validate}
\title{Perform validation to select regularization parameter}
\usage{
cobra_validate(X, E_row, E_col, w_row, w_col, gamma, Lambda_row = matrix(0, n,
  nrow(E_row)), Lambda_col = matrix(0, p, nrow(E_col)), fraction = 0.1,
  max_iter = 100, tol = 0.001, max_iter_inner = 1000, tol_inner = 1e-04)
}
\arguments{
\item{X}{Data matrix}

\item{E_row}{Edge-incidence matrix for row graph}

\item{E_col}{Edge-incidence matrix for column graph}

\item{w_row}{Vector of weights for row graph}

\item{w_col}{Vector of weights for column graph}

\item{gamma}{Regularization parameter for shrinkage}

\item{Lambda_row}{Initial guess of row Langrage multipliers}

\item{Lambda_col}{Initial guess of column Langrage multipliers}

\item{fraction}{Fraction of entries for hold out}

\item{max_iter}{Maximum number of iterations}

\item{tol}{Stopping criterion}

\item{max_iter_inner}{Maximum number of inner cobra iterations}

\item{tol_inner}{Stopping criterion for inner cobra loop}
}
\description{
\code{cobra_validate} performs an MM algorithm wrapper to do parameter selection.
}
\examples{
## Create bicluster path
## Example: Lung
X <- lung
X <- X - mean(X)
X <- X/norm(X,'f')

## Create annotation for heatmap
types <- colnames(lung)
ty <- as.numeric(factor(types))
cols <- rainbow(4)
YlGnBu5 <- c('#ffffd9','#c7e9b4','#41b6c4','#225ea8','#081d58')
hmcols <- colorRampPalette(YlGnBu5)(256)

## Construct weights and edge-incidence matrices
phi <- 0.5; k <- 5
wts <- gkn_weights(X,phi=phi,k_row=k,k_col=k)
w_row <- wts$w_row
w_col <- wts$w_col
E_row <- wts$E_row
E_col <- wts$E_col

## Connected Components of Row and Column Graphs
wts$nRowComp
wts$nColComp

#### Initialize path parameters and structures
nGamma <- 7
gammaSeq <- 10**seq(0,1,length.out=nGamma)

## Generate solution path
sol <- cobra_validate(X,E_row,E_col,w_row,w_col,gammaSeq,fraction=0.01)

## Plot validation error
verr <- sol$validation_error
plot(verr)

## Heatmap of data smoothed at the model selected to minimize validation error
ix <- which.min(verr)
groups_row <- sol$groups_row[[ix]]
groups_col <- sol$groups_col[[ix]]
M <- biclust_smooth(X,groups_row,groups_col)
heatmap(M,col=hmcols,labRow=NA,labCol=NA,ColSideCol=cols[ty])
}

