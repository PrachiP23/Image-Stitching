function[ims] = displayImage(im1, im2, H)
     
    T = maketform('projective', H);
    [~,xdataim2t,ydataim2t] = imtransform(im1, T);
   
    xdataout=[min(1,xdataim2t(1)) max(size(im2,2),xdataim2t(2))];
    ydataout=[min(1,ydataim2t(1)) max(size(im2,1),ydataim2t(2))];

    im1t=imtransform(im1,T,'XData',xdataout,'YData',ydataout);
    im2t=imtransform(im2,maketform('affine',eye(3)),'XData',xdataout,'YData',ydataout);
    ims=im1t/2 +im2t/2;
%     ims=max(im1t,im2t);
    figure; 
    imshow(ims);
   
end