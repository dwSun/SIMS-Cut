%Test generateClass function for Discriminative RBM in MNIST data set
clc;
clear;
more off;
addpath('DeeBNet');
% data = MNIST.prepareMNIST('H:\DataSets\Image\MNIST\');%using MNIST dataset completely.
data = MNIST.prepareMNIST_Small('+MNIST\');%uncomment this line to use a small part of MNIST dataset.
% data.normalize('minmax');
data.dataMin = min(min(data.trainData));
data.dataMax = max(max(data.trainData));
data.trainData = (data.trainData-data.dataMin)/(data.dataMax-data.dataMin);
data.testData = (data.testData-data.dataMin)/(data.dataMax-data.dataMin);

data.validationData=data.testData;
data.validationLabels=data.testLabels;

% RBM
rbmParams=RbmParameters(1000,ValueType.binary);
rbmParams.samplingMethodType=SamplingClasses.SamplingMethodType.PCD;
rbmParams.performanceMethod='classification';
rbm=DiscriminativeRBM(rbmParams);
rbmParams.maxEpoch=200;

%train
rbm.train(data);
%Generate data
L=([0:9]'*ones(10,1)')';
generatedData=rbm.generateClass(L(:),1000);
DataClasses.DataStore.plotData({generatedData},1);