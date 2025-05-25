@echo off
set "SCRIPT_DIR=%~dp0"
set "CAL_EXE=%SCRIPT_DIR%..\build\cal.exe"
set "TEMP_FILE=temp.txt"

echo ==================== CAL COMMAND TEST SUITE ====================
echo Testing cal command with various arguments and combinations...
echo.

:: 测试 1：无参数，显示当前月份（2025 年 5 月）
echo Testing: No parameters
%CAL_EXE% > %TEMP_FILE%
findstr /C:"May 2025" %TEMP_FILE% >nul
if %errorlevel%==0 (
    echo Test 1: PASS
) else (
    echo Test 1: FAIL - Expected 'May 2025' not found
    type %TEMP_FILE%
)
del %TEMP_FILE%
echo.

:: 测试 2：-d 2025-05
echo Testing: -d 2025-05
%CAL_EXE% -d 2025-05 > %TEMP_FILE%
findstr /C:"May 2025" %TEMP_FILE% >nul
if %errorlevel%==0 (
    echo Test 2: PASS
) else (
    echo Test 2: FAIL - Expected 'May 2025' not found
    type %TEMP_FILE%
)
del %TEMP_FILE%
echo.

:: 测试 3：-m 5
echo Testing: -m 5
"%CAL_EXE%" -m 5 > "%TEMP_FILE%"
findstr /C:"May 2025" %TEMP_FILE% >nul
if %errorlevel%==0 (
    echo Test 3: PASS
) else (
    echo Test 3: FAIL - Expected 'May 2025' not found
    type %TEMP_FILE%
)
del %TEMP_FILE%
echo.

:: 测试 4：显示 2025 年全年
echo Testing: Year 2025
%CAL_EXE% 2025 > %TEMP_FILE%
findstr /C:"January 2025" %TEMP_FILE% >nul
if %errorlevel%==0 (
    echo Test 4: PASS
) else (
    echo Test 4: FAIL - Expected 'January 2025' not found
    type %TEMP_FILE%
)
del %TEMP_FILE%
echo.

:: 测试 5：位置参数 2025 5
echo Testing: Month and year: 2025 5
call "%CAL_EXE%" 2025 5 > %TEMP_FILE%

findstr /C:"May 2025" %TEMP_FILE% >nul
if %errorlevel%==0 (
    echo Test 5: PASS
) else (
    echo Test 5: FAIL - Expected 'May 2025' not found
    type %TEMP_FILE%
)
del %TEMP_FILE%
echo.

:: 测试 6：-A 2（当前月之后2个月）
echo Testing: -A 2
%CAL_EXE% -A 2 > %TEMP_FILE%
findstr /C:"July 2025" %TEMP_FILE% >nul
if %errorlevel%==0 (
    echo Test 6: PASS
) else (
    echo Test 6: FAIL - Expected 'July 2025' not found
    type %TEMP_FILE%
)
del %TEMP_FILE%
echo.

:: 测试 7：-B 1（当前月之前1个月）
echo Testing: -B 1
%CAL_EXE% -B 1 > %TEMP_FILE%
findstr /C:"April 2025" %TEMP_FILE% >nul
if %errorlevel%==0 (
    echo Test 7: PASS
) else (
    echo Test 7: FAIL - Expected 'April 2025' not found
    type %TEMP_FILE%
)
del %TEMP_FILE%
echo.

:: 测试 8：-A 2 -B 1（前后月份组合）
echo Testing: -A 2 -B 1
%CAL_EXE% -A 2 -B 1 > %TEMP_FILE%
findstr /C:"April 2025" %TEMP_FILE% >nul
if %errorlevel%==0 (
    findstr /C:"July 2025" %TEMP_FILE% >nul
    if %errorlevel%==0 (
        echo Test 8: PASS
    ) else (
        echo Test 8: FAIL - Expected 'July 2025' not found
        type %TEMP_FILE%
    )
) else (
    echo Test 8: FAIL - Expected 'April 2025' not found
    type %TEMP_FILE%
)
del %TEMP_FILE%
echo.

:: 测试 9：-d 2024-12 -A 1 -B 1（指定日期前后月份）
echo Testing: -d 2024-12 -A 1 -B 1
%CAL_EXE% -d 2024-12 -A 1 -B 1 > %TEMP_FILE%
findstr /C:"November 2024" %TEMP_FILE% >nul
if %errorlevel%==0 (
    findstr /C:"January 2025" %TEMP_FILE% >nul
    if %errorlevel%==0 (
        echo Test 9: PASS
    ) else (
        echo Test 9: FAIL - Expected 'January 2025' not found
        type %TEMP_FILE%
    )
) else (
    echo Test 9: FAIL - Expected 'November 2024' not found
    type %TEMP_FILE%
)
del %TEMP_FILE%
echo.

:: 测试 10：-r 1 2025（全年单列显示）
echo Testing: -r 1 2025
%CAL_EXE% -r 1 2025 > %TEMP_FILE%
findstr /C:"January 2025" %TEMP_FILE% >nul
if %errorlevel%==0 (
    echo Test 10: PASS
) else (
    echo Test 10: FAIL - Expected 'January 2025' not found
    type %TEMP_FILE%
)
del %TEMP_FILE%
echo.

