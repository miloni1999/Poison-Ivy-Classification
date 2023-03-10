%{
CSCI - 631 Foundations of Computer Vision
Project - Poison Ivy

Authors:
Miloni Sangani, Rasika Sasturkar, Harshil Patel

This encapsulates the noise cleaning part of the imaging chain.
%}

function im_cleaned = clean_image( im_in )

    % read image

    im_rgb = im2double(im_in);

    % crop image

    rect = 1.0e+03 *[1.0795    0.2205    3.8820    3.4500];
    im_cropped = imcrop(im_rgb, rect);

    % grayscale image

    im_lab = rgb2lab(im_cropped);
    a_channel = im_lab(:,:,2);
    im_gray = a_channel;

    % applying sobel filter to find edge magnitudes

    fltr_sobel_dIdy = [ -1 -2 -1 ; 
                         0  0  0 ; 
                        +1 +2 +1 ] /8;
    
    fltr_sobel_dIdx = fltr_sobel_dIdy.';
        
    dIdy = imfilter(im_gray, fltr_sobel_dIdy, 'same', 'repl');
    dIdx = imfilter(im_gray, fltr_sobel_dIdx, 'same', 'repl');
    dImag = sqrt( dIdy.^2  + dIdx.^2 );

    % histogram analysis for egde magnitudes near the center leaves

    histogram_bin_edges = 0:0.001:0.500;
    [freq,bins] = histcounts( dImag(:), histogram_bin_edges );
    tmp_sum = cumsum(freq);
    norm = tmp_sum ./ tmp_sum(end);
    index = find(norm>0.90,1,'first');
    cut_off_value = histogram_bin_edges(index);

    im_strong_edges = dImag>cut_off_value;
    im_strong_edges = ~im_strong_edges;

    % find modal color

    modal_leaves = get_center_leaves(im_lab);
    [row,col] = size(im_strong_edges); 
    output_img = ones(row,col);
    for r = 1:row    
        for c = 1:col 
            if im_strong_edges(r,c) == modal_leaves(r,c)
                output_img(r,c) = im_strong_edges(r,c);
            end
        end
    end

    % morphology operations

    st = strel('disk',4);
    im_closed = imclose(output_img,st);

    % binarizing image

    im_unsigned = uint16(im_closed);
    thresh = graythresh(im_unsigned);
    im_cleaned = imbinarize(im_unsigned, thresh);
end

function center_leaves = get_center_leaves(img)
    h=image(img);
    im=imagemodel(h);
    fg_pixelvalues = [1     0     1;
         1     0     1;
         1     0     1;
         1     0     1;
         1     0     1;
         1     0     1;
         1     0     1;
         1     0     1;
         1     0     1;
         1     0     1;
         1     0     1;
         1     0     1;
         1     0     1;
         1     0     1;
         1     0     1;
         1     0     1];
    h=image(img);
    im=imagemodel(h);
    bg_pixelvalues = [1     0     1
         1     0     1;
         1     0     1;
         1     0     1;
         1     0     1;
         1     0     1;
         1     0     1;
         1     0     1;
         1     0     1;
         1     0     1;
         1     0     1;
         1     0     1;
         1     0     1;
         1     0     1;
         1     0     1;
         1     0     1];
    
    [r,c,channels] = size(img);
    new_rows = r*c;
    Y = reshape(img,[new_rows,channels]);
    
    distance_fg = mahal(Y,fg_pixelvalues);
    distance_bg = mahal(Y,bg_pixelvalues);
    
    center_leaves = distance_fg < distance_bg;
    center_leaves = reshape( center_leaves, r, c );
end