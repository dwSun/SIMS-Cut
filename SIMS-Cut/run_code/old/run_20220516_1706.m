name_list={
'hcc19d_1_pos_gaussian_ada',
'hcc19d_1_pos_gaussian_auto',
'hcc19d_1_pos_None_ada',
'hcc19d_1_pos_None_auto',
};
edge_type_list={
'ada',
'auto',
'ada',
'auto',
};
test_sample_all_file_list={
'test_samples_293.mat',
'test_samples_293.mat',
'test_samples_293.mat',
'test_samples_293.mat',
};
top_k_name_list={
'test_samples_20',
'test_samples_20',
'test_samples_20',
'test_samples_20',
};
rbm_ratio_list={
0.1,
0.1,
0.1,
0.1,
};
beta_list={
0.9,
0.9,
0.9,
0.9,
};
nei_type={
4,
4,
4,
4,
};
divn_list={
20,
20,
20,
20,
};
epoch_list={
5,
5,
5,
5,
};
sz_list={
[256 256],
[256 256],
[256 256],
[256 256],
};

process_path_pref = '/home/robu/dwSun/数字化病理/sample_data/process';
%test_sample20_file = 'test_samples_5.mat';


use_edges = 0;
%default is 0
for i=1:size(name_list,1)
    process_path = fullfile(process_path_pref,name_list{i});
    test_sample_all_file = [test_sample_all_file_list{i}];
    run_zuzhi_func_go_choose_adaauto_ext(process_path,test_sample_all_file,top_k_name_list{i},use_edges,edge_type_list{i},4,divn_list{i},sz_list{i},epoch_list{i},rbm_ratio_list{i},beta_list{i});
end
