% batch_files = {
% 'A-H_0610_274.mat',
% 'AB-A_274.mat',
% 'AB-A_0521_274.mat',
% 'AB-H-1_274.mat',
% 'AB-H-3_0604_274.mat',
% 'AB-H-4_0604_274.mat',
% 'AB-H_274.mat',
% 'H-A-M_0610_274.mat',
% 'H-M_0610_274.mat',
% 'HB-A-2_0604_274.mat',
% 'HB-A-3_0604_274.mat',
% 'HB-A_0521_274.mat',
% 'HB-H_0521_274.mat',
% 'MIX-BRDU_all.mat'
% 
% }
batch_files = {
%     '200m200_20.mat',
    '468br-ski-474no_20.mat',
    '468i-skbr-474no_20.mat'

}
for i=1:2
   cur_batch = batch_files{i}(1:end-4);
   load(batch_files{i});
%    load('C:\Users\Yuan Zhiyuan\Documents\MATLAB\SIMS_0820\MATLAB\Add-Ons\Collections\HMRF-EM-image\code\HMRF-EM-image_v2.1\code\DeeBNetV3.2\DeeBNetV3.2\data\hunyang\274\cor_sort_ind.mat');
%     test_samples_processed = test_samples+1;
%     test_samples_processed = bsxfun(@rdivide,test_samples_processed,prctile(test_samples_processed,80,2));
%     test_samples_processed = log(test_samples_processed);
%     test_samples_processed = test_samples_processed(:,cur_sort_ind(1:20));
%     test_samples_processed = test_samples(:,cur_sort_ind(1:20));
%     test_samples_processed = (test_samples_processed-min(test_samples_processed(:)))/(max(test_samples_processed(:))-min(test_samples_processed(:)));
%     
%     edge_auto = get_BK_pairwise(test_samples,1,256,256);
%     save(['edges_ori_auto_',batch_files{i}],'edge_auto');
%    edge_ada = adaptive_constrast2(edge_auto,21,256,256);
%    save(['edges_ori_ada_',batch_files{i}],'edge_ada');
    load(['edges_ori_auto_',batch_files{i}]);
%     edge_auto = get_BK_pairwise(test_samples,1,256,256);
%     save(['edges_ori_auto_',batch_files{i}],'edge_auto');
%    USIS_EM2(test_samples,cur_batch,0.8,10,edge_auto,40);
% USIS_EM2(test_samples,cur_batch,0.5,5,edge_ada,50);
%    USIS_EM2(test_samples,cur_batch,0.65,5,edge_ada,50);
   USIS_EM2(test_samples,cur_batch,0.8,5,edge_auto,80);
   USIS_EM2(test_samples,cur_batch,0.8,2.5,edge_auto,80);
   USIS_EM2(test_samples,cur_batch,0.9,5,edge_auto,80);
   USIS_EM2(test_samples,cur_batch,0.9,2.5,edge_auto,80);
   USIS_EM2(test_samples,cur_batch,1,5,edge_auto,80);
   
end