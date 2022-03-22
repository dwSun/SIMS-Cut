#!/usr/bin/env python3
# -*- coding=utf-8 -*-

from tools.preprocess import listmatter, get_samples, listmatter_top_k_corr, renamer
import pickle
import os
import os.path as osp

import logging

import tools.logger as logger


trace = logger.trace
log = logging.getLogger()


def SIMSCut_preprocess(data_name, A_matter, ptype, top_k, ifrenamer, sz):
    # ptype='gaussian'
    data_name_new = data_name + "_" + str(ptype)

    rawdata_path = data_name
    workspace = osp.join("process", data_name_new, "")
    if not osp.exists(workspace):
        log.debug("mkdir [{}]".format(workspace))
        os.makedirs(workspace)
    preprocess_path = osp.join(workspace, "preprocess", "")
    if not osp.exists(preprocess_path):
        log.debug("mkdir [{}]".format(preprocess_path))
        os.makedirs(preprocess_path)

    if ifrenamer:
        renamer(rawdata_path)

    log.debug(rawdata_path)
    matters_candidate = listmatter(rawdata_path)
    pik_path = osp.join(preprocess_path + "matters_candidate.pkl")
    with open(pik_path, "wb") as of:
        log.debug("save [{}]".format(pik_path))
        pickle.dump(matters_candidate, of)

    test_samples = get_samples(rawdata_path, matters_candidate, preprocess_path, sz=sz)

    matters_20, corr_20 = listmatter_top_k_corr(test_samples, matters_candidate, A_matter, top_k)
    log.debug(matters_20)
    log.debug(corr_20)

    # print(matters_20)
    # print(corr_20)
    # print(len(matters_20))
    log.debug("extract top [{}] data samples...".format(top_k))
    test_samples_top = get_samples(rawdata_path, matters_20, preprocess_path, ptype=ptype, sz=sz)
    log.debug(workspace)
    return data_name_new, len(matters_candidate)
