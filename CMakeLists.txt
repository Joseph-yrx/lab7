cmake_minimum_required(VERSION 3.11)  # FetchContent 需要 CMake 3.11 或更高版本
project(cal_project)

set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# 启用 FetchContent 模块
include(FetchContent)

# 配置 fmt 库的 FetchContent
FetchContent_Declare(
    fmt
    GIT_REPOSITORY https://github.com/fmtlib/fmt.git
    GIT_TAG 11.2.0  # 指定要下载的版本
    DOWNLOAD_DIR ${CMAKE_BINARY_DIR}/3rd/fmt  # 下载位置
)

# 处理下载和更新（若需要）
FetchContent_MakeAvailable(fmt)

# 创建可执行文件，指定正确的目标名称和源文件路径
add_executable(cal
    src/main.cpp
    src/option.cpp
    src/cal.cpp
)

# 链接 fmt 库到目标文件
target_link_libraries(cal PRIVATE fmt::fmt)




