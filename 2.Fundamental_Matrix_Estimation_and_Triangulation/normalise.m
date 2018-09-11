%Mean Coordinates for Points a and b
function [pts1, pts2, Ta, Tb]= normalise(m1, m2)
  
    numOfPts = size(m1,1);
    mean1 = mean(m1); 
    mean2 = mean(m2);
   
    Centered1 = m1 - repmat(mean1, [numOfPts, 1]);
    Centered2 = m2 - repmat(mean2, [numOfPts, 1]);
     
    sd1 = std(Centered1).^2;
    sd2 = std(Centered2).^2;
    
    Ta = [1/sd1(1), 0,0; 0,1/sd1(2), 0; 0,0,1]*[1,0,-mean1(1);0,1,-mean1(2);0,0,1];
    Tb = [1/sd2(1), 0,0; 0,1/sd2(2), 0; 0,0,1]*[1,0,-mean2(1);0,1,-mean2(2);0,0,1];
    Normalized1 = Ta * [m1'; ones(1,numOfPts)];
    Normalized2 = Tb * [m2'; ones(1,numOfPts)];
    
    pts1 = Normalized1';
    pts2 = Normalized2';
end