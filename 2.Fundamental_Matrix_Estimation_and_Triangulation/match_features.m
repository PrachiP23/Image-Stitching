function [ img1Feature_idx, img2Feature_idx ] = match_features( numMatches, featDescriptions_1, featDescriptions_2)
    distances = dist2(featDescriptions_1, featDescriptions_2);
    [~,distance_idx] = sort(distances(:));
    bestMatches = distance_idx(1:numMatches);
    [rowIdx_inDistMatrix, colIdx_inDistMatrix] = ind2sub(size(distances), bestMatches);
    img1Feature_idx = rowIdx_inDistMatrix;
    img2Feature_idx = colIdx_inDistMatrix;
end