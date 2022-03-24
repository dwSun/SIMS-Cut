function [] = run_zuzhi_func_go_choose_adaauto_ext(process_path, test_sample_all_file, test_sample20_file, use_edges, edge_type, auto_type, divn, sz, n_epoch, train_ratio)
    % save_mid_path不要有/
    save_final_labeling_path = fullfile(process_path, 'cut/rst/');
    test_sample_path = fullfile(process_path, 'preprocess/');
    cut_edges_path = fullfile(process_path, 'cut/edges/');
    EM_mid_path = fullfile(process_path, 'cut/EM_mid_rst/');
    save_pref = fullfile(process_path, 'cut');
    test_sample_all_file_simple = test_sample_all_file;
    test_sample_all_file = fullfile(test_sample_path, test_sample_all_file);

    if ~exist(save_pref, 'dir')
        mkdir(save_pref);
    end

    if ~exist(cut_edges_path, 'dir')
        mkdir(cut_edges_path);
    end

    if ~exist(save_final_labeling_path, 'dir')
        mkdir(save_final_labeling_path);
    end

    if ~exist(EM_mid_path, 'dir')
        mkdir(EM_mid_path);
    end

    sample_name = test_sample20_file(1:end - 4);
    load(fullfile(test_sample_path, test_sample20_file));
    % python 代码保存 mat 文件的时候，文件中的变量名就是 test_samples，这里直接使用了
    test_samples_20 = double(test_samples);

    if (use_edges == 0)

        if (auto_type == 4)
            edge_auto = get_BK_pairwise_ext(test_samples_20, 1, sz(1), sz(2));
            save(fullfile(cut_edges_path, strcat('edges_ori_auto_', test_sample20_file)), 'edge_auto');
            edge_ada = adaptive_constrast2_ext(edge_auto, 21, sz(1), sz(2));
            save(fullfile(cut_edges_path, strcat('edges_ori_ada_', test_sample20_file)), 'edge_ada');
        end

        if (auto_type == 8)
            edge_auto = get_BK_pairwise_8_autosigma(test_samples_20, 1, sz(1), sz(2));
            save(fullfile(cut_edges_path, strcat('edges_ori_auto_', test_sample20_file)), 'edge_auto');
            edge_ada = adaptive_constrast2(edge_auto, 21, sz(1), sz(2));
            save(fullfile(cut_edges_path, strcat('edges_ori_ada_', test_sample20_file)), 'edge_ada');
        end

    else
        % FIXME
        % 如果使用 edge 的话，就直接加载之前运行的结果。
        % 但是这里的 edge 运算，处理的速度很快，应该可以每次都重新计算，不需要加载之前的结果。
        load(fullfile(cut_edges_path, strcat('edges_ori_auto_', test_sample20_file)));
        load(fullfile(cut_edges_path, strcat('edges_ori_ada_', test_sample20_file)));
    end

    iters_max = 100;
    beta_list = [0.5, 0.7, 0.9];
    n_matter = size(test_samples_20, 2)
    data_file = {};
    label_file = {};
    idx = 1;
    %divn=10;
    for beta = beta_list
        date = datestr(now, 'HHMMSSFFF')

        if (strcmp(edge_type, 'ada'))
            USIS_EM2_ext(test_samples_20, strcat(sample_name, '_ada_test'), beta, divn, edge_ada, iters_max, save_pref, date, n_matter, sz, n_epoch, train_ratio);
        else

            USIS_EM2_ext(test_samples_20, strcat(sample_name, '_ada_test'), beta, divn, edge_auto, iters_max, save_pref, date, n_matter, sz, n_epoch, train_ratio);
        end

        path = fullfile(save_pref, '/EM_mid_rst/');
        file_prefix = strcat('cur_labeling_', date, '_', sample_name, '_ada_test_20_Fmeasure_', num2str(beta), '_div', num2str(divn), '_', '_');
        disp(file_prefix);
        repair_cell_comb3_ext;
        data_file{idx} = test_sample_all_file;
        label_file{idx} = strcat(save_final_labeling_path, 'final_labeling_', num2str(beta), '.mat');

        collect_pixel_data_1208zuzhi_ext;
        save(fullfile(save_final_labeling_path, strcat('datamat_', num2str(beta), '.mat')), 'data_mat', '-v7.3');
    end

    %idx=length(beta_list);
    disp(['idx', num2str(idx)])
    collect_pixel_data_1208zuzhi;
    disp(['idx', num2str(idx)])
    save(fullfile(save_final_labeling_path, strcat(date, '_datamat_', test_sample_all_file_simple)), 'data_mat', '-v7.3');
