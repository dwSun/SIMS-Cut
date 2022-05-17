#!/usr/bin/env python3
# -*- coding=utf-8 -*-
import logging
import os
import os.path as osp
import shutil
import time

import log2file

import config
from tools.preprocess import renamer
from tools.SIMSCut_preprocess import SIMSCut_preprocess

log2file.init(console=True)

trace = log2file.trace
log = logging.getLogger()


# 生成 matlab 脚本的路径
cur_time_str = time.strftime("%Y%m%d_%H%M")
matlab_config_short = osp.join(
    osp.dirname(osp.abspath(__file__)), "run_code/config_"
)

os.chdir(config.process_data_path)

config_template = """
%strings
process_path_pref = "{process_path_pref}/process"
name = "{name}"
edge_type = '{edge_type}'
test_sample_all_file = 'test_samples_{n_matter}.mat'
top_k_name = 'test_samples_{top_k}'
%float
rbm_ratio = {rbm_ratio}
beta =  {beta}
%int
nei_type = 4
divn =  {divn}
epoch = {epoch}
h = {h}
w = {w}
use_edges = 0
"""

exts = ["_ada", "_auto"]


@trace()
def preprecess_data(
    process_data_path, dataname, A_matter, top_k, rename, ptype, sz=None,
):
    data_name, n_matter, sz = SIMSCut_preprocess(
        dataname, A_matter, ptype, top_k, rename, sz
    )

    src = osp.join(process_data_path, "process", data_name)
    for ext in exts:
        dest = osp.join(process_data_path, "process", data_name) + ext

        if osp.exists(dest):
            log.error("check: [{}] exist !!".format(dest))
            os._exit(0)

        log.debug("copy from [{}] to [{}]".format(src, dest))
        shutil.copytree(src, dest)

    return n_matter, sz


for i, data_name in enumerate(config.dataname_list):
    for ptype in config.ptype_list:
        log.debug("#" * 10)
        n_matter, sz = preprecess_data(
            config.process_data_path,
            data_name,
            config.A_matter_list[i],
            config.top_k_list[i],
            config.renamer_list[i],
            ptype,
            sz=None if len(config.sz_list) == 0 else config.sz_list[i],
        )

        for ext in exts:
            # 这里 ada 和 auto 主要是用于 matlab 里面处理的不同，跟 python 的代码没有关系。
            for beta in config.beta_list:

                matlab_config_name = "{}{}_{}{}_{}_{}.m".format(
                    matlab_config_short,
                    data_name,
                    ptype,
                    ext,
                    beta,
                    cur_time_str,
                )

                with open(matlab_config_name, "w") as f:
                    f.write(
                        config_template.format(
                            **{
                                "process_path_pref": config.process_data_path,
                                "name": "{}_{}{}".format(
                                    data_name, ptype, ext
                                ),
                                "edge_type": ext[1:],
                                "n_matter": n_matter,
                                "top_k": config.top_k_list[i],
                                "rbm_ratio": config.rbm_ratio_list[i],
                                "beta": beta,
                                "divn": config.divn_list[i],
                                "epoch": config.epoch_list[i],
                                "h": sz[0],
                                "w": sz[1],
                            }
                        )
                    )

                log.debug("new config script [{}]".format(matlab_config_name))
