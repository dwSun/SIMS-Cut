path = 'C:\Users\Yuan Zhiyuan\Documents\MATLAB\SIMS_0820\MATLAB\Add-Ons\Collections\HMRF-EM-image\code\HMRF-EM-image_v2.1\code\DeeBNetV3.2\DeeBNetV3.2\EM_mid_rst\';

file_prefix = 'cur_labeling_0911_468br-ski-474no_20_20_Fmeasure_0.8_auto_div5__';
% cur_labeling_0713_liver-cancer-1_20_Fmeasure_0.5_ada21auto_div10__1.mat
file_sufix = '.mat';
iters_num = 51;
height = 256;
width = 256;
%ָ����0.75��λ����ϸ��Ҫ���Ƿ���(75��λ��)
attention_threshold = 40;
labeling_mat = zeros(height*width,iters_num);
% ����labeling_mat�������ĸ�ͼ��cell���
num_cells_li =[];
num_pixels_li = [];
for i=1:iters_num
   cur_file = [path,file_prefix,num2str(i),file_sufix];
   load(cur_file);
  
   [filtered_img,num_valid_cell,filtered_labeling] = filter_cell(cur_labeling,3);
   img = reshape(filtered_labeling,256,256);
    [separated_img]=Separate_cell(img);
%     num_cells = max();
    labeling_mat(:,i) = separated_img(:);
    num_pixels = sum(cur_labeling==2);
    num_cells_li = [num_cells_li,num_valid_cell];
    num_pixels_li = [num_pixels_li,num_pixels];
end

[max_cell_num,max_cell_idx] = max(num_cells_li);
% ��ʼ������ʼͼ�е�ϸ��
max_cell_idx=2;
%maxΪϸ��������minΪ0�����ͣ�

init_image_labeling = labeling_mat(:,max_cell_idx);
max_cell_num = max(init_image_labeling);
final_labeling = init_image_labeling;
cell_size_li = [];
for i=1:max_cell_num
    cell_size_li = [cell_size_li,sum(init_image_labeling==i)];
end
thre_area = prctile(cell_size_li,attention_threshold);
attention_cells = find(cell_size_li>thre_area);
idx = 1;
while(idx<=length(attention_cells) )
    i = attention_cells(idx);
% for i=attention_cells
    idx = idx + 1;
    region_idxs = find(final_labeling==i);
    in_region_cells_li = [];
    cell_area_var_li = [];
    cell_area_li_dict = {};
    j_in_region_dict = {};
    for j=max_cell_idx+1:iters_num
        j_sep_labeling = labeling_mat(:,j);
        j_in_region = j_sep_labeling(region_idxs);
        if(all(j_in_region))
            %���û��0��Ӧ����һ��j����
            in_region_cells_li = [in_region_cells_li,0];
            continue;
        end
%         ȥ��0֮�󣬿�����������ж��ٸ���ͬcell
        j_in_region = j_in_region(j_in_region~=0);
        cell_idx_j = unique(j_in_region);
        j_in_region_dict{j-max_cell_idx} = cell_idx_j;
        num_cells_in_region = length(cell_idx_j);
        in_region_cells_li = [in_region_cells_li,num_cells_in_region];
        
        cell_area_li = [];
        for k=cell_idx_j'
            cell_area_li = [cell_area_li,sum(j_sep_labeling==k)];
        end
        cell_area_li_dict{j-max_cell_idx} = cell_area_li;
        cell_area_var_li = [cell_area_var_li,var(cell_area_li)];
        
    end
%     [select_j_value,~] = max(in_region_cells_li);
    %ѡ����ѳ�������ϸ���������кü���ͼ�������ģ�ѡ������С�ġ�
%     [select_j_va]
%     cell_area_var_li(in_region_cells_li>=max(select_j_value-1,1))=inf;
%     [~,select_j] = min(cell_area_var_li);
%     in_region_cells_li=fliplr(in_region_cells_li);
     [~,select_j] = max(in_region_cells_li);
     j_area_li = cell_area_li_dict{select_j};
     j_idx_li = j_in_region_dict{select_j};
     
     illigel = j_idx_li(j_area_li>=thre_area);
%      if(length(j_area_li)>=1)
%         disp(i,j) ;
%      end
     
     
    select_j = select_j + max_cell_idx;
    %select_j����Ӧ���滻��attention��img�е�i��cell��ͼ
    j_sep_labeling = labeling_mat(:,select_j);
    j_in_region = j_sep_labeling(region_idxs);
    added_j_in_region = j_in_region;
    max_final_labeling = max(final_labeling);
    added_j_in_region(added_j_in_region~=0) = added_j_in_region(added_j_in_region~=0)+max_final_labeling;
    
%      final_labeling(region_idxs)=0;
    final_labeling(region_idxs)  =added_j_in_region;
    attention_cells = [attention_cells,illigel'+max_final_labeling];
    i
    
end

final_labeling(final_labeling~=0)=1;
final_labeling = final_labeling+1;
subplot(1,2,1);
imshow(reshape(final_labeling,256,256)',[]);
subplot(1,2,2);
imshow(reshape(init_image_labeling,256,256)');
[~,final_num_cells,~] = filter_cell(final_labeling,3);
disp(['��',num2str(final_num_cells),'����Чϸ��']);


% cur_labeling_0704_yidao_20_Fmeasure_0.5_ada21auto_div5__1.mat
% cur_labeling_0704_yidao_20_Fmeasure_0.5_ada21auto_div10__1.mat

