#include "option.h"
#include <iostream>
#include <ctime>
#include <unistd.h> // getopt
#include <cstdlib>  // exit
#include <string>

Option::Option() : year(0), month(0), before(0), after(0), row_num(3) {}

void Option::parseArgs(int argc, char *argv[])
{
    int opt;
    bool has_month = false; // 标记是否已通过选项指定月份
    bool has_year = false;  // 标记是否已通过选项指定年份
    while ((opt = getopt(argc, argv, "A:B:d:r:m:")) != -1)
    {
        switch (opt)
        {
        case 'A':
            try
            {
                after = std::stoi(optarg);
                if (after < 0)
                {
                    throw std::invalid_argument("");
                }
            }
            catch (const std::exception &e)
            {
                std::cerr << "Usage: cal [-A months] [-B months] [-d yyyy-mm] [-r rownum] [-m month] [yyyy]\n";
                std::cerr << "error: Invalid argument for option -A\n";
                exit(1);
            }
            break;
        case 'B':
            try
            {
                before = std::stoi(optarg);
                if (before < 0)
                {
                    throw std::invalid_argument("");
                }
            }
            catch (const std::exception &e)
            {
                std::cerr << "Usage: cal [-A months] [-B months] [-d yyyy-mm] [-r rownum] [-m month] [yyyy]\n";
                std::cerr << "error: Invalid argument for option -B\n";
                exit(1);
            }
            break;
        case 'd':
        {
            try
            {
                std::string date = optarg;
                size_t pos = date.find('-');
                if (pos == std::string::npos)
                {
                    throw std::invalid_argument("");
                }
                year = std::stoi(date.substr(0, pos));
                month = std::stoi(date.substr(pos + 1));

                // 验证年份有效性
                if (year <= 0)
                {
                    throw std::invalid_argument("");
                }
            }
            catch (const std::exception &e)
            {
                std::cerr << "Usage: cal [-A months] [-B months] [-d yyyy-mm] [-r rownum] [-m month] [yyyy]\n";
                std::cerr << "error: Invalid argument for option -d\n";
                exit(1);
            }
            if (month < 0 || month > 12)
            {
                std::cerr << "Usage: cal [-A months] [-B months] [-d yyyy-mm] [-r rownum] [-m month] [yyyy]\n";
                std::cerr << "error: Month must be between 1-12, use 0 for the whole year\n";
                exit(1);
            }
            has_month = true;
            has_year = true;
            break;
        }
        case 'r':
            try
            {
                row_num = std::stoi(optarg);
            }
            catch (const std::exception &e)
            {
                std::cerr << "Usage: cal [-A months] [-B months] [-d yyyy-mm] [-r rownum] [-m month] [yyyy]\n";
                std::cerr << "error: Invalid row number value for option -r\n";
                exit(1);
            }
            if (row_num < 1)
            {
                std::cerr << "Usage: cal [-A months] [-B months] [-d yyyy-mm] [-r rownum] [-m month] [yyyy]\n";
                std::cerr << "error: Number of months per row must be at least 1\n";
                exit(1);
            }
            break;
        case 'm':
            try
            {
                month = std::stoi(optarg);
            }
            catch (const std::exception &e)
            {
                std::cerr << "Usage: cal [-A months] [-B months] [-d yyyy-mm] [-r rownum] [-m month] [yyyy]\n";
                std::cerr << "error: Invalid month value for option -m\n";
                exit(1);
            }
            if (month < 0 || month > 12)
            {
                std::cerr << "Usage: cal [-A months] [-B months] [-d yyyy-mm] [-r rownum] [-m month] [yyyy]\n";
                std::cerr << "error: Month must be between 1-12, use 0 for the whole year\n";
                exit(1);
            }
            has_month = true;
            break;
        default:
            std::cerr << "Usage: cal [-A months] [-B months] [-d yyyy-mm] [-r rownum] [-m month] [yyyy]\n";
            exit(1);
        }
    }

    int position = argc - optind;
    if (position >= 1 && !has_year)
    {
        try
        {
            year = std::stoi(argv[optind++]);
            --position;
            has_year = true;

            // 验证年份有效性
            if (year <= 0)
            {
                throw std::invalid_argument("");
            }
        }
        catch (const std::exception &e)
        {
            std::cerr << "Usage: cal [-A months] [-B months] [-d yyyy-mm] [-r rownum] [-m month] [yyyy]\n";
            std::cerr << "error: Invalid year value\n";
            exit(1);
        }
    }

    if (position >= 1 && !has_month)
    {
        try
        {
            month = std::stoi(argv[optind++]);
            --position;
            has_month = true;
        }
        catch (const std::exception &e)
        {
            std::cerr << "Usage: cal [-A months] [-B months] [-d yyyy-mm] [-r rownum] [-m month] [yyyy]\n";
            std::cerr << "error: Invalid month value\n";
            exit(1);
        }
        if (month < 0 || month > 12)
        {
            std::cerr << "Usage: cal [-A months] [-B months] [-d yyyy-mm] [-r rownum] [-m month] [yyyy]\n";
            std::cerr << "error: Month must be between 1-12, use 0 for the whole year\n";
            exit(1);
        }
    }

    // 检查是否还有多余参数
    if (optind < argc)
    {
        std::cerr << "Usage: cal [-A months] [-B months] [-d yyyy-mm] [-r rownum] [-m month] [yyyy]\n";
        std::cerr << "error: Too many arguments\n";
        exit(1);
    }

    if (!has_year)
    {
        // 未指定年份，使用当前年份和月份
        std::time_t t = std::time(nullptr);
        std::tm *now = std::localtime(&t);
        year = now->tm_year + 1900;
        if (!has_month)
        {
            month = now->tm_mon + 1;
        }
    }
    else
    {
        // 已指定年份，但未指定月份，默认显示全年
        if (!has_month)
        {
            month = 1;  // 任意月份（仅用于计算起始点，实际生成全年）
            before = 0; // 前推0个月
            after = 11; // 后推11个月，共12个月
        }
    }
}
