<?
class Registratura extends Module
{
    function __construct($data, $realm)
    {
        parent::__construct($data, $realm);
        $this->ns = 'registratura';
    }

    function GetPanelXML()
    {
        global $DB, $cfg, $Processor, $Cache, $Session, $Error;
        $view = new Viewer();
        $calendar = new Calendar();
        /*$cmd = array_shift($this->cmd);//обрезаем (panel)
        $cmd = array_shift($this->cmd);*/
        $this->cmd = explode('/',$_GET['action']);
        $cmd = array_shift($this->cmd);
        $xml .= "<PANELXML ns=\"".$this->ns."\" action=\"{$_GET['action']}\" leftmenu=\"hide\">";
        switch($cmd)
        {
            case 'registratura':
                $cmd = array_shift($this->cmd);
                if(!$_GET[day])$_GET[day] = date('d-m-Y',time());
                $currday = strtotime($_GET[day]);
                $xml .= $calendar->GetXML($_GET[day]);
                switch($cmd)
                {
                    case 'schedule':
                        $cmd = array_shift($this->cmd);
                        switch($cmd)
                        {
                            case 'add':
                                $xml .= "<DOCTORS>";
                                $xml .= $this->GetDocXML();
                                $xml .= "</DOCTORS>";
                                if($_POST)
                                {
                                    $cday = $_POST['day'];
                                    $POST['login'] = $_POST['doctor'];
                                    $POST['day'] = strtotime($_POST['day']);
                                    if($_POST['work'] == 'yes')
                                    {
                                        $POST['spec'] = $_POST['spec'];
                                        $POST['from'] = strtotime($_POST['day']." ".$_POST['wfrom']);
                                        $POST['to'] = strtotime($_POST['day']." ".$_POST['wto']);
                                        $POST['pfrom'] = strtotime($_POST['day']." ".$_POST['pfrom']);
                                        $POST['pto'] = strtotime($_POST['day']." ".$_POST['pto']);
                                        if($_POST['jfrom'] != 0)$POST['jfrom'] = strtotime($_POST['day']." ".$_POST['jfrom']);
                                        if($_POST['jto'] != 0)$POST['jto'] = strtotime($_POST['day']." ".$_POST['jto']);
                                        $POST['cab'] = $_POST['cab'];
                                        if($POST['from'] > $POST['to'])$err = 'неправильный интервал работы врача';
                                        elseif($POST['pfrom'] > $POST['pto'])$err = 'неправильный интервал приема врача';
                                        $POST['talonstotal'] = $_POST['talonstotal'];
                                        $POST['talons'] = $_POST['talons'];
                                        if($_POST['talonstotal'] == 0)$err = 'Общее количество талонов не заполнено';
                                        //elseif($POST['pfrom'] < $POST['from'] || $POST['pfrom'] > $POST['to'])$err = 'неправильное начало приема врача';
                                        //elseif($POST['pto'] > $POST['to'] || $POST['pto'] < $POST['from'])$err = 'неправильное окончание приема врача';
                                        //elseif($POST['talons']*$POST['talonstotal']*60 > $POST['pto']-$POST['pfrom'])$err = 'неправильный интервал приема или количество талонов, не хватает времени приема';
                                        else $err = NULL;
                                        foreach($POST as $k=>$v)
                                        {
                                            $names .= "`".$k."`, ";
                                            $values .= "'".$v."', ";
                                        }
                                        if($err == NULL)
                                        {
                                            $query = "INSERT INTO `T_DAILYSCHEDULE` (".substr($names, 0, -2).") VALUES (".substr($values, 0, -2).")";
                                            $rs=$DB->Execute($query);
                                            header("Location: /panel/reg/schedule");
                                        }
                                        else $xml .= "<ERROR>".$err."</ERROR>";
                                    }
                                    elseif($_POST['work'] == 'no')
                                    {
                                        $POST['remark'] = $_POST['remark'];
                                        foreach($POST as $k=>$v)
                                        {
                                            $names .= "`".$k."`, ";
                                            $values .= "'".$v."', ";
                                        }
                                        $query = "INSERT INTO `T_DAILYSCHEDULE` (".substr($names, 0, -2).") VALUES (".substr($values, 0, -2).")";
                                        $rs=$DB->Execute($query);
                                        header("Location: /panel/reg/schedule?day=".$cday);
                                    }
                                }
                                break;
                            case 'edit':
                                if($_GET[talon] && $_GET[newtime] && $_GET[newtnum] && $_GET[id])
                                {
                                    $rs = $DB->Execute("SELECT * FROM T_DAILYSCHEDULE WHERE id=?", $_GET[id]);
                                    $fullTime = strtotime(date("d-m-Y", $rs->fields['day'])." ".$_GET[newtime]);
                                    $DB->Execute("UPDATE T_TALONS SET time=?, tnum=? WHERE id=?", Array($fullTime, $_GET[newtnum], $_GET[talon]));
                                    header("Location: /panel/reg/schedule/edit?id=".$_GET[id]);
                                }
                                $xml = "<DOCTORS>";
                                $xml .= $this->GetDocXML();
                                $xml .= "</DOCTORS>";
                                $rs = $DB->Execute("SELECT * FROM T_DAILYSCHEDULE WHERE id=?", Array($_GET['id']));
                                if(!$rs->EOF)
                                {
                                    $xml .= "<SCHEDULE ";
                                    foreach($rs->fields as $k=>$v)
                                    {
                                        //datestart	dateend	from to	pfrom pto jfrom jto
                                        if($k == 'from'||$k == 'to'||$k == 'pfrom'||$k == 'pto'||$k == 'jfrom'||$k == 'jto')
                                        {
                                            if($v != '0')$xml .= $k."=\"".date("H:i", $v)."\" ";
                                        }
                                        elseif($k == 'day') $xml .= $k."=\"".date("d-m-Y", $v)."\" ";
                                        else $xml .= $k."=\"".$v."\" ";
                                    }
                                    $xml .= ">";


                                    $talontime = ($rs->fields[pto] - $rs->fields[pfrom]) / $rs->fields[talonstotal];
                                    for($i=$rs->fields[pfrom]; $i<$rs->fields[pto]; $i=$i+$talontime)
                                    {
                                        $arr[date('H:i', $i)] = ++$j;
                                    }
                                    $existsTalons = Array();
                                    $rss = $DB->Execute("SELECT * FROM T_TALONS WHERE schedule=?", Array($_GET['id']));
                                    while(!$rss->EOF)
                                    {
                                        $t = date('H:i', $rss->fields["time"]);
                                        foreach($rss->fields as $k=>$v)$existsTalons[$t][$k] = $v;
                                        $rss->MoveNext();
                                    }
                                    $rss->close();
                                    if(is_array($arr))
                                    {
                                        $xml .= "<TIMESET cab=\"{$cab}\" in_time=\"{$f['in_time']}\">";
                                        foreach($arr as $k=>$v)
                                        {
                                            $xml .= "<TIME id=\"{$v}\" time=\"".$k."\">";
                                            if($existsTalons[$k])
                                            {
                                                $xml .= "<TALON id=\"{$existsTalons[$k][id]}\">";
                                                foreach($existsTalons[$k] as $kk=>$vv)
                                                {
                                                    if($kk == 'time')$xml .= "<FIELD name=\"{$kk}\">".date('H:i', $vv)."</FIELD>";
                                                    else $xml .= "<FIELD name=\"{$kk}\">".$vv."</FIELD>";
                                                }
                                                $xml .= "</TALON>";
                                            }
                                            unset($existsTalons[$k]);
                                            $xml .= "</TIME>";
                                        }
                                        foreach($existsTalons as $k=>$v)
                                        {
                                            $xml .= "<TALON id=\"{$existsTalons[$k][id]}\">";
                                            foreach($existsTalons[$k] as $kk=>$vv)
                                            {
                                                if($kk == 'time')$xml .= "<FIELD name=\"{$kk}\">".date('H:i', $vv)."</FIELD>";
                                                else $xml .= "<FIELD name=\"{$kk}\">".$vv."</FIELD>";
                                            }
                                            $xml .= "</TALON>";
                                        }
                                        $xml .= "</TIMESET>";
                                    }
                                    $xml .="</SCHEDULE>";
                                    $rs->MoveNext();
                                }
                                $rs->close();

                                if($_POST)
                                {
                                    $POST['day'] = strtotime($_POST['day']);
                                    if($_POST['work'] == 'yes')
                                    {
                                        $POST['spec'] = $_POST['spec'];
                                        $POST['in_time'] = $_POST['in_time'];
                                        $POST['from'] = strtotime($_POST['day']." ".$_POST['wfrom']);
                                        $POST['to'] = strtotime($_POST['day']." ".$_POST['wto']);
                                        $POST['pfrom'] = strtotime($_POST['day']." ".$_POST['pfrom']);
                                        $POST['pto'] = strtotime($_POST['day']." ".$_POST['pto']);
                                        if($_POST['jfrom'] != 0)$POST['jfrom'] = strtotime($_POST['day']." ".$_POST['jfrom']);
                                        if($_POST['jto'] != 0)$POST['jto'] = strtotime($_POST['day']." ".$_POST['jto']);
                                        $POST['talonstotal'] = $_POST['talonstotal'];
                                        $POST['talons'] = $_POST['talons'];
                                        $POST['cab'] = $_POST['cab'];
                                        if($POST['from'] > $POST['to'])$err = 'неправильный интервал работы врача';
                                        elseif($POST['pfrom'] > $POST['pto'])$err = 'неправильный интервал приема врача';
                                        //elseif($POST['pfrom'] < $POST['from'] || $POST['pfrom'] > $POST['to'])$err = 'неправильное начало приема врача';
                                        //elseif($POST['pto'] > $POST['to'] || $POST['pto'] < $POST['from'])$err = 'неправильное окончание приема врача';
                                        //elseif($POST['talons']*$POST['talonstotal']*60 > $POST['pto']-$POST['pfrom'])$err = 'неправильный интервал приема или количество талонов, не хватает времени приема';
                                        else $err = NULL;
                                        $id=$_POST['id'];

                                        foreach($POST as $k=>$v)$str .= "`".$k."`='".$v."', ";
                                        if($err == NULL)
                                        {
                                            $query = "UPDATE `T_DAILYSCHEDULE` SET ".substr($str, 0, -2)." WHERE id=".$id;
                                            $rs=$DB->Execute($query);
                                            header("Location: /panel/reg/schedule");
                                        }
                                        else $xml .= "<ERROR>".$err."</ERROR>";
                                    }
                                    elseif($_POST['work'] == 'no')
                                    {
                                        $POST['remark'] = $_POST['remark'];
                                        foreach($POST as $k=>$v)
                                        {
                                            $names .= "`".$k."`, ";
                                            $values .= "'".$v."', ";
                                        }
                                        $query = "INSERT INTO `T_DAILYSCHEDULE` (".substr($names, 0, -2).") VALUES (".substr($values, 0, -2).")";
                                        $rs=$DB->Execute($query);
                                        header("Location: /panel/reg/schedule");
                                    }
                                }
                                break;
                            case 'delete':
                                if($_GET[id])
                                {
                                    $DB->Execute("DELETE FROM T_DAILYSCHEDULE WHERE id=?", $_GET[id]);
                                    header("Location: /panel/reg/schedule?day=".$_GET[day]);
                                }
                                else header("Location: /panel/reg/schedule");

                                break;
                            case 'auto':
                                if($_POST[start] && $_POST[end])
                                {
                                    $login = $_POST['login'];
                                    $start = strtotime($_POST['start']);
                                    $end = strtotime($_POST['end']);
                                    $days = Array();//массив содержит все дни промежутка
                                    for($i=$start; $i<=$end; $i+=86400)array_push($days, $i);
                                    //$template = $_POST['template'];
                                    if(is_Array($_POST['template']))$template = $_POST['template'];
                                    else $template[] = $_POST['template'];
                                    $validdays=Array();
                                    foreach($template as $key=>$t)
                                    {

                                        //`login`, `spec`, `cab`, `from`, `to`, `pfrom`, `pto`, `jfrom`, `jto`, `in_time`, `talonstotal`, `talons`, `remark`
                                        $rs=$DB->Execute("SELECT `login`, `spec`, `cab`, `from`, `to`, `pfrom`, `pto`, `jfrom`, `jto`, `in_time`, `talonstotal`, `talons`, `remark`, `mod` FROM T_TEMPLATE WHERE template=?", Array($t));
                                        foreach($rs->fields as $k=>$v)$sched[$k]=$v;
                                        $rs->close();
                                        $mod = $sched['mod'];
                                        unset($sched['mod']);
                                        $rs=$DB->Execute("SELECT n1, n2, n3, n4, n5, n6, n7 FROM T_TEMPLATE WHERE template=?", Array($t));
                                        foreach($rs->fields as $k=>$v)$weekdays[substr($k, 1)]=$v;
                                        foreach($days as $k=>$v)
                                        {
                                            $monthday = date ('j', $v);
                                            if($mod != 0)
                                            {
                                                if($monthday % 2)$even = 1;
                                                else $even = 2;
                                                if($even == (int)$mod)$eventy = true;
                                                else $eventy = false;
                                            }
                                            else $eventy = true;
                                            if($eventy == true && $weekdays[date('N', $v)] == 1)
                                            {
                                                //$sched['day'] = $v;
                                                $validdays[]=$v;
                                            }
                                        }
                                        foreach($validdays as $k=>$v)
                                        {
                                            if($sched['from'] != 0)
                                            {
                                                $sched['from'] = strtotime(date("d-m-Y ",$v).date("H:i", $sched['from']));
                                                $sched['to'] = strtotime(date("d-m-Y ",$v).date("H:i", $sched['to']));
                                            }
                                            $sched['pfrom'] = strtotime(date("d-m-Y ",$v).date("H:i", $sched['pfrom']));
                                            $sched['pto'] = strtotime(date("d-m-Y ",$v).date("H:i", $sched['pto']));
                                            if($sched['jfrom'] != 0)
                                            {
                                                $sched['jfrom'] = strtotime(date("d-m-Y ",$v).date("H:i", $sched['jfrom']));
                                                $sched['jto'] = strtotime(date("d-m-Y ",$v).date("H:i", $sched['jto']));
                                            }
                                            $rs = $DB->Execute("SELECT * FROM T_DAILYSCHEDULE WHERE day=? AND login=?", Array($v, $sched['login']));
                                            if(!$rs->EOF){
                                                while(!$rs->EOF)
                                                {
                                                    if((int)$sched['pfrom'] >= (int)$rs->fields['pto'] || (int)$sched['pto'] <= (int)$rs->fields['pfrom'])$test = 0;
                                                    else $test=1;
                                                    $rs->MoveNext();
                                                }
                                                $rs->close();
                                            }
                                            else $test = 0;
                                            if($test == 0)
                                            {
                                                $names = '';
                                                $values = '';
                                                foreach($sched as $kk=>$vv)
                                                {
                                                    $names .= "`".$kk."`, ";
                                                    $values .= "'".$vv."', ";
                                                }
                                                $names = $names."`day`";
                                                $values = $values."'".$v."'";
                                                //$names = substr($names, 0, -2);
                                                //$values = substr($values, 0, -2);
                                                $query = "INSERT INTO `T_DAILYSCHEDULE` (".$names.") VALUES (".$values.")";
                                                $rs=$DB->Execute($query);
                                                //echo $query."<br />";
                                                //echo $test."==<br />";
                                            }
                                        }
                                    }
                                    header("Location: /panel/reg/schedule?day=".$_POST[start]);
                                }
                                if($_POST[day] && $_POST[login])
                                {
                                    $login = $_POST['login'];
                                    $day = strtotime($_POST['day']);
                                    $template = $_POST['template'];
                                    $wday = 'n'.date('N', $day);
                                    //`login`, `spec`, `cab`, `from`, `to`, `pfrom`, `pto`, `jfrom`, `jto`, `in_time`, `talonstotal`, `talons`, `remark`
                                    $rs=$DB->Execute("SELECT `login`, `spec`, `cab`, `from`, `to`, `pfrom`, `pto`, `jfrom`, `jto`, `in_time`, `talonstotal`, `talons`, `remark` FROM T_TEMPLATE WHERE template=? AND ".$wday."=1", $template);
                                    foreach($rs->fields as $k=>$v)$sched[$k]=$v;
                                    foreach($sched as $k=>$v)
                                    {
                                        $names .= "`".$k."`, ";
                                        $values .= "'".$v."', ";
                                    }
                                    $rs->close();
                                    $rs=$DB->Execute("SELECT n1, n2, n3, n4, n5, n6, n7 FROM T_TEMPLATE WHERE template=?", Array($template));
                                    $currnames = $names." day";
                                    $currvalues = $values." ".$day;
                                    $query = "INSERT INTO `T_DAILYSCHEDULE` (".$currnames.") VALUES (".$currvalues.")";
                                    $rs=$DB->Execute($query);
                                    header("Location: /panel/reg/schedule?day=".$_GET[day]);
                                }


                                $day = strtotime($_GET[day]);
                                $login = $_GET[login];
                                if($_GET[type]=='weekly')
                                {
                                    $weekday = date('N', $day);
                                    $weekstart = $day - (86400*($weekday-1));
                                    $weekend = $day + (86400*(7-$weekday));
                                    $xml.="<WEEKLY start=\"".date("d-m-Y",$weekstart)."\" end=\"".date("d-m-Y",$weekend)."\"/>";
                                    $xml.=$this->GetDocXML($login);
                                    $rs=$DB->Execute("SELECT * FROM T_TEMPLATE WHERE login=?", $login);
                                    $xml .= "<TEMPLATES>";
                                    while(!$rs->EOF)
                                    {
                                        $xml .= "<TEMPLATE template=\"{$rs->fields[template]}\" login=\"{$rs->fields[login]}\" spec=\"{$rs->fields[spec]}\" in_time=\"{$rs->fields[in_time]}\" n1=\"{$rs->fields[n1]}\" n2=\"{$rs->fields[n2]}\" n3=\"{$rs->fields[n3]}\" n4=\"{$rs->fields[n4]}\" n5=\"{$rs->fields[n5]}\" n6=\"{$rs->fields[n6]}\" n7=\"{$rs->fields[n7]}\" mod=\"{$rs->fields[mod]}\">";
                                        if($rs->fields[remark] != '')$xml .= "<MESSAGE>".$rs->fields[remark]."</MESSAGE>";
                                        else
                                        {

                                            $lrs = $DB->Execute("SELECT * FROM T_USERS WHERE login=?", Array($rs->fields[login]));
                                            $xml .= "<DOCTOR ";
                                            foreach($lrs->fields as $k=>$v)$xml .= $k."=\"".$v."\" ";
                                            $xml .= "/>";
                                            $xml .= "<WORKTIME from=\"".date("H:i", $rs->fields[from])."\" to=\"".date("H:i", $rs->fields[to])."\"/>";
                                            $xml .= "<RECIPIENTTIME from=\"".date("H:i", $rs->fields[pfrom])."\" to=\"".date("H:i", $rs->fields[pto])."\" talons=\"".$rs->fields[talonstotal]."\" onlinetalons=\"".$rs->fields[talons]."\"/>";
                                            if($rs->fields[jfrom] != 0 && $rs->fields[jto] != 0)
                                            {
                                                $xml .= "<JORNALTIME from=\"".date("H:i", $rs->fields[jfrom])."\" to=\"".date("H:i", $rs->fields[jto])."\"/>";
                                            }
                                        }
                                        $xml .= "</TEMPLATE>";
                                        $rs->MoveNext();
                                    }
                                    $rs->close();
                                    $xml .= "</TEMPLATES>";
                                }
                                if($_GET[type] == 'daily')
                                {
                                    $cday = strtotime($_GET[day]);
                                    $xml.=$this->GetDocXML($login);
                                    $wday = 'n'.date('N', $day);
                                    $rs=$DB->Execute("SELECT * FROM T_TEMPLATE WHERE login=? AND ".$wday."=1", $login);
                                    $xml .= "<TEMPLATES>";
                                    while(!$rs->EOF)
                                    {
                                        $xml .= "<TEMPLATE template=\"{$rs->fields[template]}\" login=\"{$rs->fields[login]}\" spec=\"{$rs->fields[spec]}\" in_time=\"{$rs->fields[in_time]}\" n1=\"{$rs->fields[n1]}\" n2=\"{$rs->fields[n2]}\" n3=\"{$rs->fields[n3]}\" n4=\"{$rs->fields[n4]}\" n5=\"{$rs->fields[n5]}\" n6=\"{$rs->fields[n6]}\" n7=\"{$rs->fields[n7]}\" mod=\"{$rs->fields[mod]}\">";
                                        if($rs->fields[remark] != '')$xml .= "<MESSAGE>".$rs->fields[remark]."</MESSAGE>";
                                        else
                                        {

                                            $lrs = $DB->Execute("SELECT * FROM T_USERS WHERE login=?", Array($rs->fields[login]));
                                            $xml .= "<DOCTOR ";
                                            foreach($lrs->fields as $k=>$v)$xml .= $k."=\"".$v."\" ";
                                            $xml .= "/>";
                                            $xml .= "<WORKTIME from=\"".date("H:i", $rs->fields[from])."\" to=\"".date("H:i", $rs->fields[to])."\"/>";
                                            $xml .= "<RECIPIENTTIME from=\"".date("H:i", $rs->fields[pfrom])."\" to=\"".date("H:i", $rs->fields[pto])."\" talons=\"".$rs->fields[talonstotal]."\" onlinetalons=\"".$rs->fields[talons]."\"/>";
                                            if($rs->fields[jfrom] != 0 && $rs->fields[jto] != 0)
                                            {
                                                $xml .= "<JORNALTIME from=\"".date("H:i", $rs->fields[jfrom])."\" to=\"".date("H:i", $rs->fields[jto])."\"/>";
                                            }
                                        }
                                        $xml .= "</TEMPLATE>";
                                        $rs->MoveNext();
                                    }
                                    $rs->close();
                                    $xml .= "</TEMPLATES>";
                                }
                                break;
                            default:
                                //$xml .= $this->GetDocXML(NULL, $currday);
                                $xml .= $this->GetScheduleXML(NULL, $currday);
                                break;
                        }
                        break;
                    case 'doctors':
                        if($_GET['login'])$xml .= $this->GetDocXML($_GET['login'], $currday);
                        else $xml .= $this->GetDocXML(NULL, $currday);
                        break;
                    case 'patients':
                        $cmd = array_shift($this->cmd);
                        switch($cmd)
                        {
                            case 'add':
                                if($_POST)
                                {
                                    //var_dump($_POST);
                                    $DB->Execute("DELETE FROM T_TALONS WHERE exptime < ? AND status != 1", Array(time()));
                                    $rs = $DB->Execute("SELECT * FROM T_TALONS WHERE login=? AND time=? AND dday=?", Array($_POST[login], $_POST[time], $_POST[day]));
                                    //echo $rs->sql;
                                    if($rs->EOF)
                                    {
                                        $day = strtotime($_POST['day']);
                                        $weekdayfield = "n".date('N', $day);
                                        //$query = "SELECT * FROM T_DAILYSCHEDULE WHERE login='".$_GET[login]."' AND day='".strtotime($_GET[day])."'";
                                        //echo $query;
                                        //$sh = $DB->Execute($query);
                                        $schedule = $_POST['schedule'];
                                        //$sh->close();

                                        $test = $DB->Execute("INSERT INTO T_TALONS (time, dday, login, exptime, schedule, tnum) VALUES (?,?,?,?,?,?)", Array($_POST['time'], $_POST['day'], $_POST['login'], time()+300, $schedule, $_POST['tnum']));
                                        //var_dump(Array($_POST['time'], $_POST['day'], $_POST['login'], time()+300, $schedule, $_POST['tnum']));
                                        $id = $DB->Identity();
                                        header("Location: /panel/reg/patients/edit?id=".$id);
                                    }
                                    else $xml.= "<ERROR>Время занято</ERROR>";
                                }
                                elseif($_GET['login'])
                                {
                                    $rs = $DB->Execute("SELECT * FROM T_TALONS WHERE dday=? AND login=?", Array($_GET[day], $_GET[login]));
                                    while(!$rs->EOF)
                                    {
                                        $talons[$rs->fields['time']]=$rs->fields['tnum'];
                                        $rs->MoveNext();
                                    }
                                    $rs->close();
                                    $weekdayfield = "n".date('N', $currday);
                                    $query = "SELECT * FROM T_DAILYSCHEDULE WHERE login='".$_GET[login]."' AND day='".strtotime($_GET[day])."'";
                                    $rs=$DB->Execute($query);
                                    if(!$rs->EOF)
                                    {
                                        while(!$rs->EOF)
                                        {
                                            $schedule = Array();
                                            foreach($rs->fields as $k=>$v)$schedule[$k] = $v;
                                            if($schedule[talonstotal] != 0)$talontime = ($schedule[pto] - $schedule[pfrom]) / $schedule[talonstotal];
                                            for($i=$schedule[pfrom]; $i<$schedule[pto]; $i=$i+$talontime)
                                            {
                                                $daytime = strtotime(date('d-m-Y', $currday)." ".date('H:i', $i).":00");
                                                $arr[$daytime] = date('H:i', $i);
                                            }
                                            if($schedule[jfrom] != 0 && $schedule[jto] != 0)
                                            {
                                                $jfrom = strtotime(date('d-m-Y', $currday)." ".date('H:i', $schedule[jfrom]).":00");
                                                $jto = strtotime(date('d-m-Y', $currday)." ".date('H:i', $schedule[jto]).":00");
                                                foreach($arr as $k=>$v)if($k > $jfrom && $k < $jto)$jornal[$k]=$v;
                                            }
                                            $cab=$rs->fields['cab'];
                                            $rs->MoveNext();
                                        }
                                        $rs->close();
                                    }
                                    else $xml .= "<ERROR>Нет расписания на этот день.</ERROR>";
                                    if(is_array($arr))
                                    {
                                        $xml .= "<TIMESET cab=\"{$cab}\" in_time=\"{$schedule['in_time']}\" schedule=\"{$schedule['id']}\">";
                                        $i = 1;
                                        foreach($arr as $k=>$v)
                                        {
                                            if($talons[$k] || $jornal[$k])$xml .= "<TIME id=\"{$k}\" tnum=\"".$i++."\" close=\"yes\">".$v."</TIME>";
                                            else $xml .= "<TIME id=\"{$k}\" tnum=\"".$i++."\">".$v."</TIME>";
                                        }
                                        $xml .= "</TIMESET>";
                                    }
                                    $xml .= $this->GetDocXML($_GET[login], $currday);
                                }
                                else
                                {
                                    $query = "SELECT * FROM T_USERS as a LEFT JOIN T_LOGIN_GROUP as b ON a.login=b.login WHERE b.gid=6";
                                    $rs = $DB->Execute($query);
                                    while(!$rs->EOF)
                                    {
                                        $xml .= $this->GetDocXML($rs->fields[login]);
                                        $rs->MoveNext();
                                    }
                                }
                                break;
                            case 'edit':
                                if($_POST)
                                {
                                    $fio = explode(" ", $_POST[fio]);
                                    $POST[tnum] = $_POST[tnum];
                                    $POST[f] = $fio[0];
                                    $POST[i] = $fio[1];
                                    $POST[o] = $fio[2];
                                    $POST[birth] = $_POST[birth];
                                    $POST[addr] = $_POST[addr];
                                    $POST[phone] = $_POST[phone];
                                    $POST[cartnum] = $_POST[cartnum];
                                    $POST[age] = $_POST[age];
                                    $POST[povod] = $_POST[povod];
                                    $POST[text] = $_POST[text];
                                    $POST[exptime] = 0;
                                    $POST[status] = 1;
                                    foreach($POST as $k=>$v)$str .= $k."='".$v."', ";
                                    $str = substr($str, 0, -2);
                                    $query = "UPDATE T_TALONS SET ".$str." WHERE id=".$_POST['id'];
                                    $DB->Execute($query);
                                    $rs = $DB->Execute("SELECT * FROM T_TALONS WHERE id=?", Array($_POST['id']));
                                    $day = $rs->fields['dday'];
                                    $rs->close();
                                    header("Location: /panel/reg/patients?day=".$day."&talon=".$_POST['id']);
                                }
                                $rs=$DB->Execute("SELECT * FROM T_TALONS WHERE id=".$_GET[id]);
                                $login = $rs->fields['login'];
                                $schedule = $rs->fields['schedule'];
                                $xml .= "<TALON ";
                                foreach($rs->fields as $k=>$v)
                                {
                                    if($k == 'time')$xml .= "daytime=\"".date('H:i', $v)."\" ";
                                    else $xml .= $k."=\"".$v."\" ";
                                }
                                $xml .= "/>";
                                $rs->close();

                                $rs = $DB->Execute("SELECT * FROM T_DAILYSCHEDULE WHERE id=".$schedule);
                                while(!$rs->EOF)
                                {
                                    $spec = $rs->fields['spec'];
                                    $xml .= "<SCHEDULE ";
                                    foreach($rs->fields as $k=>$v)$xml .= $k."=\"".$v."\" ";
                                    $xml .="/>";
                                    $rs->MoveNext();
                                }
                                $rs->close();
                                $xml .= $this->GetDocXML($login);
                                break;
                            case 'report':
                                if($_POST[month])
                                {

                                    $filename = date("Y-m", strtotime($_POST[month]));
                                    $cache = "cache/report/".$filename.".csv";
                                    $start = strtotime(date("Y-m-01 00:00", strtotime($_POST[month])))-86400;//компенсация за цикл
                                    $end = strtotime(date("Y-m-t 00:00", strtotime($_POST[month])));
                                    //echo ($end-$start)/86400;
                                    if(is_file($cache))unset($cache);
                                    $j = $start;
                                    $rs = $DB->Execute("SELECT * FROM T_TALONS LIMIT 1");
                                    foreach($rs->fields as $k=>$v)$out .= $k.";";
                                    $out .= "\r\n";
                                    $rs->close();
                                    for($i = $start; $i <= $end; $i = $i+86400)
                                    {
                                        $rs = $DB->Execute("SELECT * FROM T_TALONS WHERE time > ? AND time < ?", Array($j, $i));
                                        while(!$rs->EOF)
                                        {
                                            //$out .= "<TALON id=\"{$rs->fields[id]}\">";
                                            foreach($rs->fields as $k=>$v)
                                            {
                                                if($k == 'time')$out .= date('H:i', $v).";";//"<FIELD name=\"{$k}\">".date('H:i', $v)."</FIELD>";
                                                else $out .= $v.";"; //<FIELD name=\"{$k}\">".$v."</FIELD>";
                                            }
                                            //$out .= "</TALON>";
                                            $out .= "\r\n";
                                            $rs->MoveNext();
                                        }
                                        $rs->close();
                                        $j = $i;
                                        file_put_contents($cache, $out, FILE_APPEND | LOCK_EX);
                                        unset($out);
                                    }
                                }
                                $objects = scandir("cache/report");
                                $xml .= "<FILES>";
                                foreach($objects as $obj)
                                {
                                    if($obj != "." && $obj != "..")$xml .= "<FILE>/cache/report/".$obj."</FILE>";
                                }
                                $xml .= "</FILES>";
                                break;
                            default:
                                if($_GET[talon])
                                {
                                    $rs = $DB->Execute("SELECT * FROM T_TALONS WHERE id = ?", Array($_GET[talon]));
                                    $xml .= "<TALON id=\"{$rs->fields[id]}\">";
                                    foreach($rs->fields as $k=>$v)
                                    {
                                        if($k == 'time')$xml .= "<FIELD name=\"{$k}\">".date('H:i', $v)."</FIELD>";
                                        else $xml .= "<FIELD name=\"{$k}\">".$v."</FIELD>";
                                    }

                                    $rss = $DB->Execute("SELECT * FROM T_DAILYSCHEDULE WHERE id=".$rs->fields[schedule]);
                                    while(!$rss->EOF)
                                    {
                                        $spec = $rss->fields['spec'];
                                        $login = $rss->fields['login'];
                                        $xml .= "<SCHEDULE ";
                                        foreach($rss->fields as $k=>$v)
                                        {
                                            if(in_array($k, Array('from', 'to', 'pfrom', 'pto')))  $xml .= $k."=\"".date('H:i', $v)."\" ";
                                            else $xml .= $k."=\"".$v."\" ";
                                        }
                                        $xml .="/>";
                                        $rss->MoveNext();
                                    }
                                    $rss->close();
                                    $xml .= $this->GetDocXML($login);
                                    $xml .= $view->LoadListData(2);

                                    $xml .= "</TALON>";
                                }
                                else
                                {
                                    $currentdayreadable = date("d-m-Y", $currday);
                                    /*if($_GET[f] != '')$rs = $DB->Execute("SELECT * FROM T_TALONS WHERE f LIKE '".$_GET[f]."%'");
                                    elseif($_GET[doctor] != '') $rs = $DB->Execute("SELECT * FROM T_TALONS WHERE dday = ? AND login=?", Array($currentdayreadable, $_GET[doctor]));
                                    else $rs = $DB->Execute("SELECT * FROM T_TALONS WHERE dday = ?", Array($currentdayreadable));*/
                                    if($_GET[f])$sql .= "AND f LIKE '".$_GET[f]."%' ";
                                    if($_GET[doctor]) $sql .= "AND login=\"".$_GET[doctor]."\" ";
                                    if($_GET[day]) $sql .= "AND dday=\"".$currentdayreadable."\" ";
                                    $sql = "SELECT * FROM T_TALONS WHERE ".substr($sql, 4)."ORDER BY time ASC";
                                    $rs = $DB->Execute($sql);

                                    //var_dump($sql);
                                    while(!$rs->EOF)
                                    {
                                        $xml .= "<TALON id=\"{$rs->fields[id]}\">";
                                        foreach($rs->fields as $k=>$v)
                                        {
                                            if($k == 'time')$xml .= "<FIELD name=\"{$k}\">".date('H:i', $v)."</FIELD>";
                                            else $xml .= "<FIELD name=\"{$k}\">".$v."</FIELD>";
                                        }

                                        $rss = $DB->Execute("SELECT * FROM T_DAILYSCHEDULE WHERE id=".$rs->fields[schedule]);
                                        while(!$rss->EOF)
                                        {
                                            $spec = $rss->fields['spec'];
                                            $xml .= "<SCHEDULE ";
                                            foreach($rss->fields as $k=>$v)
                                            {
                                                if(in_array($k, Array('from', 'to', 'pfrom', 'pto')))
                                                {
                                                    $xml .= $k."=\"".date('H:i', $v)."\" ";
                                                }
                                                else $xml .= $k."=\"".$v."\" ";
                                            }
                                            $xml .="/>";
                                            $rss->MoveNext();
                                        }
                                        $rss->close();

                                        $xml .= "</TALON>";
                                        $rs->MoveNext();
                                    }
                                    $rs->close();
                                    $xml .= $this->GetDocXML();
                                }
                                break;
                        }
                        break;
                    case 'printable':
                        if($_GET[talon])
                        {
                            $rs = $DB->Execute("SELECT * FROM T_TALONS WHERE id = ?", Array($_GET[talon]));
                            $xml .= "<TALON id=\"{$rs->fields[id]}\">";
                            foreach($rs->fields as $k=>$v)
                            {
                                if($k == 'time')$xml .= "<FIELD name=\"{$k}\">".date('H:i', $v)."</FIELD>";
                                else $xml .= "<FIELD name=\"{$k}\">".$v."</FIELD>";
                            }

                            $rss = $DB->Execute("SELECT * FROM T_DAILYSCHEDULE WHERE id=".$rs->fields[schedule]);
                            while(!$rss->EOF)
                            {
                                $spec = $rss->fields['spec'];
                                $login = $rss->fields['login'];
                                $xml .= "<SCHEDULE ";
                                foreach($rss->fields as $k=>$v)
                                {
                                    if(in_array($k, Array('from', 'to', 'pfrom', 'pto')))  $xml .= $k."=\"".date('H:i', $v)."\" ";
                                    else $xml .= $k."=\"".$v."\" ";
                                }
                                $xml .="/>";
                                $rss->MoveNext();
                            }
                            $rss->close();
                            $xml .= $this->GetDocXML($login);
                            $xml .= "</TALON>";
                        }
                        break;
                    case 'templates':
                        $cmd = array_shift($this->cmd);
                        switch($cmd)
                        {
                            case 'add':
                                $xml = "<DOCTORS>";
                                $xml .= $this->GetDocXML();
                                $xml .= "</DOCTORS>";
                                if($_POST)
                                {
                                    $POST['login'] = $_POST['doctor'];
                                    $_POST['day'] = date("d-m-Y", time());
                                    if($_POST['work'] == 'yes')
                                    {
                                        $POST['spec'] = $_POST['spec'];
                                        $POST['from'] = strtotime($_POST['day']." ".$_POST['wfrom']);
                                        $POST['to'] = strtotime($_POST['day']." ".$_POST['wto']);
                                        $POST['pfrom'] = strtotime($_POST['day']." ".$_POST['pfrom']);
                                        $POST['pto'] = strtotime($_POST['day']." ".$_POST['pto']);
                                        if($_POST['jfrom'] != 0)$POST['jfrom'] = strtotime($_POST['day']." ".$_POST['jfrom']);
                                        if($_POST['jto'] != 0)$POST['jto'] = strtotime($_POST['day']." ".$_POST['jto']);
                                        $POST['talonstotal'] = $_POST['talonstotal'];
                                        $POST['talons'] = $_POST['talons'];
                                        $POST['cab'] = $_POST['cab'];
                                        if($_POST[wday] == NULL && $_POST['mod'] == NULL)$err = 'не выбран ни один день недели';
                                        elseif($POST['from'] > $POST['to'])$err = 'неправильный интервал работы врача';
                                        elseif($POST['pfrom'] > $POST['pto'])$err = 'неправильный интервал приема врача';
                                        elseif($POST['talonstotal'] == 0)$err = 'Общее количество талонов не заполнено';
                                        else $err = NULL;
                                        $wdays = Array();
                                        for($i=1; $i <= 7; $i++)
                                        {
                                            if($_POST[wday][$i] == on)$wdays[$i]=1;
                                            else $wdays[$i]=0;
                                        }
                                        $POST['mod'] = $_POST['mod'];
                                        foreach($wdays as $k=>$v)$POST['n'.$k] = $v;
                                        foreach($POST as $k=>$v)
                                        {
                                            $names .= "`".$k."`, ";
                                            $values .= "'".$v."', ";
                                        }
                                        if($err == NULL)
                                        {
                                            $query = "INSERT INTO `T_TEMPLATE` (".substr($names, 0, -2).") VALUES (".substr($values, 0, -2).")";
                                            $rs=$DB->Execute($query);
                                            header("Location: /panel/reg/templates");
                                        }
                                        else $xml .= "<ERROR>".$err."</ERROR>";
                                    }
                                    elseif($_POST['work'] == 'no')
                                    {
                                        $POST['remark'] = $_POST['remark'];
                                        for($i=1; $i <= 7; $i++)$POST['n'.$i] = 1;
                                        foreach($POST as $k=>$v)
                                        {
                                            $names .= "`".$k."`, ";
                                            $values .= "'".$v."', ";
                                        }
                                        $query = "INSERT INTO `T_TEMPLATE` (".substr($names, 0, -2).") VALUES (".substr($values, 0, -2).")";
                                        $rs=$DB->Execute($query);
                                        header("Location: /panel/reg/templates");
                                    }
                                }
                                break;
                            case 'edit':
                                $xml = "<DOCTORS>";
                                $xml .= $this->GetDocXML();
                                $xml .= "</DOCTORS>";
                                $rs = $DB->Execute("SELECT * FROM T_TEMPLATE WHERE template=?", Array($_GET['template']));
                                if(!$rs->EOF)
                                {
                                    $xml .= "<TEMPLATE ";
                                    foreach($rs->fields as $k=>$v)
                                    {
                                        if($k == 'from'||$k == 'to'||$k == 'pfrom'||$k == 'pto'||$k == 'jfrom'||$k == 'jto')$xml .= $k."=\"".date("H:i", $v)."\" ";
                                        else $xml .= $k."=\"".$v."\" ";
                                    }
                                    $xml .= ">";
                                    $xml .="</TEMPLATE>";
                                    $rs->MoveNext();
                                }
                                $rs->close();
                                if($_POST)
                                {
                                    $_POST['day'] = date("d-m-Y", time());
                                    $POST['login'] = $_POST['doctor'];
                                    if($_POST['work'] == 'yes')
                                    {
                                        $POST['spec'] = $_POST['spec'];
                                        $POST['in_time'] = $_POST['in_time'];
                                        $POST['from'] = strtotime($_POST['day']." ".$_POST['wfrom']);
                                        $POST['to'] = strtotime($_POST['day']." ".$_POST['wto']);
                                        $POST['pfrom'] = strtotime($_POST['day']." ".$_POST['pfrom']);
                                        $POST['pto'] = strtotime($_POST['day']." ".$_POST['pto']);
                                        if($_POST['jfrom'] != 0)$POST['jfrom'] = strtotime($_POST['day']." ".$_POST['jfrom']);
                                        if($_POST['jto'] != 0)$POST['jto'] = strtotime($_POST['day']." ".$_POST['jto']);
                                        $POST['talonstotal'] = $_POST['talonstotal'];
                                        $POST['talons'] = $_POST['talons'];
                                        $POST['cab'] = $_POST['cab'];
                                        if($_POST['wday'] == NULL && $_POST['mod'] == NULL)$err = 'не выбран ни один день недели';
                                        elseif($POST['from'] > $POST['to'])$err = 'неправильный интервал работы врача';
                                        elseif($POST['pfrom'] > $POST['pto'])$err = 'неправильный интервал приема врача';
                                        //elseif($POST['pfrom'] < $POST['from'] || $POST['pfrom'] > $POST['to'])$err = 'неправильное начало приема врача';
                                        //elseif($POST['pto'] > $POST['to'] || $POST['pto'] < $POST['from'])$err = 'неправильное окончание приема врача';
                                        //elseif($POST['talons']*$POST['talonstotal']*60 > $POST['pto']-$POST['pfrom'])$err = 'неправильный интервал приема или количество талонов, не хватает времени приема';
                                        else $err = NULL;
                                        $wdays = Array();
                                        for($i=1; $i <= 7; $i++)
                                        {
                                            if($_POST[wday][$i] == on)$wdays[$i]=1;
                                            else $wdays[$i]=0;
                                        }
                                        $POST['mod'] = $_POST['mod'];
                                        foreach($wdays as $k=>$v)$POST['n'.$k] = $v;
                                        $template=$_POST['template'];

                                        foreach($POST as $k=>$v)$str .= "`".$k."`='".$v."', ";
                                        if($err == NULL)
                                        {
                                            $query = "UPDATE `T_TEMPLATE` SET ".substr($str, 0, -2)." WHERE template=".$template."";
                                            $rs=$DB->Execute($query);
                                            //echo $query;
                                            header("Location: /panel/reg/templates");
                                        }
                                        else $xml .= "<ERROR>".$err."</ERROR>";
                                    }
                                    elseif($_POST['work'] == 'no')
                                    {
                                        $POST['remark'] = $_POST['remark'];
                                        for($i=1; $i <= 7; $i++)$POST['n'.$i] = 1;
                                        foreach($POST as $k=>$v)
                                        {
                                            $names .= "`".$k."`, ";
                                            $values .= "'".$v."', ";
                                        }
                                        $query = "INSERT INTO `T_TEMPLATE` (".substr($names, 0, -2).") VALUES (".substr($values, 0, -2).")";
                                        $rs=$DB->Execute($query);
                                        header("Location: /panel/reg/templates");
                                    }
                                }
                                break;
                            case 'delete':
                                $template = $_GET['template'];
                                $DB->Execute("DELETE FROM T_TEMPLATE WHERE template=?", Array($template));
                                header("Location: /panel/reg/templates");
                                break;
                            default:
                                //$templates = $this->GetDocXML(NULL, $currday, TRUE);
                                $today = strtotime(date('d-m-Y',time()));
                                $rs = $DB->Execute("SELECT * FROM T_TEMPLATE ORDER BY login DESC");
                                $xml .= "<TEMPLATES>";
                                while(!$rs->EOF)
                                {
                                    $xml .= "<TEMPLATE template=\"{$rs->fields[template]}\" login=\"{$rs->fields[login]}\" spec=\"{$rs->fields[spec]}\" in_time=\"{$rs->fields[in_time]}\" n1=\"{$rs->fields[n1]}\" n2=\"{$rs->fields[n2]}\" n3=\"{$rs->fields[n3]}\" n4=\"{$rs->fields[n4]}\" n5=\"{$rs->fields[n5]}\" n6=\"{$rs->fields[n6]}\" n7=\"{$rs->fields[n7]}\" mod=\"{$rs->fields[mod]}\">";
                                    if($rs->fields[remark] != '')$xml .= "<MESSAGE>".$rs->fields[remark]."</MESSAGE>";
                                    else
                                    {
                                        $lrs = $DB->Execute("SELECT * FROM T_USERS WHERE login=?", Array($rs->fields[login]));
                                        if(!$lrs->EOF)
                                        {
                                            $xml .= "<DOCTOR ";
                                            foreach($lrs->fields as $k=>$v)$xml .= $k."=\"".$v."\" ";
                                            $xml .= "/>";
                                            $xml .= "<WORKTIME from=\"".date("H:i", $rs->fields[from])."\" to=\"".date("H:i", $rs->fields[to])."\"/>";
                                            $xml .= "<RECIPIENTTIME from=\"".date("H:i", $rs->fields[pfrom])."\" to=\"".date("H:i", $rs->fields[pto])."\" talons=\"".$rs->fields[talonstotal]."\" onlinetalons=\"".$rs->fields[talons]."\"/>";
                                            if($rs->fields[jfrom] != 0 && $rs->fields[jto] != 0)
                                            {
                                                $xml .= "<JORNALTIME from=\"".date("H:i", $rs->fields[jfrom])."\" to=\"".date("H:i", $rs->fields[jto])."\"/>";
                                            }
                                        }
                                    }
                                    $xml .= "</TEMPLATE>";
                                    $rs->MoveNext();
                                }
                                $rs->close();
                                $xml .= "</TEMPLATES>";
                                break;
                        }
                        break;
                }
                break;
        }
        $xml .= $view->LoadListData(2);
        $xml .= "</PANELXML>";
        return $xml;
    }

