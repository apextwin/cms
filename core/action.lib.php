<?
class Action
{
    var $url;
    
    function action($uri)
    {
        $cmd = $uri;
        $this->Cmd = $cmd[sizeof($cmd) - 1];
    }
    
    function GetData($data)
    {                   
        Global $DB, $Error, $cfg, $Session;
        $viewer = new Viewer();
        switch($this->Cmd)
        {
            case 'order':
                if($data['phone'] == '')$output="Заполните обязательное поле `Телефон`";
                elseif($data['name'] == '')$output="Заполните обязательное поле `Имя`";
                else
                {
                    $DB->Execute("INSERT INTO T_ORDER (login, phone, uname, node, date, status) VALUES (?, ?, ?, ?, ?, ?)", Array($data['email'],$data['phone'],$data['name'],$data['node'],strtotime($data['date']),'0'));
                    $output = 'ok';
                }
                //$output = var_dump($data);
            break;
            case 'getevent':
                $xml .= "<NODESET coursetype=\"{$data['id']}\">";
                $xml .= $viewer->LoadListData($list=$data['id']);
                $rs = $DB->Execute("SELECT a.node FROM T_NODE as a LEFT JOIN T_NODE_DATA as b ON a.node=b.node WHERE b.dataid=? AND b.value=? ORDER BY a.node DESC", Array(30, $data[id]));
                while(!$rs->EOF)
                {
                    $xml .= $viewer->LoadNodeData($rs->fields['node']);
                    $rs->MoveNext();
                }   
                $xml .= "</NODESET>";
                                
                $xsl = implode('',file("$cfg[xsldir]/coursetype.xsl"));
                $arguments = array('/_xml' => $xml, '/_xsl' => $xsl);
				$xh = $this->xslt_create();
				$html = $this->xslt_process($xh, 'arg:/_xml', 'arg:/_xsl', null, $arguments);
				unset($xh); 
                $output = $html;
                
                $rs->close();
            break;
            case 'getmore':
                $page = $data['page'];
                $start = ($page-1)*4;
                $xml .= "<NODESET coursetype=\"latest\">";
                $query = "SELECT node FROM T_NODE WHERE class = \"event\" ORDER BY node DESC LIMIT ".$start.", 4";
                $rs = $DB->Execute($query);
                while(!$rs->EOF)
                {
                    $xml .= $viewer->LoadNodeData($rs->fields['node']);
                    $rs->MoveNext();
                }
                $xml .= "</NODESET>";
                $xsl = implode('',file("$cfg[xsldir]/coursetype.xsl"));
                $arguments = array('/_xml' => $xml, '/_xsl' => $xsl);
				$xh = $this->xslt_create();
				$html = $this->xslt_process($xh, 'arg:/_xml', 'arg:/_xsl', null, $arguments);
				unset($xh); 
                $output = $html;            
            break;
            case 'getall':
                $xml .= "<NODESET coursetype=\"latest\">";
                $query = "SELECT node FROM T_NODE WHERE class = \"event\" ORDER BY node DESC";
                $rs = $DB->Execute($query);
                while(!$rs->EOF)
                {
                    $xml .= $viewer->LoadNodeData($rs->fields['node']);
                    $rs->MoveNext();
                }
                $xml .= "</NODESET>";
                $xsl = implode('',file("$cfg[xsldir]/coursetype.xsl"));
                $arguments = array('/_xml' => $xml, '/_xsl' => $xsl);
				$xh = $this->xslt_create();
				$html = $this->xslt_process($xh, 'arg:/_xml', 'arg:/_xsl', null, $arguments);
				unset($xh); 
                $output = $html;            
            break;
            case 'saveprice':
                if(is_array($data))$DB->Execute("UPDATE T_PRICE SET extkey=?, count=?, price1=? WHERE node=?", Array($data['extkey'],$data['count'],$data['price1'],$data['node']));
                $output = 'ok';
            break;           
        }
        header("Cache-Control: no-store"); 
        header("Expires: ".date("r", time()-36000));    
        return $output;
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