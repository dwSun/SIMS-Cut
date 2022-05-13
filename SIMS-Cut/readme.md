# SIMS-Cut 使用说明

## Python 环境安装

在 SIMS-Cut 目录下开启命令行，执行下列命令，创建 conda 虚拟环境。
```sh
conda create -n sims-cut python=3.8
```
其中 `sims-cut` 是虚拟环境的名字，`python=3.8` 是希望建立虚拟环境的 python 版本，请视具体需求填写。

在收到 `Proceed ([y]/n)?` 提示时按 y +回车以继续。虚拟环境建立成功后，请使用以下代码：

```sh
conda activate sims-cut
pip install -r requirements.txt
```
进入刚建立的虚拟环境，并且安装 requirements.txt 里的所需 python 模块。

## Python 使用说明

请按注释编辑 config.py 中相应的项目，在 process_data_path 项设置好质谱仪数据目录的路径，之后直接在该目录开启命令行，运行下述代码即可：

```sh
python SIMSCutpipe.py
```

> 注意，运行该命令之后，会在 process_data_path 指定的目录下生成 process 目录。请确保运行该代码之前 process 目录不存在，不然上述代码会报错。

SIMSCutpipe.py 成功执行后，会在 /SIMS-Cut/run_code 目录下生成以 `config` 开头， `.m` 结尾的配置文件。

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

请在 MATLAB 程序中打开“数字化病理”目录，并且在 "AddOn", "sample_data" 和 "SIMS-Cut" 文件夹上逐个右键，每个都选择“添加到路径” - “选定到文件夹和子文件夹”。

添加完成后，在 数字化病理/SIMS-Cut/SIMS-Cut/run_code 目录下找到 run_config.m 文件，在该文件上右键选择运行即可。

如需查看编译可执行文件相关的更多信息，请参考[附录 - 在 MATLAB 中编译可执行文件](#在-matlab-中编译可执行文件)。

## MATLAB Runtime 安装与配置

> 若用户没有 MATLAB 主程序，则在运行可执行文件前，需要进行 MATLAB Runtime 的配置。

在 MATLAB 官网下载 [MATLAB R2019b 的 Runtime 安装包](https://ww2.mathworks.cn/products/compiler/matlab-runtime.html)，下载后得到 MCR_R2019b_glnxa64_installer.zip

在压缩包所在目录右键开启终端，在命令行使用以下代码解压文件：

```sh
unzip MCR_R2019b_glnxa64_installer.zip
```

进入解压后的文件夹，右键开启终端，输入 `./install` 开始 Runtime 的安装，在弹出的安装界面按提示点选下一步直到“文件夹选择”。将安装路径设置为合适的位置，**并且请记住该路径（接下来的设置中还会用到，并且直接影响程序可否执行）**。本手册中安装路径以 /home/robu/Matlab_runtime 为例。

### 运行可执行文件

将 /SIMS-Cut/SIMS-Cut/run_code 文件夹下 config 开头的文件复制到可执行文件输出目录中的 /run_config/for_testing 文件夹。

输入 `./run_run_config.sh </home/robu/Matlab_runtime>` 运行程序（`</home/robu/Matlab_runtime>` 请替换为 runtime 文件夹的安装路径）。

## 附录

### 在 MATLAB 中编译可执行文件

> 若最终用户没有条件使用收费的 MATLAB 程序，软件提供者可提供经过编译、只需要 MATLAB Runtime 支持即可运行的程序（该运行环境可免费下载使用）。

在 MATLAB 中运行 run_config.m 文件，选择最上面导航栏的 APP 一栏，再选择 Application Compiler，在弹出的窗口中找到 'Add main file'，点击并选择原始文件（run_config.m），其余选项可以默认，最后点击绿色打勾图标，在弹出的“保存工程”选择工程文件的保存目录（同时会在相同目录下生成包含编译后的程序的同名文件夹，默认为 /run_config）。等待“打包”完成，点击打开输出目录，在 /run_config/for_testing 目录下找到输出的可执行文件。