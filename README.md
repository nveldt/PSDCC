## Low-Rank Positive Semidefinite Correlation Clustering

Included here is all the code for the implementation of the ZonoCC algorithm of Veldt, Wirth, and Gleich for positive semidefinite correlation clustering.

Also included are implementations of other commonly used correlation clustering algorithms.

### Datasets

1. 157CSconferences.mat: Search query data over the past several years (2003-2016) for search terms associated with 157 different CS conferences. Obtained from Google-Trends

2. prices_easy.mat: closing stock market prices for 497 companies over a 253 day trading period.

### Code included here from outside sources

Some of the .m files for working with figures were obtained from outside sources:

1. set_figure_size.m: From David F. Gleich's mcode software package. (https://github.com/dgleich/mcode)
2. Process_atendHeader(filein,fileout) https://www.mathworks.com/matlabcentral/newsreader/view_thread/337705
3. simplex_coordinates1.m: code to generate coordinates of vertices of a regular simplex, by John Burkardt (http://people.sc.fsu.edu/~jburkardt/). Available at https://people.sc.fsu.edu/~jburkardt/m_src/simplex_coordinates/simplex_coordinates1.m

### Dependencies

The function GeneralCC relies on Gurobi software. An academic lisence can be obtained free of charge at http://www.gurobi.com/.

Our implementation of CGW in matlab requires CVX: http://cvxr.com/cvx/

In order to run the experiments on the Facebook networks, access to the FaceBook 100 datasets is needed. They are not included here.
