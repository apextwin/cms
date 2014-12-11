<?
    #CGI library. version 1.0
	class xpCGI
	{
		var $Filter;
		var $Data;
		
		function xpCGI()
		{
			$this->Filter = 4;
			
		}
		function GetXML()
		{
            Global $cfg;
			$xml = '<CGI>';
			//вывод переменных
			if($this->Filter >= 1)$xml .= $this->GetParams($_GET,'get',false);
			if($this->Filter >= 2)$xml .= $this->GetParams($_COOKIE,'cookie',false);
			if($this->Filter >= 3)$xml .= $this->GetParams($_FILES,'files',false);
			if($this->Filter >= 4)$xml .= $this->GetParams($_POST,'post',false);
			if($this->Filter >= 5)$xml .= $this->GetParams($_SERVER,'server');
			if($this->Filter >= 6)$xml .= $this->GetParams($_ENV,'env');
			$xml .= '</CGI>';
			return $xml;
		}
		function GetParams($data, $source, $cdata_name=true)
		{
			$xml = "<PARAMS source=\"$source\">";
			$this->Data[$source] = array();
			if(is_array($data))foreach($data as $n => $v)
            {
                if($n != 'uri')
                {
                    if(is_array($v))
                    {
                        $xml .= "<PARAMSET name=\"$n\">";
                        $arr = array();
                        foreach($v as $k => $l)
                        {
                            $xml .= "<PARAM name=\"$k\">$l</PARAM>";
                            $arr[$k]=$l;
                        }
                        $this->Data[$source][$n] = $arr;
                        $xml .= "</PARAMSET>";
                    }
                    elseif(is_array(json_decode(stripslashes($v), true)))
                    {
                        $arr = array();
                        $xml .= "<PARAMSET name=\"$n\">";
                        foreach(json_decode(stripslashes($v), true) as $k => $l)
                        {
                            $xml .= "<PARAM name=\"$k\">$l</PARAM>";       
                            $arr[$k]=$l;
                        }
                        $this->Data[$source][$n] = $arr;
                        $xml .= "</PARAMSET>";
                    }
                    elseif(!$cdata_name)
                    {
                        $xml .= "<PARAM name=\"$n\">$v</PARAM>";
                        $this->Data[$source][$n] = $v;
                    }
                    else $xml .= '<PARAM><NAME><![CDATA['.$n.']]></NAME><VALUE><![CDATA['.$v.']]></VALUE></PARAM>';
                }
            }
			$xml .= '</PARAMS>';
			return $xml;
		}
	};
?>