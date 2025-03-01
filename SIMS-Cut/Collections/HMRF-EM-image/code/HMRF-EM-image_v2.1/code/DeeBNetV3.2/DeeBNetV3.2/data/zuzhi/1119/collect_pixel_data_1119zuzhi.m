% 276维，前两维是 Br和I
%BR和I放在datamat的最后两位

data_file = {
%     'liver-cancer-1_all.mat',
%     'liver-cancer-2_all.mat',
%     'liver-xwh-1_all.mat',
%     'liver-xwh-2-1_all.mat',
%     'liver-xwh-2-2_all.mat',
%     'liver-xwh-3_all.mat'
      
%       '181109_liver_highres_223.mat',
%       '181109_liver_highres_223.mat'
% '181119_liver_181.mat',
% '181119_lung_181.mat',
% '181126_lung_150.mat'
'20181126_lung-type2_160.mat'
% '181111_liver_hoechst_blood_181.mat'
};
label_file = {
%     '0713_liver-cancer-1_labeling.mat',
%     '0713_liver-cancer-2_labeling.mat',
%     '0713_liver-xwh-1_labeling.mat',
%     '0713_liver-xwh-2-1_labeling.mat',
%     '0713_liver-xwh-2-2_labeling.mat',
%     '0713_liver-xwh-3_labeling.mat'
%      '0928_468I-SKNO-YINGGUANG_249_labeling.mat',
%      '0928_HELA-BR-SK-I-A549-NO_194_labeling.mat'
% 'labeling_181106_mcf-7-high-spatial-resolution.mat'
% 'labeling_181109_liver_highres_354.mat',
% 'labeling_181109_liver_highres_434.mat'
% 'labeling_181111_liver_free_181.mat',
% 'labeling_181111_liver_hoechst_blood_dim181_cell402.mat'
% 'labeling_181119_liver_414.mat',
% 'labeling_181119_lung_663.mat'
% 'labeling_181126_lung_306.mat'
'labeling_181126_lung-type2_434_160dim.mat'
};

label_path = 'labeling\';
% data_file={
% 'C:\Users\yzy\Documents\SIMS\MATLAB\MATLAB\Add-Ons\Collections\HMRF-EM-image\code\HMRF-EM-image_v2.1\code\DeeBNetV3.2\DeeBNetV3.2\data\hunyang\MIX-BRDU_all.mat'    
% }
% label_file = {
% 'C:\Users\yzy\Documents\SIMS\MATLAB\MATLAB\Add-Ons\Collections\HMRF-EM-image\code\HMRF-EM-image_v2.1\code\DeeBNetV3.2\DeeBNetV3.2\data\hunyang\中间结果\MIX-BRDU_0724_labeling.mat'    
% }

data_mat = [];
for i=1:1
load(data_file{i});
load(label_file{i});
cur_labeling = final_labeling;
[filtered_img,num_valid_cell,cur_labeling] = filter_cell(cur_labeling,1);

[cur_cells,cur_cells_mean,sep_labeling] = get_each_cell_finger(cur_labeling,test_samples); 


for j=0:num_valid_cell
    cur_batch = i;
       cur_idxs = find(sep_labeling==j);
       cur_pixels = test_samples(cur_idxs,:);
       
%        cur_pixels = cur_cells{j};
       
       cur_cellidx = j;
       
       to_add = [repmat([cur_batch,cur_cellidx],size(cur_pixels,1),1),cur_idxs,cur_pixels];
%        to_add = to_add(:,1:289);
       data_mat = [data_mat;to_add];
end
end