:: 测试 11：-r 4 -A 3（多列显示多个月）
echo Testing: -r 4 -A 3
%CAL_EXE% -r 4 -A 3 > %TEMP_FILE%
findstr /C:"August 2025" %TEMP_FILE% >nul
if %errorlevel%==0 (
    echo Test 11: PASS
) else (
    echo Test 11: FAIL - Expected 'August 2025' not found
    type %TEMP_FILE%
)
del %TEMP_FILE%
echo.

:: 测试 12：-m 2 -A 1 -B 1 -r 3（指定月前后多列显示）
echo Testing: -m 2 -A 1 -B 1 -r 3
%CAL_EXE% -m 2 -A 1 -B 1 -r 3 > %TEMP_FILE%
findstr /C:"January 2025" %TEMP_FILE% >nul
if %errorlevel%==0 (
    findstr /C:"March 2025" %TEMP_FILE% >nul
    if %errorlevel%==0 (
        echo Test 12: PASS
    ) else (
        echo Test 12: FAIL - Expected 'March 2025' not found
        type %TEMP_FILE%
    )
) else (
    echo Test 12: FAIL - Expected 'January 2025' not found
    type %TEMP_FILE%
)
del %TEMP_FILE%
echo.

:: 测试 13：-d 2023-06 -r 2 -A 2（指定日期多列显示）
echo Testing: -d 2023-06 -r 2 -A 2
%CAL_EXE% -d 2023-06 -r 2 -A 2 > %TEMP_FILE%
findstr /C:"August 2023" %TEMP_FILE% >nul
if %errorlevel%==0 (
    echo Test 13: PASS
) else (
    echo Test 13: FAIL - Expected 'August 2023' not found
    type %TEMP_FILE%
)
del %TEMP_FILE%
echo.

:: 新增测试用例
:: 测试 14：混合参数 -m 12 -A 2 -B 1 -r 2 2024（指定年的月份前后显示）
echo Testing: -m 12 -A 2 -B 1 -r 2 2024
%CAL_EXE% -m 12 -A 2 -B 1 -r 2 2024 > %TEMP_FILE%
findstr /C:"November 2024" %TEMP_FILE% >nul
if %errorlevel%==0 (
    findstr /C:"February 2025" %TEMP_FILE% >nul
    if %errorlevel%==0 (
        echo Test 14: PASS
    ) else (
        echo Test 14: FAIL - Expected 'February 2025' not found
        type %TEMP_FILE%
    )
) else (
    echo Test 14: FAIL - Expected 'November 2024' not found
    type %TEMP_FILE%
)
del %TEMP_FILE%
echo.

:: 测试 15：跨年显示 -d 2024-12 -A 2 -B 1（跨年度月份显示）
echo Testing: -d 2024-12 -A 2 -B 1
%CAL_EXE% -d 2024-12 -A 2 -B 1 > %TEMP_FILE%
findstr /C:"November 2024" %TEMP_FILE% >nul
if %errorlevel%==0 (
    findstr /C:"February 2025" %TEMP_FILE% >nul
    if %errorlevel%==0 (
        echo Test 15: PASS
    ) else (
        echo Test 15: FAIL - Expected 'February 2025' not found
        type %TEMP_FILE%
    )
) else (
    echo Test 15: FAIL - Expected 'November 2024' not found
    type %TEMP_FILE%
)
del %TEMP_FILE%
echo.

:: 测试 16：最大月份显示 -d 2024-12 -A 11（显示一整年）
echo Testing: -d 2024-12 -A 11
%CAL_EXE% -d 2024-12 -A 11 > %TEMP_FILE%
findstr /C:"December 2024" %TEMP_FILE% >nul
if %errorlevel%==0 (
    findstr /C:"November 2025" %TEMP_FILE% >nul
    if %errorlevel%==0 (
        echo Test 16: PASS
    ) else (
        echo Test 16: FAIL - Expected 'November 2025' not found
        type %TEMP_FILE%
    )
) else (
    echo Test 16: FAIL - Expected 'December 2024' not found
    type %TEMP_FILE%
)
del %TEMP_FILE%
echo.

:: 测试 17：行号参数 -r 6 2025（6列显示全年）
echo Testing: -r 6 2025
%CAL_EXE% -r 6 2025 > %TEMP_FILE%
findstr /C:"January 2025" %TEMP_FILE% >nul
if %errorlevel%==0 (
    findstr /C:"June 2025" %TEMP_FILE% >nul
    if %errorlevel%==0 (
        echo Test 17: PASS
    ) else (
        echo Test 17: FAIL - Expected 'June 2025' not found
        type %TEMP_FILE%
    )
) else (
    echo Test 17: FAIL - Expected 'January 2025' not found
    type %TEMP_FILE%
)
del %TEMP_FILE%
echo.

