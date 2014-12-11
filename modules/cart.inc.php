<?
	class Cart extends Module
	{
		var $Data;
		var $Cmd;
		var $Entity;

	   function __construct($data, $realm)
        {
            parent::__construct($data, $realm);
            $this->ns = 'cart';
        } 
		function GetXML()
		{
		    Global $DB, $Processor, $CGI, $Session, $cfg;
		    $view = new Viewer();
		    $uri = $Processor->Uri;
		    $realm = $Processor->Realm;
            $cart = $CGI->Data['cookie']['cart'];
            $login = $Session->login;
            if($this->Cmd == 'cart')
            {
                $rs = $DB->Execute("SELECT * FROM T_ORDER WHERE login = ? ORDER BY date DESC", Array($login));
                $xml .= "<ORDERS>";
                while(!$rs->EOF)
                {   
                    $date = date('d-m-Y H:m:s', $rs->fields['time']);
                    $xml .= "<ORDER id=\"{$rs->fields['id']}\">";
                    foreach($rs->fields as $k=>$v)
                    {
                        if($k == 'date')$xml .= "<FIELD name=\"$k\">".date("d.m.Y H:i", $v)."</FIELD>";
                        else $xml .= "<FIELD name=\"$k\">$v</FIELD>";
                    }
                    $xml .= $view->LoadNodeData($rs->fields['node']);
                    $xml .= "</ORDER>"; 
                    $rs->MoveNext();
                }
                $rs->close();
                $xml .= "</ORDERS>";
            }
            
            if($_GET[submit] && is_array($cart))
            {
                $xml .="<MSG>";
                
                $login = $Session->login;
                $rs = $DB->Execute("SELECT * FROM T_USERS WHERE login=?", Array($login));
                $name = $rs->fields['name'];
                $email = $rs->fields['email'];
                $phone = $rs->fields['phone'];

				$subject = "Заказ с сайта ".$cfg[name];
                
                $headers = "Subject: ".$subject."\r\n";
				$headers.= "Content-Type: text/html; charset=utf-8\r\n";
                $headers.= "From: robot <".$cfg[email].">\r\n";
                $headers.= "To: ".$cfg[email]."\r\n";
                $headers.= "Reply-To: ".$email."\r\n";
                $headers.= "MIME-Version: 1.0\r\n";
                $headers.= "\r\n";
				
				$msg="<table>
                    <tr><td>ФИО</td><td>".$name."</td></tr>
                    <tr><td>Электронная почта</td><td>".$email."</td></tr>
                    <tr><td>Контактный телефон</td><td>".$phone."</td></tr>
                </table>";
			    $msg .= "<table border=1><tr><td>Наименование</td><td>Количество</td><td>Цена</td><td>Вес</td><td>Всего</td></tr>";
                $counttotal = 0;
                
                foreach($cart as $k=>$v)
                {
                    $rs = $DB->Execute("SELECT price1 FROM T_PRICE WHERE node=?", Array($v['product']));
                    $currtotal = $rs->fields['price1'] * $v['count'];
                    $price1 = $rs->fields['price1'];
                    $rs->close();
                    $total = $total + ($currtotal);
                    
                    $rsves = $DB->Execute("SELECT a.value FROM T_NODE_DATA as a LEFT JOIN T_NODE_DATANAME as b ON a.dataid=b.dataid WHERE a.node=? AND b.dataname=?", Array($k, 'ves'));
                    $cves = $rsves->fields['value'];
                    $cves = str_replace(",", ".", $cves); 
                    settype($cves, 'float');
                    $currtotalves = $cves * (float)$v['count'];
                    $totalves = $totalves + $currtotalves; 
                    $ves = $rsves->fields['value'];
                    $rsves->close();
                    
                    $rstitle = $DB->Execute("SELECT a.value FROM T_NODE_DATA as a LEFT JOIN T_NODE_DATANAME as b ON a.dataid=b.dataid WHERE a.node=? AND b.dataname=?", Array($k, 'title'));
                    $title = $rstitle->fields['value'];
                    $rstitle->close();
                    
                    //$total = $total + ($currtotal);
                    $msg .= "<tr>";
                    $msg .= "<td>".$title."</td>";
                    $msg .= "<td>".$v['count']."</td>";
                    $msg .= "<td>".$price1."</td>";
                    $msg .= "<td>".$currtotalves."</td>";
                    $msg .= "<td>".$currtotal."</td>";
                    $msg .= "</tr>";
                }
                

                
                $msg .= "</table>";
                $invoice = $msg;
                $msg .= "Это сообщение отправлено с сайта автоматически, не отвечайте на него! Отвечать адресату нужно на его email адрес указанный в этом сообщении.";
				$letter ="<html><head><meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\"></head><body leftmargin=\"10\" topmargin=\"10\">".$msg."</body></html>";
                
                mail($cfg[email], $subject, $letter, $headers);
                mail($email, $subject, $letter, $headers);
                
                $xml .= "<CART send=\"1\" message='Вы успешно подтвердили заказ. Теперь вы можете следить за его состоянием в разделе Отслеживание заказа'/>";
                
                $DB->Execute("INSERT INTO T_ORDER (login, orderhash, invoice, total, time) VALUES (?, ?, ?, ?, ?)", Array($login, $orderhash, $invoice, $total, time()));
                
				setcookie('cart','', 1, '/', $cfg[name]);
                unset($cart);
                //$DB->Execute("UPDATE T_CONF SET value=value+? WHERE name='counter'", Array($counttotal));
                
                $xml .="</MSG>";
            }            
		    if(is_Array($cart))
		    {
                $xml .= "<CART>";
                foreach($cart as $k=>$v)
                {
                    $totalcount = $totalcount +  $v['count']; 
                    $rs = $DB->Execute("SELECT price1 FROM T_PRICE WHERE node=?", Array($v['product']));
                    $currtotal = $rs->fields['price1'] * $v['count'];
                    $price1 = $rs->fields['price1'];
                    $rs->close();
                    $total = $total + ($currtotal);
                    
                    $rsves = $DB->Execute("SELECT a.value FROM T_NODE_DATA as a LEFT JOIN T_NODE_DATANAME as b ON a.dataid=b.dataid WHERE a.node=? AND b.dataname=?", Array($k, 'ves'));
                    $cves = $rsves->fields['value'];
                    $cves = str_replace(",", ".", $cves); 
                    settype($cves, 'float');
                    $currtotalves = $cves * (float)$v['count'];
                    $totalves = $totalves + $currtotalves; 
                    $ves = $rsves->fields['value'];
                    $rsves->close();
                    
                    $xml .="<ORDER id=\"{$v['product']}\" count=\"{$v['count']}\" price1=\"{$price1}\" total=\"$currtotal\" ves=\"$cves\" fullves=\"$currtotalves\">";
                    $xml .= $view->LoadNodeData($v['product']);
                    $xml .= "</ORDER>";    
                }
                //$discount = $this->GetDiscount($total);

                $xml .= "<TOTAL>".$total."</TOTAL>";
                if($discount[discount]==true)
                {
                    $xml.="<DISCOUNT percent=\"".$discount[percent]."\">".$discount[discounttotal]."</DISCOUNT>";
                }
                $xml .= "<VES>".$totalves."</VES>";
                $xml .= "<TOTALCOUNT>".$totalcount."</TOTALCOUNT>";
    		    $xml .= "</CART>";
    		}

			return $xml;
		}
	}
?>
