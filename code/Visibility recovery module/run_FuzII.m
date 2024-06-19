close all;   clc;
Input_path = '.\image\';  
Output_path='.\result\';
namelist = dir(strcat(Input_path,'*.jpg'));  %获得文件夹下所有的 .jpg图片
len = length(namelist);
tic;
for i = 1:len
    name=namelist(i).name;  %namelist(i).name; %这里获得的只是该路径下的文件名
    g=im2double(imread(strcat(Input_path, name))); %图片完整的路径名
    alpha =.95;


    mx=max(g(:));mn=min(g(:));
    f=(g-mn)./(mx-mn);



    n=length(f(:));
    mu=(sum(f(:))./n);

    std=sqrt((1/(n-1))*sum((f(:)-mu).^2));

    var=std.^2;

    m_high=(f.^alpha)+(1-f.^alpha).*(var.^alpha);
    m_low=((alpha.*mu)./(std+alpha)).*(f-alpha.*mu);
    fuzzII=(m_high+m_low+(var-2)*m_high.*m_low)./(1-(1-var)*m_high.*m_low);


    gamma_value=1.5*alpha;
    max_img=max(fuzzII(:));
    fuzzII=(max_img*(fuzzII/max_img).^gamma_value);
    imwrite(fuzzII,[Output_path,name]); %完整的图片存储的路径名  并将整形的数字
end
toc;