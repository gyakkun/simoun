#!/bin/bash
# Simoun the script
# author : gyakkun
# date   : 2018/8/10

# 脚本目标

# 预设环境: 

# 系统: Linux Based, x86_64
# 装有module用以切换环境, 可用mpi库包括但不限于openmpi, mpich, psxe(?), 可能的环境有nvidia cuda

# 1. 环境变量测试: 脚本内使用module, 检测环境变量, 测试命令包括但不限于env -grep, mpirun, mpicc, mpiicc (intel specified)
# 2. 网络带宽测试: 运行mpi测试(OSU/IMB), 可指定通信机器
# 3. CPU主频压力测试
# 4. 内存压力测试
# 5. 磁盘大负荷写入测试

# Define the common path and filenames of modulefiles

M_OMPI="ompi"
M_PSXE="psxe"
M_MPICH="mpich"
M_CUDA="cuda"
module_to_test=(
"$M_MPICH"
"$M_OMPI"
"$M_PSXE"
)

# Start - From nodesource_setup.sh

if test -t 1; then # if terminal
    ncolors=$(which tput > /dev/null && tput colors) # supports color
    if test -n "$ncolors" && test $ncolors -ge 8; then
        termcols=$(tput cols)
        bold="$(tput bold)"
        underline="$(tput smul)"
        standout="$(tput smso)"
        normal="$(tput sgr0)"
        black="$(tput setaf 0)"
        red="$(tput setaf 1)"
        green="$(tput setaf 2)"
        yellow="$(tput setaf 3)"
        blue="$(tput setaf 4)"
        magenta="$(tput setaf 5)"
        cyan="$(tput setaf 6)"
        white="$(tput setaf 7)"
    fi
fi

bail() {
    print_error 'Error executing command, exiting'
    exit 1
}

exec_cmd_nobail() {
    print_normal "+ $1"
    bash -c "$1"
}

exec_cmd() {
    exec_cmd_nobail "$1" || bail
}

# End - From nodesource_setup.sh

print_normal() {
	echo "${normal}$@${normal}"
}

print_info() {
	echo "${cyan}[Info] $@${normal}"
}

print_warning() {
	echo "${yellow}[Warning] $@${normal}"
}

print_error() {
	echo "${red}${bold}[Error]${normal} ${red}$@${normal}"
}

print_success() {
	echo "${green}[Success] $@${normal}"
}

test_module_installed() {
	type module &> /dev/null
	if [ $? -eq 1 ]; then
		print_error "Module hasn't been installed yet, please install it first."
		print_info "In Debian-based distro, use \"sudo apt-get install environment-modules\""
		exit 1
	else
		print_success "Module installation detected."
	fi
}

test_avail_module(){
	test_module_installed

	for m_name in ${module_to_test[@]}
	do
		if [ `module avail | grep -c $m_name` -ne 0 ]; then
			print_info "$m_name exists"
		else
			print_warning "$m_name doesn't exist"
		fi
	done
}

# 将module avail 中的得到的版本号提取出来, 逐一载入测试

test_module_by_ver_num(){
# echo ${module_to_test[@]}

	for m_name in ${module_to_test[@]}
	do
		ctr=0
		for i in `module avail | egrep "$m_name[^ ]+" -o`
		do
			items[ctr]=$i
			ctr=`expr $ctr + 1`
		done
		for i in ${items[@]}
		do
# 将下面这句替换成module load 即可
			exec_cmd "module load $i"
			exec_cmd "module unload $i"
		done
	done
	
}

test_avail_module

test_module_by_ver_num

exit 0
