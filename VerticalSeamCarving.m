image= imread('raccoon.png');
figure,imshow(image);
v_cnt = 600;
h_cnt = 400;
image = SeamCarving(image,v_cnt);
image = Rotation(image);
newimage = SeamCarving(image(:,800:1800,:),h_cnt);
im = cat(2,image(:,1:800,:),newimage);
im = cat(2,im,image(:,1800:end,:));
newimage = SeamCarving(im(:,2100:end,:),200);
im = cat(2,im(:,1:2100,:),newimage);
im = Rotation(im);
figure, imshow(im);
function rotated = Rotation(image)
    rotated(:,:,1) = image(:,:,1)';
    rotated(:,:,2) = image(:,:,2)';
    rotated(:,:,3) = image(:,:,3)';
end
function image = SeamCarving(image,v_cnt)
    im = rgb2gray(image);
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
        vseams = zeros(y,1);
        vseams(y,1)=j;
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
            vseams(ii,1)=j;
        end
        image2 = image(:,1:end-1,:);
        M2 = M(:,1:end-1);
        for i=1:y
            image2(i,vseams(i):end,:) = image(i,vseams(i)+1:end,:);
            M2(i,vseams(i):end) = M(i,vseams(i)+1:end);
        end
        image = image2;
        M = M2;
        [y,x] = size(M);
    end 
end