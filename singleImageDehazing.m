[im,map]= imread('boat.jpg');
[y,x,z] = size(im);
figure,imshow(im);
% first operation of linear transformation
R = Linear(im);
figure,imshow(R);
% second operation of high-boost filtering
J = HighBoost(im,3,0.08);
figure,imshow(J);
% combination of R and J 
D = zeros(y,x,3);
D(:,:,1) = 0.7.*R(:,:,1)+0.3.*J(:,:,1);
D(:,:,2) = 0.7.*R(:,:,2)+0.3.*J(:,:,2);
D(:,:,3) = 0.7.*R(:,:,3)+0.3.*J(:,:,3);
figure, imshow(D);
% white balance??
function R=Linear(im2)
    im = im2double(im2);
    [y,x,z] = size(im);
    R = zeros(y,x,z);
    mi = min(im,[],"all");
    Mi = max(im,[],"all");
    for j = 1:y
        for i = 1:x
            R(j,i,1) = (im(j,i,1)-mi)/(Mi-mi);
            R(j,i,2) = (im(j,i,2)-mi)/(Mi-mi);
            R(j,i,3) = (im(j,i,3)-mi)/(Mi-mi);
        end
    end
end
function J = HighBoost(im1,wdim,eps)
    im2 = im2double(im1);
    im  = padarray(im2,[wdim-1 wdim-1],0,'both');
    [y,x,z] = size(im2);
    J = zeros(y,x,z);
    % define window size (must be odd)
    mu = fspecial("average",wdim);
    mean=imfilter(im,mu);
    std = stdfilt(im,true(wdim));
    a = std./(std+eps);
    [j,i,z] = size(a);
    onemat = double(ones(j,i,z));
    b = (onemat-a).*mean;
%     find window near each pixel
    for j =2:y
        for i=2:x
           [card,s]=compute(uint8(j),uint8(i),uint8(wdim),a,b,im);
         J(j,i,1) = 1/card*s(1);
         J(j,i,2) = 1/card*s(2);
         J(j,i,3) = 1/card*s(3);
%            disp(size(s));
%            J(j,i,:) = 1/card*s(:);
        end
    end 
end
function [card,s]=compute(j,i,wdim,a,b,im)
    card=0;
    ak=zeros(3);
    bk=zeros(3);
    s = zeros(3);
    mid = ceil(wdim/2);
    for jj = 1:wdim
       for ii=1:wdim
           y=j-(mid-jj);
           x=i-(mid-ii);
           ak(1)=ak(1)+a(uint8(y),uint8(x),1)*im(uint8(j),uint8(i),1);
           ak(2)=ak(2)+a(uint8(y),uint8(x),2)*im(uint8(j),uint8(i),2);
           ak(3)=ak(3)+a(uint8(y),uint8(x),3)*im(uint8(j),uint8(i),3);
%            ak(:)=ak(:)+a(uint8(y),uint8(x),:).*im(uint8(j),uint8(i),:);
           bk(1)=bk(1)+b(uint8(y),uint8(x),1);
           bk(2)=bk(2)+b(uint8(y),uint8(x),2);
           bk(3)=bk(3)+b(uint8(y),uint8(x),3);
%            bk(:)=bk(:)+b(uint8(y),uint8(x),:);
           card=card+1;
       end
    end
    s(1) = ak(1)+bk(1);
%     disp(size(s(1)));
    s(2) = ak(2)+bk(2);
%     disp(size(s(2)));
    s(3) = ak(3)+bk(3);
%     disp(size(s(3)));
end