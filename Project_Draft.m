
function Project_Draft()

    % read image

    im_rgb = im2double(imread("POISON/IMG_3149_P.JPG"));
    figure, imshow(im_rgb), title("Original image");

%     im_rgb = round(im_rgb * 16) / 16;
%     figure, imshow(im_rgb), title("after noise removal");

%     disp(size(im_rgb));

%     im_resized = imresize(im_rgb, 0.25);
%     figure, imshow(im_resized), title("Resized image");

    % crop image

%     rect = [160.5100   34.5100  593.9800  550.9800];
%     im_cropped = imcrop(im_rgb, rect);
%     [im_cropped, rect] = imcrop(im_rgb);
%     disp(rect);
%     rect = 1.0e+03 *[1.3555    0.6945    3.5820    3.0180];
    rect = 1.0e+03 *[1.0795    0.2205    3.8820    3.4500];
%     rect = 1.0e+03 *[1.0795    0.6945    3.7820    3.2500];
    im_cropped = imcrop(im_rgb, rect);
    figure, imshow(im_cropped), title("cropped image");

    % sharpening the image

%     im_sharpened = imsharpen(im_cropped);
% %     figure, subplot(1,2,1), imshow(im_sharpened), title("using imsharpen");
%     im_sharpened = imsharpen(im_cropped,'Radius',2,'Amount',1);
%     figure, imshow(im_sharpened), title("using imsharpen and parameters");

    im_lab = rgb2lab(im_cropped);
    a_channel = im_lab(:,:,2);
    im_gray = a_channel;
    figure, imagesc(im_gray), title("a- grayscale image");

    % applying sobel filter to find edge magnitudes

    fltr_sobel_dIdy = [ -1 -2 -1 ; 
                         0  0  0 ; 
                        +1 +2 +1 ] /8;
    
    fltr_sobel_dIdx = fltr_sobel_dIdy.';
        
    dIdy = imfilter(im_gray, fltr_sobel_dIdy, 'same', 'repl');
    dIdx = imfilter(im_gray, fltr_sobel_dIdx, 'same', 'repl');
    dImag = sqrt( dIdy.^2  + dIdx.^2 );
    figure, imshow(dImag), title("dImag");

    % histogram analysis for egde magnitudes near the center leaves

%     mag_min = min(dImag, [], 'all');
%     mag_max = max(dImag, [], 'all');
%     histogram_bin_edges = mag_min:0.001:mag_max;
    histogram_bin_edges = 0:0.001:0.500;

    [freq,bins] = histcounts( dImag(:), histogram_bin_edges );
    tmp_sum = cumsum(freq);
    norm = tmp_sum ./ tmp_sum(end);
    index = find(norm>0.90,1,'first');
    cut_off_value = histogram_bin_edges(index);
%     disp(cut_off_value);
% 
%     rect = 1.0e+03 *[1.0195    0.535    3.9340    3.1780];
%     im_cropped = imcrop(dImag, rect);
% %     figure, imshow(im_cropped), title("cropped image");
% 
    im_strong_edges = dImag>cut_off_value;
    im_strong_edges = ~im_strong_edges;

    figure, imshow(im_strong_edges), title("after determining edge strength");

    poison_ivy_fg = chpt4_FIND_poison_ivy(im_lab);
    [row,col] = size(im_strong_edges); 
    output_img = ones(row,col);
    % disp(size(output_img));
    for r = 1:row    
        for c = 1:col 
            if im_strong_edges(r,c) == poison_ivy_fg(r,c)
                output_img(r,c) = im_strong_edges(r,c);
            end
        end
    end
    figure, imshow(output_img), title("after getting shape of the leaves");
%     imwrite(output_img,'before_closing.png');
    
    st = strel('disk',4);
    closed = imclose(output_img,st);
    figure, imshow(closed), title("final shape of the leaves");

%     im_unsigned = uint16(output_img);
% 
%     thresh = graythresh(im_unsigned);
%     im_binarized = imbinarize(im_unsigned, thresh);
% %     im_binarized = ~im_binarized;
%     figure, imshow(im_binarized);

%     imwrite(im_binarized, "IMG_3158.jpg");
% 
%     % perform morphology
% 
% %     st = strel('square',3);
% %     im_closed = imclose(im_strong_edges, st);
% %     figure, imshow(im_closed), title("final shape of the leaves");

end


function b_is_fg = chpt4_FIND_poison_ivy(img)
%     cropped = imcrop(img,rect);
    % fprintf("Click on 16 maple leaf pixels\n");
    h=imshow(img);
    % [x,y] = ginput(16);
    % row = round(y);
    % col = round(x);
    im=imagemodel(h);
    % fg_pixelvalues = getPixelValue(im,row,col);
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
    h=imshow(img);
    % [x_bg,y_bg] = ginput(16);
    % row_bg = round(y_bg);
    % col_bg = round(x_bg);
    im=imagemodel(h);
    % bg_pixelvalues = getPixelValue(im,row_bg,col_bg);
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
    
    distance_poison_ivy = mahal(Y,fg_pixelvalues);
    distance_bg = mahal(Y,bg_pixelvalues);
    
    b_is_fg = distance_poison_ivy < distance_bg;
    b_is_fg = reshape( b_is_fg, r, c );
    % disp(fg_pixelvalues);
    % disp(bg_pixelvalues);
end
