% specular removal inspired by Tan et al.
% Vsf = Vi(p)-minVi(p)
[im,map]= imread('figs.jpg');
im = im2double(im);
figure, imshow(im);
vmin = min(im,[],3);
figure,imshow(vmin);
% diffuse component Vsf
imr = im(:,:,1)-vmin;
img = im(:,:,2)-vmin;
imb = im(:,:,3)-vmin;
Vsf = cat(3,imr,img,imb);
figure, imshow(Vsf);


Tv = mean(Vsf,'all')+0.8*std(Vsf,0,'all');
disp(Tv);
% Tv = 0.9;
% tau = Tv if Vmin>Tv
% tau = Vmin o.w.
[y,x,z]=size(image);
tau = zeros(y,x);
for i=1:y
    for j=1:x
        if(vmin(i,j)>=Tv)
            tau(i,j) = Tv;
        else
            tau(i,j) = vmin(i,j);
        end
    end
end
% MSF = Vsf +tau
MSF = cat(3,Vsf(:,:,1) +tau,Vsf(:,:,2) +tau,Vsf(:,:,3) +tau);
figure,imshow(MSF);
% CMSF = V-k(Vmin-tau)
% calculate k first:
final = im-0.4*(vmin-tau);
figure,imshow(final);
