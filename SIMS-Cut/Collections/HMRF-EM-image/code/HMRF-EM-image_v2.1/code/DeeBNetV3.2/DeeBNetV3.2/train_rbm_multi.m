function[bg_rbm,fg_rbm,PF] = train_rbm_multi(normed_data,Labeling,n_hidden,n_epoch,beta)


%ÿһ���õ�����RBM
Width = 256;
Height = 256;
d = 20;
train_ratio = 0.8;
%Labeling����ָ�Ľ����1��bg��2��fg��
% Labeling ��65536*1��λ�ú�test_samplesλ��һ��
% Labeling = zeros(Width,Height);



%test_samples�������ݣ�65536*20
% test_samples = zeros(Width*Height,d);

% processed_test_samples = preprocess_samples(test_samples);
% processed_test_samples = test_samples/max(test_samples(:));
processed_test_samples = normed_data;

bg_samples = processed_test_samples(Labeling==1,:);
fg_samples = processed_test_samples(Labeling==2,:);

bg_samples_shuffle = bg_samples(randperm(size(bg_samples,1)),:);
fg_samples_shuffle = fg_samples(randperm(size(fg_samples,1)),:);

bg_train_samples = bg_samples_shuffle(1:train_ratio*size(bg_samples_shuffle,1),:);
bg_test_samples = bg_samples_shuffle(train_ratio*size(bg_samples_shuffle,1)+1:end,:);

fg_train_samples = fg_samples_shuffle(1:train_ratio*size(fg_samples_shuffle,1),:);
fg_test_samples = fg_samples_shuffle(train_ratio*size(fg_samples_shuffle,1)+1:end,:);





bg_rbm=train_one_rbm(bg_train_samples,bg_test_samples,n_hidden,n_epoch);

fg_rbm=train_one_rbm(fg_train_samples,fg_test_samples,n_hidden,n_epoch);

PF = train_softmax2(bg_train_samples,bg_test_samples,bg_rbm,fg_train_samples,fg_test_samples,fg_rbm,beta)

