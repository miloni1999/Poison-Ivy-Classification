function RUN_CLASSIFIER( )
%  This tests the use of the DecisionTree Classifiers to classify three different screw types.
%
%  "doc Classification Trees" for more information...
%
%  '20-Jul-2020'    Thomas B. Kinsman
%
BG_COLOR    = [ 0, 0, 0 ] ;     % Set to black for on-screen demos, white for PowerPoints
FS          = 28;
in_dir      = 'Images_cropped_Mix_of_3_b';  % Or whatever
out_dir     = 'Images_classified_T5';
vers        = get_fn_version( mfilename() );


    screw_classes  = 'ABC';

    %
    %  RELOAD THE TRAINED CLASSIFIER FROM A FILE:
    %
    load tree_classifier_634.mat tree_classifier; 


    %
    %  Load each mixture of screws, and classify them:
    %
    file_pattrn     = sprintf('%s%cim_mix_of_thr*.jpg', in_dir, filesep() );
    training_files  = dir( file_pattrn );
    
    %
    %  For Demo purposes, filter out most of the images.
    %
    b_to_keep       = false(size(training_files));
    for idx = 1 : length( training_files )
        if ( regexp( training_files(idx).name, 'b.jpg' ) )
            b_to_keep(idx) = true;
        end
    end
    training_files( ~b_to_keep ) = [];
    

    for idx = 1 : length( training_files )
        [~,bn,~] = fileparts( training_files(idx).name );
        fn_in = sprintf('%s%c%s', in_dir,  filesep(), training_files(idx).name );
        fn_ot = sprintf('%s%c%s%s%s', out_dir, filesep(), bn, vers, '.jpg' );

        %  From the image, we want to extract all of the regions, using the
        %  same noise cleaning methods used.
        % 
        %  We want to use bw_label, so that we can identify each piece of the image,
        %  and color it different colors: (red, green, blue)...
        %
        im_gray         = rgb2gray( imread( fn_in ) );

        %  Track regions in the image to keep:
	mminx =  size(im_gray,2);
        mminy =  size(im_gray,1);
        mmaxx =    1;
        mmaxy =    1;

        if ( idx == 1 )
            zoom_figure([1000,800]);
        else
            clf( );
        end
        imagesc( im_gray );
        colormap(gray);
        drawnow;
        
        %
        %  DO NOISE CLEANING ON THE IMAGE.
        %
        %  NOTE: Must be done exactly the same way as when the classifier was built.
        %
        %
        %  CHANGE ME: Flush out the skeleton code.
        %
        im_cleaned          = clean_image_SKELETON( im_gray );
        
        %
        %  BREAK THE IMAGE INTO SUB-IMAGES.
        %
        [im_rgs, n_rgs]     = bwlabel( im_cleaned );

        %  Make the Background BLACK for the printed document,
        %  and TO_SHOW_ON_THE_SCREEN.
        im_classified_red   = uint8( BG_COLOR(1) * ones( size(im_gray) ) );
        im_classified_grn   = uint8( BG_COLOR(2) * ones( size(im_gray) ) );
        im_classified_blu   = uint8( BG_COLOR(3) * ones( size(im_gray) ) );
        
        classes_this_image  = [ 0 0 0 0 ];
        
        
        %  Extract features from each region:
        for region_idx = 1 : n_rgs

            b_rgn           = im_rgs == region_idx;
            
            rgn_props       = regionprops( b_rgn );
            bb              = rgn_props.BoundingBox;
            xs              = [ floor(bb(1)-1)      ;
                                ceil(bb(1)+bb(3)+1) ];
            ys              = [ floor(bb(2)-1)      ;
                                ceil(bb(2)+bb(4)+1) ];
            sub_image       = uint8( b_rgn( ys(1):ys(2), xs(1):xs(2) ) );
            
            % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %
            %  EXTRACT FEATURES FROM THE IMAGE IN THE SAME WAY YOU DID 
            %  WHEN BUILDING THE CLASSIFIER.
            %
            %  NOTE: The imaging chain here MUST be the same.
            %
            % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            

            % 
            %  CHANGE ME:  ADD SKELETON FEATURE EXTRACTION CODE.
            %
            feat_sets       = get_features_SKELETON( sub_image );
            if ( size(feat_sets,1) <= 0 )
                pred_cls    = 4;   % This blob has no features.  It is cruft.
            else
                
                
                % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                %
                %  USE THE DECISION TREE CLASSIFIER.
                %
                % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                pred_cls    = tree_classifier.predict( feat_sets );
                
            end

            %  Track bounding box for entire image, 
            %  so that the result is not the size of the entire rotated image.
            mminx     = min( [ mminx xs(1) ] );
            mminy     = min( [ mminy ys(1) ] );
            
            mmaxx     = max( [ mmaxx xs(2) ] );
            mmaxy     = max( [ mmaxy ys(2) ] );
            
            
            %  Decorate the resulting classified image.
            %
            %  Must:
            %  1.  Extract the current classification of pixels.
            %  2.  Change only the pixels on the target.
            %  3.  Put the newly classified pixels back.
            %
            b_pixels_on_target_in_sub_image     = sub_image ~= 0;
            
            sub_regn_classified_red             = im_classified_red( ys(1):ys(2), xs(1):xs(2) );
            sub_regn_classified_grn             = im_classified_grn( ys(1):ys(2), xs(1):xs(2) );
            sub_regn_classified_blu             = im_classified_blu( ys(1):ys(2), xs(1):xs(2) );
            
            switch pred_cls 
                case 1
                    %  Make RED:
                    sub_regn_classified_red( b_pixels_on_target_in_sub_image )   = 255;
                    sub_regn_classified_grn( b_pixels_on_target_in_sub_image )   = 0;  
                    sub_regn_classified_blu( b_pixels_on_target_in_sub_image )   = 0;
                case 2
                    %  Make Green:
                    sub_regn_classified_red( b_pixels_on_target_in_sub_image )   = 0;
                    sub_regn_classified_grn( b_pixels_on_target_in_sub_image )   = 255;
                    sub_regn_classified_blu( b_pixels_on_target_in_sub_image )   = 0;
                case 3
                    %  Make Blue:
                    sub_regn_classified_red( b_pixels_on_target_in_sub_image )   = 0;
                    sub_regn_classified_grn( b_pixels_on_target_in_sub_image )   = 0;
                    sub_regn_classified_blu( b_pixels_on_target_in_sub_image )   = 255;
                otherwise
                    %  Make the dirt a darker magenta:
                    sub_regn_classified_red( b_pixels_on_target_in_sub_image  )   = 220;
                    sub_regn_classified_grn( b_pixels_on_target_in_sub_image  )   =   0;
                    sub_regn_classified_blu( b_pixels_on_target_in_sub_image  )   = 220;
            end

            % Put the pixels back into the classified image channels:
            im_classified_red( ys(1):ys(2), xs(1):xs(2) ) = sub_regn_classified_red;
            im_classified_grn( ys(1):ys(2), xs(1):xs(2) ) = sub_regn_classified_grn;
            im_classified_blu( ys(1):ys(2), xs(1):xs(2) ) = sub_regn_classified_blu;
            
            classes_this_image(pred_cls) = classes_this_image(pred_cls) + 1;
        end
        
        % Build the final combined RGB image:
        im_classified_RGB           = im_classified_red;
        im_classified_RGB(:,:,2)    = im_classified_grn; 
        im_classified_RGB(:,:,3)    = im_classified_blu; 

        % Crop out the region of interest, delete the boarders,
        % but leave a margin:
        mrgn                = 100;  
        im_classified_RGB   = im_classified_RGB( (mminy-mrgn):(mmaxy+mrgn), (mminx-mrgn):(mmaxx+mrgn), : ); 
         
        imagesc( im_classified_RGB );
        
        ttl             = fn_in;
        ttl(ttl=='_')   = ' ';
        title( ttl, 'FontSize', FS );
        
        imwrite( im_classified_RGB, fn_ot, 'JPEG', 'Quality', 98 );
        
        if ( idx == 1 )
            % Print the header:
            fprintf('%-50s,  ', '          ---   File Name   ---' );
            for cls_idx = 1 : 3
                fprintf('%2c,  ', screw_classes(cls_idx) );
            end
            fprintf('\n');
        end

        fn_in = sprintf('%s%c%s', in_dir, filesep(), training_files(idx).name );
        fprintf('%-50s,  ', fn_in );

        for cls_idx = 1 : length(classes_this_image)
            num_of_this_class = classes_this_image(cls_idx);
            fprintf('%2d,  ', num_of_this_class );
        end
        fprintf('Dirt\n');
        
        clear class_this_image;

        pause( 1 );
    end
end
