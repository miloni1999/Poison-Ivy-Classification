function CHKPT_03 ()
    im_in = imread("IMAGES/IMG_3127.JPG");
    im_cropped = imcrop(im_in);
    figure, subplot(1,3,1), imshow(im_cropped);
    im_lab = rgb2lab(im_cropped);
    a_channel = im_lab(:,:,2);
    figure, imagesc(a_channel);
    figure, histogram(a_channel);
    mask = a_channel>-2.5 & a_channel<0.5;
    a_new = (~mask) == 1;
    figure, imshow(a_new);
%     se = strel("disk", 10);
%     im_closed = imclose(a_new, se);
%     se = strel('disk', 50);
%     im_opened = imopen(im_closed, se);
%     im_final = bwareaopen(im_opened, 3900);
%     figure, imshow(im_opened);
%     sc = strel("disk", 10);
%     im_eroded = imerode(a_new, sc);
%     figure, imshow(im_eroded);
%     sc = strel("disk", 2);
%     im_dilated = imdilate(im_eroded, sc);
%     subplot(1,2,2), imshow(im_dilated);
%     im_dilated = imdilate(im_eroded, sc);
%     figure, imshow(im_dilated);
end
