%输入separated_img，从Separate_cell得到，0是bg，非零的为idx
%输入test_samples为e.g. 65536*20的数据

function [all_cells_info, all_cells_mean, sep_labeling] = get_each_cell_finger_ext(Labeling, test_samples, sz)

    img = reshape(Labeling, sz(1), sz(2));
    [separated_img] = Separate_cell(img);
    num_cells = max(separated_img(:));
    sep_labeling = separated_img(:);
    all_cells_info = cell(num_cells);
    all_cells_mean = zeros(num_cells, size(test_samples, 2));

    for i = 1:num_cells
        idx_vector = sep_labeling == i;
        cur_cell_info = test_samples(idx_vector, :);
        all_cells_info{i} = cur_cell_info;
        cur_cell_mean = mean(cur_cell_info);
        all_cells_mean(i, :) = cur_cell_mean;
    end
