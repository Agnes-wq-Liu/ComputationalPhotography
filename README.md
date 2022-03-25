# ComputationalPhotography
\section{Image Processing Techniques}
\subsection{Seam Carving}
Seam Carving is the process that identifies and removes connected paths of horizontal or vertical pixels that have the lowest sum of importance to achieve a content-aware image retargeting. In my implementation, a feature function is adopted from \(insert\ method\ here\):
\begin{equation}
    HH
\end{equation}
together with the forward energy developed by\href{ https://www.merl.com/publications/docs/TR2008-064.pdf}{\underline{\color{blue}Rubinstein et al. (2008)}}\cite{Rubinstein08}: 
\begin{equation}
    M(i,j) = P(i,j)+min 
    \begin{cases}
    M(i-1,j-1)+C_L(i,j)\\
    M(i-1,j)+C_U(i,j)\\
    M(i-1,j+1)+C_R(i,j)\\
    \end{cases}
\end{equation}
\subsection{Image Dehazing}
\subsection{Style Transfer}
\begin{figure}
    \includegraphics[width=0.33\textwidth]{STimages/cottonrose.jpg}
    \includegraphics[width=0.30\textwidth]{STimages/vanGoghPink.jpg}
    \includegraphics[width=0.33\textwidth]{STimages/stylized_cottonrose.png}
    \caption{(a)The original cottonroses, (b)Van Gogh painting \textit{},(c)Style\((b)\) Transferred to\((a)\)}
\end{figure}
\begin{figure}
    \includegraphics[width=0.33\textwidth]{STimages/JeanMance.jpg}
    \includegraphics[width=0.30\textwidth]{STimages/vanGoghField.jpg}
    \includegraphics[width=0.33\textwidth]{STimages/stylized_JM.png}
    \caption{(a)The original Parc Jean Mance, (b)Van Gogh painting \textit{},(c)Style\((b)\) Transferred to\((a)\)}
\end{figure}
Style Transfer refers to presenting the contents of an image in the style of another image.
If we are given a content image \(p\) and a style image \(a\), then the goal of Style Transfer is obtaining image \(x\) where:
\begin{equation}
C(x)=C(p), S(x) = S(a)
\end{equation}
This is usually achieved by training a Convolutional Neural Network minimizing \(x\)'s content and style losses. The TensorFlow Hub provides a pretrained CNN for Style Transfer that can be directly loaded and used, or alternatively, one can take advantage of VGG-19 by training and optimizing over a selected combination of its intermediate layers. Idea of this methods comes from \href{https://www.tensorflow.org/tutorials/generative/style_transfer}{\underline{\color{blue}TensorFlow Tutorial}}\cite{tensorflow2015-whitepaper}, with theoreticals behine from \(fill\ the\ paper\ here\).
\subsection{Single Image Super Resolution}
\subsection{Specular Removal}
