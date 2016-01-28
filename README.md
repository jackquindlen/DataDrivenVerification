# DataDrivenVerification

Code for "Case Studies in Data-Driven Verification of Dynamical Systems" by Alexandar Kozarev, John Quindlen, Jonathan How, and Ufuk Topcu submitted to Hybrid Systems: Computation and Control 2016.

The following examples are included in the folders: Van der Pol oscillator, model reference adaptive controller, aircraft reversionary safety controller, and reinforcement learning-based controller.  Each of these examples is further explained in their own subsequent section.  The training and testing data used in the paper are included in each folder along with the Matlab code required to train the support vector machines.  Note that the Matlab Machine Learning library is required for SVM implementation.  Unless otherwise indicated, the code to generate those samples is not included - just the samples themselves.  

## Van der Pol Oscillator
The first example is the Van der Pol oscillator taken from previous nonlinear analysis and verification work and provides a baseline for comparison.  The goal of the problem is to estimate the set of initial conditions from which the system will sucessfully be able to return to the origin (0,0). 

The necessary files are found in the folder location: "Van der Pol Oscillator".  The function is "vanderpol svm.m" and the training and testing data are all lumped into "vdp_data.mat".  Note that the training data, "dataX" and "dataY", is pre-generated using Lyapunov-function barrier certificate functions - see the paper listed immediately below.  Meanwhile, the testing data is pre-generated using a discrete test grid of 0.025 increments over x1: [-3.4827,+3.4423] and x2: [-3.3070,+3.6180].  

###### For more information:

+Ufuk Topcu, Andrew Packard, and Peter Seiler. Local stability analysis using ssimulation and sum-of-squares programming. Automatica, 44(10):2669{2675, 2008.

+Ufuk Topcu, Andrew K. Packard, Peter Seiler, and Gary J. Balas. Robust region-of-attraction estimation. IEEE Transactions on Automatic Control, 55(1):137{142, January 2010.

## Model Reference Adaptive Controllers
The second example is a concurrent learning model reference adaptive controller (CL-MRAC) implementation.  In this example problem, we want to estimate the full set of parameters (W1, W2) from which the adaptive system will still be able to track a reference trajectory within +/-1.0 bounds.  

The necessary files are found in the folder location: "Model Reference Adaptive Control/Simple MRAC". The main file is "train_SVM.m" - everything is controlled from there.  The training samples are found in the file "trainingData.mat" and the samples for testing the trained SVM are found in the file "testingData.mat".  The training data is pre-generated using the same functions as in the Van der Pol example.  Likewise, the testing data is a discrete grid of 0.1 increments from W1: [-8,+8] and W2:[-10,+10].  

###### For more information:

+Girish V. Chowdhary. Concurrent Learning for Convergence in Adaptive Control Without Persistency of Excitation. PhD thesis, Georgia Institute of Technology, December 2010.

+Girish Chowdhary, Hassan A. Kingravi, Jonathan How, and Patricio A. Vela. Bayesian nonparametric adaptive control using gaussian processes. IEEE Transactions on Neural Networks and Learning Systems, 26(3):537{550, March 2015.

## Aircraft Reversionary Safety Controller
Another example problem is an aircraft reversionary safety controller that is intended to take over from a separate controller and return the system to a nominal condition.  In this problem, we are interested in estimating the set of perturbed states from which the reversionary controller can successfully take over.  

The necessary files and data is found in the folder location: "Aircraft Controller".  The main training and testing file is "svm.m".  There is another function, "bounds_class.m", which is used to determine whether a set of conditions is safe or not.  There are actually three different files for sampling - "aircraftSamples2000.mat", "aircraftSamples4000.mat", and "aircraftSamples16000.mat" - which each have 2000, 4000, or 16000 samples of training and testing data.  Note that while there are 10 states in each of the testing or training matrices, only 3 states are used by the classifier for identifying safety: the 1st, 2nd, and 9th states.  

## Reinforcement Learning-based Controller
The last example problem is a reinforcement learning-based controller for a two-link robot, the acrobot problem.  The controller was trained using a prior reinforcement learning step using Sarsa and aims to stabilize the two links on top of one another, akin to a gymnast swinging on a high bar.  The problem of interest here is to verify whether the trained policy can stabilize the acrobot starting from various initial conditions within 1000 simulation steps (of \Delta t = 0.5).  

The files and data are found in the "Reinforcement Learning Acrobot" folder.  The main file is "AcrobotSvm.m".  All that is needed is to run that file.  The data is stored in the "acrobot_data.mat" file.  For both the training and testing data, there are two variables of 4000 parameter samples.  The "test-data" and "train-data" variables are 4000x4 matrices, with each column corresponding to angular positions \theta1 and \theta2 and angular velocities \dot{\theta1} and \dot{\theta2}, in that order.  The 4000x1 vectors "test-class" and "train-class" are the true labels corresponding to each sample in the data matrices.  The initial conditions were randomly varied between: \theta1: [-pi/2, +pi/2], \theta2: [-pi/2, +pi/2], \dot{\theta1}: [-2pi, +2pi], \dot{\theta2}: [-2pi, +2pi].  

