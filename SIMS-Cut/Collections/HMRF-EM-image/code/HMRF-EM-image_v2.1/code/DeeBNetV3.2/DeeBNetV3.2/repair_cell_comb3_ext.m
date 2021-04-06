% path = 'C:\Users\Yuan Zhiyuan\Documents\MATLAB\SIMS_0820\MATLAB\Add-Ons\Collections\HMRF-EM-image\code\HMRF-EM-image_v2.1\code\DeeBNetV3.2\DeeBNetV3.2\data\zuzhi\1208\EM_mid_rst\';
% file_prefix = 'cur_labeling_1023_20181208_liver-alb_20_ada_test_20_Fmeasure_0.8_div10__';
% cur_labeling_0713_liver-cancer-1_20_Fmeasure_0.5_ada21auto_div10__1.mat
file_sufix = '.mat';
iters_max = 200;
iters_num = 0
for i=1:iters_max
   cur_file = strcat(path,file_prefix,num2str(i),file_sufix);
   
	disp(cur_file)
   if exist(cur_file, 'file') 
       iters_num = i;
   end
end
disp(num2str(iters_num));
height = sz;
fold_mean = 1.00;
width = sz;
%ָ����0.75��λ����ϸ��Ҫ���Ƿ���(75��λ��)
attention_threshold = 40;
labeling_mat = zeros(height*width,iters_num);
% ����labeling_mat�������ĸ�ͼ��cell���
num_cells_li =[];
num_pixels_li = [];
for i=1:iters_num
   cur_file = [path,file_prefix,num2str(i),file_sufix];
   load(cur_file);
  
   [filtered_img,num_valid_cell,filtered_labeling] = filter_cell_ext(cur_labeling,0,sz);
   img = reshape(filtered_labeling,sz,sz);
    [separated_img]=Separate_cell(img);
%     num_cells = max();        
    labeling_mat(:,i) = separated_img(:);
    num_pixels = sum(cur_labeling==2);
    num_cells_li = [num_cells_li,num_valid_cell];
    num_pixels_li = [num_pixels_li,num_pixels];
end
labeling_mat = labeling_mat(:,2:end);
disp('filter done')
%��i��λ�ñ�ʾi�Žڵ�ĸ��ڵ��idx,1�Žڵ���ȫ1
parent_list = [0];
%��¼��i���ڵ�������һ�㣬��1����labeling_1
level_list = [0];
%��¼��i���ڵ�����һ��ļ���ϸ��
cell_list = [1];
area_list = [sz*sz];


lost_number = 0;
iters_num = iters_num-1;
%�����һ��labeling������bias��kmeans����ȫ1�������ڵ㣬����Ϊ1
 pre_lost = 0;
for i=1:iters_num
disp(['loop2',':',num2str(i)])
   cur_labeling = labeling_mat(:,i);
   num_cells = max(cur_labeling);
   if(i==1)
       for j=1:num_cells
           parent_list = [parent_list,1];
           level_list = [level_list,1];
           cell_list = [cell_list,j];
           area_list = [area_list,sum(cur_labeling==j)];
       end
       continue;
   end
   pre_labeling = labeling_mat(:,i-1);
   pre_idxs = (length(parent_list)-max(pre_labeling)+1+pre_lost):length(parent_list);

   pre_cells = cell_list(pre_idxs);
   pre_lost = 0;
   for j=1:num_cells
      %�������Ľڵ�ĸ��ڵ��¼����
      flag = 1;
      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%       for k=pre_cells
%          if(max(max((cur_labeling==j)+(pre_labeling==k)))==2)
%              
%             
%             %˵������������segment���ص�
%             parent_list = [parent_list,pre_idxs(k)];
%             level_list = [level_list,i];
%             cell_list = [cell_list,j];
%             area_list = [area_list,sum(cur_labeling==j)];
%             
%             flag = 0;
%             break;
%     
%              
%          end
%          
%          
%          
%       end
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%        Ҫ���ص������󣬲��ǰְ�
%         overlap_area_list = [];
%         for k=pre_idxs
%             overlap_area = sum((cur_labeling==j)+(pre_labeling==cell_list(k))==2);
%             overlap_area_list = [overlap_area_list,overlap_area];
%         end
%         [max_area_val,max_area_ind] = max(overlap_area_list);
%         if(max_area_val>0)
%             %˵���ҵ��ְ���
%             flag= 0;
%             
%             parent_list = [parent_list,pre_idxs(max_area_ind)];
%             level_list = [level_list,i];
%             cell_list = [cell_list,j];
%             area_list = [area_list,sum(cur_labeling==j)];
%         
%             %˵���Ҳ����ְ֣���ʧ
%         end
       
       
       
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       
       for k=pre_idxs
         if(max(max((cur_labeling==j)+(pre_labeling==cell_list(k))))==2)
             
            
            %˵������������segment���ص�
            parent_list = [parent_list,k];
            level_list = [level_list,i];
            cell_list = [cell_list,j];
            area_list = [area_list,sum(cur_labeling==j)];
            
            flag = 0;
            break;
    
             
         end
         
         
         
      end
       
       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
       
       
       
