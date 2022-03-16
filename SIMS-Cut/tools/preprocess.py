#!/usr/bin/env python3
# -*- coding=utf-8 -*-

import os
import os.path as osp
from scipy.ndimage import gaussian_filter

# import magic
from pathlib import Path
import pickle
import pandas as pd
import math

import logging

import tools.logger as logger


trace = logger.trace
log = logging.getLogger()


# import pyfpgrowth
import operator
import numpy as np
from scipy.io import savemat
from scipy.stats import pearsonr


@trace()
def matter_filter(threshold, path):
    # find matter whose heatmap has more none-zero pixels.
    matter_pixel_dict = get_matter_pixel_dict(path)
    matter_nonezeropixels_dict = {}
    for matter, pixel in matter_pixel_dict.iteritems():
        matter_nonezeropixels_dict[matter] = sum(map(lambda x: x >= 1, pixel))
    sorted_dict = sorted(matter_nonezeropixels_dict.items(), key=operator.itemgetter(1))
    return sorted_dict


@trace()
def get_matter_pixel_dict(path):
    matter_pixel_dict = {}
    for filename in os.listdir(path):
        if "total" in filename or "sum" in filename:
            continue
        # idx_former = filename.find('-',25)
        # idx_latter = filename.find('u',15)
        matter = filename[:-4]

        pixel = get_pixel_list_from_file(path + filename)
        matter_pixel_dict[matter] = pixel
    return matter_pixel_dict


@trace()
def get_pixel_list_from_file(filename):
    pixel_list = []
    f = open(filename, "r")
    lines = f.readlines()[9:]
    for line in lines:
        intensity = float(line.split(" ")[2])
        pixel_list.append(intensity)
    f.close()
    return pixel_list


@trace()
def renamer(path):
    # print 'bb'
    for filename in os.listdir(path):
        if "total" in filename or "sum" in filename or "tif" in filename:
            continue
        if len(filename) <= 10:
            continue
        idx_former = filename.rfind("-")
        idx_latter = filename.rfind("txt")
        # print idx_former,idx_latter
        print(filename[idx_former + 2 : idx_latter - 3])

        print(filename)
        matter = filename[idx_former + 2 : idx_latter - 3].strip()
        originam_filename = osp.join(path, filename)
        changed_filename = osp.join(path, matter + ".txt")
        print("change {o} to {c}".format(o=filename, c=matter))
        os.rename(originam_filename, changed_filename)


@trace()
def find_cooccorance_matters(matter_li):
    DEs = [1, 5, 6, 7, 8, 9, 10]
    DSs = range(5, 16)
    DE_pre = "/Users/yzy/Desktop/study/SKMS/PROCESS1127/DATA/YZY-2017-11-27/DE-1/DE-1-{num}/"
    DS_pre = "/Users/yzy/Desktop/study/SKMS/PROCESS1127/DATA/YZY-2017-11-27/DS-1/DS-1-{num}/"

    filtered_matters = []
    for matter in matter_li:
        DE_flag = True
        for de in DEs:
            full_filename = DE_pre.format(num=de) + str(matter) + ".txt"
            if not osp.isfile(full_filename):
                DE_flag = False
        DS_flag = True
        for ds in DSs:
            full_filename = DS_pre.format(num=ds) + str(matter) + ".txt"
            if not osp.isfile(full_filename):
                DS_flag = False

        if DE_flag and DS_flag:
            filtered_matters.append(matter)
    return filtered_matters


@trace()
def get_matter_list_from_path(path):
    matter_list = []
    for file in os.listdir(path):
        if "total" in file or "sum" in file or "tif" in file:
            continue
        matter_list.append(file[:-4])
    matter_list = map(float, matter_list)
    return sorted(matter_list)


@trace()
def find_cooccorance_matters1(path1, path2):
    common_matter_list = []
    # for path in path_list:
    # all_matter_list.extend(get_matter_list_from_path(path))
    # return sorted(list(set(all_matter_list)))
    path1_matters = get_matter_list_from_path(path1)
    path2_matters = get_matter_list_from_path(path2)
    for m in path1_matters:
        if m in path2_matters:
            common_matter_list.append(m)
    return common_matter_list


# 读取质谱仪文本数据并存储为 matlab 格式
@trace()
def get_samples(rawdata_path, matters_candidate, tosave_path, ptype=None, sz=256):
    rst_sample = []
    for matter in matters_candidate:
        matter = "{0:.2f}".format(matter)

        cur_file = osp.join(rawdata_path, matter + ".txt")
        cur_matter_pd = pd.read_csv(open(cur_file, "r"), sep=" ", skiprows=9, header=None, names=["row", "col", "val"])

        cur_matter_data = np.array(cur_matter_pd["val"])
        rst_sample.append(cur_matter_data)
    rst_sample = np.array(rst_sample)
    rst_sample = np.transpose(rst_sample)
    if ptype == "magic":
        rst_sample = magic.MAGIC().fit_transform(rst_sample)
    if ptype == "gaussian":

        for i in range(rst_sample.shape[1]):
            cur_col = rst_sample[:, i]
            cur_img = cur_col.reshape(sz[0], sz[1])
            cur_img_blur = gaussian_filter(cur_img, 1)
            rst_sample[:, i] = cur_img_blur.reshape((sz[0] * sz[1],))
    savemat(file_name=tosave_path + "test_samples_{num_features}.mat".format(num_features=len(matters_candidate)), mdict={"test_samples": rst_sample})
    return rst_sample
    # print(rst_sample.shape)


@trace()
def listmatter_top_k_corr(test_samples, matters_candidate, A_matter, top_k):
    log.debug("get top {0} correlation matters with {1}...".format(top_k, A_matter))
    cor_array = np.zeros(shape=(len(matters_candidate)))
    A_matter = float(A_matter)
    top_k = int(top_k)
    data_134 = test_samples[:, matters_candidate.index(A_matter)]
    count = 0
    for i in range(len(matters_candidate)):
        count += 1
        [a, b] = pearsonr(data_134, test_samples[:, i])
        cor_array[i] = float(a)
    sorted_idx = np.flip(np.argsort(cor_array), axis=0)
    sorted_cors = np.flip(np.sort(cor_array), axis=0)
    matters_candidate_np = np.array(matters_candidate)
    rst_matter = matters_candidate_np[sorted_idx[:top_k]]
    rst_corr = sorted_cors[:top_k]
    return rst_matter, rst_corr


@trace()
def listmatter(path):
    li = []
    for filename in os.listdir(path):
        if "DS_S" in filename:
            continue
        if "txt" not in filename:
            continue
        if "total" in filename or "sum" in filename or "tif" in filename:
            continue
        if "I" in filename or "Br" in filename or len(filename) <= 4:
            continue

        matter = filename[0:-4]
        matter = matter.strip()

        matter = float(matter)
        li.append(matter)
    li = sorted(li)
    log.debug("matters:[{}]".format(li))
    return li
