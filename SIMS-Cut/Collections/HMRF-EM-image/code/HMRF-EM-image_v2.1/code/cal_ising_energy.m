function[rst] = cal_ising_energy(img,enc,pen)
%enc���ھ���ͬʱ�Ľ���
%pen���ھӲ�ͬʱ�ĳͷ�
%p=exp��-rst��
u = 0;
[rows,cols] = size(img);
%��img���Һ��½�����չ
%��tmpȥ��䣬tmp��img��û���ֹ��ı�ǩ����max+1
tmp = max(img(:))+1;
extended_img = [img,tmp*ones(rows,1);tmp*ones(1,cols+1)];
for i=1:rows
    for j=1:cols
        if((extended_img(i+1,j)~=tmp)&(extended_img(i+1,j)==extended_img(i,j)))
            u=u+enc;
        end
        if((extended_img(i,j+1)~=tmp)&(extended_img(i,j+1)==extended_img(i,j)))
            u=u+enc;
        end
        if((extended_img(i+1,j)~=tmp)&(extended_img(i+1,j)~=extended_img(i,j)))
            u=u+pen;
        end
        if((extended_img(i,j+1)~=tmp)&(extended_img(i,j+1)~=extended_img(i,j)))
            u=u+pen;
        end
    end
    
end
rst = -u;
