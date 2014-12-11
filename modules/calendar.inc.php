<?
class Calendar
{
    var $startDay = 0;
    var $startMonth = 1;
    var $dayNames = array("пн", "вт", "ср", "чт", "пт", "сб", "вс");
    var $monthNames = array("Январь", "Февраль", "Март", "Апрель", "Май", "Июнь",
        "Июль", "Август", "Сентябрь", "Октябрь", "Ноябрь", "Декабрь");
    var $daysInMonth = array(31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31);

    function Calendar()
    {
    }

    function getDayName($d, $m, $y)
    {
        return date("w",mktime(0,0,0,$m,$d,$y));
    }
    /*
        Get the array of strings used to label the days of the week. This array contains seven
        elements, one for each day of the week. The first entry in this array represents Sunday.
    */
    function getDayNames()
    {
        return $this->dayNames;
    }


    /*
        Set the array of strings used to label the days of the week. This array must contain seven
        elements, one for each day of the week. The first entry in this array represents Sunday.
    */
    function setDayNames($names)
    {
        $this->dayNames = $names;
    }

    /*
        Get the array of strings used to label the months of the year. This array contains twelve
        elements, one for each month of the year. The first entry in this array represents January.
    */
    function getMonthNames()
    {
        return $this->monthNames;
    }

    /*
        Set the array of strings used to label the months of the year. This array must contain twelve
        elements, one for each month of the year. The first entry in this array represents January.
    */
    function setMonthNames($names)
    {
        $this->monthNames = $names;
    }



    /*
        Gets the start day of the week. This is the day that appears in the first column
        of the calendar. Sunday = 0.
    */
    function getStartDay()
    {
        return $this->startDay;
    }

    /*
        Sets the start day of the week. This is the day that appears in the first column
        of the calendar. Sunday = 0.
    */
    function setStartDay($day)
    {
        $this->startDay = $day;
    }


    /*
        Gets the start month of the year. This is the month that appears first in the year
        view. January = 1.
    */
    function getStartMonth()
    {
        return $this->startMonth;
    }

    /*
        Sets the start month of the year. This is the month that appears first in the year
        view. January = 1.
    */
    function setStartMonth($month)
    {
        $this->startMonth = $month;
    }


    /*
        Return the URL to link to in order to display a calendar for a given month/year.
        You must override this method if you want to activate the "forward" and "back"
        feature of the calendar.

        Note: If you return an empty string from this function, no navigation link will
        be displayed. This is the default behaviour.

        If the calendar is being displayed in "year" view, $month will be set to zero.
    */
    function getCalendarLink($month, $year)
    {
        $m = $this->getMonthNames();
        return "{$m[$month]}";
    }

    /*
        Return the URL to link to  for a given date.
        You must override this method if you want to activate the date linking
        feature of the calendar.

        Note: If you return an empty string from this function, no navigation link will
        be displayed. This is the default behaviour.
    */
    function getDateLink($day, $month, $year)
    {
        global $DB;
        $date = $year."-".$month."-".$day;
        $rs = $DB->Execute("SELECT news FROM T_NEWS WHERE date=?", Array('date' => $date));
        if (!$rs->EOF)
        {
            return "news={$rs->fields[news]}";
        }
        else return "";
    }


    /*
        Return the HTML for the current month
    */
    function getCurrentMonthView()
    {
        $d = getdate(time());
        return $this->getMonthView($d["mday"], $d["mon"], $d["year"]);
    }


    /*
        Return the HTML for the current year
    */
    function getCurrentYearView()
    {
        $d = getdate(time());
        return $this->getYearView($d["year"]);
    }


    /*
        Return the HTML for a specified month
    */
    function getMonthView($date, $month, $year)
    {
        return $this->getMonthHTML($date, $month, $year);
    }


    /*
        Return the HTML for a specified year
    */
    function getYearView($year)
    {
        return $this->getYearHTML($year);
    }



    /********************************************************************************

    The rest are private methods. No user-servicable parts inside.

    You shouldn't need to call any of these functions directly.

     *********************************************************************************/


