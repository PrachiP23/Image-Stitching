function H = computeHomography(im1Pts, im2Pts)
    [numMatches, ~] = size(im1Pts);
    A = []; % 2N x 9
    for i = 1:numMatches
        p1 = im1Pts(i,:);
        p2 = im2Pts(i,:);
        A(2*i-1, :) = [p1(1) p1(2) 1 0 0 0 -p1(1)*p2(1) -p1(2)*p2(1) -p2(1)];
        A(2*i, :) = [0 0 0 p1(1) p1(2) 1 -p1(1)*p2(2) -p1(2)*p2(2) -p2(2)]; 
        
    end
    [~,~,U] = svd(A); 
    x = U(:,end);     
    H = reshape(x, 3, 3);  
    H = H ./ H(3,3);        
end