function CHKPT_02()
    im_in = imread("IMAGES/IMG_3127.JPG");
    figure, imshow(im_in);
    disp(size(im_in));
    im_resized = imresize(im_in, [600, 900]);
    figure, imshow(im_resized);
    im_crop = imcrop(im_resized);
%     imshow(im_crop);
    im_lab = rgb2lab(im_crop);
    a_channel = im_lab(:,:,2);
    figure, imagesc(a_channel);

    thresh = graythresh(a_channel);
    im_binarized = imbinarize(a_channel, thresh);
    im_binarized = ~(im_binarized);
    figure, imshow(im_binarized);
%     figure, histogram(a_channel);
%     mask = a_channel>-2.5 & a_channel<0.5;
%     a_new = (~mask) == 1;
%     figure, imshow(a_new);
%     im_gray = im2gray(im2double(im_resized(:,:,2) - im_resized(:,:,1)));
%     im_gray = im2gray(im2double(im_resized));
% %     im_adjust = imadjust(im_gray);
% %     figure, imshow(im_adjust);
%     thresh = graythresh(im_gray);
%     disp(thresh);
%     im_binarize = imbinarize(im_gray, thresh + 0.06);
%     figure, imshow(im_binarize);
%     se = strel("disk", 16);
%     im_binarize = imclose(im_binarize, se);
%     se = strel('disk', 75);
%     im_binarize = imopen(im_binarize, se);
%     im_binarize = bwareaopen(im_binarize, 3900);
%     figure, imshow(im_binarize);

end