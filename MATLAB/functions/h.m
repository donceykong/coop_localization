function [y] = h(x)
%H Summary of this function goes here
%   Detailed explanation goes here
    y = zeros(5, 1);
    y(1, 1) = atan2(x(5) - x(2), x(4) - x(1)) - x(3); % +v(1) ;
    y(2, 1) = sqrt((x(1) - x(4))^2 + (x(2) - x(5))^2) ; % +v(2) ;
    y(3, 1) = atan2(x(2) - x(5), x(1) - x(4)) - x(6) ; % +v(3) ;
    y(4, 1) = x(4) ; % +v(4) ;
    y(5, 1) = x(5) ; % +v(5) ;
end