:: 测试 18：多列多月份组合 -m 3 -A 5 -B 2 -r 4 2025（显示7个月，4列）
echo Testing: -m 3 -A 5 -B 2 -r 4 2025
%CAL_EXE% -m 3 -A 5 -B 2 -r 4 2025 > %TEMP_FILE%
findstr /C:"January 2025" %TEMP_FILE% >nul
if %errorlevel%==0 (
    findstr /C:"August 2025" %TEMP_FILE% >nul
    if %errorlevel%==0 (
        echo Test 18: PASS
    ) else (
        echo Test 18: FAIL - Expected 'August 2025' not found
        type %TEMP_FILE%
    )
) else (
    echo Test 18: FAIL - Expected 'January 2025' not found
    type %TEMP_FILE%
)
del %TEMP_FILE%
echo.

:: 测试 19：负数月份参数 -d 2025-01 -B 2（显示前两个月）
echo Testing: -d 2025-01 -B 2
%CAL_EXE% -d 2025-01 -B 2 > %TEMP_FILE%
findstr /C:"November 2024" %TEMP_FILE% >nul
if %errorlevel%==0 (
    findstr /C:"January 2025" %TEMP_FILE% >nul
    if %errorlevel%==0 (
        echo Test 19: PASS
    ) else (
        echo Test 19: FAIL - Expected 'January 2025' not found
        type %TEMP_FILE%
    )
) else (
    echo Test 19: FAIL - Expected 'November 2024' not found
    type %TEMP_FILE%
)
del %TEMP_FILE%
echo.

:: 测试 20：最小年份边界 1900
echo Testing: Year 1900
%CAL_EXE% 1900 > %TEMP_FILE%
findstr /C:"January 1900" %TEMP_FILE% >nul
if %errorlevel%==0 (
    echo Test 20: PASS
) else (
    echo Test 20: FAIL - Expected 'January 1900' not found
    type %TEMP_FILE%
)
del %TEMP_FILE%
echo.

:: 测试 21：闰年2月检查
echo Testing: Leap year February 2024
%CAL_EXE% 2024 2 > %TEMP_FILE%
findstr /C:"29" %TEMP_FILE% >nul
if %errorlevel%==0 (
    echo Test 21: PASS
) else (
    echo Test 21: FAIL - Expected '29' not found
    type %TEMP_FILE%
)
del %TEMP_FILE%
echo.

:: 测试 22：非闰年2月检查
echo Testing: Non-leap year February 2025
%CAL_EXE% 2025 2 > %TEMP_FILE%
findstr /C:"28" %TEMP_FILE% >nul
if %errorlevel%==0 (
    echo Test 22: PASS
) else (
    echo Test 22: FAIL - Expected '28' not found
    type %TEMP_FILE%
)
del %TEMP_FILE%
echo.

:: 测试 23：无效月份参数 -m 13
echo Testing Error: -m 13
%CAL_EXE% -m 13 > %TEMP_FILE% 2>&1
findstr /C:"Usage" %TEMP_FILE% >nul
if %errorlevel%==0 (
    echo Test 23: PASS - Error detected
) else (
    echo Test 23: FAIL - Expected error 'Usage' not found
    type %TEMP_FILE%
)
del %TEMP_FILE%
echo.

:: 测试 24：无效年份参数 -d 0000-01
echo Testing Error: -d 0000-01
%CAL_EXE% -d 0000-01 > %TEMP_FILE% 2>&1
findstr /C:"Usage" %TEMP_FILE% >nul
if %errorlevel%==0 (
    echo Test 24: PASS - Error detected
) else (
    echo Test 24: FAIL - Expected error 'Usage' not found
    type %TEMP_FILE%
)
del %TEMP_FILE%
echo.

:: 测试 25：无效参数组合 -A -1
echo Testing Error: -A -1
%CAL_EXE% -A -1 > %TEMP_FILE% 2>&1
findstr /C:"Usage" %TEMP_FILE% >nul
if %errorlevel%==0 (
    echo Test 25: PASS - Error detected
) else (
    echo Test 25: FAIL - Expected error 'Usage' not found
    type %TEMP_FILE%
)
del %TEMP_FILE%
echo.

:: 测试 26：无效参数 -x
echo Testing Error: -x
%CAL_EXE% -x > %TEMP_FILE% 2>&1
findstr /C:"Usage" %TEMP_FILE% >nul
if %errorlevel%==0 (
    echo Test 26: PASS - Error detected
) else (
    echo Test 26: FAIL - Expected error 'Usage' not found
    type %TEMP_FILE%
)
del %TEMP_FILE%
echo.

:: 测试 27：过多参数
echo Testing Error: Too many arguments
%CAL_EXE% 1 2 3 4 > %TEMP_FILE% 2>&1
findstr /C:"Usage" %TEMP_FILE% >nul
if %errorlevel%==0 (
    echo Test 27: PASS - Error detected
) else (
    echo Test 27: FAIL - Expected error 'Usage' not found
    type %TEMP_FILE%
)
del %TEMP_FILE%
echo.

echo ==================== ALL TESTS COMPLETED ====================