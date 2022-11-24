%{
CSCI - 631 Foundations of Computer Vision
Project - Poison Ivy

Authors:
Miloni Sangani, Rasika Sasturkar, Harshil Patel

This runs the classifier on validation data.
%}

function run_classifier( )
    in_dir_name  = 'TEST/*.JPG';
    in_dir = 'TEST';
    count_P = 0;
    count_NP = 0;
    testing_files = dir(in_dir_name);

    % load the tree classifier

    load tree_classifier_631.mat tree_classifier; 

    % running on test images

    for idx = 1 : length( testing_files )
        disp(testing_files(idx).name);
%         [~,bn,~] = fileparts( testing_files(idx).name );
        fn_in = sprintf('%s%c%s', in_dir,  filesep(), testing_files(idx).name );
        disp(fn_in);
        im_in = imread(fn_in);
        im_cleaned = clean_image( im_in );
        feats = get_features(im_cleaned);
        n_new = size( feats, 1 );
        if ( n_new <= 0 )
            pred_cls    = 3;   % This blob has no features.  It is cruft.
        else
            pred_cls    = tree_classifier.predict( feats );
        end
        
        final_predicted_class = mode(pred_cls);
        
        if final_predicted_class == 1
            count_P = count_P + 1;
        else
            count_NP = count_NP + 1;
        end
        
        disp("predicted:--------------------------------------------------------")
        disp(final_predicted_class);
     end
     
     disp("Number of Non Poison ivy leaves detected:")
     disp(count_NP);
     disp("Number of Poison ivy leaves detected:")
     disp(count_P);
end