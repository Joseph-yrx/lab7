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

    // 支持任意公元日期（含公元1年之前）
    static bool isLeapYear(int y);
    static int daysInMonth(int y, int m);
    static int dayOfWeek(int y, int m, int d);
};
