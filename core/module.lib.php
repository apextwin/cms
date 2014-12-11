<?
	abstract class Module
	{
		var $Data;
        var $Realm;
		var $Cmd;
        var $cmd;
        var $Entity;
        var $ns;
        var $Config; 

		function __construct($uri, $realm)
		{
			Global $CGI;
			$this->Data = $uri;
            $this->Realm = $realm;
			$this->cmd = explode('/',$uri);
            $this->Entity = $this->cmd[0];
			$this->Cmd = $this->cmd[sizeof($this->cmd) - 1];
		}
        
		abstract function GetXML();
        
        function _gettemplate($templ = NULL)
        {
            global $cfg;
            if($this->Realm < '1000')
            {
                $file = "templates/modules/".$this->ns."_conf.xsl";
                if($templ != NULL)$file = "templates/modules/module_conf.xsl";
            }    
            else $file = $cfg['xsldir']."/modules/".$this->ns.".xsl";
            return $file;
        }
        
        function GetPanelXML()
        {            
            Global $Config;
            $this->Config = $Config->Getmoduleconf($this->ns);
            switch($_GET['action'])
            {
                case 'addval':
                    $res = $Config->SetVar($this->ns, $_POST[key], $_POST[value]);
                    header("Location: /panel/module?module=".$_GET[module]);                           
                break;
                case 'editval':
                    $res = $Config->EditVar($this->ns, $_POST[key], $_POST[value]);
                    header("Location: /panel/module?module=".$_GET[module]);                           
                break;
                case 'delval':
                    $res = $Config->DelVar($this->ns, $_GET[key]);
                    header("Location: /panel/module?module=".$_GET[module]);                           
                break;
                default:
                    $xml .= "<VARS ns=\"".$this->ns."\" >";
                    if($this->Config != NULL)foreach($this->Config as $k=>$v)$xml .= "<VAR name=\"".$k."\">".$v."</VAR>";
                    $xml .= "</VARS>";
                break;
            }
            return $xml;
        }
        
        function GetChildrenRealms($realm, $depth=10)
		{
            global $DB;
            if(!$depth==0)
            {
                $realms = Array();
                $rs = $DB->Execute("SELECT realm FROM T_REALM WHERE parent=?", Array($realm));
                while(!$rs->EOF)
                {
                    array_push($realms, $rs->fields['realm']);
                    if($depth==NULL)$childrens = $this->GetChildrenRealms($rs->fields['realm']);
                    else $childrens = $this->GetChildrenRealms($rs->fields['realm'], $depth-1);
                    $realms = array_merge($realms, $childrens);
                    $rs->MoveNext();
                }
                $rs->close();
                return $realms;
            }
            else return Array();
        }
        
	}
?>