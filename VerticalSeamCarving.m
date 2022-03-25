[im,map]= imread('raccoon.jpg');
im = rgb2gray(im);
% disp(sum(im(im(:)==0)));
figure,imshow(im);
v_cnt = 20;
[y,x] = size(im);
C = zeros(y,x,3);
% C(:,1:2:3) = CL:CU:CR
C(2:y-1,2:x-1,1)= abs(im(2:y-1,3:x)-im(2:y-1,1:x-2))+abs(im(1:y-2,2:x-1)-im(2:y-1,1:x-2));
C(2:y-1,2:x-1,2)= abs(im(2:y-1,3:x)-im(2:y-1,1:x-2));
C(2:y-1,2:x-1,3)= abs(im(2:y-1,3:x)-im(2:y-1,1:x-2))+abs(im(1:y-2,2:x-1)-im(2:y-1,3:x));
%M
M = zeros(y,x);
for i=2:y
    for j=2:x-1
        M(i,j) = min([(M(i-1,j-1)+C(i,j,1)),(M(i-1,j)+C(i,j,2)),(M(i-1,j+1)+C(i,j,3))]);
    end
    M(i,1) = min([(M(i-1,j)+C(i,j,2)),(M(i-1,j+1)+C(i,j,3))]);
    M(i,x) = min([(M(i-1,j-1)+C(i,j,1)),(M(i-1,j)+C(i,j,2))]);
end
a = zeros(y,x-v_cnt);
%remove vertical seams from smallest M(y,:)
vseams = zeros(y,v_cnt);
for k = 1:v_cnt
    [value,j] = min(M(y,:));
    M(y,j)=nan;
    vseams(y,k)=j;
    for ii =y-1:-1:1
        if(j==1)
            [v,ind] = min([M(ii,1),M(ii,2)]);
            j = ind;
        elseif (j==x)
            [v,ind] = min([M(ii,x-1),M(ii,x)]);
            j = ind+(x-2);
        else
            [v,ind] = min([M(ii,j-1),M(ii,j),M(ii,j+1)]);
            j = j-2+ind;
        end            
        vseams(ii,k)=j;
        M(ii,j)=nan;
        im(ii,j)=nan;
    end

end
figure, imshow(im);

