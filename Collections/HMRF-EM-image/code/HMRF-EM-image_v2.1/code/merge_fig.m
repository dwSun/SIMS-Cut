function[rst,seg] =merge_fig(fig1,fig2,pre)
%preָ�����Ǹ�figΪ׼��pre=1ʱ������fig overlap������fig1Ϊ׼
[sz1,sz2] = size(fig1);
rst = zeros(sz1,sz2);
seg = zeros(sz1,sz2);
if(pre==1)
    f1 = fig1;
    f2 = fig2;
else
    f1 = fig2;
    f2 = fig1;
end

for i = 1:sz1
    for j=1:sz2
        if(f1(i,j)~=0)
            rst(i,j) = f1(i,j);
            seg(i,j) = 1;
        elseif(f2(i,j)~=0)
            rst(i,j) = f2(i,j);
            seg(i,j) = 2;
        else
            rst(i,j) = 0;
            seg(i,j) = 0;
        end
    end
end