%       ���ֶ�ʧ��770��
      if(flag)
          pre_lost = pre_lost+1;
         lost_number = lost_number+1; 
         disp([num2str(i+1),',',num2str(j)]);
         
      end
      
   end
    
end


%�ҳ����е�Ҷ�ӽڵ㣬������final_labeling
parent_set = unique(parent_list);
all_set = 1:length(parent_list);
leaf_set = setdiff(all_set,parent_set);

mean_leaf_area = median(area_list(leaf_set));
area_threshold = fold_mean*mean_leaf_area;
single_leaf_set = leaf_set;
%��ÿһ��Ҷ�ӽڵ����ϻ��ݣ��ҵ�level��͵Ĳ����ѽڵ�
intensity_134_list_count = 1;
intensity_134_list= [];
for i=leaf_set
    

disp(['loop3',':',num2str(i)])
        if(length(intensity_134_list)>=2)
        disp(['---------------',num2str(length(intensity_134_list))]);
        intensity_134_list_cell{intensity_134_list_count} = intensity_134_list;
        intensity_134_list_count = intensity_134_list_count+1;
    end
    
    intensity_134_list= [];
    ori_leaf = i;
    cur_leaf = i;
    cur_leaf_level = level_list(i);

   while(cur_leaf~=0)
       
       
        
        cur_leaf_cell = cell_list(cur_leaf);
        if(cur_leaf_level<=0)
	    continue;
        end
        cur_134_mean = mean(test_samples_20(labeling_mat(:,cur_leaf_level)==cur_leaf_cell,1));
        intensity_134_list = [intensity_134_list,cur_134_mean];
        
        if(length(intensity_134_list)==1)
            foldchange_intensity_134 = 1;
        else
            foldchange_intensity_134 = intensity_134_list(end)/intensity_134_list(end-1);
        end
        
       
        
%        �ȿ���ǰ����û��leaf��curleaf��ͬһ���ְ�
       check_brother = sum(parent_list(level_list==cur_leaf_level)==parent_list(cur_leaf));
       if(check_brother==0)
           disp('error');
           
%            �������ֲ��������û���⣬��ΪֻҪ�й���
%           �ص���Ҫ������������һ��ֹͣ��������threshold����
% ������������ƽ��134���źŲ����������߻�һ������������ƽ��134�ı仯ͼ��Ӧ�����½����ƣ���ȡ�յ㡣
% ���ڣ�ֻҪ134��ƽ��ֵ�½��˰ٷ�֮*��ֹͣ����
% ����˵134��ƽ����û�н���ԭ���İٷ�֮*��ֹͣ

%        elseif(check_brother==1 & area_list(cur_leaf)<=area_threshold)
        elseif(check_brother==1 && foldchange_intensity_134>=fold_mean)
           %˵������������
           cur_leaf = parent_list(cur_leaf);
%            cur_leaf_level = cur_leaf_level-1;
            cur_leaf_level = level_list(cur_leaf);
       else
           %����������
           single_leaf_set(single_leaf_set==ori_leaf) = cur_leaf;
           disp(['change ',num2str(ori_leaf),'to ',num2str(cur_leaf)]);
           break;
       end
       
       
       
   end
end


final_labeling = zeros(sz*sz,1);
leaf_labeling = zeros(sz*sz,1);
for i=single_leaf_set
   cur_leaf_level = level_list(i);
   cur_leaf_cell = cell_list(i);
   final_labeling(labeling_mat(:,cur_leaf_level)==cur_leaf_cell) = 1;
end

for i=leaf_set
   cur_leaf_level = level_list(i);
   cur_leaf_cell = cell_list(i);
   leaf_labeling(labeling_mat(:,cur_leaf_level)==cur_leaf_cell) = 1;
end