    function GetXML()
    {

    }

    function GetDocSchedule($login, $day, $talon=NULL, $arr=FALSE)
    {
        Global $DB;
        $weekday = date('N', $day);
        $weekdayfield = "n".$weekday;
        $weekstart = $day - (86400*($weekday-1));
        for($i=1; $i <= 7; $i++)
        {
            $currentday = $weekstart + (86400*($i-1));
            $weekdayfield = "n".$i;
            $query = "SELECT * FROM T_DAILYSCHEDULE WHERE login='".$login."' AND day='".$day."'";
            //echo $query."<br />";
            $rs=$DB->Execute($query);
            while(!$rs->EOF)
            {
                if($arr == FALSE)
                {
                    $currentdayreadable = date("d-m-Y", $currentday);
                    $xml .= "<SCHEDULE schedule=\"{$rs->fields[id]}\" login=\"{$rs->fields[login]}\" spec=\"{$rs->fields[spec]}\" day=\"$currentdayreadable\" weekday=\"$i\" in_time=\"{$rs->fields[in_time]}\">";
                    if($rs->fields[remark] != '')$xml .= "<MESSAGE>".$rs->fields[remark]."</MESSAGE>";
                    else
                    {
                        $xml .= "<WORKTIME from=\"".date("H:i", $rs->fields[from])."\" to=\"".date("H:i", $rs->fields[to])."\"/>";
                        $xml .= "<RECIPIENTTIME from=\"".date("H:i", $rs->fields[pfrom])."\" to=\"".date("H:i", $rs->fields[pto])."\" duration=\"".$rs->fields[talonstotal]."\" talons=\"".$rs->fields[talons]."\"/>";
                        if($rs->fields[jfrom] != 0 && $rs->fields[jto] != 0)
                        {
                            $xml .= "<JORNALTIME from=\"".date("H:i", $rs->fields[jfrom])."\" to=\"".date("H:i", $rs->fields[jto])."\"/>";
                        }
                        if($talon == TRUE)
                        {
                            $rss=$DB->Execute("SELECT * FROM T_TALONS WHERE login=? AND dday=?", Array($rs->fields[login], $currentdayreadable));
                            while(!$rss->EOF)
                            {
                                $xml .= "<TALON ";
                                foreach($rss->fields as $k=>$v)
                                {
                                    if($k == 'time')$xml .= "daytime=\"".date('H:i', $v)."\" ";
                                    else $xml .= $k."=\"".$v."\" ";
                                }
                                $xml .= "/>";
                                $rss->MoveNext();
                            }
                            $rss->close();
                        }
                    }
                    $xml .= "</SCHEDULE>";
                }
                else return $rs->fields;
                $rs->MoveNext();
            }
            $rs->close();
        }
        return $xml;
    }

