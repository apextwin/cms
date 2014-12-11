<?
    include_once('core/config.lib.php');
    include_once('core/cgi.lib.php');
	include_once('core/session.lib.php');
    include_once('core/auth.lib.php'); 
	include_once('core/tree.lib.php');
	include_once('core/viewer.lib.php');
	include_once('core/node.lib.php');
	include_once('core/cache.lib.php');
	include_once('core/admin.lib.php');
    include_once('core/action.lib.php');
    include_once('core/module.lib.php');
    include_once('core/template.lib.php');
	
	class xpProcessor
	{
		var $Uri;
        var $XML;
		var $XSL;
		var $Template;
		var $Root;
		var $Realm;

		function xpProcessor()
		{
			global $cfg;
            
            if($_GET[uri] != '')$this->Uri = $_GET[uri];
            else $this->Uri = '/';
			ksort($_GET);//сортируем по ключу, по алфавиту
			if($_GET != NULL)foreach($_GET as $n=>$v)if($n != uri)$this->params .= $n.'='.$v.'&';
			else $this->params = 'NULL';
			$this->Root = $cfg['root'];
		}

		function Run()
		{
			global $cfg, $CGI, $Session, $DB, $Error, $Cache, $Config;
			$Config = new Config();
            $loadconf =  $Config->Getmoduleconf('global');
            $cfg = array_merge($cfg, $loadconf);
            $this->Realm = NULL;

			$CGI = new xpCGI();
            $Session = new xpSession();
            //$Cache = new xpCache($this->Uri, $this->params);
            $Tree = new xpTree();
            $Auth = new Auth();
			$rs = $DB->Execute("SELECT * FROM T_REALM WHERE name=? LIMIT 1", Array($this->Uri));
			if($rs)$this->Realm = $rs->fields['realm'];
            $this->Template = new Template($this->Realm);

            if($_GET['output'] == 'ajax' || $_POST['output'] == 'ajax')
            {
                if($_GET['uri'] != '')
                {
                    $uri = explode('/',$_GET['uri']);
                    if($uri[0] == 'action')
                    {
                        $Action = new action($uri);
                        $output = $Action->GetData($_POST);
                    }
                }
                print_r($output);
            }
            else
            {
                $this->XML = "<?xml version=\"1.0\" encoding=\"utf-8\"?>";
			    $this->XML .= "<DOCUMENT>";
    			$this->XML .= "<REALM name=\"{$rs->fields[name]}\" id=\"{$this->Realm}\">";
                $this->XML .= "<TITLE>".$rs->fields[title]."</TITLE>";
                $this->XML .= "<DESCR><![CDATA[".$rs->fields[descr]."]]></DESCR>";
                $this->XML .= "<METADESCR><![CDATA[".$rs->fields[metadescr]."]]></METADESCR>";
                $this->XML .= "<METAKEY><![CDATA[".$rs->fields[metakey]."]]></METAKEY>";
                $this->XML .= "<URI><![CDATA[".$cfg['url']."]]></URI>";
                $this->XML .= "</REALM>";

                $curr_realm = $this->Realm;
    			$curr_pagesize = $rs->fields['realmpagesize'];
    			$Template = $rs->fields['template'];
    			$rs->close();

                if($_GET[node])
                {
                    $rss = $DB->Execute("SELECT * FROM T_NODE WHERE node=? LIMIT 1", Array($_GET[node]));
                    if($rss->EOF){
                        header("HTTP/1.0 404 Not Found");
                        $this->XML .= "<ERROR type=\"404\"/>";
                    }
                    $rss->close();
                }
                if($this->Realm == NULL)
    		    {
                    header("HTTP/1.0 404 Not Found");
                    $this->XML .= "<ERROR type=\"404\"/>";
                    $Template = "template.xsl";

                }
    			$this->XML .= $Session->GetXML();
    			$this->XML .= $Tree->GetXML();
    			if($Auth->CheckPermission($this->Realm) == TRUE)
    			{
                    if(strripos($this->Uri, 'module'))
                    {
                        $pos = strpos($this->Uri, '/', 6);
                        $_GET['action'] = substr($this->Uri, ++$pos);
                        $this->Uri = "panel/module";
                        $pos = strpos($_GET['action'], '/');
                        if($pos == 0)$_GET['module'] = $_GET['action'];
                        else $_GET['module'] = substr($_GET['action'], 0, $pos);
                    }
        			$this->XML .= $CGI->GetXML();
                    if($this->Realm == '')$this->Realm = 1000;
                    if($this->Realm < 1000)//если realm относится к админским по ид
                    {
                        $Admin = new xpAdmin($this->Uri);
                        $this->XML .= $Admin->GetXML($this->Realm);
                        //Загрузка шаблона
                        if($Template == 'panel.xsl' || $Template == 'login.xsl')
                        {
                            $this->XSL = $this->Template->GetXSL("templates/{$Template}");
                        }
                        else
                        {
                            $this->Template->addtemplate("templates/".$Template);
                            if($_GET['modal'] == true)$this->XSL = $this->Template->GetXSL("templates/modal.xsl");
                            else $this->XSL = $this->Template->GetXSL("templates/panel.xsl");
                        }
                    }
                    elseif($this->Realm >= 1000)
                    {
                        $this->XML .= $this->Execute($this->Realm, $this->Uri);
            			$Node = new xpNode($this->Uri);
            			$this->XML .= $Node->GetXML($this->Realm, $curr_pagesize);
                        //Загрузка шаблона
                        if(is_file("$cfg[xsldir]/{$Template}"))$this->XSL = $this->Template->GetXSL("$cfg[xsldir]/{$Template}");
                        else $_GET[output]="xml";
                    }
                }
                else
                {
                    $this->XML .= $this->Execute($this->Realm, $this->Uri);
                    $this->XML .= $Error->is_error('p_1', 'Access denided!');
                }
                $this->XML .= $Error->GetXML(); //ошибки выводить в самом конце обработки
    			$this->XML .= "</DOCUMENT>";
    			$this->DoOutput();
            }
		}
		
		function Execute ($realm, $uri)
		{
            global $DB, $cfg;
            $realms = $this->GetParents($uri);
            $query = "SELECT * FROM T_INCLUDE_REALM AS a LEFT JOIN T_INCLUDE AS b ON a.include = b.include WHERE (a.realm IN ("."'".implode("','" , $realms)."'".") AND a.mode = 1) OR (a.realm=\"{$realm}\")";
            //echo $query;
            $rs = $DB->Execute($query);
            while(!$rs->EOF)
            {
				eval("\$Object = new {$rs->fields['class']}(\$uri, \$realm);");
				$xml .= "<INCLUDE name=\"{$rs->fields['class']}\" mode=\"{$rs->fields['mode']}\" realm=\"{$rs->fields['realm']}\" >";
				if(isset($Object))
                {
                    $xml .= $Object->GetXML($realm);
                    if(method_exists($Object, '_gettemplate'))
                    {
                        $modxsl = $Object->_gettemplate();
                        $this->Template->addtemplate($modxsl);
                    }
                }
				$xml .= "</INCLUDE>";
                $rs->MoveNext();
            }
            return $xml;
        }
        
		function GetParents($uri)
		{
		    global $DB;
		    $res = array();
		    if(is_numeric($uri))
		    {
                $rs=$DB->Execute("SELECT name FROM T_REALM WHERE realm=?", Array($uri));
                $uri=$rs->fields['name'];
                $rs->close();
            }
            if($uri!='/')
            {
                $arr = explode('/', $uri);
                if(sizeof($arr))array_push($res, "/");
                foreach($arr as $v)
                {
                    if($url != '')$url .= "/";
                    $url .= $v;
                    array_push($res, $url);
                }
            }
            else array_push($res, $uri);
            $rs = $DB->Execute("SELECT realm, name FROM T_REALM WHERE name IN ("."'".implode("','" , $res)."'".")");
            $res = array();
            while(!$rs->EOF)
            {
                $res[$rs->fields['name']]=$rs->fields['realm'];
                $rs->MoveNext();
            }
            unset($res[$uri]);
            return $res;
        }

        function DoOutput()
		{
			global $cfg;
			//$_GET[output] = 'xml';
            if($_GET[output] == 'xml')
			{
     			header('Content-Type: text/xml');
    		    print $this->XML;
			}
			else if($_GET[output] == 'xsl')
			{
				header('Content-Type: text/xml');
				print $this->XSL;
			}
			else
			{
                if($this->XSL == NULL)$this->XSL = file_get_contents('templates/template.xsl');
				$arguments = array('/_xml' => $this->XML, '/_xsl' => $this->XSL);
				$xh = $this->xslt_create();
				$html = $this->xslt_process($xh, 'arg:/_xml', 'arg:/_xsl', null, $arguments);
				unset($xh);
				print  $html;
			}
		}

		function xslt_create(){return new XsltProcessor();}
		
		function xslt_process($xsltproc,$xml_arg,$xsl_arg,$xslcontainer = null,$args = null,$params = null)
		{
			$xml_arg = str_replace('arg:', '', $xml_arg);
			$xsl_arg = str_replace('arg:', '', $xsl_arg);
			$xml = new DomDocument('1.0', 'utf-8');
			$xsl = new DomDocument('1.0', 'utf-8');
			$xml->loadXML($args[$xml_arg]);
			$xsl->loadXML($args[$xsl_arg],LIBXML_NOCDATA);
			$xsltproc->importStyleSheet($xsl);
			if($params)foreach($params as $param => $value)$xsltproc->setParameter("", $param, $value);

			$processed = $xsltproc->transformToXML($xml);
			if ($xslcontainer)return @file_put_contents($xslcontainer, $processed);
			else return $processed;
		}
	}
?>