#include <iostream>

#include <CLI/CLI.hpp>
#include <elfio/elfio.hpp>

#include "VV.h"
#include "VV_V.h"
#include "VV_RV32.h"
#include "VV_IMEM.h"
#include "VV_FETCH.h"
#include <verilated_vcd_c.h>

int main(int argc, char *argv[]) {
    Verilated::commandArgs(argc, argv);

    CLI::App cli_app("RISC-V CPU");
    std::string path_to_exec{};
    bool is_trace = false;

    cli_app.add_option("-p,--path", path_to_exec, "Path to executable file")
        ->required();
    cli_app.add_flag("--trace,-t", is_trace, "Path for trace dump");

    CLI11_PARSE(cli_app, argc, argv);

    auto top_module = std::make_unique<VV>();
    Verilated::traceEverOn(true);
    auto vcd = std::make_unique<VerilatedVcdC>();
    top_module->trace(vcd.get(), 10); // Trace 10 levels of hierarchy
    vcd->open("out.vcd");

    ELFIO::elfio m_reader{};
    if (!m_reader.load(path_to_exec))
        throw std::invalid_argument("Bad ELF filename : " + path_to_exec);
    if (m_reader.get_class() != ELFIO::ELFCLASS32) {
        throw std::runtime_error("Wrong ELF file class.");
    }

    if (m_reader.get_encoding() != ELFIO::ELFDATA2LSB) {
        throw std::runtime_error("Wrong ELF encoding.");
    }
    ELFIO::Elf_Half seg_num = m_reader.segments.size();

    for (size_t seg_i = 0; seg_i < seg_num; ++seg_i) {
        const ELFIO::segment *segment = m_reader.segments[seg_i];
        if (segment->get_type() != ELFIO::PT_LOAD) {
            continue;
        }
        uint32_t address = segment->get_virtual_address();

        size_t filesz = static_cast<size_t>(segment->get_file_size());
        size_t memsz = static_cast<size_t>(segment->get_memory_size());

        if (filesz) {
            const auto *begin =
                reinterpret_cast<const uint8_t *>(segment->get_data());
            uint8_t *dst =
                reinterpret_cast<uint8_t *>(top_module->V->RV32->fetch->imem->mem_buff);
            std::copy(begin, begin + filesz, dst + address);
        }
    }

    vluint64_t vtime = 0;
    int clock = 0;
    top_module->clk = 1;
    top_module->rst = 0;
    
    top_module->V->RV32->fetch->entry = m_reader.get_entry();
    top_module->V->RV32->fetch->PC = m_reader.get_entry();

    int inst_counter = 0;
    int tackt = 0;

    while (!Verilated::gotFinish()) {
        vtime += 1;
        if (vtime % 8 == 0) {
            // switch the clock
            clock ^= 1;
            tackt += clock;        
            top_module->rst = 0;
        }
        if (vtime == 1000) {
            break;
        }
        top_module->clk = clock;
        top_module->eval();
        vcd->dump(vtime);
    }

    top_module->final();
    vcd->close();

    return 0;
}