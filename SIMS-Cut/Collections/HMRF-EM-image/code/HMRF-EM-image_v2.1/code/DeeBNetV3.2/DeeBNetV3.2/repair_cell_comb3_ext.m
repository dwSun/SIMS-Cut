% test code
%clc
%clear

% small
%path = '/home/dl/dwSun/数字化病理/sample_data/process/HCC-05-N1-NEG_gaussian_ada/cut/EM_mid_rst/';
%file_prefix = 'cur_labeling_203554659_test_sample_ada_test_20_Fmeasure_0.5_div20__';
%sz = [256 256];
%load('/home/dl/dwSun/数字化病理/sample_data/process/HCC-05-N1-NEG_gaussian_ada/preprocess/test_samples_20.mat');
%save_final_labeling_path = '/home/dl/dwSun/数字化病理/sample_data/process/HCC-05-N1-NEG_gaussian_ada/cut/rst/';
%beta = 0.5;
%test_samples_20 = double(test_samples);

% big
%path = '/home/dl/dwSun/数字化病理/sample_data/process/HCC-05-T-big_gaussian_ada/cut/EM_mid_rst/';
%file_prefix = 'cur_labeling_094637326_test_sample_ada_test_20_Fmeasure_0.5_div20__';
%sz = [1792 512];
%load('/home/dl/dwSun/数字化病理/sample_data/process/HCC-05-T-big_gaussian_ada/preprocess/test_samples_20.mat');
%save_final_labeling_path = '/home/dl/dwSun/数字化病理/sample_data/process/HCC-05-T-big_gaussian_ada/cut/rst/';
%beta = 0.5;
%test_samples_20 = double(test_samples);

% test code end

file_sufix = '.mat';
iters_max = 200;
iters_num = 0;

height = sz(1);
fold_mean = 1.00;
width = sz(2);
%指大于0.75分位数的细胞要考虑分裂(75分位数)
attention_threshold = 40;
labeling_mat = zeros(height * width, iters_num);
% 构建labeling_mat，并看哪个图的cell最多

all_cells_num = 0;

for i = 1:iters_max
    % 这里要处理的数据，就是上一个步骤，那一堆 rbm 输出的 label，1为背景，2为细胞
    cur_file = strcat(path, file_prefix, num2str(i), file_sufix);

    if exist(cur_file, 'file')
        iters_num = i;

        cur_file = [path, file_prefix, num2str(i), file_sufix];
        disp(['load: ', cur_file]);
        load(cur_file);

        labeling_mat(:, i) = cur_labeling;
    end

end

parfor i = 1:iters_num
    disp(['filter: ', num2str(i)]);

    [filtered_img, num_valid_cell, filtered_labeling] = filter_cell_ext(labeling_mat(:, i), 0, sz);
    img = reshape(filtered_labeling, sz(1), sz(2));
    [separated_img] = Separate_cell(img);
    % 记下来一共有多少个细胞，最大也就是这么多

    labeling_mat(:, i) = separated_img(:);
    all_cells_num = all_cells_num + max(labeling_mat(:, i));
    % 这里有一个隐式的reshape，separated_img 是一个二维图像，labeling_mat是一个一维的

end

labeling_mat = labeling_mat(:, 2:end);
% FIXME 这里排除了 第一个 kmeans 生成的 结果，why?

disp('filter done')

%第i个位置表示i号节点的父节点的idx,1号节点是全1
parent_list = zeros(1, all_cells_num);
%记录第i个节点属于哪一层，第1层是labeling_1
level_list = zeros(1, all_cells_num);
%记录第i个节点是那一层的几号细胞
cell_list = zeros(1, all_cells_num);
area_list = zeros(1, all_cells_num);; % 每个细胞的像素数

cell_idx = 1;

parent_list(cell_idx) = 0;
level_list(cell_idx) = 0;
cell_list(cell_idx) = 1;
area_list(cell_idx) = sz(1) * sz(2);

lost_number = 0;
iters_num = iters_num - 1;
%假设第一个labeling包含了bias的kmeans，把全1当作根节点，代号为1
pre_lost = 0;

for i = 1:iters_num
    cur_labeling = labeling_mat(:, i);
    num_cells = max(cur_labeling);
    disp(['loop2', ':', num2str(i), ':', num2str(num_cells)])

    if (i == 1)

        for j = 1:num_cells
            cell_idx = cell_idx + 1;
            parent_list(cell_idx) = 1;
            level_list(cell_idx) = 1;
            cell_list(cell_idx) = j;
            area_list(cell_idx) = sum(cur_labeling == j);
        end

        continue;
    end

    %tic
    % [size x size, 1]
    pre_labeling = labeling_mat(:, i - 1);
    % [1, num_cells_with_father]
    pre_idxs = (cell_idx - max(pre_labeling) + 1 + pre_lost):cell_idx;

    pre_lost = 0;
    % 使用元胞，尽量避免大数组的索引
    tt = {};
    sum_tt = {};
    pre_labeling_mat = {};

    pre_cells = cell_list((cell_idx - max(pre_labeling) + 1 + pre_lost):cell_idx);

    for j = 1:num_cells
        %把新来的节点的父节点记录下来
        flag = 1;

        if length(tt) < j
            tt{j} = cur_labeling == j;
        end

        for k_i = 1:length(pre_idxs)

            k = pre_idxs(k_i);

            if length(pre_labeling_mat) < k_i
                pre_labeling_mat{k_i} = pre_labeling == pre_cells(k_i);
            end

            if any(tt{j} & pre_labeling_mat{k_i})

                %说明两层这两个segment有重叠
                cell_idx = cell_idx + 1;
                parent_list(cell_idx) = k;
                level_list(cell_idx) = i;
                cell_list(cell_idx) = j;

                if length(sum_tt) < j || sum_tt{j} == 0
                    sum_tt{j} = sum(tt{j});
                end

                area_list(cell_idx) = sum_tt{j};

                flag = 0;
                break;

            end

        end

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        %       发现丢失了770个
        if (flag)
            pre_lost = pre_lost + 1;
            lost_number = lost_number + 1;
            disp([num2str(i + 1), ',', num2str(j)]);

        end

    end

    %toc

