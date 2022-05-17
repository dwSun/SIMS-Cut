# SIMS-Cut 使用说明

## Python 环境安装

在 SIMS-Cut 目录下开启命令行，执行下列命令，创建 conda 虚拟环境。
```bash
conda create -n sims-cut python=3.8
```
其中 `sims-cut` 是虚拟环境的名字，`python=3.8` 是希望建立虚拟环境的 python 版本，请视具体需求填写。

在收到 `Proceed ([y]/n)?` 提示时按 y + 回车以继续。虚拟环境建立成功后，请使用以下代码：

```bash
conda activate sims-cut
pip install -r requirements.txt
```

进入刚建立的虚拟环境，并且安装 **requirements.txt** 里的所需 python 模块。

## Python 使用说明

请按注释编辑 config.py 中相应的项目，（**请注意，所有的路径应只有大小写字母、数字和下划线，不能以数字开头，请勿带空格**），之后直接在该目录开启命令行，激活刚刚创建的虚拟环境，运行下述代码即可：

```sh
conda activate sims-cut
python SIMSCutpipe.py
```

> 注意，运行该命令之后，会在 **process_data_path** 指定的目录下生成 **process** 及每个数据对应的目录。请确保运行该代码之前 **process** 下各数据对应的目录不存在，不然上述代码会报错。

SIMSCutpipe.py 成功执行后，会在** /SIMS-Cut/run_code** 目录下生成以 `config` 开头， `.m` 结尾的配置文件。

**每次 SIMSCutpipe.py 执行后不会删除已存在的配置文件，而下文 MATLAB 程序运行时会运行本目录中所有 config 开头的文件，请将不需要处理的 config 文件移动到 old 文件夹或者删除。**

## MATLAB 代码运行环境配置

> 本章节仅限可使用 MATLAB 主程序的用户参考，若无主程序请跳至 [MATLAB Runtime 安装与配置](#matlab-runtime-安装与配置)。

### MATLAB R2019b 及以上版本需要安装的组件

- MATLAB
- MATLAB Compiler
- Image Processing Toolbox
- Statistics and Machine Learning Toolbox
- Parallel Computing Toolbox

### 在 MATLAB GUI 中运行 .m 文件

请在 MATLAB 程序中打开“数字化病理”目录，并且在 **AddOn**, **sample_data** 和 **SIMS-Cut** 文件夹上逐个右键，每个都选择“添加到路径” - “选定到文件夹和子文件夹”。

添加完成后，在 数字化病理 **SIMS-Cut/SIMS-Cut/run_code** 目录下找到 **run_config.m** 文件，在该文件上右键选择运行即可。

如需查看编译可执行文件相关的更多信息，请参考[附录 - 在 MATLAB 中编译可执行文件](#在-matlab-中编译可执行文件)。

## MATLAB Runtime 安装与配置

> 若用户没有 MATLAB 主程序，则在运行可执行文件前，需要进行 MATLAB Runtime 的配置。

在 MATLAB 官网下载 [MATLAB R2019b 的 Runtime 安装包](https://ww2.mathworks.cn/products/compiler/matlab-runtime.html)，下载后得到 **MCR_R2019b_glnxa64_installer.zip**

在压缩包所在目录右键开启终端，在命令行使用以下代码解压文件：

```sh
unzip MCR_R2019b_glnxa64_installer.zip
```

进入解压后的文件夹，右键开启终端，输入 `./install` 开始 Runtime 的安装，在弹出的安装界面按提示点选下一步直到“文件夹选择”。将安装路径设置为合适的位置，**并且请记住该路径（接下来的设置中还会用到，并且直接影响程序可否执行）**。本手册中安装路径以 **/home/robu/Matlab_runtime** 为例。

### 运行可执行文件

请下载本项目提供的可执行文件和其环境设置脚本，即 **run_run_config.sh** 和 **run_config** 文件，并将其放置于 **数字化病理/SIMS-Cut/SIMS-Cut/run_code** 目录中，以下述方式执行

```bash
./run_executalbe.sh ./run_run_config.sh /home/robu/Matlab_runtime/v97
```

> 其中 **/home/robu/Matlab_runtime/** 为 MATLAB Runtime 的安装目录，请根据实际情况进行设置。

## 附录

### 在 MATLAB 中编译可执行文件

> 若最终用户没有条件使用收费的 MATLAB 程序，软件提供者可提供经过编译、只需要 MATLAB Runtime 支持即可运行的程序（该运行环境可免费下载使用）。

在 MATLAB 界面上，选择最上面导航栏的 APP 一栏，再选择 Application Compiler，在弹出的窗口中找到 'Add main file'，点击并选择原始文件（run_config.m），其余选项可以默认，最后点击 Package 按钮，在弹出的“保存工程”选择工程文件的保存目录。等待“打包”完成，点击打开输出目录，在 **for_redistribution_files_only** 目录下即可找到输出的可执行文件和对应的脚本文件。
