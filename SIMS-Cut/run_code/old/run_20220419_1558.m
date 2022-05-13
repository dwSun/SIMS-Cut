name_list = {
        'HCC-05-T-big-1792x1024_gaussian_ada',
        'HCC-05-T-big-1792x1024_gaussian_auto',
        'HCC-05-T-big-1792x1024_None_ada',
        'HCC-05-T-big-1792x1024_None_auto',
        };
nei_type = {
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
                        'test_samples_320.mat',
                        'test_samples_320.mat',
                        'test_samples_320.mat',
                        'test_samples_320.mat',
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
rbm_ratio_list = {
            0.1,
            0.1,
            0.1,
            0.1,
            };
sz_list = {
        [1792 1024],
        [1792 1024],
        [1792 1024],
        [1792 1024],
        };
beta_list = {
        0.5,
        0.5,
        0.5,
        0.5,
        };

process_path_pref = '/home/robu/dwSun/数字化病理/sample_data/process';
%test_sample20_file = 'test_samples_5.mat';

use_edges = 0;
%default is 0
for i = 1:size(1, 1)
    process_path = fullfile(process_path_pref, name_list{i});
    test_sample_all_file = [test_sample_all_file_list{i}];
    run_zuzhi_func_go_choose_adaauto_ext(process_path, test_sample_all_file, top_k_name_list{i}, use_edges, edge_type_list{i}, 4, divn_list{i}, sz_list{i}, epoch_list{i}, rbm_ratio_list{i}, beta_list{i});
end
