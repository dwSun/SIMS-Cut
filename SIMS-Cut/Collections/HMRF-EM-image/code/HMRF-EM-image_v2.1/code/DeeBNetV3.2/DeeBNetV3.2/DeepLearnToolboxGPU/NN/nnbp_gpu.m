function nn = nnbp_gpu(nn)
    %NNBP performs backpropagation
    % nn = nnbp(nn) returns an neural network structure with updated weights

    n = nn.n; %number of layers
    sparsityError = 0;

    % calculate backprop for output layer
    switch nn.output
        case 'sigm'
            d_act =- nn.e .* (nn.a{n} .* (1 - nn.a{n}));
            d{n} = d_act;
        case {'nnsoftmax', 'linear'}
            d{n} =- nn.e;
    end

    %backpropagate trough layers
    for i = fliplr(2:n - 1)

        switch nn.activation_function % Derivative of the activation function
            case 'sigm'
                d_act = nn.a{i} .* (1 - nn.a{i});
            case 'ReLU' % linear rectified units max(0,x)
                d_act = nn.cast(nn.a{i} > 0);
            case 'tanh_opt'
                d_act = nn.cast(2.7159 * 2/3) * (gpuArray.ones(1, nn.caststr) - nn.cast(1 / (1.7159).^2) * nn.a{i}.^2);
        end

        if (nn.nonSparsityPenalty > 0)
            % not tested if sparsitypenalty works with w,b notation
            pi = repmat(nn.p{i}, size(nn.a{i}, 1), 1);
            sparsityError = [zeros(size(nn.a{i}, 1), 1) nn.nonSparsityPenalty * (-nn.sparsityTarget ./ pi + (1 - nn.sparsityTarget) ./ (1 - pi))];
        end

        % Backpropagate first derivatives
        %
        %i+1=n
        d{i} = (d{i + 1} * nn.W{i} + sparsityError) .* d_act;

        if (nn.dropoutFraction > 0)
            d{i} = d{i} .* nn.dropOutMask{i};
        end

    end

    batchsize = size(d{n}, 1);

    for i = 1:(n - 1)
        dt = d{i + 1}';
        nn.dW{i} = (dt * nn.a{i}) / batchsize;
        %nn.db{i} = (dt * ones(size(d{i+1},1),1) / batchsize);
        nn.db{i} = sum(dt, 2) / batchsize; %faster than the line above
        clear dt
    end

    for u = 1:numel(nn.a)
        nn.a{u} = [];
    end

end
