#pragma once
#include <string>

class Option
{
public:
    int year;
    int month;
    int before;
    int after;
    int row_num;

    Option();
    void parseArgs(int argc, char *argv[]);
};
