% gauassian 适用于细胞核比较远，细胞边界比较宽的情况
% ada 适用于细胞核大小适中的情况
% auto 适用于细胞核较小的情况

% 优选 None + ada

name_list = {
        'HCC-05-N1-NEG_gaussian_ada',
        'HCC-05-N1-NEG_gaussian_auto', % 所有高频信息都丢失了，所以最终的数据比较平滑，细胞核数量较少，适用于图像干扰较大的质谱数据。
        'HCC-05-N1-NEG_None_ada', % 在上下两个结果之中折衷
        'HCC-05-N1-NEG_None_auto', % 保留所有的高频信息，细胞核数量较多，适用于图像干扰较小的质谱数据。
        };
nei_type = {%  观测像素点临近的像素点数量
        4,
        4,
        4,
        4,
        };
edge_type_list = {
            'ada',
            'auto',
            'ada',
            'auto',
            };
test_sample_all_file_list = {
                        'test_samples_275.mat',
                        'test_samples_275.mat',
                        'test_samples_275.mat',
                        'test_samples_275.mat',
                        };
top_k_name_list = {
                'test_samples_20',
                'test_samples_20',
                'test_samples_20',
                'test_samples_20',
                };
divn_list = {
        20,
        20,
        20,
        20,
        };
epoch_list = {
        5,
        5,
        5,
        5,
        };
rbm_ratio_list = {% rbm的训练数据比例
            0.1,
            0.1,
            0.1,
            0.1,
            };
sz_list = {
        [256 256],
        [256 256],
        [256 256],
        [256 256],
        };

process_path_pref = '/Users/david/Code/Projects/数字化病理/sample_data/process';
%test_sample20_file = 'test_samples_5.mat';

use_edges = 0;
%default is 0
for i = 1:size(name_list, 1)
    process_path = fullfile(process_path_pref, name_list{i});
    test_sample_all_file = [test_sample_all_file_list{i}];
    run_zuzhi_func_go_choose_adaauto_ext(process_path, test_sample_all_file, top_k_name_list{i}, use_edges, edge_type_list{i}, 4, divn_list{i}, sz_list{i}, epoch_list{i}, rbm_ratio_list{i});
end
