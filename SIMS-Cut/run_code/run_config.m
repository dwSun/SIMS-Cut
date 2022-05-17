config_file = getenv('RUN_CONFIG_FILE');

if isempty(config_file)
    % run from MATLAB GUI

    fullpath = mfilename('fullpath');
    [path, name] = fileparts(fullpath);
    display(fullpath);

    listing = dir([path, '/config*']);

    for i = 1:size(listing, 1)
        file = listing(i);
        display(file);
        file_path = fullfile(file.folder, file.name);
        display(file_path);

        scriptCode = fileread(file_path);
        eval(scriptCode);

        process_path = fullfile(process_path_pref, name);
        display(process_path);
        sz(1) = h;
        sz(2) = w;
        display(sz);
        run_zuzhi_func_go_choose_adaauto_ext(process_path, test_sample_all_file, top_k_name, use_edges, edge_type, 4, divn, sz, epoch, rbm_ratio, beta);
    end

else
    % run from executable
    scriptCode = fileread(config_file);
    eval(scriptCode);

    process_path = fullfile(process_path_pref, name);
    display(process_path);
    sz(1) = h;
    sz(2) = w;
    display(sz);
    run_zuzhi_func_go_choose_adaauto_ext(process_path, test_sample_all_file, top_k_name, use_edges, edge_type, 4, divn, sz, epoch, rbm_ratio, beta);
end
