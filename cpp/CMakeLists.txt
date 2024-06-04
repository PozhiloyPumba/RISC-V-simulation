set(TARGET sim)

add_executable(${TARGET} main.cpp)

target_link_libraries(${TARGET} PRIVATE CLI11::CLI11 elfio::elfio)

verilate(${TARGET} 
    SOURCES V.v 
    VERILATOR_ARGS --trace
    INCLUDE_DIRS 
        "../verilog"
)