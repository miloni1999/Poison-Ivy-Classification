function print_mat( mat_to_print, fp, mat_name, n_decimal_pts )
% print_mat( mat_to_print, file_pointer, mat_name, n_decimal_pts )
%
% Print out a 2D matrix, in matlab notation, so that it can be pulled in again later by another routine.
% Writes to the file pointed to by 'fp', which might be 1 for stdout.
%
% T. Kinsman   April 11, 2009
%
% Modified to get maginitude of largest value, so that all the values
% will line up when printed.  - May 8, 2010
% 

    if ( nargin < 4)
        n_decimal_pts = 5;
    end
    if ( nargin < 3)
        mat_name    = 'matlab_matrix';
    end
    if ( nargin < 2)
        fp          = 1;
    end

    matrix_wo_Inf_and_wo_Nan                        = mat_to_print;
    matrix_wo_Inf_and_wo_Nan( isnan(mat_to_print) ) = 0;
    matrix_wo_Inf_and_wo_Nan( isinf(mat_to_print) ) = 0;
    
    [~,maxi] = max(abs(matrix_wo_Inf_and_wo_Nan(:)));
    maxv     = matrix_wo_Inf_and_wo_Nan(maxi);
    n_digits = ceil( log(maxv)/log(10) );   % ceil( log10( ) )
    if ( maxv < 0 )
        n_digits = n_digits + 1;
    end
    
    % Add to the number of decimal digits, the number of decimal points,
    % plus one for the decimal point itself.
    n_digits = n_digits + n_decimal_pts + 2;
    
    % If any of the digits are negative, add another place for a minus sign:
    if ( length( find( mat_to_print(:) < 0 ) > 0 ) )
        n_digits = n_digits + 1;
    end

    
    [m n]=size(mat_to_print);
    fprintf(fp,'\n\n%% mat_to_print =\n%s = [ ...\n', mat_name );
    for i=1:m
        fprintf(fp,'  ');
        for j=1:n
            value = mat_to_print(i,j);
            if isinf(value)
                fprintf(fp, ' %*s', n_digits, 'Inf');
            elseif isnan(value) 
                fprintf(fp, ' %*s', n_digits, 'Nan');
            else
                fprintf(fp, ' %*.*f', n_digits, n_decimal_pts, value);
            end
        end
        fprintf(fp,' ;\n');
    end
    fprintf(fp,'];\n\n');

end