    function GetDocXML($doctor=NULL, $day=NULL, $arr=FALSE)
    {
        Global $DB;
        if($arr == FALSE)
        {
            $query = "SELECT * FROM T_USERS as a LEFT JOIN T_LOGIN_GROUP as b ON a.login=b.login WHERE b.gid=6";
            if($doctor != NULL)$query .= " AND a.login=\"$doctor\"";
            $rs = $DB->Execute($query);
            while(!$rs->EOF)
            {
                $result .= "<DOCTOR ";
                foreach($rs->fields as $k=>$v)$result .= $k."=\"".$v."\" ";
                if($day != NULL)
                {
                    $result .= ">";
                    $result .= xpReg::GetDocSchedule($rs->fields['login'], $day, TRUE, $arr);
                    $result .= "</DOCTOR>";
                }
                else $result .= "/>";
                $rs->MoveNext();
            }
            $rs->close();
        }
        else
        {
            $result = Array();
            $query = "SELECT * FROM T_USERS as a LEFT JOIN T_LOGIN_GROUP as b ON a.login=b.login WHERE b.gid=6";
            if($doctor != NULL)$query .= " AND a.login=\"$doctor\"";
            $rs = $DB->Execute($query);
            while(!$rs->EOF)
            {
                $result[$rs->fields['login']] = xpReg::GetDocSchedule($rs->fields['login'], $day, TRUE, $arr);
                $rs->MoveNext();
            }
        }
        return $result;
    }

