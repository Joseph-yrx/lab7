#include "cal.h"
#include <fmt/core.h>
#include <iostream>
#include <algorithm>

// 判断闰年（回溯格里高利历）
bool Calendar::isLeapYear(int y)
{
    return (y % 400 == 0) || (y % 4 == 0 && y % 100 != 0);
}

// 每月天数
int Calendar::daysInMonth(int y, int m)
{
    static const int mdays[12] = {31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};
    if (m == 2 && isLeapYear(y))
        return 29;
    return mdays[m - 1];
}

// 星期计算，0=Sunday..6=Saturday，使用Sakamoto算法，支持任意整数年份
int Calendar::dayOfWeek(int y, int m, int d)
{
    static const int t[] = {0, 3, 2, 5, 0, 3, 5, 1, 4, 6, 2, 4};
    int yy = y;
    if (m < 3)
        yy -= 1;
    int w = (yy + yy / 4 - yy / 100 + yy / 400 + t[m - 1] + d) % 7;
    if (w < 0)
        w += 7;
    return w;
}

Calendar::Calendar(const Option &opt)
    : year(opt.year), month(opt.month), before(opt.before), after(opt.after), row_num(opt.row_num) {}

std::vector<std::string> Calendar::generateMonth(int y, int m)
{
    std::vector<std::string> lines;
    static const char *monthNames[12] = {
        "January", "February", "March", "April", "May", "June",
        "July", "August", "September", "October", "November", "December"};
    std::string title = fmt::format("{:^20}", std::string(monthNames[m - 1]) + " " + std::to_string(y));
    lines.push_back(title);
    lines.push_back("Su Mo Tu We Th Fr Sa");

    int start_day = dayOfWeek(y, m, 1);
    int dim = daysInMonth(y, m);

    std::string week;
    for (int i = 0; i < start_day; ++i)
        week += "   ";
    for (int day = 1; day <= dim; ++day)
    {
        week += fmt::format("{:>2} ", day);
        if ((start_day + day) % 7 == 0 || day == dim)
        {
            lines.push_back(week);
            week.clear();
        }
    }
    while (lines.size() < 8)
        lines.push_back("");
    return lines;
}

std::vector<std::vector<std::string>> Calendar::generateMultiMonths()
{
    std::vector<std::vector<std::string>> months;
    if (month == 0)
    {
        for (int m = 1; m <= 12; ++m)
            months.push_back(generateMonth(year, m));
    }
    else
    {
        int start = month - before;
        int end = month + after;
        for (int m = start; m <= end; ++m)
        {
            int y = year;
            int cm = m;
            // 调整超出范围的月数
            while (cm > 12)
            {
                cm -= 12;
                y += 1;
            }
            while (cm < 1)
            {
                cm += 12;
                y -= 1;
            }
            if (y < 1)
                continue; // 可视需求决定是否跳过公元前
            months.push_back(generateMonth(y, cm));
        }
    }
    return months;
}

void Calendar::printCalendar()
{
    auto months = generateMultiMonths();
    int total = months.size();
    for (int i = 0; i < total; i += row_num)
    {
        int end = std::min(i + row_num, total);
        for (int line = 0; line < 8; ++line)
        {
            for (int j = i; j < end; ++j)
            {
                std::string txt = (line < months[j].size() ? months[j][line] : "");
                std::cout << fmt::format("{:<22}", txt);
            }
            std::cout << std::endl;
        }
        std::cout << std::endl;
    }
}