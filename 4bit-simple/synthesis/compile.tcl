analyze -format verilog ../rtl/*.v
elaborate core
link
uniquify

compile -area_effort max

redirect cell.rep {report_cell}
redirect area.rep {report_area}
exit
