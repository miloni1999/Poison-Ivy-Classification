image = im2double(imread("IMAGES/IMG_3127.JPG"));
% Resizing Image
image_resize = imresize(image, 0.25);
figure
imshow(image_resize);

weight = 1/2500;
clusters = 15;
dimensions = size(image_resize);
[xs, ys] = meshgrid(1:dimensions(2), 1:dimensions(1));

% Smoothig filter:
my_filter = fspecial('gaussian', [10 10], 0.75);
smooth_image = imfilter( image_resize, my_filter, 'same', 'repl');
% smooth_image = medfilt2(image_resize, [7 7]);
% smooth_image(:,:,1)   = medfilt2( smooth_image(:,:,1), [7 7] );
% smooth_image(:,:,2)   = medfilt2( smooth_image(:,:,2), [7 7] );
% smooth_image(:,:,3)   = medfilt2( smooth_image(:,:,3), [7 7] );


figure,imshow(smooth_image);
% imwrite(smooth_image, "leaf.png");


% Getting each channels of smoothed image
red = smooth_image(:, :, 1);
green = smooth_image(:, :, 2);
blue = smooth_image(:, :, 3);


% applying kmeans for clustering
attribute = [xs(:)*weight, ys(:)*weight, red(:) , green(:), blue(:)];
[label, colorMap] = kmeans(attribute, clusters);
label = reshape(label, dimensions(1), dimensions(2));
final_image = label2rgb(label, colorMap(:, 3:end));

% Getting edges of the image:
edges_image_red = edge(final_image(:,:,1), 'canny', [0, 0.25], 2);
edges_image_green = edge(final_image(:,:,2), 'canny', [0, 0.25], 2);
edges_image_blue = edge(final_image(:,:,3), 'canny', [0, 0.25], 2);
edges_image = edges_image_red + edges_image_green + edges_image_blue;

% canny edge detection on grayscale image:
edges_image = edge(rgb2gray(final_image), 'canny', [0, 0.25], 2);
figure
imshow(im2double(edges_image));


% Subtracting edges from image
final_image = im2double(final_image) - edges_image;
figure
imshow(final_image);

% Writing the final image
imwrite(final_image, "leaf.png");
