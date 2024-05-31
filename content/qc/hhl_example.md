+++
title = 'HHL algorithm implementation for SLE'
date = 2024-05-31T01:37:55-05:00
draft = false
math = true
+++

## What is the actual implementation of HHL?

<b>Input: 
$$
    A = \begin{bmatrix}
        2 & 1 \\\\
        1 & 2
    \end{bmatrix}, b = \begin{bmatrix} \frac{1}{\sqrt{2}} & -\frac{1}{\sqrt{2}}\end{bmatrix}
$$

Let see how we can implement HHL algorithm to solve it?

## Precalculation
By eigenvalue decomposition, we have:

$$
    A = Q\Lambda Q^T = \begin{bmatrix}\frac{1}{\sqrt{2}} & \frac{1}{\sqrt{2}} \\\\
        \frac{1}{\sqrt{2}} & -\frac{1}{\sqrt{2}}
    \end{bmatrix} \begin{bmatrix}1 & 0 \\\\
        0 & 3
    \end{bmatrix} \begin{bmatrix}\frac{1}{\sqrt{2}} & \frac{1}{\sqrt{2}} \\\\
        \frac{1}{\sqrt{2}} & -\frac{1}{\sqrt{2}}
    \end{bmatrix}^T
$$
It means the eigenvectors of \\(A\\) are: \\(q_0 = \begin{bmatrix}\frac{1}{\sqrt{2}} & \frac{1}{\sqrt{2}}\end{bmatrix}^T, q_1 = \begin{bmatrix}\frac{1}{\sqrt{2}} & -\frac{1}{\sqrt{2}}\end{bmatrix}^T\\) correponsding the eigenvalues \\(\lambda_0 = 1, \lambda_1 = 3\\).

Observation from the input: 
- The matrix \\(A\\) is Hermitian, so do not need to do the agumented operation.
- The vector \\(b\\) is unit vector (\\(\sqrt{(\frac{1}{\sqrt{2}})^2+(-\frac{1}{2})^2}=1\\)), so do not need to do the normalization.

### How many qubits need to be used?
To encode \\(\lambda_0, \lambda_1\\), we need to use \\(n_c=2\\) qubits since the maximum eigenvalue is 3 and the ratio between \\(\lambda_1\\) and \\(\lambda_0\\) is \\(3/1 = 4\\). It means we present these value in a Hilbert space with basics \\(\ket{00}, \ket{01}, \ket{10}, \ket{11}\\). This encoding is done in a register, which is called as clock-register, or c-register for short. Luckily, they are all integers and the ratio is also integer. This means the representation of those values in quantum circuit are exact itself, i.e., \\(\tilde{\lambda_0} = 1, \tilde{\lambda_1} = 3\\), or in other words \\(\ket{\tilde{\lambda_0}}=\ket{01}\\) and \\(\ket{\tilde{\lambda_1}}=\ket{11}\\). This give us a perfect encoding with \\(n_c=2\\). Therefore, \\(t\\) would be chosen to be \\(\frac{\pi}{2}\\) due to \\(\tilde{\lambda_j} = 2^{n_c}\lambda_j t / 2\pi\\).

Also, we have to spend 1 more qubit to encode \\(b = \begin{bmatrix}\frac{1}{\sqrt{2}} & -\frac{1}{\sqrt{2}}\end{bmatrix}^T\\).

Therefore, the total number of qubits is \\(n + n_c + 1 = 1 + 2 + 1 = 4\\). Noticeably, in this calculation, besides c-register and input register for \\(b\\), we also need anciila qubit (which is already counted) to perform rotation and partial measurement.

### Matrix encoding \\(U = e^{iAt}\\)
We need to find two matrix \\(U^2, U\\) with \\(U=e^{iAt}\\). From the previous analysis, we have: \\(A = Q \Lambda Q^T\\), or \\(\Lambda = Q^T A Q\\). Supposedly, \\(U = Q U_{\text{diag}} Q^{\dagger}\\), then we have:
$$
    U_{\text{diag}} = \begin{bmatrix}
        e^{i\lambda_0t} & 0 \\\\
        0 & e^{i\lambda_1t}
    \end{bmatrix} = \begin{bmatrix}
        e^{i \times 1 \times \frac{\pi}{2}} & 0 \\\\
        0 & e^{i \times 2 \times \frac{\pi}{2}}
    \end{bmatrix} = \begin{bmatrix}
        i & 0 \\\\
        0 & -1
    \end{bmatrix} 
$$
and $$
    U_{\text{diag}}^2 = U_{\text{diag}} U_{\text{diag}} = \begin{bmatrix}
        i & 0 \\\\
        0 & -1
    \end{bmatrix} \begin{bmatrix}
        i & 0 \\\\
        0 & -1
    \end{bmatrix} = \begin{bmatrix}
        -1 & 0 \\\\
        0 & 1
    \end{bmatrix} 
$$
Then, we transform \\(U_{\text{diag}}, U_{\text{diag}}^2\\) back to \\(U, U^2\\) by:
$$
    U = Q U_{\text{diag}}Q^{\dagger} =  \begin{bmatrix}\frac{1}{\sqrt{2}} & \frac{1}{\sqrt{2}} \\\\
        \frac{1}{\sqrt{2}} & -\frac{1}{\sqrt{2}}
    \end{bmatrix} \begin{bmatrix}
        i & 0 \\\\
        0 & -1
    \end{bmatrix} \begin{bmatrix}\frac{1}{\sqrt{2}} & \frac{1}{\sqrt{2}} \\\\
        \frac{1}{\sqrt{2}} & -\frac{1}{\sqrt{2}}
    \end{bmatrix}^T =\frac{1}{2} \begin{bmatrix}i - 1& i + 1 \\\\
        i + 1 & i - 1
    \end{bmatrix} 
$$

$$
    U^2 = \frac{1}{4} \begin{bmatrix}i - 1& i + 1 \\\\
        i + 1 & i - 1
    \end{bmatrix} \begin{bmatrix}i - 1& i + 1 \\\\
        i + 1 & i - 1
    \end{bmatrix} = \begin{bmatrix}0 & -1 \\\\
        -1 & 0
    \end{bmatrix} 
$$

For quantum implementation of these operators, a 4-parameter arbitrary unitary gate is utilized:
$$
    G = \begin{bmatrix}
        e^{i \gamma} \cos{(\theta/2)} & -e^{i(\gamma + \lambda)}\sin{(\theta/2)} \\\\
        e^{i(\gamma + \phi)}\sin{(\theta/2)} & e^{i(\gamma + \phi + \lambda)}\cos{(\theta/2)}
    \end{bmatrix}
$$
It means, to implement \\(U\\) into quantum circuit, we have to find/define a tuple of four parameters \\((\theta, \phi, \lambda, \gamma)\\) such that:

$$
    \begin{cases}
        \frac{1}{2}(i-1) = e^{i\gamma } \cos{(\theta/2)} \\\\
        \frac{1}{2}(i+1) = -e^{i(\gamma + \lambda)}\sin{(\theta/2)} \\\\
        \frac{1}{2}(i+1) = e^{i(\gamma + \phi)}\sin{(\theta/2)} \\\\
        \frac{1}{2}(i-1) = e^{i(\gamma + \phi + \lambda)}\cos{(\theta/2)} \\\\
    \end{cases}
$$
So now we have \\(4\\) euqations and \\(4\\) unknowns! 