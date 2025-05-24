#include "cal.h"
#include <fmt/core.h>
#include <fmt/chrono.h>
#include <iostream>
#include <ctime>
#include <algorithm>

Calendar::Calendar(const Option &opt)
    : year(opt.year), month(opt.month), before(opt.before), after(opt.after), row_num(opt.row_num) {}

std::vector<std::string> Calendar::generateMonth(int y, int m)
{
    std::vector<std::string> lines;
    // 初始化指定年月的第一天
    std::tm tm = {0, 0, 0, 1, m - 1, y - 1900};
    std::mktime(&tm);
    // 前两行
    std::string month_name = fmt::format("{:%B}", tm);
    lines.push_back(fmt::format("{:^20}", month_name + " " + std::to_string(y)));
    lines.push_back("Su Mo Tu We Th Fr Sa");

    int start_day = tm.tm_wday;
    // 计算当月天数
    std::tm tm_last = tm;
    tm_last.tm_mon += 1;
    tm_last.tm_mday = 0;
    std::mktime(&tm_last);
    int days_in_month = tm_last.tm_mday;

    std::string week;
    // 打印第一天之前的空格
    for (int i = 0; i < start_day; ++i)
        week += "   ";
    // 生成日历，逢七换行
    for (int day = 1; day <= days_in_month; ++day)
    {
        week += fmt::format("{:>2} ", day);
        if ((start_day + day) % 7 == 0 || day == days_in_month)
        {
            lines.push_back(week);
            week.clear();
        }
    }
    // 对齐格式
    while (lines.size() < 8)
        lines.push_back("");

    return lines;
}

std::vector<std::vector<std::string>> Calendar::generateMultiMonths()
{
    std::vector<std::vector<std::string>> months;
    // 进行多个月份的打印
    if (month == 0)
    { // 整年打印
        for (int m = 1; m <= 12; ++m)
            months.push_back(generateMonth(year, m));
    }
    else
    { // 针对-A和-B进行多个月份的打印
        int start_month = month - before;
        int end_month = month + after;
        for (int m = start_month; m <= end_month; ++m)
        {
            int y = year + m / 12;
            int cm = m % 12;
            if (cm <= 0)
            {
                y -= 1;
                cm += 12;
            }
            if (y < 1)
                continue;

            months.push_back(generateMonth(y, cm));
        }
    }

    return months;
}
// 打印
void Calendar::printCalendar()
{
    auto months = generateMultiMonths();
    int total_months = months.size();

    for (int i = 0; i < total_months; i += row_num)
    { // 控制每行的月份数
        int end = std::min(i + row_num, total_months);
        for (int line = 0; line < 8; ++line)
        {
            for (int j = i; j < end; ++j)
            {
                std::string padded = (line < months[j].size()) ? months[j][line] : "";
                std::cout << fmt::format("{:<22}", padded);
            }
            std::cout << std::endl;
        }
        std::cout << std::endl;
    }
}