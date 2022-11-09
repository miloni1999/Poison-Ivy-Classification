function CHKPT_04()
    chpt4_isolate_poison_ivy();
end

function b_is_fg = chpt4_FIND_poison_ivy(img,rect)
    cropped = imcrop(img,rect);
    % fprintf("Click on 16 maple leaf pixels\n");
    h=imshow(cropped);
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
    h=imshow(cropped);
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
    
    [r,c,channels] = size(cropped);
    new_rows = r*c;
    Y = reshape(cropped,[new_rows,channels]);
    
    distance_poison_ivy = mahal(Y,fg_pixelvalues);
    distance_bg = mahal(Y,bg_pixelvalues);
    
    b_is_fg = distance_poison_ivy < distance_bg;
    b_is_fg = reshape( b_is_fg, r, c );
    % disp(fg_pixelvalues);
    % disp(bg_pixelvalues);
    end
    
    function chpt4_isolate_poison_ivy()
    I = rgb2lab(im2double( imread("IMAGES/IMG_3141.JPG")));
    % figure, imshow(I);
    % title("original image");
    % im_r = I(:,:,1);
    im_g = I(:,:,2);
    % im_b = I(:,:,3);
    
    figure, subplot(2,2,1), imshow(im_g);
    title("L*a*b colorspace a channel");
    f_sobel_dIdy    = [ -1 -2 -1 ; 
                         0  0  0 ; 
                        +1 +2 +1 ] /8;
    
    f_sobel_dIdx    = f_sobel_dIdy.';
        
    dIdy            = imfilter( im_g, f_sobel_dIdy, 'same', 'repl' );
    dIdx            = imfilter( im_g, f_sobel_dIdx, 'same', 'repl' );
    dImag           = sqrt( dIdy.^2  + dIdx.^2 );
    
    
    % dIangle         = atan2( -dIdy, dIdx ) * 180 / pi;
    histogram_bin_edges = 0:0.001:0.500;
    [freq,bins] = histcounts( dImag(:), histogram_bin_edges );
    tmp_sum = cumsum(freq);
    norm = tmp_sum ./ tmp_sum(end);
    idx = find(norm>0.90,1,'first');
    cut_off_val = histogram_bin_edges(idx);
    disp(cut_off_val);
    
    
    rect = 1.0e+03 *[1.0195    0.535    3.9340    3.1780];
    [dImag_cropped] = imcrop(dImag,rect);
    
    % figure, imagesc(dImag_cropped);
    % colormap("gray");
    % title("cropped image");
    
    img1 = dImag_cropped>cut_off_val;
    img1 = ~img1;
    subplot(2,2,2),imshow(img1);
    title("after determining edge strengths");
    imwrite(img1,'img1.png');
    
    poison_ivy_fg = chpt4_FIND_poison_ivy(I,rect);
    % figure,imshow(poison_ivy_fg);
    % imwrite(poison_ivy_fg,'img2.png');
    % 
    [row,col] = size(img1); 
    output_img = ones(row,col);
    % disp(size(output_img));
    for r = 1:row    
        for c = 1:col 
            if img1(r,c) == poison_ivy_fg(r,c)
                output_img(r,c) = img1(r,c);
            end
        end
    end
    subplot(2,2,3),imshow(output_img);
    title("shape of the leaves");
    imwrite(output_img,'before_closing.png');
    
    st = strel('disk',4);
    closed = imclose(output_img,st);
    subplot(2,2,4),imshow(closed);
    title("final shape of the leaves");
    imwrite(closed,'after_closing.png');

end