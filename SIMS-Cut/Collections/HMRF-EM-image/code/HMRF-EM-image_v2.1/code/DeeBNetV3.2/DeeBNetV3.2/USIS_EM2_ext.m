function [num_pos_li, beta_li] = USIS_EM2_ext(test_samples, batch_name, beta, divn, ed, niters, save_pref, date, n_matter, sz, n_epoch, train_ratio)
    Height = sz(1);
    Width = sz(2);
    % 数据总长度
    n_sites = Height * Width;

    % load('C:\Users\Yuan Zhiyuan\Documents\MATLAB\SIMS_0820\MATLAB\Add-Ons\Collections\HMRF-EM-image\code\HMRF-EM-image_v2.1\code\DeeBNetV3.2\DeeBNetV3.2\data\hunyang\274\cor_sort_ind.mat');
    %test_samples_processed = test_samples + 1;
    %test_samples_processed = bsxfun(@rdivide, test_samples_processed, prctile(test_samples_processed, 80, 2));
    %test_samples_processed = log(double(test_samples_processed));
    %test_samples_processed = test_samples_processed(:, 1:n_matter);

    % 上面的代码都没用到，就让最后这个赋值给全部覆盖了
    test_samples_processed = test_samples(:, 1:n_matter);
    %fg:2,bg:1
    % 2 细胞，1 背景
    % test_samples = zeros(n_sites,n_matters);
    rdpm = randperm(n_sites);
    init_labeling = ones(n_sites, 1);
    init_labeling(rdpm(1:n_sites / 2)) = 2;
    % 随机初始化了1/2作为标签值。

    % [init_labeling,C] = kmeans(test_samples_processed(:,1),2);
    % if(C(1)>=C(2))
    %     init_labeling = -init_labeling+3;
    % end

    [tmp_labeling, C] = kmeans(test_samples_processed(:, 1), 4);
    [tmp, min_C_ind] = min(C);
    [tmp, max_C_ind] = max(C);
    init_labeling = tmp_labeling;
    init_labeling(tmp_labeling == min_C_ind) = 1;
    % 细胞核物质的密度比较小的，都当作背景处理，其他的都当作细胞核处理
    init_labeling(tmp_labeling ~= min_C_ind) = 2;

    %init_labeling(tmp_labeling==max_C_ind) = 2;
    %init_labeling(tmp_labeling~=max_C_ind) = 1;

    cur_labeling = init_labeling;

    edges_sigma = 8;
    lambda = 0.5;

    global edges;
    edges = ed;
    edges(:, 3:end) = edges(:, 3:end) / divn;
    % edges(:,3:end) = 0;
    n_hidden = 50;
    % 隐层有50个神经元
    normed_data = (test_samples_processed - min(test_samples_processed(:))) / (max(test_samples_processed(:)) - min(test_samples_processed(:)));
    % 这里给数据做了一个 0 均值化
    iters = 1;
    % imshow(reshape(cur_labeling,256,256)',[])
    num_pos_li = [n_sites];
    % hard_constraint = find(test_samples(:,1)>=20);
    hard_constraint = [];
    cur_beta = beta;
    pre_labeling = cur_labeling;

    while (iters <= niters & sum(cur_labeling == 2) > 10)
        % 只要没达到 100 个迭代次数 或者，该层细胞标注中，还能找到 10个以上的细胞，就继续循环。
        % FIXME，20个质峰，按照相关性排序，所以拍最后的那个质峰，应该跟细胞核没啥关系了。

        cell_count = sum(cur_labeling == 2)
        disp(["cell count:", num2str(cell_count)]);
        num_pos_li = [num_pos_li, cell_count];
        % FIXME 这里貌似收集了所有迭代的细胞核数量
        decrease_ratio = 1 - num_pos_li(end) / num_pos_li(end - 1);
        % 后一次迭代的细胞核数量，应该都要小于前一次的，如果不是变少了，就需要显示一下。

        if (decrease_ratio <= 0)
            disp([num2str(decrease_ratio)])
            disp(num_pos_li)
            %   cur_beta = cur_beta-0.01;
        end

        if (iters > 2)
            cur_labeling(pre_labeling == 1) = 1;
            % 每次迭代，都把当前迭代的细胞，参考上次迭代结果中，非细胞核的，全部设置成非细胞核
        end

        suf = strcat(date, '_', batch_name, '_20_Fmeasure_', num2str(beta), '_div', num2str(divn), '_');
        save(strcat(save_pref, '/EM_mid_rst/cur_labeling_', suf, '_', num2str(iters), '.mat'), 'cur_labeling');
        % 只有当前这个位置会保存 每次运行产生的 label 结果的 mat 数据 以及对应的 png 文件。这个文件名跟外面的 file_prefix 是同一个文件。
        % 也是repair cell 里面用到的那个文件名。
        cur_labeling_img = logical(reshape(cur_labeling, sz(1), sz(2))' - 1);
        imwrite(cur_labeling_img, strcat(save_pref, '/EM_mid_rst/cur_labeling_', suf, '_', num2str(iters), '_', num2str(cur_beta), '.png'));

        pre_labeling = cur_labeling;

        % 这里 n_epoch=5 那就是只训练了5次，够么。
        % 这个 rbm 似乎就是个单隐层的线性网络。
        % PF 居然是个标量，不是向量。
        [bg_rbm, fg_rbm, PF] = train_rbm_multi_ext(normed_data, cur_labeling, n_hidden, n_epoch, cur_beta, sz, train_ratio);

        cur_labeling = MRF_MAP_RBM_BK_multi(Height, Width, bg_rbm, fg_rbm, normed_data, PF, hard_constraint, batch_name, iters);
        %      plot(1:iters,num_pos_li)
        %强行要求cur_labeling，**真**包于pre_labeling
        %1是背景，要求pre是1的，现在还是1.

        iters = iters + 1;

    end
