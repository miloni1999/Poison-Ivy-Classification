function Preprocessing(image)
    im_in = imread(image);
    figure, imshow(im_in);
    im_resized = imresize(im_in, 0.25);
    figure, imshow(im_resized);
%     im_crop = imcrop(im_resized);
%     im_gray = im2gray(im2double(im_resized(:,:,2) - im_resized(:,:,1)));
    im_gray = im2gray(im2double(im_resized));
%     im_adjust = imadjust(im_gray);
%     figure, imshow(im_adjust);
    thresh = graythresh(im_gray);
    disp(thresh);
    im_binarize = imbinarize(im_gray, thresh + 0.06);
    figure, imshow(im_binarize);
    se = strel("disk", 16);
    im_binarize = imclose(im_binarize, se);
    se = strel('disk', 75);
    im_binarize = imopen(im_binarize, se);
    im_binarize = bwareaopen(im_binarize, 3900);
    figure, imshow(im_binarize);

end