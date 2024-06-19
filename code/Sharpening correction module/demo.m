
Input_path = '.\image\';  
Output_path='.\result\';
namelist = dir(strcat(Input_path,'*.jpg'));  %获得文件夹下所有的 .jpg图片
len = length(namelist);
tic;

for i = 1:len
    imageName=namelist(i).name;  %namelist(i).name; %这里获得的只是该路径下的文件名
    %% loading our model
    load(fullfile('model.mat'));
    %% reading image
    I=im2double(imread(strcat(Input_path, imageName))); %图片完整的路径名

    sz = size(I);

    %% gray-world estimation and correction
    ill = illumgray(I); ill = ill./norm(ill); %estimate illuminant using GW
    D = ill(2)./ill; %diagonal correction matrix

    I_gw = out_of_gamut_clipping(reshape(reshape(im2double(I),[],3) * ...
        diag(D),size(I))); %corrected using GW wo our post-processing
    %% our post-processing
    d = pdist2(ill,model.C,'cosine');
    [~,cids] = sort(d); cid = cids(1);
    M = reshape(D * reshape(model.B(cid,:),[3,33]),[11,3]);
    I_corr = out_of_gamut_clipping(...
        reshape(PHI(reshape(I,[],3)) * M,[sz(1),sz(2),sz(3)]));
    imwrite(I_corr,[Output_path,imageName]); %完整的图片存储的路径名  并将整形的数字 
end
toc;
