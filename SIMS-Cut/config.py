#!/usr/bin/env python
# -*- coding=utf-8 -*-


################
# HCC-05-N1-NEG
################
# 要处理的数据目录
dataname_list = ["HCC-05-N1-NEG"]
# 细胞核相关的数据
A_matter_list = [134.06]
# 细胞核分割取的数据维度
divn_list = [20]
# 对数据进行的处理
ptype_list = ["gaussian", None]
# 细胞核分割取的数据维度
top_k_list = [20]
# 是否对数据进行重命名
renamer_list = [1]
# 输入数据尺寸，如果留空，则会从质谱仪数据中自动读入尺寸
# sz_list = [[256, 256]]
sz_list = []
# RBM 处理的轮数
epoch_list = [5]
# RMB 参数
rbm_ratio_list = [0.1]

beta_list = [0.5]

# 质谱仪数据目录
process_data_path = "/Volumes/ExternalSSD/数字化病理/sample_data"


"""
################
# HCC-05-T-big
################
# 要处理的数据目录
dataname_list = ["HCC-05-T-big"]
# 细胞核相关的数据
A_matter_list = [134.04]
# 细胞核分割取的数据维度
divn_list = [20]
# 对数据进行的处理
ptype_list = ["gaussian", None]
# 细胞核分割取的数据维度
top_k_list = [20]
# 是否对数据进行重命名
renamer_list = [1]
# 输入数据尺寸，如果留空，则会从质谱仪数据中自动读入尺寸
# sz_list = [[1792, 512]]
sz_list = []
# RBM 处理的轮数
epoch_list = [5]
# RMB 参数
rbm_ratio_list = [0.1]

beta_list = [0.5]

# 质谱仪数据目录
process_data_path = "/Users/david/Code/Projects/数字化病理/sample_data"



################
# HCC-05-T-big-1792x1024
################
# 要处理的数据目录
dataname_list = ["HCC-05-T-big-1792x1024"]
# 细胞核相关的数据
A_matter_list = [134.04]
# 细胞核分割取的数据维度
divn_list = [20]
# 对数据进行的处理
ptype_list = ["gaussian", None]
# 细胞核分割取的数据维度
top_k_list = [20]
# 是否对数据进行重命名
renamer_list = [1]
# 输入数据尺寸，如果留空，则会从质谱仪数据中自动读入尺寸
# sz_list = [[1792, 512]]
sz_list = []
# RBM 处理的轮数
epoch_list = [5]
# RMB 参数
rbm_ratio_list = [0.1]

beta_list = [0.5]

# 质谱仪数据目录
process_data_path = "/Volumes/ExternalSSD/数字化病理/sample_data"




################
# HCC-05-T-big-1792x1024
################
# 要处理的数据目录
dataname_list = ["HCC-05-T-big-1792x1792"]
# 细胞核相关的数据
A_matter_list = [134.04]
# 细胞核分割取的数据维度
divn_list = [20]
# 对数据进行的处理
ptype_list = ["gaussian", None]
# 细胞核分割取的数据维度
top_k_list = [20]
# 是否对数据进行重命名
renamer_list = [1]
# 输入数据尺寸，如果留空，则会从质谱仪数据中自动读入尺寸
# sz_list = [[1792, 512]]
sz_list = []
# RBM 处理的轮数
epoch_list = [5]
# RMB 参数
rbm_ratio_list = [0.1]

beta_list = [0.5]

# 质谱仪数据目录
process_data_path = "/Volumes/ExternalSSD/数字化病理/sample_data"

"""
