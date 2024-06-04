cmake_minimum_required(VERSION 3.10)

project(RISC_V_CPU_SIM)

find_package(verilator HINTS $ENV{VERILATOR_ROOT})

add_subdirectory(third_party)

add_subdirectory(cpp)
