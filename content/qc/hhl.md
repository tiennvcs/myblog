+++
title = 'Quantum algorithm for system of linear equations'
date = 2024-05-30T14:35:17-05:00
draft = false
math = true
+++

## System of linear equations
The most well-known problems in linear algebera that people educated in school is system of linear equations, aka SLE. The simple one is:

$$
    2x_0 + 3 = 0
$$

Or multiple linear equations like below.

$$
\begin{cases}
    x_0 + x_1 = -1 \\\\
    3x_0 + x_1 = 10
\end{cases}
$$

In linear algebra, we can form the problem under matrix presentation:
$$
    Ax = b
$$
with 
$$
    \mathbb{R}^{N \times D} \ni A = \begin{bmatrix}
        a_{0,0} &  \dots & a_{0, D-1} \\\\
        \vdots & \ddots & \vdots \\\\
        a_{N-1, 0} & \dots & a_{N-1, D-1}
    \end{bmatrix}, 
    b = \begin{bmatrix}
        b_0 \\\\
        \vdots \\\\
        b_{N-1}
    \end{bmatrix} \in \mathbb{R}^{N}
$$
and the goal is to find vector \\(x = [x_0, \dots, x_{D-1}]\\) given \\(A, b\\).
For example, the above problem can be modeled as:
$$
\begin{bmatrix}
1 & 1 \\\\
3 & 10 
\end{bmatrix} \begin{bmatrix} x_0 \\\\ x_1\end{bmatrix} = \begin{bmatrix}-1 \\\\ 10\end{bmatrix}
$$. In this cae, \\(A = \begin{bmatrix}
1 & 1 \\\\
3 & 10 
\end{bmatrix}\\) and \\(\begin{bmatrix}-1 \\\\ 10\end{bmatrix}\\).


## In-school teach algorithms
The most common way to solve the system of linear equation we usually know is the substitution. For example to solve the problem above, from the first equation, we have \\(y = -1 - x\\), then we plug it into the second euqation:
$$
    3x + 10(-1 - x) = 10 \\\\
    \Rightarrow x = -\frac{20}{7}
$$
then we have \\(y = - 1 - x = \frac{13}{7}\\). Therefore, the solution of given system is \\((\frac{-20}{7}, \frac{13}{7})\\).

Under point of view of linear algebera, the solution vector \\(x\\) can be found by multiplying the inverse of \\(A\\) with vector \\(b\\).
$$
    x = A^{-1} b
$$
, with \\(A^{-1}\\) denotes for the inverse operator. Of course, to do it, \\(A\\) must be a square matrix, and invertible. It means exists a matrix \\(C\\) such that \\(CA = I\\), with \\(I\\) is an identity matrix. 

Now we talk about the way we can find the inverse of \\(A\\). In college, we would be educated a method call Gaussian-Jordan elimination which iteratively standarlize the original matrix to identity matrix and at the end we get the inverse. For example, to find the inverse of abovementioned matrix, we write the original matrix as an expansion version below.

$$
   \begin{pmatrix}
        1 & 1  &\bigm| &1 & 0 \\\\
        3 & 10 &\bigm| &0 & 1 \\\\
    \end{pmatrix} \rightarrow \begin{pmatrix}
        1 & 0 &\bigm| &10/7 &  -1/7\\\\
        0 & 1 &\bigm| &-3/7 & 1/7 \\\\
    \end{pmatrix}
$$
So we have the inverse matrix is \\(\begin{bmatrix} 10/7 &  -1/7\\\\ 
    -3/7 & 1/7\end{bmatrix}\\)
Then, by simply multiplying it with vector \\(b\\), we get the solution:
$$
    x  = \begin{bmatrix} 10/7 &  -1/7\\\\ 
    -3/7 & 1/7\end{bmatrix}\begin{bmatrix}-1 \\\\ 10\end{bmatrix} = \begin{bmatrix}-20/7 \\\\ 13/7 \end{bmatrix}
$$

About the complexity, GJ requires an amount of running time is an order of \\(\mathcal{O}(N^3)\\) while the total memory need to be allocated is order of \\(\mathcal{O}(n^2)\\)

## Any faster methods?
Under the development of quantum computing, which is expected to replace the classical computation with many merits. In that, exponential speed up ability is the main advantage of quantum property compared with classical computers. For example, the fastest method to solve SLE, in classic, which is conjugate gradient requiring \\(\mathcal{O}(m\sqrt{k})\\), where \\(m\\) is the number of non-zero entries and \\(k\\) is the condition number.

However, quantum hardware can beat the limit of classic! In 2009, three research scientists including Aram W. Harrow, Avinatan Hassisdim, Seth Lloyd presented a quantum algorithm for SLE. The most successfull merit of their paper is their method only requires a \\(poly(\log{N},k)\\) in term of speeed, which is expentential improvement compared with the best classical algorithm.


