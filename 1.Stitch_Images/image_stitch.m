function [] = image_stitch(img1, img2)
%     img1 = imread('../data/part1/uttower/left.jpg');
%     img2 = imread('../data/part1/uttower/right.jpg');
    
%     %format image
    colorImg1 = im2double(img1);
    colorImg2 = im2double(img2);
    [h1, w1, ~] = size(img2);
    [h2, w2, ~] = size(img2);

    grayImg1 = rgb2gray(colorImg1);
    grayImg2 = rgb2gray(colorImg2);
%%   
    %harris detector and features points:
   r=10;
   enlarge_factor=1.5;
   [~, x1, y1] = harris(grayImg1, 2, 0.01, 2, 0);
   circles = [y1 x1 r*ones(length(x1), 1)];  
   sifts1 = find_sift(grayImg1, circles, enlarge_factor);
   
   [~, x2, y2] = harris(grayImg2, 2, 0.01, 2, 0);
   circles = [y2 x2 r*ones(length(x2), 1)];
   sifts2 = find_sift(grayImg2, circles, enlarge_factor);

  %%
   %get the first 250 points 
    numMatches=250;
    dist = dist2(sifts1, sifts2);
    [~,distance_idx] = sort(dist(:));
    bestMatches = distance_idx(1:numMatches);
    [idx1, idx2] = ind2sub(size(dist), bestMatches);

    match_r1 = x1(idx1);
    match_c1 = y1(idx1);
    match_r2 = x2(idx2);
    match_c2 = y2(idx2);
    
 %%   
    img1FeatPts = [match_c1, match_r1,  ones(numMatches,1)];
    img2FeatPts = [match_c2, match_r2,  ones(numMatches,1)];
    [H, inlierIndices] = ransac(img1FeatPts, img2FeatPts, 4);
    
    disp('Number of inliers:');
    disp(length(inlierIndices));
    disp('Average residual/error for inliers:');
    disp(mean(errorFunction(H, img1FeatPts(inlierIndices,:), img2FeatPts(inlierIndices,:))));
    
    

 %% 
    % Display lines connecting the inliers matched features
    plot_r = [match_r1, match_r2];
    plot_c = [match_c1, match_c2 + w1];
    figure; imshow([colorImg1 colorImg2]);
    hold on; 
    title('Matched features');
    hold on; 
    plot(match_c1, match_r1,'ys');           %mark features from the 1st img
    plot(match_c2 + w1, match_r2, 'ys'); %mark features from the 2nd img
    for i = 1:numMatches             %draw lines connecting matched features
        plot(plot_c(i,:), plot_r(i,:));
    end
    
      
 %%   
    ims = displayImage(colorImg1, colorImg2, H);

end