    /*
        Calculate the number of days in a month, taking into account leap years.
    */
    function getDaysInMonth($month, $year)
    {
        if ($month < 1 || $month > 12)
        {
            return 0;
        }

        $d = $this->daysInMonth[$month - 1];

        if ($month == 2)
        {
            // Check for leap year
            // Forget the 4000 rule, I doubt I'll be around then...

            if ($year%4 == 0)
            {
                if ($year%100 == 0)
                {
                    if ($year%400 == 0)
                    {
                        $d = 29;
                    }
                }
                else
                {
                    $d = 29;
                }
            }
        }

        return $d;
    }


    /*
        Generate the HTML for a given month
    */
    //$date = DD-MM-YYYY
    function GetXML($date)
    {
        $curr_day = strtotime($date);
        $input_day = $curr_day;
        $d = date('d',$curr_day);
        $m = date('m',$curr_day);
        $y = date('Y',$curr_day);
        $M = date('n',$curr_day);
        $monthName = $this->monthNames[$M - 1];
        $firstmonthday = strtotime("01-".$m."-".$y);
        $lastmonthday = strtotime($this->getDaysInMonth($M, $y)."-".$m."-".$y);
        $firstmonthweekday = date('w',$firstmonthday);
        if($firstmonthweekday == 0)$firstmonthweekday = 7;
        $firstweekday = $firstmonthday - ($firstmonthweekday-1)*86400;
        $counter = $firstweekday;
        $curr_day = $firstweekday;
        $week = array();
        $month = array();
        $j=1;
        while($counter < $lastmonthday)
        {
            $i=1;
            do
            {
                $week[$i] = $curr_day;
                $curr_day = $curr_day + 86400;
                $i++;
            }
            while($i<=7);
            $counter = $week[7];
            $month[$j] = $week;
            $j++;
        }
        $s.="<CALENDAR>";
        //Выведем дни недели
        $s .= "
        <WEEKDAY weekday=\"1\" short=\"пн.\">Понедельник</WEEKDAY>
        <WEEKDAY weekday=\"2\" short=\"вт.\">Вторник</WEEKDAY>
        <WEEKDAY weekday=\"3\" short=\"ср.\">Среда</WEEKDAY>
        <WEEKDAY weekday=\"4\" short=\"чт.\">Четверг</WEEKDAY>
        <WEEKDAY weekday=\"5\" short=\"пт.\">Пятница</WEEKDAY>
        <WEEKDAY weekday=\"6\" short=\"сб.\">Суббота</WEEKDAY>
        <WEEKDAY weekday=\"7\" short=\"вс.\">Воскресенье</WEEKDAY>
        ";
        $s .= "<MONTH name=\"$monthName\">";
        foreach($month as $m=>$week)
        {
            $s.="<WEEK>";
            foreach($week as $weekday=>$day)
            {
                $fulldate = date('d-m-Y',$day);
                $d = date('d',$day);
                $m = date('n',$day);
                if($day != $input_day)$curr="no";
                else $curr="yes";
                if($day <= $input_day)$past="yes";
                else $past="no";
                if($day <= $lastmonthday && $day >= $firstmonthday)$s.="<DATE month=\"$m\" is_current=\"$curr\" weekday=\"$weekday\" fulldate=\"$fulldate\" datetime=\"$day\" past=\"$past\">".$d."</DATE>";
                else $s.="<DATE month=\"$m\" weekday=\"$weekday\" fulldate=\"$fulldate\" datetime=\"$day\" past=\"$past\">".$d."</DATE>";
            }
            $s.="</WEEK>";
        }
        $s .= "</MONTH>";
        foreach($this->monthNames as $k => $v)$s .= "<MONTHNAME num=\"".++$k."\">".$v."</MONTHNAME>";
        $s.="</CALENDAR>";
        return $s;
    }


    /*
        Adjust dates to allow months > 12 and < 0. Just adjust the years appropriately.
        e.g. Month 14 of the year 2001 is actually month 2 of year 2002.
    */
    function adjustDate($month, $year)
    {
        $a = array();
        $a[0] = $month;
        $a[1] = $year;

        while ($a[0] > 12)
        {
            $a[0] -= 12;
            $a[1]++;
        }

        while ($a[0] <= 0)
        {
            $a[0] += 12;
            $a[1]--;
        }

        return $a;
    }

}

?>