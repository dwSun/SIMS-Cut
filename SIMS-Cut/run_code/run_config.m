%olddir = pwd;
%display(pwd);
%mfileinfo = mfilename('fullpath');
%mfileinfo = which('run_config.m');
%mfiledir = fileparts(mfileinfo);
%cd(mfiledir);
%display(mfiledir);
%dir;
%dir name
%listing = dir(name)

listing = dir('./config*');

disp('Config files:');
ls config *;

while (1)

    choice = menu('继续执行?', 'Yes', 'No');

    if choice == 2 || choice == 0
        break;
    end

    use_edges = 0;
    %default is 0
    for i = 1:size(listing, 1)
        file = listing(i);
        display(file);
        file_path = fullfile(file.folder, file.name);
        display(file_path);
        %run(file_path);

        scriptCode = fileread(file_path);
        eval(scriptCode);

        process_path = fullfile(process_path_pref, name);
        display(process_path);
        sz(1) = h;
        sz(2) = w;
        display(sz);
        run_zuzhi_func_go_choose_adaauto_ext(process_path, test_sample_all_file, top_k_name, use_edges, edge_type, 4, divn, sz, epoch, rbm_ratio, beta);
    end

    break
end

%cd(olddir);