end

parent_list = parent_list(1:cell_idx);
level_list = level_list(1:cell_idx);
cell_list = cell_list(1:cell_idx);
area_list = area_list(1:cell_idx);

%找出所有的叶子节点，并赋给final_labeling
parent_set = unique(parent_list);
all_set = 1:length(parent_list);
leaf_set = setdiff(all_set, parent_set);

mean_leaf_area = median(area_list(leaf_set));
area_threshold = fold_mean * mean_leaf_area;
single_leaf_set = leaf_set;
%对每一个叶子节点往上回溯，找到level最低的不分裂节点
intensity_134_list_count = 1;
intensity_134_list = [];

for i = leaf_set

    disp(['loop3', ':', num2str(i)])

    if (length(intensity_134_list) >= 2)
        disp(['---------------', num2str(length(intensity_134_list))]);
        intensity_134_list_cell{intensity_134_list_count} = intensity_134_list;
        intensity_134_list_count = intensity_134_list_count + 1;
    end

    intensity_134_list = [];
    ori_leaf = i;
    cur_leaf = i;
    cur_leaf_level = level_list(i);

    while (cur_leaf ~= 0)

        cur_leaf_cell = cell_list(cur_leaf);

        if (cur_leaf_level <= 0)
            continue;
        end

        cur_134_mean = mean(test_samples_20(labeling_mat(:, cur_leaf_level) == cur_leaf_cell, 1));
        intensity_134_list = [intensity_134_list, cur_134_mean];

        if (length(intensity_134_list) == 1)
            foldchange_intensity_134 = 1;
        else
            foldchange_intensity_134 = intensity_134_list(end) / intensity_134_list(end - 1);
        end

        %        先看当前层有没有leaf跟curleaf是同一个爸爸
        check_brother = sum(parent_list(level_list == cur_leaf_level) == parent_list(cur_leaf));

        if (check_brother == 0)
            disp('error');

            %            上升到分叉这个条件没问题，因为只要有沟壑
            %           重点是要决定上升到哪一层停止？单纯用threshold不行
            % 方案：上升到平均134的信号不减弱？或者画一个上升过程中平均134的变化图（应该是下降趋势），取拐点。
            % 现在：只要134的平均值下降了百分之*就停止上升
            % 或者说134的平均，没有降到原来的百分之*才停止

            %        elseif(check_brother==1 & area_list(cur_leaf)<=area_threshold)
        elseif (check_brother == 1 && foldchange_intensity_134 >= fold_mean)
            %说明可以往上走
            cur_leaf = parent_list(cur_leaf);
            %            cur_leaf_level = cur_leaf_level-1;
            cur_leaf_level = level_list(cur_leaf);
        else
            %不能往上走
            single_leaf_set(single_leaf_set == ori_leaf) = cur_leaf;
            disp(['change ', num2str(ori_leaf), 'to ', num2str(cur_leaf)]);
            break;
        end

    end

end

final_labeling = zeros(sz(1) * sz(2), 1);
leaf_labeling = zeros(sz(1) * sz(2), 1);

for i = single_leaf_set
    cur_leaf_level = level_list(i);
    cur_leaf_cell = cell_list(i);
    final_labeling(labeling_mat(:, cur_leaf_level) == cur_leaf_cell) = 1;
end

for i = leaf_set
    cur_leaf_level = level_list(i);
    cur_leaf_cell = cell_list(i);
    leaf_labeling(labeling_mat(:, cur_leaf_level) == cur_leaf_cell) = 1;
end

final_labeling = final_labeling + 1;
leaf_labeling = leaf_labeling + 1;
[~, final_num_cells, final_labeling] = filter_cell_ext(final_labeling, 1, sz);
disp(['there are ', num2str(final_num_cells), ' valid cells']);
% subplot(1,2,1);
% imshow(reshape(leaf_labeling,256,256)',[]);
% subplot(1,2,2);
% imshow(reshape(final_labeling,256,256)',[]);
save(strcat(save_final_labeling_path, 'final_labeling_', num2str(beta), '.mat'), 'final_labeling');

final_labeling_img = logical(reshape(final_labeling, sz(1), sz(2))' - 1);
imwrite(final_labeling_img, strcat(save_final_labeling_path, 'final_labeling_', num2str(beta), '.png'));
img_134 = reshape(test_samples_20(:, 1), sz(1), sz(2))';
imshowpair(img_134, final_labeling_img);
print(strcat(save_final_labeling_path, 'final_labeling_merge134_', num2str(beta), '.png'), '-dpng');
