function [] = main_part2()
    img1 = '../data/part2/house1.jpg';
    img2 = '../data/part2/house2.jpg';
%      img1 = 'house1.jpg';
%     img2 = 'house2.jpg';
    
    %format image
    colorImg1 = im2double(imread(img1));
    colorImg2 = im2double(imread(img2));
    [h1, w1, ~] = size(colorImg1);
    [h2, w2, ~] = size(colorImg2);

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
    img1FeatPts = [match_c1, match_r1];
    img2FeatPts = [match_c2, match_r2];
    [F, inlierIndices] = ransac(img1FeatPts, img2FeatPts, 8);
    matches = [img1FeatPts(inlierIndices,:), img2FeatPts(inlierIndices,:)];
    
    disp('Number of inliers:');
    disp(length(inlierIndices));
    disp('Average residual/error for inliers:');
    disp(mean(errorFunction(F, img1FeatPts(inlierIndices,:), img2FeatPts(inlierIndices,:))));
    
    %%
    N = size(matches,1);

    L = (F * [matches(:,1:2) ones(N,1)]')'; % transform points from 
    % the first image to get epipolar lines in the second image

    % find points on epipolar lines L closest to matches(:,3:4)
    L = L ./ repmat(sqrt(L(:,1).^2 + L(:,2).^2), 1, 3); % rescale the line
    pt_line_dist = sum(L .* [matches(:,3:4) ones(N,1)],2);
    closest_pt = matches(:,3:4) - L(:,1:2) .* repmat(pt_line_dist, 1, 2);

    % find endpoints of segment on epipolar line (for display purposes)
    pt1 = closest_pt - [L(:,2) -L(:,1)] * 10; % offset from the closest point is 10 pixels
    pt2 = closest_pt + [L(:,2) -L(:,1)] * 10;

    % display points and segments of corresponding epipolar lines
    clf;
    imshow(img2); hold on;
    plot(matches(:,3), matches(:,4), '+r');
    line([matches(:,3) closest_pt(:,1)]', [matches(:,4) closest_pt(:,2)]', 'Color', 'r');
    line([pt1(:,1) pt2(:,1)]', [pt1(:,2) pt2(:,2)]', 'Color', 'g');


 %%
%     camera1 = load('house1_camera.txt');
%     camera2 = load('house2_camera.txt');
%     
%      [~, ~, V] = svd(camera1);
%     camera1Center = V(:,end);
%     camera1Center = camera1Center./camera1Center(4,1);
%     
%      [~, ~, U] = svd(camera2);
%      camera2Center = U(:,end);
%      camera2Center = camera2Center./camera2Center(4,1);
%     
%     
%     for i=1:numMatches
%         pt1 = img1FeatPts(i,:);
%         pt2 = img2FeatPts(i,:);
%         
% %         x1 = img1FeatPts(i,:);
% %         x2 = img2FeatPts(:,1);
% %         y1 = img1FeatPts(:,2);
% %         y2 = img2FeatPts(:,2);
% 
%         A = [y1*camera1(3,:)' - camera1(2,:)'; 
%             camera1(1,:)' - x1*camera1(3,:)';
%             y2*camera2(3,:)' - camera2(2,:)';
%             camera2(1,:)' - x2*camera2(3,:)'];
%         [~,~,V] = svd(A);
%         trainPts = V(:,end);
%         size(trainPts)  
%     end

    
    %%
    camera1 = load('../data/part2/house1_camera.txt');
    camera2 = load('../data/part2/house2_camera.txt');
    matches = load('../data/part2/house_matches.txt');
    x12 = matches( :, 1 : 2);
    x34 = matches( :, 3 : 4);
    noMatches = size(x12, 1);

    triangular_pts = zeros(noMatches, 3);
    left_proj_pts = zeros(noMatches, 2);
    right_proj_pts = zeros(noMatches, 2);

    [~, ~, V1] = svd(camera1);
    center_cam1 = V1( :, end);
    center_cam1T = center_cam1';
    cam1cord_temp = bsxfun(@rdivide, center_cam1T, center_cam1T( :, end));
    cord_cam1 = cam1cord_temp(:, 1 : ( size(center_cam1T, 2) - 1));

    [~, ~, V2] = svd(camera2);
    center_cam2 = V2( :, end);
    center_cam2_transpose = center_cam2';
    temp_cord_cam2 = bsxfun(@rdivide, center_cam2_transpose, center_cam2_transpose( :, end));
    cord_cam2 = temp_cord_cam2(:, 1 : ( size(center_cam2_transpose, 2) - 1));

    [a, b] = size(x12);
    left_homo = ones( a, b+1);
    left_homo( :, 1 : b) = x12( :, 1 : b);

    [c, d] = size(x34);
    right_homo = ones( c, d+1);
    right_homo( :, 1 : d) = x12( :, 1 : d);

    for x = 1 : noMatches
        left_img_pt = left_homo( x, : );
        right_img_pt = right_homo(x, : );

        left_mat = [0   -left_img_pt(3)  left_img_pt(2); left_img_pt(3)   0   -left_img_pt(1); -left_img_pt(2)  left_img_pt(1)   0];
        right_mat = [0   -right_img_pt(3)  right_img_pt(2); right_img_pt(3)   0   -right_img_pt(1); -right_img_pt(2)  right_img_pt(1)   0];

        temp = [ left_mat * camera1; right_mat * camera2];
        [~, ~, V] = svd(temp);

        triangular_pt_homo = V( :, end)';

        temp1 = bsxfun(@rdivide, triangular_pt_homo, triangular_pt_homo( :, end));
        triangular_pts(x, :) = temp1(:, 1 : ( size(triangular_pt_homo, 2) - 1));

        temp_cam1 = (camera1 * triangular_pt_homo')';
        temp2 = bsxfun(@rdivide, temp_cam1, temp_cam1( :, end));
        left_proj_pts(x, :) = temp2(:, 1 : ( size(temp_cam1, 2) - 1));

        temp_cam2 = (camera2 * triangular_pt_homo')';
        temp3 = bsxfun(@rdivide, temp_cam2, temp_cam2( :, end));
        right_proj_pts(x, :) = temp3(:, 1 : ( size(temp_cam2, 2) - 1));
    end

    left_err_dist = diag(dist2(x12, left_proj_pts));
    right_err_dist = diag(dist2(x34, right_proj_pts));

    disp('mean residual for left image');
    disp(mean(left_err_dist));
    disp('mean residual for right image');
    disp(mean(right_err_dist));

    figure; axis equal; hold on;
    plot3( -triangular_pts(:, 1), triangular_pts(:, 2), triangular_pts(:, 3), '.r');
    plot3( -cord_cam1(1), cord_cam1(2), cord_cam1(3), '*g');
    plot3( -cord_cam2(1), cord_cam2(2), cord_cam2(3), '*b');
    grid on; xlabel('x'); ylabel('y'); zlabel('z'); axis equal;

  
 end