function [ bestH, inlierIdx] = ransac(x, y, n)
    [numMatches, ~] = size(x);
    
    numIterations = 5000;
    threshold = 1;
    minNumOfInliers = 4;   
    bestH = [];

    for i = 1 : numIterations
        index = randperm(numMatches, n);
        xpts = x(index, :);
        ypts = y(index, :); 
        H = computeHomography(xpts, ypts);
        error = errorFunction(H, x, y);     
        inlierIdx = find(error < threshold);      
        numOfInliers = length(inlierIdx);
        if numOfInliers>= minNumOfInliers
            minNumOfInliers = numOfInliers;
            x_inliers = x(inlierIdx, :);
            y_inliers = y(inlierIdx, :);
            bestH = computeHomography(x_inliers, y_inliers);
        end
    end
    error = errorFunction(bestH, x, y);
    inlierIdx = find(error < threshold);
end