clear all
% reversible digital image watermarking using triangular number generator functions
cov =   [' C:\Users\eaakagg\Desktop\AP.jpg   '];

covr =imread('C:\Users\eaakagg\Desktop\AP.jpg');
figure,image(covr),title('1.Cover image');

w=['C:\Users\eaakagg\Desktop\lena_color_256.tif'];
wm=imread('C:\Users\eaakagg\Desktop\lena_color_256.tif');
figure,image(wm),title('2.WaterMark');

%Dimensions of Images
[r,c]= size(covr);
[g,h]= size(wm);

%preserve msb of watermark
wm_pre=wm;  
for i=1:4
    wm_pre=bitset(wm_pre,i,0);
end
figure,image(wm_pre),title('3.MSB of WaterMark');

wms=bitshift(wm_pre,-4);
figure,image(wms),title('4.Shifted wmark');

% extract the lsb of cover image
lsb_covr=covr;
for i=5:8
    lsb_covr=bitset(lsb_covr,i,0);
end
figure,image(lsb_covr),title('5.LSB of cover');




%preserve the msb of cover image
msb_covr=covr;
for i=1:4
    msb_covr=bitset(msb_covr,i,0);
end
figure,image(msb_covr),title('6.MSB of cover');

%{

%divide  LSB of cover and shifted msb by 4
lsb_covrd=lsb_covr/4;
msb_wmd=wms/4;
%}

rem= zeros(256,256,3,'uint16');
quo= zeros(256,256,3,'uint16');

%Add wmark to cover
wm1= zeros(256,256,3,'uint16');
for i=1:10
  for j=1:10
      for k =1:3
wm1(i,j,k)=((uint16(lsb_covr(i,j,k))+uint16(wms(i,j,k)))^2+uint16(3*uint16(lsb_covr(i,j,k)))+uint16(wms(i,j,k)))/2;


%Do modulo 16 operation and store remainder in rem
rem(i,j,k)=mod(wm1(i,j,k),16);
%Store the quotient in wm3

quo(i,j,k)=(wm1(i,j,k)-rem(i,j,k))/16;
      end
  end
end
wmi=msb_covr+uint16(rem);

figure,image(wmi),title('7.Water Marked Image');





%preserve the msb of wmi image

msb_wmi=wmi;
for i=1:4
    msb_wmi=bitset(msb_wmi,i,0);
end
figure,image(msb_wmi),title('8.MSB of wmimage');


%preserve the lsb of wmi image

lsb_wmi=wmi;
for i=5:8
    lsb_wmi=bitset(lsb_wmi,i,0);
end
figure,image(lsb_wmi),title('9.LSB of wmimage');

%Generate the matrix of lsb_covr combined with msb_wm

comb= zeros(256,256,3,'uint16');
for i=1:256
  for j=1:256
      for k =1:3
    comb(i,j,k)=quo(i,j,k)*16+uint16(lsb_wmi(i,j,k));
      end
  end
end

figure,image(comb),title('10.LSB combined with msb of wmark');



%Determine the sum of the 2 numbers
sum= zeros(256,256,3,'uint16');
for i=1:256
  for j=1:256
      for k =1:3
    sum(i,j,k)=floor((sqrt(8*double(comb(i,j,k))+1)- 1)/2);
      end
  end
end

%Determine lsb of cover
lsb_pre=zeros(256,256,3,'uint16');
for i=1:256
  for j=1:256
      for k =1:3
lsb_pre(i,j,k)=floor((comb(i,j,k) - (sum(i,j,k)*(sum(i,j,k)+1)/2)));
      end
  end
end
figure,image(lsb_pre),title('11.LSB Extracted');



%Extract the watermark
wm2=zeros(256,256,3,'uint16');
for i=1:256
  for j=1:256
      for k =1:3
          

wm2(i,j,k)=floor(sum(i,j,k)*( sum(i,j,k)+3)/2- comb(i,j,k));
      end
  end
end

wm3=bitshift(uint16(wm2),4);


figure,image(wm3),title('12.Predicted Watermark');

%regenerating cover image


covr2=msb_wmi+uint16(lsb_pre);

figure,image(covr2),title('13.Regenerated Cover image ');

%}
%}