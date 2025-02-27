% 276维，前两维是 Br和I
%BR和I放在datamat的最后两位

data_file = {
%     'liver-cancer-1_all.mat',
%     'liver-cancer-2_all.mat',
%     'liver-xwh-1_all.mat',
%     'liver-xwh-2-1_all.mat',
%     'liver-xwh-2-2_all.mat',
%     'liver-xwh-3_all.mat'
      'hela-i-a549-br-sk-no_181023_all.mat',
      'hela-br-a549-i-sk-no_181023_all.mat'
};
label_file = {
%     '0713_liver-cancer-1_labeling.mat',
%     '0713_liver-cancer-2_labeling.mat',
%     '0713_liver-xwh-1_labeling.mat',
%     '0713_liver-xwh-2-1_labeling.mat',
%     '0713_liver-xwh-2-2_labeling.mat',
%     '0713_liver-xwh-3_labeling.mat'
     'labeling_hela-i-a549-br-sk-no-217_181023.mat',
     'labeling_hela-br-a549-i-sk-no-211_181023.mat'

};

label_path = 'labeling\';
% data_file={
% 'C:\Users\yzy\Documents\SIMS\MATLAB\MATLAB\Add-Ons\Collections\HMRF-EM-image\code\HMRF-EM-image_v2.1\code\DeeBNetV3.2\DeeBNetV3.2\data\hunyang\MIX-BRDU_all.mat'    
% }
% label_file = {
% 'C:\Users\yzy\Documents\SIMS\MATLAB\MATLAB\Add-Ons\Collections\HMRF-EM-image\code\HMRF-EM-image_v2.1\code\DeeBNetV3.2\DeeBNetV3.2\data\hunyang\中间结果\MIX-BRDU_0724_labeling.mat'    
% }

data_mat = [];
for i=1:2
load(data_file{i});
load([label_path,label_file{i}]);
cur_labeling = final_labeling;
test_samples = [test_samples,test_samples(:,1:2)]
test_samples = test_samples(:,3:end)
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