final_labeling = final_labeling+1;
leaf_labeling = leaf_labeling + 1;
[~,final_num_cells,final_labeling] = filter_cell_ext(final_labeling,1,sz);
disp(['there are ',num2str(final_num_cells),' valid cells']);
% subplot(1,2,1);
% imshow(reshape(leaf_labeling,256,256)',[]);
% subplot(1,2,2);
% imshow(reshape(final_labeling,256,256)',[]);
save(strcat(save_final_labeling_path,'final_labeling_',num2str(beta),'.mat'),'final_labeling');

final_labeling_img = logical(reshape(final_labeling,sz,sz)'-1);
imwrite(final_labeling_img,strcat(save_final_labeling_path,'final_labeling_',num2str(beta),'.png'));
img_134 = reshape(test_samples_20(:,1),sz,sz)';
imshowpair(img_134,final_labeling_img);
print(strcat(save_final_labeling_path,'final_labeling_merge134_',num2str(beta),'.png'),'-dpng');

























% [max_cell_num,max_cell_idx] = max(num_cells_li);
% % ��ʼ������ʼͼ�е�ϸ��
% max_cell_idx=2;
% %maxΪϸ��������minΪ0�����ͣ�
% 
% init_image_labeling = labeling_mat(:,max_cell_idx);
% max_cell_num = max(init_image_labeling);
% final_labeling = init_image_labeling;
% cell_size_li = [];
% for i=1:max_cell_num
%     cell_size_li = [cell_size_li,sum(init_image_labeling==i)];
% end
% thre_area = prctile(cell_size_li,attention_threshold);
% attention_cells = find(cell_size_li>thre_area);
% idx = 1;
% while(idx<=length(attention_cells) )
%     i = attention_cells(idx);
% % for i=attention_cells
%     idx = idx + 1;
%     region_idxs = find(final_labeling==i);
%     in_region_cells_li = [];
%     cell_area_var_li = [];
%     cell_area_li_dict = {};
%     j_in_region_dict = {};
%     for j=max_cell_idx+1:iters_num
%         j_sep_labeling = labeling_mat(:,j);
%         j_in_region = j_sep_labeling(region_idxs);
%         if(all(j_in_region))
%             %���û��0��Ӧ����һ��j����
%             in_region_cells_li = [in_region_cells_li,0];
%             continue;
%         end
% %         ȥ��0֮�󣬿�����������ж��ٸ���ͬcell
%         j_in_region = j_in_region(j_in_region~=0);
%         cell_idx_j = unique(j_in_region);
%         j_in_region_dict{j-max_cell_idx} = cell_idx_j;
%         num_cells_in_region = length(cell_idx_j);
%         in_region_cells_li = [in_region_cells_li,num_cells_in_region];
%         
%         cell_area_li = [];
%         for k=cell_idx_j'
%             cell_area_li = [cell_area_li,sum(j_sep_labeling==k)];
%         end
%         cell_area_li_dict{j-max_cell_idx} = cell_area_li;
%         cell_area_var_li = [cell_area_var_li,var(cell_area_li)];
%         
%     end
% %     [select_j_value,~] = max(in_region_cells_li);
%     %ѡ����ѳ�������ϸ���������кü���ͼ�������ģ�ѡ������С�ġ�
% %     [select_j_va]
% %     cell_area_var_li(in_region_cells_li>=max(select_j_value-1,1))=inf;
% %     [~,select_j] = min(cell_area_var_li);
% %     in_region_cells_li=fliplr(in_region_cells_li);
%      [~,select_j] = max(in_region_cells_li);
%      j_area_li = cell_area_li_dict{select_j};
%      j_idx_li = j_in_region_dict{select_j};
%      
%      illigel = j_idx_li(j_area_li>=thre_area);
% %      if(length(j_area_li)>=1)
% %         disp(i,j) ;
% %      end
%      
%      
%     select_j = select_j + max_cell_idx;
%     %select_j����Ӧ���滻��attention��img�е�i��cell��ͼ
%     j_sep_labeling = labeling_mat(:,select_j);
%     j_in_region = j_sep_labeling(region_idxs);
%     added_j_in_region = j_in_region;
%     max_final_labeling = max(final_labeling);
%     added_j_in_region(added_j_in_region~=0) = added_j_in_region(added_j_in_region~=0)+max_final_labeling;
%     
% %      final_labeling(region_idxs)=0;
%     final_labeling(region_idxs)  =added_j_in_region;
%     attention_cells = [attention_cells,illigel'+max_final_labeling];
%     i
%     
% end
% 
% final_labeling(final_labeling~=0)=1;
% final_labeling = final_labeling+1;
% subplot(1,2,1);
% imshow(reshape(final_labeling,256,256)',[]);
% subplot(1,2,2);
% imshow(reshape(init_image_labeling,256,256)');
% [~,final_num_cells,~] = filter_cell(final_labeling,3);
% disp(['��',num2str(final_num_cells),'����Чϸ��']);
% 
% 
% % cur_labeling_0704_yidao_20_Fmeasure_0.5_ada21auto_div5__1.mat
% % cur_labeling_0704_yidao_20_Fmeasure_0.5_ada21auto_div10__1.mat

