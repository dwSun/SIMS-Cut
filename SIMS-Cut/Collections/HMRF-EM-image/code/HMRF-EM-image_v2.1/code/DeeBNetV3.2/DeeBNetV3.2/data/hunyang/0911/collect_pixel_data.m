data_file = {
'468br-ski-474no_274.mat'
};
label_file = {
'labeling_468br-ski-474no.mat'

};

% label_path = 'labeling\';
% data_file={
% 'C:\Users\yzy\Documents\SIMS\MATLAB\MATLAB\Add-Ons\Collections\HMRF-EM-image\code\HMRF-EM-image_v2.1\code\DeeBNetV3.2\DeeBNetV3.2\data\hunyang\MIX-BRDU_all.mat'    
% }
% label_file = {
% 'C:\Users\yzy\Documents\SIMS\MATLAB\MATLAB\Add-Ons\Collections\HMRF-EM-image\code\HMRF-EM-image_v2.1\code\DeeBNetV3.2\DeeBNetV3.2\data\hunyang\中间结果\MIX-BRDU_0724_labeling.mat'    
% }

%蓝为1
group = ones(154,1);
%绿为2
group([4,9,11,12,13,14,17,18,19,20,23,28,32,35,37,38,39,40,41,43,46,50,52,55,56,58,60,62,63,66,68,70,74,75,76,77,78,81,83,84,85,90,91,93,99,103,104,105,106,107,110,111,112,113,114,115,117,119,120,122,123,128,134,136,140,141,142,143,145,146,147,151,153,154])=2;
%红为3
group([1,2,3,6,7,10,15,16,21,22,24,26,44,45,47,48,51,54,57,59,61,71,72,87,89,92,96,98,100,101,108,118,124,125,131,132,133,135,137,139,148])=3;
data_mat = [];
for i=1:1
load(data_file{i});
load(label_file{i});
cur_labeling = final_labeling;
[filtered_img,num_valid_cell,cur_labeling] = filter_cell(cur_labeling,1);

[cur_cells,cur_cells_mean,sep_labeling] = get_each_cell_finger(cur_labeling,test_samples); 


for j=1:num_valid_cell
    cur_batch = i;
       cur_idxs = find(sep_labeling==j);
       cur_pixels = test_samples(cur_idxs,:);
       
%        cur_pixels = cur_cells{j};
       
       cur_cellidx = j;
       cur_celltype = group(cur_cellidx);
       to_add = [repmat([cur_batch,cur_cellidx,cur_celltype],size(cur_pixels,1),1),cur_idxs,cur_pixels];
%        to_add = to_add(:,);
       data_mat = [data_mat;to_add];
end
cur_idxs = find(sep_labeling==0);
% cur_FE = ith_FE_mat(cur_idxs,:);
    cur_pixels = test_samples(cur_idxs,:);
    cur_batch = i;
    cur_cellidx = 0;
    cur_celltype=0;
    to_add = [repmat([cur_batch,cur_cellidx,cur_celltype],size(cur_pixels,1),1),cur_idxs,cur_pixels];
      data_mat = [data_mat;to_add];
end