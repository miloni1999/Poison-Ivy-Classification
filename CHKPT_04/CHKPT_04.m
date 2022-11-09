function CHKPT_04()
    clc
    close all;
    clear all;
    a=imread('IMAGES/IMG_3127.JPG');
    figure(1);
    subplot(3,3,1);
    imshow(a);
    title('Actual image');
    
    g=rgb2gray(a);
    subplot(3,3,2);
    imshow(g);
    title('Gray image');
    
    [r c l]=size(a);
    o(:,:)=a(:,:,1);
    x=0;y=0;

    thresh = graythresh(a);
    
    bw=imbinarize(a,thresh);
    subplot(3,3,3)
    imshow(bw)
    title('binarized image');
    
    s=imcomplement(bw);
    subplot(3,3,4)
    imshow(s)
    title('complement for binarized image')
    for i=1:r
        for j=1:c
            for k=1:3
                if g(i,j)<=80
                    o(i,j)=0;
                elseif g(i,j)>80
                    o(i,j)=255;
                end 
                if(s(i,j)==255)
                    x=x+1;
                    w=x*0.00147;
                elseif(s(i,j)==0)
                    y=y+1;
                    b=y*0.00147;
                end
             end
         end
     end
     c=edge(s,'canny');
     subplot(3,3,5);
      imshow(c);
      title('canny');
      p=edge(s,'log');
      subplot(3,3,6);
      imshow(p);
      title('log filter');
      p=edge(s,'roberts');
      subplot(3,3,7);
      imshow(p);
      title('roberts filter');
      p=edge(s,'sobel');
      subplot(3,3,8);
      imshow(p);
      title('sobel filter');
end