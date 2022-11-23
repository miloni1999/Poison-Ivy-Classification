function feature_mat = get_features(im_cleaned)
% Given a grayscale image, which has been cleaned, find features for each region:

    %  Note that you want to be careful about which features you use here.
    %  For example, putting in the Center of Mass would be worthless,
    %  because it returns an (X,Y) location.  That is worthless
    %  unless you are comparing it to something like the Convex Hull...
    %  which is problematic.
    %
    %
    %  YOU MAY ADD OTHER FEATURES HERE:
    %
    feature_tbl = regionprops( 'table', im_cleaned, 'Area', 'MajorAxisLength', 'MinorAxisLength','ConvexArea' );  

    %  Explicitly toss out small DIRT particles:
    % You should change this.  CHANGE ME!!
    b_too_small                     = feature_tbl.Area <= 5000;  % 50^2 pixels.  
    
    feature_tbl(b_too_small,:)      = [];
    disp("Feature Table after tossing out dirt components");
    disp(feature_tbl);

    if ( size(feature_tbl,1) == 0 )
        %  THIS IS DIRT:
        %  warning('No Valid features returned');
        feature_mat = [];
    else 
        % 
        %  Convert table to a matrix:
        %
        for row = 1 : size( feature_tbl, 1 )
            feature_mat(row,1) = feature_tbl{row,1};
            feature_mat(row,2) = feature_tbl{row,2};
            feature_mat(row,3) = feature_tbl{row,3};
            feature_mat(row,4) = feature_tbl{row,4}/feature_tbl{row,1};
             
        end
        disp("Feature matrix:")
        disp(feature_mat);
    end
end

