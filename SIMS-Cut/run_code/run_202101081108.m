name_list = {
        'test_MIBI_2048_div10_top5_gaussian_gaussian_ada',
        'test_MIBI_2048_div10_top5_gaussian_gaussian_auto',
        'test_MIBI_2048_div30_top5_gaussian_gaussian_ada',
        'test_MIBI_2048_div30_top5_gaussian_gaussian_auto',
        'test_MIBI_2048_div20_top5_gaussian_gaussian_ada',
        'test_MIBI_2048_div20_top5_gaussian_gaussian_auto',
        'test_MIBI_2048_div5_top5_gaussian_gaussian_ada',
        'test_MIBI_2048_div5_top5_gaussian_gaussian_auto',
        'test_MIBI_2048_div1_top5_gaussian_gaussian_ada',
        'test_MIBI_2048_div1_top5_gaussian_gaussian_auto',
        };
nei_type = {
    '4',
    '4',
    '4',
    '4',
    '4',
    '4',
    '4',
    '4',
    '4',
    '4',
    };
edge_type_list = {
            'ada',
            'auto',
            'ada',
            'auto',
            'ada',
            'auto',
            'ada',
            'auto',
            'ada',
            'auto',
            };
test_sample_all_file_list = {
                        'test_samples_36.mat',
                        'test_samples_36.mat',
                        'test_samples_36.mat',
                        'test_samples_36.mat',
                        'test_samples_36.mat',
                        'test_samples_36.mat',
                        'test_samples_36.mat',
                        'test_samples_36.mat',
                        'test_samples_36.mat',
                        'test_samples_36.mat',
                        };
top_k_name_list = {
            'test_samples_5',
            'test_samples_5',
            'test_samples_5',
            'test_samples_5',
            'test_samples_5',
            'test_samples_5',
            'test_samples_5',
            'test_samples_5',
            'test_samples_5',
            'test_samples_5',
            };
divn_list = {
        '10',
        '10',
        '30',
        '30',
        '20',
        '20',
        '5',
        '5',
        '1',
        '1',
        };
epoch_list = {
        '5',
        '5',
        '5',
        '5',
        '5',
        '5',
        '5',
        '5',
        '5',
        '5',
        };
rbm_ratio_list = {
            '0.001',
            '0.001',
            '0.001',
            '0.001',
            '0.001',
            '0.001',
            '0.001',
            '0.001',
            '0.001',
            '0.001',
            };
sz_list = {
    '2048',
    '2048',
    '2048',
    '2048',
    '2048',
    '2048',
    '2048',
    '2048',
    '2048',
    '2048',
    };

process_path_pref = '/home/yzy/bioSIMS/data/process/';
%test_sample20_file = 'test_samples_5.mat';

use_edges = 0;
%default is 0
for i = 1:size(name_list, 1)
    process_path = [process_path_pref, name_list{i}, '/'];
    test_sample_all_file = [test_sample_all_file_list{i}];
    run_zuzhi_func_go_choose_adaauto_ext(process_path, test_sample_all_file, top_k_name_list{i}, use_edges, edge_type_list{i}, 4, str2num(divn_list{i}), str2num(sz_list{i}), str2num(epoch_list{i}), str2num(rbm_ratio_list{i}));
end
