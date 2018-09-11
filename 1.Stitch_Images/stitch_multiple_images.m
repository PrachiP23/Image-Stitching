function [] = stitch_multiple_images(img1, img2, img3)
           
       img1 = imread('1.jpg');
       img2 = imread('2.jpg');
       img3 = imread('3.jpg');
       img4 = image_stitch(img1, img2);
       image_stitch(img4, img3);
       
end