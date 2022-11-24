%{
CSCI - 631 Foundations of Computer Vision
Project - Poison Ivy

Authors:
Miloni Sangani, Rasika Sasturkar, Harshil Patel

This finds features for each region of the cleaned image.
%}

function feature_mat = get_features(im_cleaned)

    feature_tbl = regionprops( 'table', im_cleaned, 'Area', ...
        'MajorAxisLength', 'MinorAxisLength','ConvexArea' );  

    b_too_small = feature_tbl.Area <= 5000;
    feature_tbl(b_too_small,:)      = [];

    if ( size(feature_tbl,1) == 0 )
        %  THIS IS DIRT:
        %  warning('No Valid features returned');
        feature_mat = [];
    else 
        %  Convert table to a matrix:
        for row = 1 : size( feature_tbl, 1 )
            feature_mat(row,1) = feature_tbl{row,1};
            feature_mat(row,2) = feature_tbl{row,2};
            feature_mat(row,3) = feature_tbl{row,3};
            feature_mat(row,4) = feature_tbl{row,4}/feature_tbl{row,1};
        end
    end
end

