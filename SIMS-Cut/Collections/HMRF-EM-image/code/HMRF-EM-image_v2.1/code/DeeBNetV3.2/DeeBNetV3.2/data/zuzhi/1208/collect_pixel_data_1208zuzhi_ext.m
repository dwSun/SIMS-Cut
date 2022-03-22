% 276维，前两维是 Br和I
%BR和I放在datamat的最后两位

label_path = 'labeling\';
% data_file={
% 'C:\Users\yzy\Documents\SIMS\MATLAB\MATLAB\Add-Ons\Collections\HMRF-EM-image\code\HMRF-EM-image_v2.1\code\DeeBNetV3.2\DeeBNetV3.2\data\hunyang\MIX-BRDU_all.mat'
% }
% label_file = {
% 'C:\Users\yzy\Documents\SIMS\MATLAB\MATLAB\Add-Ons\Collections\HMRF-EM-image\code\HMRF-EM-image_v2.1\code\DeeBNetV3.2\DeeBNetV3.2\data\hunyang\中间结果\MIX-BRDU_0724_labeling.mat'
% }

data_mat = [];
data_mat_cell = cell(0);
disp(['idx', num2str(idx)])
%return
for i = 1:idx
    load(data_file{i});
    load(label_file{i});
    cur_labeling = final_labeling;
    [filtered_img, num_valid_cell, cur_labeling] = filter_cell_ext(cur_labeling, 1, sz);

    [cur_cells, cur_cells_mean, sep_labeling] = get_each_cell_finger_ext(cur_labeling, test_samples, sz);

    for j = 0:num_valid_cell
        cur_batch = i;
        cur_idxs = find(sep_labeling == j);
        cur_pixels = test_samples(cur_idxs, :);

        %        cur_pixels = cur_cells{j};

        cur_cellidx = j;

        % [单个细胞像素个数，1 + 细胞编号 + 细胞所在像素点 + 质谱维度 ]
        to_add = [repmat([cur_batch, cur_cellidx], size(cur_pixels, 1), 1), cur_idxs, cur_pixels];
        data_mat_cell{end + 1} = to_add;
    end

end

data_mat = vertcat(data_mat_cell{:});
