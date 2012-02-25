function [ dstd ] = matdailystd( data, D )
    sqr = (data - repmat(mean(data), length(data), 1)).^2;
    dstd = (261/D) * sum(sqr, 1);
end

