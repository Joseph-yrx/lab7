#pragma once
#include <vector>
#include <string>
#include "Option.h"

class Calendar
{
public:
    Calendar(const Option &opt);

    void printCalendar();

private:
    int year;
    int month;
    int before;
    int after;
    int row_num;

    std::vector<std::string> generateMonth(int y, int m);
    std::vector<std::vector<std::string>> generateMultiMonths();
};
