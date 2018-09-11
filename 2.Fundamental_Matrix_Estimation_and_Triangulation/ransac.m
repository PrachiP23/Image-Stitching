function [ bestH, inlierIdx] = ransac(x, y, n)
    [numMatches, ~] = size(x);
    
    numIterations = 1000;
    threshold = 10;
    bestH = [];
    minNumOfInliers=4;

    for i = 1 : numIterations
        index = randperm(numMatches, n);
        xpts = x(index, :);
        ypts = y(index, :); 
        H = fit_fundamental([xpts, ypts],1);
        error = errorFunction(H, x, y);   
        inlierIdx = find(error < threshold);    
        numOfInliers = size(inlierIdx,1);
        if numOfInliers >=  minNumOfInliers
            minNumOfInliers = numOfInliers;
            x_inliers = x(inlierIdx, :);
            y_inliers = y(inlierIdx, :);
            bestH = fit_fundamental([x_inliers, y_inliers],1);
        end
    end
    error = errorFunction(bestH, x, y);
    inlierIdx = find(error < threshold);
    
    
    
end