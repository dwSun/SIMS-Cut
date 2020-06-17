%������0-1�ı��ָ���ͼ����256*256����1��bg��2��cell��
%Ҫ�������0/1/2/3....k��ͼ��k��ϸ������
%������ͨ�ľ���һ��cell
% function[separated_img]=Separate_cell(input_img)
% img = zeros(size(input_img));
% img(input_img==1)=0;
% img(input_img==2)=1;
% [sz1,sz2] = size(img);
% %��img��������������һ����
% extended_img = zeros(sz1+2,sz2+2);
% extended_img(2:end-1,2:end-1) = img;
% separated_img = zeros(sz1,sz2);
% cell_idx = 1;
% for i=1:sz1
%     for j=1:sz2
%         
%         if(extended_img(i,j)==0)
%             continue
%         else
%             if(extended_img(i-1,j)~=0)
%                separated_img(i,j)= separated_img(i-1,j);
%             elseif(extended_img(i,j-1)~=0)
%                 separated_img(i,j)= separated_img(i,j-1);
%             else
%                 separated_img(i,j)=cell_idx;
%                 cell_idx = cell_idx+1;
%                 
%             end
%         end
%     end
%     
% end

function[separated_img]=Separate_cell(img)
[sz1,sz2] = size(img);
% img = reshape(Labeling,256,256);
img_bin = zeros(sz1,sz2);
img_bin(img==1)=0;
img_bin(img==2)=1;
cc = bwconncomp(img_bin);
separated_img = zeros(sz1,sz2);
for i=1:cc.NumObjects
    ith_comp = cc.PixelIdxList(i);
    ith_comp = ith_comp{1};
    for j=1:length(ith_comp)
       [pos_i,pos_j] = ind2ij(ith_comp(j),sz1,sz2); 
       separated_img(pos_i,pos_j) = i;
    end
end
end



function[i,j] = ind2ij(ind,height,width)
i = mod(ind-1,height)+1;
j = floor((ind-1)/height)+1;
end
