load('lung-erxing_181103_225.mat');
test_samples_all = test_samples+1;
load('lung-erxing_181103_20.mat');
test_samples_20 = test_samples;

test_samples_20_processed = bsxfun(@rdivide,test_samples_20,prctile(test_samples_all,50,2));
% test_samples_20_processed = bsxfun(@rdivide,test_samples_20,test_samples_all(:,158));
% test_samples_20_processed = bsxfun(@rdivide,test_samples_20,test_samples_all(:,165));
% test_samples_20_processed(isnan(test_samples_20_processed))=0;
% test_samples_20_processed(isinf(test_samples_20_processed))=0;
img = reshape(test_samples_20_processed(:,1),256,256)';
Iblur1 = imgaussfilt(img,2);
imshow(img,[])
