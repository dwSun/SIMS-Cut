#!/usr/bin/env python3
# -*- coding=utf-8 -*-

from tools.preprocess import *
import pickle
import os
import os.path as osp
import timeit


def SIMSCut_preprocess(data_name, A_matter, ptype, top_k, ifrenamer, sz):
    # ptype='gaussian'
    data_name_new = data_name + "_" + str(ptype)

    # ifrenamer =1
    rawdata_path = data_name
    workspace = osp.join("process", data_name_new, "")
    if not osp.exists(workspace):
        os.makedirs(workspace)
    preprocess_path = osp.join(workspace, "preprocess", "")
    if not osp.exists(preprocess_path):
        os.makedirs(preprocess_path)

    print("renaming...")
    start = timeit.default_timer()
    # ifrenamer=0
    if ifrenamer:
        renamer(rawdata_path)
    stop = timeit.default_timer()
    print("done! Time cost: ", stop - start)

    print("get matters candidate...")
    start = timeit.default_timer()
    print(rawdata_path)
    matters_candidate = listmatter(rawdata_path)
    pickle.dump(matters_candidate, open(preprocess_path + "matters_candidate.pkl", "wb"))
    stop = timeit.default_timer()
    print("done! Time cost: ", stop - start)

    print("extract data samples...")
    start = timeit.default_timer()
    test_samples = get_samples(rawdata_path, matters_candidate, preprocess_path, sz=sz)
    stop = timeit.default_timer()
    print("done! Time cost: ", stop - start)

    print("get top {0} correlation matters with {1}...".format(top_k, A_matter))
    start = timeit.default_timer()
    matters_20, corr_20 = listmatter_top_k_corr(test_samples, matters_candidate, A_matter, top_k)
    print(matters_20)
    print(corr_20)
    stop = timeit.default_timer()
    print("done! Time cost: ", stop - start)

    # print(matters_20)
    # print(corr_20)
    # print(len(matters_20))
    print("extract top 20 data samples...")
    start = timeit.default_timer()
    test_samples_30 = get_samples(rawdata_path, matters_20, preprocess_path, ptype=ptype, sz=sz)
    stop = timeit.default_timer()
    print("done! Time cost: ", stop - start)
    print(workspace)
    return data_name_new, len(matters_candidate)
