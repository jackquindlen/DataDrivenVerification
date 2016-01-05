# DataDrivenVerification

Code for "Case Studies in Data-Driven Verification of Dynamical Systems" by Alexandar Kozarev, John Quindlen, Jonathan How, and Ufuk Topcu submitted to Hybrid Systems: Computation and Control 2016.

The following examples are included in the folders: Van der Pol oscillator, model reference adaptive controller, aircraft reversionary safety controller, and reinforcement learning-based controller.  Each of these examples is further explained in their own subsequent section.  The training and testing data used in the paper are included in each folder along with the Matlab code required to train the support vector machines.  Note that the Matlab Machine Learning library is required for SVM implementation.  Unless otherwise indicated, the code to generate those samples is not included - just the samples themselves.  

## Van der Pol Oscillator
The first example is the Van der Pol oscillator taken from previous nonlinear analysis and verification work.  

###### For more information:

+Ufuk Topcu, Andrew Packard, and Peter Seiler. Local stability analysis using ssimulation and sum-of-squares programming. Automatica, 44(10):2669{2675, 2008.

+Ufuk Topcu, Andrew K. Packard, Peter Seiler, and Gary J. Balas. Robust region-of-attraction estimation. IEEE Transactions on Automatic Control, 55(1):137{142, January 2010.

## Model Reference Adaptive Controllers
The second example is a concurrent learning model reference adaptive controller (CL-MRAC) implementation.  The necessary files are found in the folder location: "Model Reference Adaptive Control/Simple MRAC". The training samples are found in the file "trainingData.mat" and the samples for testing the trained SVM are found in the file "testingData.mat".  

###### For more information:

+Girish V. Chowdhary. Concurrent Learning for Convergence in Adaptive Control Without Persistency of Excitation. PhD thesis, Georgia Institute of Technology, December 2010.

+Girish Chowdhary, Hassan A. Kingravi, Jonathan How, and Patricio A. Vela. Bayesian nonparametric adaptive control using gaussian processes. IEEE Transactions on Neural Networks and Learning Systems, 26(3):537{550, March 2015.

## Aircraft Reversionary Safety Controller

## Reinforcement Learning-based Controller


