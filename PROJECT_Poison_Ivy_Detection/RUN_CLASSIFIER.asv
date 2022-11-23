function RUN_CLASSIFIER( )
in_dir_name  = 'TEST/*.JPG';  % Or whatever
in_dir = 'TEST';
% out_dir     = 'Images_classified';
% vers        = get_fn_version( mfilename() );
count_P = 0;
count_NP = 0;


%     leaf_classes  = 'PN';
    load tree_classifier_634.mat tree_classifier; 

    training_files = dir(in_dir_name);
     for idx = 1 : length( training_files )
        disp(training_files(idx).name);
        [~,bn,~] = fileparts( training_files(idx).name );
        fn_in = sprintf('%s%c%s', in_dir,  filesep(), training_files(idx).name );
        disp(fn_in);
        fn_ot = sprintf('%s%c%s%s', out_dir, filesep(), bn,'.jpg' );
        
        im_in     = imread( fn_in );
%         im_cleaned          = clean_image_vSKELETON( im_in );
        feats       = get_features_SKELETON( clean_image_vSKELETON( im_in ) );
        n_new       = size( feats, 1 );
        if ( n_new <= 0 )
            pred_cls    = 3;   % This blob has no features.  It is cruft.
        else
            pred_cls    = tree_classifier.predict( feats );
            
        end
        final_predicted = mode(pred_cls);
        if final_predicted == 1
            count_P = count_P + 1;
        else
            count_NP = count_NP + 1;
        end
        
        disp("predicted:--------------------------------------------------------")
        disp(final_predicted);
     end
     disp(count_NP);
     disp(count_P);
end