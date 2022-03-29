#!/usr/bin/env python3
# -*- coding=utf-8 -*-

# %%
import os
from tools.SIMSCut_preprocess import SIMSCut_preprocess
import shutil
import time
import os.path as osp
import logging

from tools.preprocess import renamer


from tools import logger

logger.init(console=True)

trace = logger.trace
log = logging.getLogger()

import config

# 生成 matlab 脚本的路径
cur_time_str = time.strftime("%Y%m%d_%H%M")
matlab_script_name = osp.join(osp.dirname(osp.abspath(__file__)), "run_code/run_{0}.m".format(cur_time_str))


matlab_info = {
    "name_list": [],
    "nei_type": [],
    "edge_type_list": [],
    "test_sample_all_file_list": [],
    "top_k_name_list": [],
    "divn_list": [],
    "epoch_list": [],
    "rbm_ratio_list": [],
    "sz_list": [],
}

os.chdir(config.process_data_path)


@trace()
def preprecess_data(process_data_path, matlab_info, dataname, A_matter, top_k, rename, divn, epoch, rbm_ratio, ptype, ext, sz=None):
    data_name, n_matter, sz = SIMSCut_preprocess(dataname, A_matter, ptype, top_k, rename, sz)

    src = osp.join(process_data_path, "process", data_name)
    dest = osp.join(process_data_path, "process", data_name) + ext

    if osp.exists(dest):
        log.error("check: [{}] exist !!".format(dest))
        os._exit(0)

    log.debug("copy from [{}] to [{}]".format(src, dest))
    shutil.copytree(src, dest)

    matlab_info["name_list"].append(data_name + ext)
    matlab_info["nei_type"].append(4)
    matlab_info["edge_type_list"].append(ext[1:])
    matlab_info["test_sample_all_file_list"].append("test_samples_{n_matter}.mat".format(n_matter=n_matter))
    matlab_info["top_k_name_list"].append("test_samples_{0}".format(top_k))
    matlab_info["divn_list"].append(divn)
    matlab_info["epoch_list"].append(epoch)
    matlab_info["rbm_ratio_list"].append(rbm_ratio)
    matlab_info["sz_list"].append(sz)


for i in range(len(config.dataname_list)):
    dataname = config.dataname_list[i]
    A_matter = config.A_matter_list[i]
    top_k = config.top_k_list[i]
    rename = config.renamer_list[i]
    divn = config.divn_list[i]
    epoch = config.epoch_list[i]
    rbm_ratio = config.rbm_ratio_list[i]
    if len(config.sz_list) == 0:
        sz = None
    else:
        sz = config.sz_list[i]

    for ptype in config.ptype_list:
        for ext in ["_ada", "_auto"]:
            # 这里 ada 和 auto 主要是用于 matlab 里面处理的不同，跟 python 的代码没有关系。
            log.debug("#" * 10)
            preprecess_data(config.process_data_path, matlab_info, dataname, A_matter, top_k, rename, divn, epoch, rbm_ratio, ptype, ext, sz)


matlab_code_temp = (
    """
process_path_pref = '{}';
%test_sample20_file = 'test_samples_5.mat';

""".format(
        osp.join(config.process_data_path, "process")
    )
    + """
use_edges = 0;
%default is 0
for i=1:size(name_list,1)
    process_path = fullfile(process_path_pref,name_list{i});
    test_sample_all_file = [test_sample_all_file_list{i}];
    run_zuzhi_func_go_choose_adaauto_ext(process_path,test_sample_all_file,top_k_name_list{i},use_edges,edge_type_list{i},4,divn_list{i},sz_list{i},epoch_list{i},rbm_ratio_list{i});
end
"""
)
matlab_code_comp = ""
for key, val in matlab_info.items():
    if isinstance(val[0], str):
        val_str = "".join(["'{}',\n".format(v) for v in val])
    elif isinstance(val[0], list):
        val_str = "".join(["[{} {}],\n".format(v[0], v[1]) for v in val])
    else:
        val_str = "".join(["{},\n".format(v) for v in val])

    cur_code = "{}={{\n{}}};\n".format(key, val_str)
    matlab_code_comp += cur_code
matlab_code = matlab_code_comp + matlab_code_temp

with open(matlab_script_name, "w") as f:
    f.write(matlab_code)

log.debug("script [{}]".format(matlab_script_name))
