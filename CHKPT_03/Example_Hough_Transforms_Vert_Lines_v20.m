
function Example_Hough_Transforms_Vert_Lines_v20( )
FS = 24;
N_LINES_TO_FIND                     = 100;

SHOW_EDGE_COMPONENTS                = true;
SHOW_HISTOGRAM_OF_EDGE_MAGNITUDES   = false;
SHOW_EDGE_ANGLES                    = false;
SHOW_HOUGH_PEAKS                    = false;

%     workspace();        % What does this do?
    
%     im      = im2double( imread( 'Images\IMG_3134.JPG' ) );
    im      = im2double( imread( 'leaf.png' ) );
    im_g    = im( :, :, 2 );
    
    im_g    = imfilter( im_g, fspecial('Gauss', 9, 0.9), 'same', 'repl' );
    
%     im_g    = im_g( 2:2:end, 2:2:end );s
    im_g    = imrotate( im_g, 90 );
    
    figure,imshow(im_g);
    %
    %  DO NOT DO THIS!!  (Why not?)
    %
    %     im_edges = edge( im_g, 'Canny', [0.08 0.1] );
    
    %
    %  Instead do this:  (Why?)
    %
    f_sobel_dIdy    = [ -1 -2 -1 ; 
                         0  0  0 ; 
                        +1 +2 +1 ] /8;
    f_sobel_dIdx    = f_sobel_dIdy.';
    
    dIdy            = imfilter( im_g, f_sobel_dIdy, 'same', 'repl' );
    dIdx            = imfilter( im_g, f_sobel_dIdx, 'same', 'repl' );
    dImag           = sqrt( dIdy.^2  + dIdx.^2 );
%     dImag = ( dIdy.^2  + dIdx.^2 );
    

    % Visualize what you have done:
    if ( SHOW_EDGE_COMPONENTS )
%         zoom_figure( [1800 1200] );     % or figure('Position', [10 10 1800 1400] );
        figure('Position', [10 10 1800 1400] );
        subplot( 1, 2, 1 );
        imagesc( im_g ); colormap( gray ); axis image; title('Imput Image', 'FontSize', FS );

%         subplot( 2, 2, 2 );
%         imagesc( dIdy ); colormap( gray ); axis image;  title('dIdy', 'FontSize', FS );
% 
%         subplot( 2, 2, 3 );
%         imagesc( dIdx ); colormap( gray ); axis image; title('dIdx', 'FontSize', FS );

        subplot( 1, 2, 2 );
        imagesc( dImag ); 
        colormap( gray ); 
        axis image;
        title('Edge Magnitude', 'FontSize', FS );
        colorbar;
        pause(2);
    end
    
    %
    % A histogram of the edge magnitudes:
    %
    if ( SHOW_HISTOGRAM_OF_EDGE_MAGNITUDES )
        histogram_bin_edges = [0:0.001:0.100];
        [freq,bins] = histc( dImag(:), histogram_bin_edges );
%         zoom_figure( [1800 1200]  );     % or whatever
        bar( histogram_bin_edges, freq );
        title( 'Edge Strength Bar Graph -- What does this mean?', 'FontSize', FS );
        pause(2);
    end
    
    
    %
    % Visualize Angles:
    %
    % You should look at this so see that the angles come in pairs.
    %
    dIangle         = atan2( -dIdy, dIdx ) * 180 / pi;
    if ( SHOW_EDGE_ANGLES )
%         zoom_figure( [1800 1200]  );     % or whatever

        figure,imagesc( dIangle );
        axis image;
        colormap( hsv(256) );
        colorbar;
        title( 'Edge Direction', 'FontSize', FS );
        pause(2);
    end

    warning('Remember that the image has been rotated by 90 degrees.');
    %
    %  Find strong HORIZONTAL gradients --> vertical edges.
    %  Here we ignore negative edges, to avoid getting two 
    %  lines next to each other.
    %
    %  Notice that the single '&' operator is used for vector operations.
    %
    im_edges_vert     = ( dIdx         > 0.10 ) & ...
                        ( abs(dIangle) <= 85 );
           
    %
    %  What is this, and what is it for?
    %
    weird_region = [ 1 1 1 1 1 ;
                     0 1 1 1 0 ; 
                     0 1 1 1 0 ;
                     0 0 1 0 0 ;
                     0 1 1 1 0 ; 
                     0 1 1 1 0 ;
                     1 1 1 1 1 ];
    num_ones            = sum( weird_region(:) );
    im_cleaned_vert = ordfilt2( im_edges_vert, num_ones-size(weird_region,1)-1, weird_region );
    
%     zoom_figure( [1800 1200] );
    figure,imagesc( im_cleaned_vert );
    colormap(gray);
    
    angles = -89:5:89;
    [HoughSpace,Thetas,Rhos] = hough( im_cleaned_vert, ...
                                      'RhoResolution',  50, ...
                                      'Theta',          angles );
    peaks = houghpeaks( HoughSpace, N_LINES_TO_FIND, ...
                        'NHoodSize', [3 3], ...
                        'Theta', Thetas);
    if SHOW_HOUGH_PEAKS
%         zoom_figure([1800 1400] );
        figure,imagesc( HoughSpace );
        xticks = get(gca,'XTick');
        set(gca,'XTickLabels',      Thetas(xticks)    );
        yticks = get(gca,'YTick');
        set(gca,'YTickLabels',      Rhos(yticks)    );
        xlabel('Angle (Degrees),    \Theta', 'FontSize', FS   );
        ylabel('Distance (Pixels), \rho',   'FontSize', FS   );
        set(gca,'FontSize', FS-4);
        hold on;
        plot( peaks(:,2), peaks(:,1),'ko', ...
                       'MarkerSize', 30, ...
                       'LineWidth', 2);
        colorbar();
    end

    % lines = houghlines( im_edges_vertical, Thetas, Rhos, peaks, 'FillGap', 10, 'MinLength', 40 );
    
    lines = houghlines( im_cleaned_vert, Thetas, Rhos, peaks, 'MinLength', 30 );
    disp(length(lines));
    
    hold on;
    for line_idx = 1 : min( [N_LINES_TO_FIND, length(lines)] )
        p1 = lines(line_idx).point1;
        p2 = lines(line_idx).point2;
        hold on;
        title("Plot final");
        plot( [p1(1), p2(1)], [p1(2), p2(2)], 'r-', 'LineWidth', 3 );
    end
    
end
