<?
	class Template
	{
		var $Data;
        var $Realm;
        var $tpls = Array();
        function __construct($realm)
		{
			$this->Realm = $realm;
		}
        function GetXSL($xslfile)
        {
            $xsl = implode('',file($xslfile));
            if(count($this->tpls) > 0)
            {
                $this->tpls = array_unique($this->tpls);
                foreach($this->tpls as $k=>$v)if(is_file($v))$str .= "<xsl:include href=\"".$v."\"/>";
                $str .= "</xsl:stylesheet>";
                $xsl = str_replace("</xsl:stylesheet>", $str, $xsl);
            }
            return $xsl;    
        }
        
        function addtemplate($tpl)
        {
            Array_push($this->tpls, $tpl);
            return true;
        }
	}
?>