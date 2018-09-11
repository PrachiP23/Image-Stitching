function [F]= fit_fundamental(matches, norm)
   m1 = matches(:,1:2);
   m2 = matches(:,3:4);
   
   if norm==1
       [m1, m2, Ta, Tb]= normalise(m1, m2);
   end
   
   x2 = m1(:,1);
   x1 = m2(:,1);
   y2 = m1(:,2);
   y1 = m2(:,2);
   
   F =  [x1.*x2 x1.*y2 x1 y1.*x2 y1.*y2 y1 x2 y2 ones(size(matches,1), 1)];
   [~,~,V] = svd(F);
   x = V(:,9); 
   F = reshape(x,3,3)';
   [U,D,V] = svd(F); %enforce the rank 2 constraint on F
   D(3,3) = 0;
   F = U*D*V';
     if norm==1
         F = transpose(Tb)*F*Ta;
     end
end
