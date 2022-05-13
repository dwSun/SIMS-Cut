#!/usr/bin/env python3
# -*- coding=utf-8 -*-

# %%
import config
import os
from tools.SIMSCut_preprocess import SIMSCut_preprocess
import shutil
import time
import os.path as osp
import logging

import log2file

from tools.preprocess import renamer


log2file.init(console=True)

trace = log2file.trace
log = logging.getLogger()


# 生成 matlab 脚本的路径
cur_time_str = time.strftime("%Y%m%d_%H%M")
matlab_script_name = osp.join(
    osp.dirname(osp.abspath(__file__)),
    "run_code/run_{0}.m".format(cur_time_str),
)

matlab_config_short = osp.join(
    osp.dirname(osp.abspath(__file__)), "run_code/config_"
)

matlab_info = {
    "name_list": [],
    "edge_type_list": [],
    "test_sample_all_file_list": [],
    "top_k_name_list": [],
    "rbm_ratio_list": [],
    "beta_list": [],
    "nei_type": [],
    "divn_list": [],
    "epoch_list": [],
    "sz_list": [],
}

os.chdir(config.process_data_path)


@trace()
def preprecess_data(
    process_data_path,
    matlab_info,
    dataname,
    A_matter,
    top_k,
    rename,
    divn,
    epoch,
    rbm_ratio,
    beta,
    ptype,
    ext,
    sz=None,
):
    data_name, n_matter, sz = SIMSCut_preprocess(
        dataname, A_matter, ptype, top_k, rename, sz
    )

    src = osp.join(process_data_path, "process", data_name)
    dest = osp.join(process_data_path, "process", data_name) + ext

    if osp.exists(dest):
        log.error("check: [{}] exist !!".format(dest))
        os._exit(0)

    log.debug("move from [{}] to [{}]".format(src, dest))
    shutil.move(src, dest)

    matlab_info["name_list"].append(data_name + ext)
    matlab_info["nei_type"].append(4)
    matlab_info["edge_type_list"].append(ext[1:])
    matlab_info["test_sample_all_file_list"].append(
        "test_samples_{n_matter}.mat".format(n_matter=n_matter)
    )
    matlab_info["top_k_name_list"].append("test_samples_{0}".format(top_k))
    matlab_info["divn_list"].append(divn)
    matlab_info["epoch_list"].append(epoch)
    matlab_info["rbm_ratio_list"].append(rbm_ratio)
    matlab_info["sz_list"].append(sz)
    matlab_info["beta_list"].append(beta)

    return sz


for i in range(len(config.dataname_list)):
    for ptype in config.ptype_list:
        for ext in ["_ada", "_auto"]:
            # 这里 ada 和 auto 主要是用于 matlab 里面处理的不同，跟 python 的代码没有关系。
            log.debug("#" * 10)
            sz = preprecess_data(
                config.process_data_path,
                matlab_info,
                config.dataname_list[i],
                config.A_matter_list[i],
                config.top_k_list[i],
                config.renamer_list[i],
                config.divn_list[i],
                config.epoch_list[i],
                config.rbm_ratio_list[i],
                config.beta_list[i],
                ptype,
                ext,
                sz=None if len(config.sz_list) == 0 else config.sz_list[i],
            )

            matlab_config_name = osp.join(
                f"{matlab_config_short}"
                + config.dataname_list[i]
                + "_"
                + str(ptype)
                + ext
                + "_{0}.m".format(cur_time_str),
            )

            with open(matlab_config_name, "w") as f:
                f.write("%strings\n")
                f.write(
                    "process_path_pref="
                    + f'"{str(config.process_data_path)}/process"'
                    + "\n"
                )
                f.write(
                    "name="
                    + f'"{str(config.dataname_list[i])+"_"+str(ptype)+ext}"'
                    + "\n"
                )
                f.write("edge_type_list=" + f"'{ext[1:]}'" + "\n")
                f.write("test_sample_all_file='test_samples_275.mat'\n")
                f.write(
                    "top_k_name_list='test_samples_{0}'".format(
                        config.top_k_list[i]
                    )
                    + "\n"
                )
                f.write("%float\n")
                f.write(
                    "rbm_ratio_list=" + str(config.rbm_ratio_list[i]) + "\n"
                )
                f.write("beta_list=" + str(config.beta_list[i]) + "\n")
                f.write("%int\n")
                f.write("nei_type=" + str(4) + "\n")
                f.write("divn_list=" + str(config.divn_list[i]) + "\n")
                f.write("epoch_list=" + str(config.epoch_list[i]) + "\n")
                f.write("h=" + str(sz[0]) + "\n")
                f.write("w=" + str(sz[1]))


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
    run_zuzhi_func_go_choose_adaauto_ext(process_path,test_sample_all_file,top_k_name_list{i},use_edges,edge_type_list{i},4,divn_list{i},sz_list{i},epoch_list{i},rbm_ratio_list{i},beta_list{i});
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

# %%
