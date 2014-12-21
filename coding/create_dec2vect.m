function [ dec2vect ] = create_dec2vect( K )
%create_dec2vect:
%
%Input: 
%  K: input designating the largest number for which to return a vector.
%     This largest number will be 2^K - 1
%
%Output:
%  dec2vect: matrix that gives the binary vector representation for each 
%     decimal number from 0 up to 2^K - 1. Each row will give the vector
%     representation for that number, with K digits.
%     

dec2vect = zeros(2^K,K);
for a = 1:2^K
    for b = 1:K
        dec2vect(a,K-b+1) = bitget(a-1,b);
    end
end

end
