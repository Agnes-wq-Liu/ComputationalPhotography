[im,map]= imread('raccoon.jpg');
im = rgb2gray(im);
figure,imshow(im);
h_cnt = 600;
[y,x] = size(im);
C = zeros(y,x,3);
% CU = I(i-1,j)-I(i+1,j)+{I(i,j-1)-I(i+1,j)}
C(2:y-1,2:x-1,1)= abs(im(1:y-2,2:x-1)-im(3:y,2:x-1))+abs(im(2:y-1,1:x-2)-im(3:y,2:x-1));
% CL = I(i+1,j)-I(i-1,j)
C(2:y-1,2:x-1,2)= abs(im(3:y,2:x-1)-im(1:y-2,2:x-1));
% CD = I(i-1,j)-I(i+1,j)+{I(i,j-1)-I(i+1,j)}
C(2:y-1,2:x-1,3)= abs(im(1:y-2,2:x-1)-im(3:y,2:x-1))+abs(im(2:y-1,1:x-2)-im(3:y,2:x-1));
%M
M = zeros(y,x);
for j=2:x
    for i=2:y-1
        M(i,j) = min([(M(i-1,j-1)+C(i,j,1)),(M(i,j-1)+C(i,j,2)),(M(i+1,j-1)+C(i,j,3))]);
    end
    M(1,j) = min([(M(i,j-1)+C(i,j,2)),(M(i+1,j-1)+C(i,j,3))]);
    M(y,j) = min([(M(i-1,j-1)+C(i,j,1)),(M(i,j-1)+C(i,j,2))]);
end
% remove horizontal seams from smallest M(:,x)
for k = 1:h_cnt
    [value,i] = min(M(:,x));
    M(i,x)=nan;
    for jj =x-1:-1:1
        if(i==1)
            [v,ind] = min([M(1,jj),M(2,jj)]);
            i = ind;
        elseif (i==y)
            [v,ind] = min([M(y-1,jj),M(y,jj)]);
            i = ind+(y-2);
        else
            [v,ind] = min([M(i-1,jj),M(i,jj),M(i+1,jj)]);
            i = i-2+ind;
        end
         M(i,jj)=nan;
        im(i,jj)=nan; 
    end 
end
im(isnan(im))=[];
figure, imshow(im);
