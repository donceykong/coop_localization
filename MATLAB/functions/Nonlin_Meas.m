function [y_nom] = Nonlin_Meas(x,v)
%NONLIN_MEAS Summary of this function goes here
% Calculate all Meaurements
y = zeros(6,1001);

column = 1;
for t = 1:1001
    y(1, column) = atan2(x(5, column) - x(2, column), x(4, column) - x(1, column)) - x(3, column)+v(1) ;
    y(2, column) = sqrt((x(1, column) - x(4, column))^2 + (x(2, column) - x(5, column))^2)+v(2) ;
    y(3, column) = atan2(x(2, column) - x(5, column), x(1, column) - x(4, column)) - x(6, column)+v(3) ;
    y(4, column) = x(4, column)+v(4) ;
    y(5, column) = x(5, column)+v(5) ;

    column = column + 1;
end
y_nom = y(1:5,:) ;
end

