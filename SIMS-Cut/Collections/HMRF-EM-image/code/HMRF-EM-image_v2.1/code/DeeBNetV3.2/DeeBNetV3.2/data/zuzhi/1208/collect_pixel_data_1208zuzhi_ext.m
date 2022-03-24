% 276维，前两维是 Br和I
%BR和I放在datamat的最后两位

%label_path = 'labeling\';

% test code
%save_final_labeling_path = '/home/dl/dwSun/数字化病理/sample_data/process/HCC-05-T-big_gaussian_ada/cut/rst/';
%data_file = {
%        '/home/dl/dwSun/数字化病理/sample_data/process/HCC-05-T-big_gaussian_ada/preprocess/test_samples_320.mat'
%        };
%label_file = {
%        '/home/dl/dwSun/数字化病理/sample_data/process/HCC-05-T-big_gaussian_ada/cut/rst/final_labeling_0.5.mat'
%        };

%beta = 0.5;
%idx = 1;
%sz = [1792 512];
% test code end

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

% test code

%save(fullfile(save_final_labeling_path, strcat('datamat_', num2str(beta), '.mat')), 'data_mat', '-v7.3');

% test code end
