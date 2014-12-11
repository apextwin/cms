<?php
	class xpImage
	{
		var $filename;
		function xpImage($post_file, $post_name)
		{
			$this->filename = $post_name;
			$this->file = $post_file;
		}
		function imageUpload($key, $prefix, $foldername, $x=450, $y=400)
		{
			global $cfg;
			if ($this->file["tmp_name"]["{$this->filename}"])
			{
			    preg_match('/\.([A-Za-z]*)$/',$this->file['name']["{$this->filename}"],$ext);
				$filename = $this->file['tmp_name']["{$this->filename}"];
				$outfile = "$foldername/".$prefix.$key.$ext[0];
				$loaded[image] = $this->imageResize($outfile,$filename, $x, $y);
				return $key.$ext[0];
			}
		}
		
		function _imageUpload($key, $prefix, $foldername, $x=450, $y=400)
		{
			global $cfg;
			if ($this->file["tmp_name"])
			{
			    preg_match('/\.([A-Za-z]*)$/',$this->file['name'],$ext);
				$filename = $this->file['tmp_name'];
				$outfile = "$foldername/".$prefix.$key.$ext[0];
				$loaded[image] = $this->imageResize($outfile,$filename, $x, $y);
				return $outfile;
			}
		}
		
		function imagerealmUpload($prefix, $foldername)
		{
			global $cfg;
			$size=Array('200', '200');
			if ($this->file["tmp_name"])
			{
			    preg_match('/\.([A-Za-z]*)$/',$this->file['name'],$ext);
				$filename = "$foldername/".$prefix.$ext[0];
				$f = file_get_contents($this->file['tmp_name']);
		        file_put_contents($filename,$f);
                chmod("$filename",0775);
				$loaded[image] = $filename;
				$outfile = "$foldername/"."small_".$prefix.$ext[0];
				$loaded[image_small] = $this->imageResize($outfile,$filename,$size[0],$size[1]);
				return $loaded;
			}
		}
		
		function imageResize($outfile,$filename,$max_width,$max_height)
		{
			$size = GetImageSize($filename);
			$width = $size[0];
			$height = $size[1];
			$x_ratio = $max_width / $width;
			$y_ratio = $max_height / $height;
			if ( ($width <= $max_width) && ($height <= $max_height) )
			{
				$tn_width = $width;
				$tn_height = $height;
			}elseif (($x_ratio * $height) < $max_height)
			{
				$tn_height = ceil($x_ratio * $height);
				$tn_width = $max_width;
			}else
			{
				$tn_width = ceil($y_ratio * $width);
				$tn_height = $max_height;
			}
			switch($size[2])
				{
				case 1:
					$src = imagecreatefromgif($filename);
					break;
				case 2:
					$src = imagecreatefromjpeg($filename);
					break;
				case 3:
					$src = imagecreatefrompng($filename);
					break;
				case 4:
					break;
				}
			$dst = imagecreatetruecolor($tn_width,$tn_height);
			imagecopyresampled($dst, $src, 0, 0, 0, 0,$tn_width,$tn_height,$width,$height);
			ImageJPEG($dst,$outfile,100);
			chmod("$outfile",0664);
			imagedestroy($src);
			Imagedestroy($dst);
			return $outfile;
        }
	}
?>