    function GetScheduleXML($doctor=NULL, $day=NULL)
    {
        Global $DB;
        $query = "SELECT * FROM T_USERS as a LEFT JOIN T_LOGIN_GROUP as b ON a.login=b.login WHERE b.gid=6";
        if($doctor != NULL)$query .= " AND a.login=\"$doctor\"";
        $rs = $DB->Execute($query);
        while(!$rs->EOF)
        {
            $result .= "<DOCTOR ";
            foreach($rs->fields as $k=>$v)$result .= $k."=\"".$v."\" ";
            if($day != NULL)
            {
                $result .= ">";
                $result .= $this->GetSchedule($rs->fields['login'], $day);
                $result .= "</DOCTOR>";
            }
            else $result .= "/>";
            $rs->MoveNext();
        }
        $rs->close();
        return $result;
    }

    function GetSchedule($login, $day)
    {
        Global $DB;
        $weekday = date('N', $day);
        $weekstart = $day - (86400*($weekday-1));
        for($i=1; $i <= 7; $i++)
        {
            $currentday = $weekstart + (86400*($i-1));
            $query = "SELECT * FROM T_DAILYSCHEDULE WHERE login='".$login."' AND day = ".$currentday;
            $rs=$DB->Execute($query);
            while(!$rs->EOF)
            {
                $dayreadable = date("d-m-Y", $currentday);
                $xml .= "<SCHEDULE id=\"{$rs->fields[id]}\" login=\"{$rs->fields[login]}\" spec=\"{$rs->fields[spec]}\" day=\"$dayreadable\" in_time=\"{$rs->fields[in_time]}\">";
                if($rs->fields[remark] != '')$xml .= "<MESSAGE>".$rs->fields[remark]."</MESSAGE>";
                else
                {
                    $xml .= "<WORKTIME from=\"".date("H:i", $rs->fields[from])."\" to=\"".date("H:i", $rs->fields[to])."\"/>";
                    $xml .= "<RECIPIENTTIME from=\"".date("H:i", $rs->fields[pfrom])."\" to=\"".date("H:i", $rs->fields[pto])."\" duration=\"".$rs->fields[talonstotal]."\" talons=\"".$rs->fields[talons]."\"/>";
                    if($rs->fields[jfrom] != 0 && $rs->fields[jto] != 0)
                    {
                        $xml .= "<JORNALTIME from=\"".date("H:i", $rs->fields[jfrom])."\" to=\"".date("H:i", $rs->fields[jto])."\"/>";
                    }
                }
                $xml .= "</SCHEDULE>";
                $rs->MoveNext();
            }
            $rs->close();
        }
        return $xml;
    }
}
?>