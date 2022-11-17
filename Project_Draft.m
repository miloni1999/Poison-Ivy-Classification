
function Project_Draft()

    % read image
    im_rgb = im2double(imread("IMAGES/IMG_3127.JPG"));
%     figure, imshow(im_rgb), title("Original image");

%     disp(size(im_in));
    im_resized = imresize(im_rgb, [600, 900]);

    % crop image
    rect = [182.5100  118.5100  573.9800  445.9800];
    im_cropped = imcrop(im_resized, rect);

    % choosing the grayscale channel

    red = im_cropped(:,:,1);
    green = im_cropped(:,:,2);
    blue = im_cropped(:,:,3);

    figure, subplot(1,3,1), imshow(red), title("Red channel");
    subplot(1,3,2), imshow(green), title("Green channel");
    subplot(1,3,3), imshow(blue), title("Blue channel");

    im_hsv = rgb2hsv(im_cropped);
    hue = im_hsv(:,:,1);
    saturation = im_hsv(:,:,2);
    value = im_hsv(:,:,3);

    figure, subplot(1,3,1), imshow(hue), title("hue channel");
    subplot(1,3,2), imshow(saturation), title("saturation channel");
    subplot(1,3,3), imshow(value), title("value channel");

    im_lab = rgb2lab(im_cropped);
    l_channel = im_lab(:,:,1);
    a_channel = im_lab(:,:,2);
    b_channel = im_lab(:,:,3);

    figure, subplot(1,3,1), imagesc(l_channel), title("L channel");
    subplot(1,3,2), imagesc(a_channel), title("a* channel");
    subplot(1,3,3), imagesc(b_channel), title("b* channel");

    im_gray = a_channel;

    % Applying gaussian filter to smoothen the image

end