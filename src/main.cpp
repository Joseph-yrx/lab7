#include "option.h"
#include "cal.h"

int main(int argc, char *argv[])
{
    Option opt;
    opt.parseArgs(argc, argv);

    Calendar cal(opt);
    cal.printCalendar();

    return 0;
}
